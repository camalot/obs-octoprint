#!/usr/bin/env bash
set -e;

base_dir=$(dirname "$0");
# shellcheck source=/dev/null
source "${base_dir}/shared.sh";

get_opts() {
	while getopts ":v:n:o" opt; do
		case $opt in
			v) export opt_version="$OPTARG";
			;;
			n) export opt_name="$OPTARG";
			;;
			o) export opt_org="$OPTARG";
			;;
			\?) echo "Invalid option -$OPTARG" >&2;
			exit 1;
			;;
		esac;
	done;

	return 0;
};


tag_exists() {
	RESULT=$(curl -u "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD}" --insecure -s -X GET "https://${PULL_REPOSITORY}/v2/$1/tags/list?page_size=10000");
	EXISTS=$(echo $RESULT | jq -r "[.tags | to_entries | .[] | .value == \"$2\"] | any");
	test $EXISTS = true;
}

[[ -z "${ARTIFACTORY_USERNAME// }" ]] && __error "Environment variable 'ARTIFACTORY_USERNAME' missing";
[[ -z "${ARTIFACTORY_PASSWORD// }" ]] && __error "Environment variable 'ARTIFACTORY_PASSWORD' missing";

WORKDIR="${WORKSPACE:-"${pwd}"}";
get_opts "$@";

DOCKER_ORG="${opt_org:-"${CI_DOCKER_ORGANIZATION}"}";
TAG_VERSION="${opt_version:-"${CI_BUILD_VERSION}"}";
INSTANCE_NAME="${opt_name:-"${CI_PROJECT_NAME}"}";
PULL_REPOSITORY="${DOCKER_REGISTRY}";
DOCKER_IMAGE="${DOCKER_ORG}/${INSTANCE_NAME}";

[[ -z "${DOCKER_ORG// }" ]] && __error "Environment variable 'CI_DOCKER_ORGANIZATION' missing or empty.";
[[ -z "${TAG_VERSION// }" ]] && __error "Environment variable 'CI_BUILD_VERSION' missing or empty.";
[[ -z "${INSTANCE_NAME// }" ]] && __error "Environment variable 'CI_PROJECT_NAME' missing or empty.";
[[ -z "${PULL_REPOSITORY// }" ]] && __error "Environment variable 'DOCKER_REGISTRY' missing or empty.";


! tag_exists "${DOCKER_IMAGE}" "${TAG_VERSION}" && __error "Tag '${DOCKER_IMAGE}/${TAG_VERSION}' was not found";

exit 0;
