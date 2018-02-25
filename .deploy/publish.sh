#!/usr/bin/env bash
set -e;
base_dir=$(dirname "$0");

# shellcheck source=.deploy/shared.sh
# shellcheck disable=SC1091
source "${base_dir}/shared.sh";

get_opts() {
	while getopts ":n:v:o:" opt; do
	  case $opt in
			n) export opt_project_name="$OPTARG";
			;;
			v) export opt_version="$OPTARG";
			;;
			o) export opt_org="$OPTARG";
			;;
	    \?) __error "Invalid option $opt";
	    ;;
	  esac;
	done;
	return 0;
};

get_opts "$@";

PROJECT_NAME="${opt_project_name:-"${CI_PROJECT_NAME}"}";
BUILD_VERSION="${opt_version:-"${CI_BUILD_VERSION:-"1.0.0-snapshot"}"}";
BUILD_ORG="${opt_org:-"${CI_DOCKER_ORGANIZATION}"}";

[[ -z "${PROJECT_NAME// }" ]] && __error "Environment variable 'CI_PROJECT_NAME' missing or is empty";
[[ -z "${BUILD_VERSION// }" ]] && __error "Environment variable 'CI_BUILD_VERSION' missing or is empty";
[[ -z "${BUILD_ORG// }" ]] && __error "Environment variable 'CI_DOCKER_ORGANIZATION' missing or is empty";

TARBALL="${base_dir}/../dist/${BUILD_ORG}-${PROJECT_NAME}-${BUILD_VERSION}.tgz";
[ ! -f "${TARBALL}" ] && __error "cannot find file '${TARBALL}'." && exit 4;

[[ ! $BUILD_VERSION =~ -snapshot$ ]] && \
	npm publish "$TARBALL";
[[ $BUILD_VERSION =~ -snapshot$ ]] && \
	npm publish "$TARBALL";

__info "published '$TARBALL'";
exit 0;
