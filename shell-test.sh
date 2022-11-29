#!/usr/bin/env sh
# shellcheck disable=SC2142

# shellcheck disable=SC3028
DOLLAR_UNDER=$_
echo "\$0=$0"
echo "\$1=$1"
echo "\$*=$*"
echo "\$@:"
echo "$@"
echo "\$DOLLAR_UNDER=$DOLLAR_UNDER"
echo "\$SHELL=$SHELL"
# shellcheck disable=SC2128,SC3054
if [ -n "${BASH_SOURCE}" ]; then echo "\${BASH_SOURCE[0]}=${BASH_SOURCE[0]}"; else echo "NO BASH_SOURCE"; fi
x=$(lsof -p $$ -Fn0 | tail -1); echo "\${x#n}=${x#n}"
echo "for i in \"\$@\":"
for i in "$@"; do true; done; echo "$i"
p0pid=$(ps -o ppid= -o command= -p $$)
echo "p0pid=$p0pid"
p0pid=$(echo "$p0pid" | awk '{ print $1 }')
p1pid=$(ps -o ppid= -o command= -p "$p0pid")
echo "p1pid=$p1pid"
p1pid=$(echo "$p1pid" | awk '{ print $1 }')
p2pid=$(ps -o ppid= -o command= -p "$p1pid")
echo "p2pid=$p2pid"
p2pid=$(echo "$p2pid" | awk '{ print $1 }')
p3pid=$(ps -o ppid= -o command= -p "$p2pid")
echo "p3pid=$p3pid"

test_offset() { echo "$LINENO"; }
LINENO_GLOBAL_OFFSET=$(test_offset)
echo "LINENO_GLOBAL_OFFSET=$LINENO_GLOBAL_OFFSET"

echo
env | sort
echo

mkdir -p ./tmp

test_shell() {
    echo "$1":
    ln -sf "$(which "$1")" ./tmp/sh
    ./tmp/sh shell-test-toplevel.sh
    echo
}

if [ "$1" = "" ]; then
    test_shell bash
    test_shell dash
    test_shell zsh
fi
