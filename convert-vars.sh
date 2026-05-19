#!/bin/bash

_log() {
  echo "~> $*" 1>&2
}

_log "Starting Keycloak variables mapping"

# ADMIN USER
if [ -n "${SSO_ADMIN_USERNAME}" ]; then
  export KC_ADMIN="${SSO_ADMIN_USERNAME}"
  export KC_ADMIN_PASSWORD="${SSO_ADMIN_PASSWORD}"
else
  export KC_ADMIN="${KEYCLOAK_USER}"
  export KC_ADMIN_PASSWORD="${KEYCLOAK_PASSWORD}"
fi
if [ -n "${KC_ADMIN}" ]; then
  export KEYCLOAK_ADMIN="${KC_ADMIN}"
  export KEYCLOAK_ADMIN_PASSWORD="${KC_ADMIN_PASSWORD}"
  # Export backward-compatible variables for EntandoKeycloakServerController
  export KEYCLOAK_USER="${KC_ADMIN}"
  export KEYCLOAK_PASSWORD="${KC_ADMIN_PASSWORD}"
  export SSO_ADMIN_USERNAME="${KC_ADMIN}"
  export SSO_ADMIN_PASSWORD="${KC_ADMIN_PASSWORD}"
fi

# SERVLET SETTINGS
DEFAULT_SERVER_SERVLET_CONTEXT_PATH="/auth"
export KC_HOSTNAME_STRICT="${KC_HOSTNAME_STRICT:-false}"
export KC_HTTP_RELATIVE_PATH="${SERVER_SERVLET_CONTEXT_PATH:-"$DEFAULT_SERVER_SERVLET_CONTEXT_PATH"}"
export KC_HTTP_ENABLED="${KC_HTTP_ENABLED:-"true"}"

if [ -z "${KC_PROXY_HEADERS}" ]; then
  if [ "${PROXY_ADDRESS_FORWARDING}" = "true" ]; then
    export KC_PROXY_HEADERS="xforwarded"
  fi
fi

# DB SETTINGS
if [[ -n "$DB_VENDOR" && ( "$DB_VENDOR" == "h2" || "$DB_VENDOR" == "H2" ) ]]; then
  export KC_DB="dev-mem"
else
  export KC_DB="${DB_VENDOR,,}"
fi
if [ -n "${DB_POSTGRESQL_SERVICE_HOST}" ]; then
  export KC_DB_URL_HOST="${DB_POSTGRESQL_SERVICE_HOST}"
  export KC_DB_URL_PORT="${DB_POSTGRESQL_SERVICE_PORT}"
elif [ -n "${DB_MYSQL_SERVICE_HOST}" ]; then
  export KC_DB_URL_HOST="${DB_MYSQL_SERVICE_HOST}"
  export KC_DB_URL_PORT="${DB_MYSQL_SERVICE_PORT}"
else
  export KC_DB_URL_HOST="${DB_ADDR}"
  export KC_DB_URL_PORT="${DB_PORT}"
fi
if [ -n "${DB_USERNAME}" ]; then
  export KC_DB_USERNAME="${DB_USERNAME}"
elif [ -n "${DB_USER}" ]; then
  export KC_DB_USERNAME="${DB_USER}"
fi
export KC_DB_PASSWORD="${DB_PASSWORD}"
if [ -n "${DB_SCHEMA}" ]; then
  export KC_DB_SCHEMA="${DB_SCHEMA}"
fi
if [ -n "${JDBC_PARAMS}" ]; then
  export KC_DB_URL_PROPERTIES="${JDBC_PARAMS}"
fi
if [ -n "${DB_DATABASE}" ]; then
  export KC_DB_URL_DATABASE="${DB_DATABASE}"
fi

if [ "${ENTANDO_KC_DB_CONN_MODE}" = "implicit-url" ]; then
  KC_DB_URL_HOST="" KC_DB_URL_PORT="" KC_DB_URL_DATABASE=""
  KC_DB_URL="jdbc:${KC_DB}://${KC_DB_URL_HOST}:${KC_DB_URL_PORT}/${KC_DB_URL_DATABASE}"
  [[ -n "${KC_DB_URL_PROPERTIES}" ]] && KC_DB_URL+="?${KC_DB_URL_PROPERTIES}"
  export KC_DB_URL
elif [ "${ENTANDO_KC_DB_CONN_MODE}" = "url" ]; then
  export KC_DB_URL
else
  KC_DB_URL=""
fi

cat 1>&2 <<-EOS
~> Resulting Keycloak Variables:
  DB_VENDOR: "${DB_VENDOR}"
  KC_DB: "${KC_DB}"
  KC_DB_URL_HOST: "${KC_DB_URL_HOST}"
  KC_DB_URL_PORT: "${KC_DB_URL_PORT}"
  KC_DB_URL_DATABASE: "${KC_DB_URL_DATABASE}"
  KC_DB_USERNAME: "${KC_DB_USERNAME}"
  KC_DB_SCHEMA: "${KC_DB_SCHEMA}"
  KC_DB_URL: "${KC_DB_URL}"
  KC_HTTP_RELATIVE_PATH: "${KC_HTTP_RELATIVE_PATH}"
  KC_ADMIN: "${KC_ADMIN}"
  KC_PROXY_HEADERS: "${KC_PROXY_HEADERS}"
  KC_HOSTNAME_STRICT: "${KC_HOSTNAME_STRICT}"
EOS
