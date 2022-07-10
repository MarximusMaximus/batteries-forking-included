#!/usr/bin/env sh
# shellcheck disable=all
DOLLAR_UNDER=$_
echo "\$0=$0"
echo "\$1=$1"
echo "\$*=$*"
echo "\$@:"
echo "$@"
echo "\$DOLLAR_UNDER=$DOLLAR_UNDER"
if [ -n "${BASH_SOURCE}" ]; then echo "\${BASH_SOURCE[0]}=${BASH_SOURCE[0]}"; else echo "NO BASH_SOURCE"; fi
x=$(lsof -p $$ -Fn0 | tail -1); echo "\${x#n}=${x#n}"
echo "for i in \"\$@\":"
for i in "$@"; do true; done; echo "$i"
