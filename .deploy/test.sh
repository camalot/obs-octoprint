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

#npm run test;

exit 0;


# WORKDIR="${WORKSPACE:-"${pwd}"}";
# BUILD_PROJECT="${opt_project_name:-"${CI_PROJECT_NAME}"}";
# BUILD_VERSION="${opt_version:-"${CI_BUILD_VERSION:-"1.0.0-snapshot"}"}";
# BUILD_ORG="${opt_docker_org}";

# [[ -z "${BUILD_PROJECT// }" ]] && __error "Environment variable 'CI_PROJECT_NAME' missing or empty.";
# [[ -z "${BUILD_VERSION// }" ]] && __error "Environment variable 'CI_BUILD_VERSION' missing or empty.";
# [[ -z "${BUILD_ORG// }" ]] && __error "Argument '-o' (organization) is missing or empty.";

# tag="${BUILD_ORG}/${BUILD_PROJECT}";
# tag_name_ver="${tag}:${BUILD_VERSION}";

# docker run --rm \
#     -v "$(pwd)":/work \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     docker.artifactory.bit13.local/camalot/dgoss "${tag_name_ver}" || exit 1;
