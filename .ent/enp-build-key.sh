#!/bin/bash

TMP="$(cat Dockerfile.keycloak Dockerfile.redhat-sso  | sha256sum --zero | cut -d' ' -f1)"
TMP+="${PPL_COMMIT_ID}_${ENTANDO_PRJ_VERSION}"
echo "$TMP"