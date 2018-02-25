#!/usr/bin/env bash

set -e;

base_dir=$(dirname "$0");
# shellcheck source=/dev/null
source "${base_dir}/shared.sh";

get_opts() {
	while getopts ":v:n:o:f" opt; do
		case $opt in
			v) export opt_version="$OPTARG";
			;;
			n) export opt_name="$OPTARG";
			;;
			o) export opt_org="$OPTARG";
			;;
			f) export opt_force=1;
			;;
			\?) __error "Invalid option '-${OPTARG}'";
			;;
	  esac;
	done;

	return 0;
};


get_opts "$@";

FORCE_DEPLOY=${opt_force:-0};
BUILD_PROJECT="${opt_project_name:-"${CI_PROJECT_NAME}"}";
BUILD_VERSION="${opt_version:-"${CI_BUILD_VERSION:-"1.0.0-snapshot"}"}";
BUILD_ORG="${opt_org:-"${CI_DOCKER_ORGANIZATION}"}";
PULL_REPOSITORY="${DOCKER_REGISTRY}";

[[ -z "${PULL_REPOSITORY// }" ]] && __error "Environment Variable 'DOCKER_REGISTRY' missing or is empty";
[[ -z "${BUILD_PROJECT// }" ]] && __error "Environment Variable 'CI_PROJECT_NAME' missing or is empty";
[[ -z "${BUILD_VERSION// }" ]] && __error "Environment variable 'CI_BUILD_VERSION' missing or is empty";
[[ -z "${BUILD_ORG// }" ]] && __error "Environment variable 'CI_DOCKER_ORGANIZATION' missing or is empty";

[[ -z "${OCTOPRINT_HOST// }" ]] && __error "Environment variable 'OCTOPRINT_HOST' missing or is empty";
[[ -z "${OCTOPRINT_PORT// }" ]] && __error "Environment variable 'HUBOT_REACTION_RESPONSES' missing or is empty";
[[ -z "${OCTOPRINT_API_KEY// }" ]] && __error "Environment variable 'HUBOT_SLACK_TOKEN' missing or is empty";

DOCKER_IMAGE="${BUILD_ORG}/${BUILD_PROJECT}:${BUILD_VERSION}";

echo "${DOCKER_REGISTRY}/${DOCKER_IMAGE}";

docker login --username "${ARTIFACTORY_USERNAME}" "${PULL_REPOSITORY}" --password-stdin <<< "${ARTIFACTORY_PASSWORD}";

docker pull "${DOCKER_REGISTRY}/${DOCKER_IMAGE}";


# CHECK IF IT IS CREATED, IF IT IS, THEN DEPLOY
DC_INFO=$(docker ps --all --format "table {{.Status}}\t{{.Names}}" | awk '/obs-octoprint$/ {print $0}');
__info "DC_INFO: $DC_INFO";
DC_STATUS=$(echo "${DC_INFO}" | awk '{print $1}');
__info "DC_STATUS: $DC_STATUS";
__info "FORCE_DEPLOY: $FORCE_DEPLOY";
if [[ -z "${DC_STATUS}" ]] && [ $FORCE_DEPLOY -eq 0 ]; then
	__warning "Container '$DOCKER_IMAGE' not deployed. Skipping deployment";
	exit 0;
fi

if [[ ! $DC_STATUS =~ ^Exited$ ]]; then
  __info "stopping container";
	docker stop "${BUILD_PROJECT}" || __warning "Unable to stop '${BUILD_PROJECT}'";
fi
if [[ ! -z "${DC_INFO}" ]]; then
  __info "removing image";
	docker rm "${BUILD_PROJECT}" || __warning "Unable to remove '${BUILD_PROJECT}'";
fi


docker run -d \
	--user 0 \
	--restart unless-stopped \
	--name "${BUILD_PROJECT}" \
	-e OCTOPRINT_API_KEY="${OCTOPRINT_API_KEY}" \
	-e OCTOPRINT_HOST="${OCTOPRINT_HOST}" \
	-e OCTOPRINT_PORT="${OCTOPRINT_PORT}" \
	-P \
	-t "${DOCKER_IMAGE}";
