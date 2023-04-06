#!/bin/bash

. .ent/enp-prereq.sh


just-build() {
  local build="$1"
  IFS=',' read -r _dockerFile _dockerImageAddress <<<"${build//=>/,}"
  docker build -t "$ENTANDO_OPT_DOCKER_ORG/$_dockerImageAddress:$ENTANDO_PRJ_VERSION" -f "$_dockerFile" .
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_log_i "Starting the login process over redhat here"

docker login --username "$ENTANDO_RHT_DOCKER_USERNAME" \
--password-stdin <<< "$ENTANDO_RHT_DOCKER_PASSWORD" "$ENTANDO_RHT_DOCKER_REGISTRY"

_log_i "Ending the login process over redhat here"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

_log_i "Running build"

_log_i "Building \"$ENTANDO_OPT_DOCKER_ORG/$ENTANDO_PRJ_IMAGE_NAME:$ENTANDO_PRJ_VERSION\""

while IFS= read -r build; do
  echo "$build"
  just-build "$build"
done <<< "${ENTANDO_OPT_DOCKER_BUILDS//,/$'\n'}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_log_i "Starting the logout process over redhat here"

docker logout

_log_i "Ending the logout process over redhat here"