FROM node:9-alpine

# set version label
ARG PROJECT_NAME="obs-octoprint"
ARG BUILD_VERSION="1.0.0-snapshot"

ARG PUID=3000
ARG PGID=3000

ARG VUSER="abc"
ARG VGROUP="abc"

RUN addgroup "${VGROUP}" -g "${PGID}" && \
	adduser -S -G "${VGROUP}" -u "${PUID}" "${VUSER}"

LABEL \
	LABEL="${PROJECT_NAME}-v${BUILD_VERSION}" \
	VERSION="${BUILD_VERSION}" \
	MAINTAINER="camalot <camalot@gmail.com>"

EXPOSE 3000

RUN \
	apk update && apk upgrade \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /octoprint


COPY . /octoprint
WORKDIR /octoprint

RUN \
	chown -R "${VUSER}:${VGROUP}" /octoprint

USER ${VUSER}

# npm config set registry https://artifactory.bit13.local/artifactory/api/npm/npm/ && \
# npm config set strict-ssl false && \
RUN \
	npm version "${BUILD_VERSION}" --git-tag-version && \
	npm install --production;

ENTRYPOINT ["npm", "start"]
