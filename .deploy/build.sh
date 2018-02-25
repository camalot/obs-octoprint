#!/usr/bin/env bash
set -e;
base_dir=$(dirname "$0");
# shellcheck source=/dev/null
source "${base_dir}/shared.sh";

get_opts() {
	while getopts ":n:v:o:f" opt; do
	  case $opt in
			n) export opt_project_name="$OPTARG";
			;;
			v) export opt_version="$OPTARG";
			;;
			o) export opt_docker_org="$OPTARG";
			;;
			f) export opt_force="--no-cache ";
			;;
			\?) echo "Invalid option -$OPTARG" >&2;
			exit 1;
			;;
		esac;
	done;

	return 0;
};

get_opts "$@";

BUILD_PROJECT="${opt_project_name:-"${CI_PROJECT_NAME}"}";
BUILD_PUSH_REGISTRY="${DOCKER_REGISTRY}";
BUILD_VERSION="${opt_version:-"${CI_BUILD_VERSION:-"1.0.0-snapshot"}"}";
BUILD_ORG="${opt_docker_org}";

WORKDIR="${WORKSPACE:-"$(pwd)"}";

[[ -z "${BUILD_PROJECT// }" ]] && __error "Environment variable 'CI_PROJECT_NAME' missing or empty.";
[[ -z "${BUILD_VERSION// }" ]] && __error "Environment variable 'CI_BUILD_VERSION' missing or empty.";
[[ -z "${BUILD_PUSH_REGISTRY// }" ]] && __error "Environment variable 'DOCKER_REGISTRY' missing or empty.";
[[ -z "${BUILD_ORG// }" ]] && __error "Argument '-o' (organization) is missing or empty.";
[[ -z "${ARTIFACTORY_USERNAME// }" ]] && __error "Environment variable 'ARTIFACTORY_USERNAME' missing or empty.";
[[ -z "${ARTIFACTORY_PASSWORD// }" ]] && __error "Environment variable 'ARTIFACTORY_PASSWORD' missing or empty.";

	tag="${BUILD_ORG}/${BUILD_PROJECT}";
	tag_name_latest="${tag}:latest";
	tag_name_ver="${tag}:${BUILD_VERSION}";
	docker build ${opt_force}--pull \
		--build-arg BUILD_VERSION="${BUILD_VERSION}" \
		--build-arg PROJECT_NAME="${BUILD_PROJECT}" \
		--tag "${tag_name_ver}" \
		-f "${WORKDIR}/Dockerfile" .;

	# This will NOT push `tag:latest` if the build version is `1.0.0-snapshot`. It will still push the `1.0.0-snapshot` build.
	[[ ! $BUILD_VERSION =~ -snapshot$ ]] && \
		docker tag "${tag_name_ver}" "${tag_name_latest}" && \
		docker tag "${tag_name_ver}" "${BUILD_PUSH_REGISTRY}/${tag_name_latest}"

	docker tag "${tag_name_ver}" "${BUILD_PUSH_REGISTRY}/${tag_name_ver}";
unset BUILD_PROJECT;
unset BUILD_PUSH_REGISTRY;
unset BUILD_VERSION;
unset BUILD_ORG;
