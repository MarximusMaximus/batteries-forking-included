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

my_shell_exec=$(ps -o comm= -p $$)

test_offset() { echo "$LINENO"; }
LINENO_OFFSET=$(test_offset)
echo "LINENO_OFFSET=$LINENO_OFFSET"

echo
env | sort
echo

set -x
PS4="+ \$0:\$LINENO - "

#def_G() {
#    sh -c "echo = $1:$2:\$(head -n $2 $1 | tail -n 1 | awk '{ print \$2 }' | tr -d '()')"
#}
#alias def="def_G \"\$0\" \"\$LINENO\" "

alias def="sh -c \"echo = \$0:\$LINENO:\\\$(head -n \$LINENO \$0 | tail -n 1 | awk '{ print \\\$2 }' | tr -d '()')\""

call_G () {
    >&2 echo "- $1:$2"
    shift
    "$@"
    return $?
}
alias call="call_G \"\$0:\$LINENO\""


# alias call="true \"- \$0:\$LINENO\";"


def; foo() {
    echo foo "$@";
}
def; bar() {
    call foo "$@";
}
def; baz() { (
    call bar "$@" );
}
def; asdf() {
    echo asdf "$(call baz "$@")";
}
def; qwerty() {
    echo qwerty "$(call asdf "$@")";
}


call qwerty 1 2 3 4 5

echo INVOKE: shell-test-module.sh
"$my_shell_exec" ./shell-test-module.sh

echo SOURCE: shell-test-module.sh
. ./shell-test-module.sh

echo FROM TOP LEVEL:
call qwerty2 11 12 13 14 15
