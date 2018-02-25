#!/usr/bin/env bash

__error() {
	RED='\e[0;31m';
	NC='\e[0m';
	(>&2 echo -e "${RED}${1}${NC}");
	exit 9;
}
__warning() {
	YELLOW='\e[0;33m';
	NC='\e[0m';
	(>&2 echo -e "${YELLOW}${1}${NC}");
}
__info() {
	NC='\e[0m';
	(>&2 echo -e "${NC}${1}${NC}");
}
