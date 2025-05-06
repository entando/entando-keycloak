#!/bin/bash

. "/opt/convert-vars.sh"

echo "~> Starting keycloak.." 1>&2

term_handler() {
  echo "SIGTERM received, shutting down..."
  exit 0
}

trap 'term_handler' SIGTERM

exec "/opt/keycloak/bin/kc.sh" "start"
