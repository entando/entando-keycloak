#!/bin/bash

. .ent/enp-prereq.sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
just-publish() {
  local build="$1"
  IFS=',' read -r _dockerFile _dockerImageAddress <<<"${build//=>/,}"

  IMAGE="$ENTANDO_OPT_DOCKER_ORG/$_dockerImageAddress:$ENTANDO_PRJ_VERSION"
  _log_i "Publishing \"$IMAGE\" to \"$ENTANDO_PRJ_IMAGE_REGISTRY\""

  docker tag "$IMAGE" "$ENTANDO_PRJ_IMAGE_REGISTRY/$IMAGE"
  docker push "$ENTANDO_PRJ_IMAGE_REGISTRY/$IMAGE"

}

_log_i "Running publication"

docker login "$ENTANDO_PRJ_IMAGE_REGISTRY" \
  --username "$ENTANDO_OPT_DOCKER_USERNAME" \
  --password-stdin <<< "$ENTANDO_OPT_DOCKER_PASSWORD"

while IFS= read -r build; do
  _log_i "use config $build to publish"
  just-publish "$build"
done <<< "${ENTANDO_OPT_DOCKER_BUILDS//,/$'\n'}"