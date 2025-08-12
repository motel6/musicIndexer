#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

cd "${BASH_SOURCE%/*}"

[[ -e "/bin/mscidx" ]] && rm "/bin/mscidx"

ln -s "$(realpath ./cli.sh)" "/bin/mscidx"

chmod +x "/bin/mscidx"
