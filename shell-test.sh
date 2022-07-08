#!/usr/bin/env sh
# shellcheck disable=all
last=$_
echo "$0"
echo "$1"
echo "$*"
echo "$@"
echo "$last"
if [ -n "${BASH_SOURCE}" ]; then echo "${BASH_SOURCE[0]}"; else echo ""; fi
x=$(lsof -p $$ -Fn0 | tail -1); echo "${x#n}"
for i in "$@"; do true; done; echo "$i"
