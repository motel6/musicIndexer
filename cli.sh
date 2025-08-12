#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

cd "${BASH_SOURCE%/*}"

declare -r cliPath="$(readlink ${BASH_SOURCE})"

cd "${cliPath%/*}"

source "./main.sh" && main "${@}"