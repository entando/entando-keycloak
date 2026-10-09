#!/bin/bash
#
# Configures a Keycloak realm to use the "entando-mfa" login theme and two-factor authentication (OTP).
#
#   optional  (default) users that configured an authenticator app are asked for a code at sign in;
#             the others sign in with username and password only (Keycloak built-in "browser" flow).
#   required  every user must use an authenticator app: users without one are asked to configure it
#             at the next sign in (copy of the "browser" flow with the OTP step marked as REQUIRED).
#   disabled  restores the "entando" login theme and the built-in "browser" flow.
#
# Requirements: curl, jq. Uses the Keycloak Admin REST API with an admin user of the master realm.

set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8081/auth}"
ADMIN_REALM="${ADMIN_REALM:-master}"
ADMIN_USER="${KEYCLOAK_ADMIN:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-}"
REALM="entando"
MODE="optional"
FLOW_ALIAS="entando-mfa browser"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -s <url>       Keycloak base URL, including the relative path (default: $KEYCLOAK_URL)
  -r <realm>     realm to configure (default: $REALM)
  -m <mode>      optional | required | disabled (default: $MODE)
  -u <user>      admin user of the "$ADMIN_REALM" realm (default: $ADMIN_USER, env KEYCLOAK_ADMIN)
  -p <password>  admin password (env KEYCLOAK_ADMIN_PASSWORD)
  -h             show this help

Example:
  $(basename "$0") -s https://my.entando.host/auth -r entando -m required -u admin -p secret
EOF
}

while getopts "s:r:m:u:p:h" opt; do
  case "$opt" in
    s) KEYCLOAK_URL="${OPTARG%/}" ;;
    r) REALM="$OPTARG" ;;
    m) MODE="$OPTARG" ;;
    u) ADMIN_USER="$OPTARG" ;;
    p) ADMIN_PASSWORD="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

case "$MODE" in
  optional|required|disabled) ;;
  *) echo "Invalid mode: $MODE" >&2; usage; exit 1 ;;
esac

for cmd in curl jq; do
  command -v "$cmd" >/dev/null || { echo "$cmd is required" >&2; exit 1; }
done

if [ -z "$ADMIN_PASSWORD" ]; then
  read -r -s -p "Password for $ADMIN_USER: " ADMIN_PASSWORD
  echo
fi

TOKEN="$(curl -sSf -X POST "$KEYCLOAK_URL/realms/$ADMIN_REALM/protocol/openid-connect/token" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "client_id=admin-cli" \
  --data-urlencode "username=$ADMIN_USER" \
  --data-urlencode "password=$ADMIN_PASSWORD" | jq -r '.access_token')"

ADMIN_API="$KEYCLOAK_URL/admin/realms/$REALM"
FLOW_PATH="$(jq -rn --arg v "$FLOW_ALIAS" '$v|@uri')"

api() {
  local method="$1" path="$2"
  shift 2
  curl -sSf -X "$method" "$ADMIN_API$path" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" "$@"
}

update_realm() {
  api PUT "" -d "$1"
}

ensure_required_action_enabled() {
  local alias="$1" action
  action="$(api GET "/authentication/required-actions/$alias")"
  if [ "$(jq -r '.enabled' <<<"$action")" != "true" ]; then
    api PUT "/authentication/required-actions/$alias" -d "$(jq '.enabled = true' <<<"$action")"
  fi
}

create_required_flow() {
  if ! api GET "/authentication/flows" | jq -e --arg a "$FLOW_ALIAS" 'any(.[]; .alias == $a)' >/dev/null; then
    echo "~> Creating flow \"$FLOW_ALIAS\" (copy of \"browser\")"
    api POST "/authentication/flows/browser/copy" -d "$(jq -n --arg n "$FLOW_ALIAS" '{newName: $n}')" -o /dev/null
  fi

  # The conditional OTP sub-flow becomes REQUIRED: its condition is no longer evaluated and the
  # OTP form asks users without an authenticator to configure one (CONFIGURE_TOTP required action).
  local execution
  execution="$(api GET "/authentication/flows/$FLOW_PATH/executions" \
    | jq -c 'first(.[] | select(.authenticationFlow == true and (.displayName | test("Conditional OTP"))))')"
  if [ -z "$execution" ]; then
    echo "Conditional OTP sub-flow not found in \"$FLOW_ALIAS\"" >&2
    exit 1
  fi
  api PUT "/authentication/flows/$FLOW_PATH/executions" -d "$(jq '.requirement = "REQUIRED"' <<<"$execution")" -o /dev/null
}

echo "~> Configuring realm \"$REALM\" on $KEYCLOAK_URL (mode: $MODE)"

case "$MODE" in
  optional)
    ensure_required_action_enabled CONFIGURE_TOTP
    update_realm '{"loginTheme": "entando-mfa", "browserFlow": "browser"}'
    ;;
  required)
    ensure_required_action_enabled CONFIGURE_TOTP
    create_required_flow
    update_realm "$(jq -n --arg f "$FLOW_ALIAS" '{loginTheme: "entando-mfa", browserFlow: $f}')"
    ;;
  disabled)
    update_realm '{"loginTheme": "entando", "browserFlow": "browser"}'
    ;;
esac

echo "~> Done"
