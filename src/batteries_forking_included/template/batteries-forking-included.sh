#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"

################################################################################
#region Usage Text

usage_text__update=$(cat<<EOF
Usage:
    bfi-update.sh [flags|options]

Global Flags:
    -h, -?, --help, --usage
                        display this message
    -q, --quiet         forcibly reduce output to minimal
    +q, --no-quiet      do not forcibly reduce output to minimal
    -v, --verbose       increase output verbosity by one level
                        may be specified multiple times
                        default: 1
    +v, --no-verbose    reduce output verbosity by one level
                        may be specified multiple times
    -c, --color         use colorized output
                        default: use color
    +c, --no-color      do not use colorized output
    -C, --alt-color     use alternate colorized output
                        [accessibility]
                        greens will become blues
                        NOTE: purples are never used to begin with
                        WARNING: pip, poetry, and other helpers may not abide
    +C, --no-alt-color  do not use alternate colorized output
    -r, --report        display report at end of run
                        default: true
    +r, --no-report     do NOT display report at end of run

Global Options:
    * [=] denotes optional equals sign
    --verbosity[=]VERBOSITY_LEVEL, --log-level[=]VERBOSITY_LEVEL
                        explicitly set the verbosity level
                        default: 1
    -b[=]BFI_DIR, --bfi-dir[=]BFI_DIR
                        override to use specified batteries-forking-included dir
                        default: sibling directory of PROJECT_DIR named
                            batteries-forking-included
    -p[=]PROJECT_DIR, --project-dir[=]PROJECT_DIR
                        override to use specified project dir
                        default: current working directory of invocation
    -P[=]PROJECT_BASE_NAME, --project-base-name[=]PROJECT_BASE_NAME
                        override to use specified project base name
                        default: basename of PROJECT_DIR

Positional Arguments:
    NONE

Subcommands:
    NONE
EOF
)
export usage_text__update

usage_text__bootstrap=$(cat<<EOF
Usage:
    bootstrap.sh [flags|options] [subcommand]

Global Flags:
    -h, -?, --help, --usage
                        display this message
    -V, --version       print version number
    -q, --quiet         forcibly reduce output to minimal
    +q, --no-quiet      do not forcibly reduce output to minimal
    -v, --verbose       increase output verbosity by one level
                        may be specified multiple times
                        default: 1
    +v, --no-verbose    reduce output verbosity by one level
                        may be specified multiple times
    -c, --color         use colorized output
                        default: use color
    +c, --no-color      do not use colorized output
    -C, --alt-color     use alternate colorized output
                        [accessibility]
                        greens will become blues
                        NOTE: purples are only used for debugging BFI itself,
                            neither devs using BFI nor users of programs using
                            BFI should ever see purples in their logs
                        WARNING: pip, poetry, and other helpers may not abide by
                            this setting
                        default: false
    +C, --no-alt-color  do not use alternate colorized output
    -r, --report        display report at end of run
                        default: true
    +r, --no-report     do NOT display report at end of run
    -d, --dev, --developer
                        install as developer (include development dependencies)
                        default: false
    +d, --no-dev, --no-develeoper
                        do not install as developer
    -D, --deploy, --deployment
                        install as a deployment
    +D, --no-deploy, --no-deployment
                        do not install as a deployment

Global Options:
    * [=] denotes optional equals sign
    --verbosity[=]VERBOSITY_LEVEL, --log-level[=]VERBOSITY_LEVEL
                        explicitly set the verbosity level
                        default: 1
    -b[=]BFI_DIR, --bfi-dir[=]BFI_DIR
                        override to use specified batteries-forking-included dir
                        default: sibling directory of PROJECT_DIR named
                            batteries-forking-included
    -p[=]PROJECT_DIR, --project-dir[=]PROJECT_DIR
                        override to use specified project dir
                        default: current working directory of invocation
    -P[=]PROJECT_BASE_NAME, --project-base-name[=]PROJECT_BASE_NAME
                        override to use specified project base name
                        default: basename of PROJECT_DIR

Positional Arguments:
    NONE

Subcommands:
    NONE
EOF
)
export usage_text__bootstrap

#endregion Usage Text
################################################################################

################################################################################
#region marximus-shell-extensions Base Preamble

if [ "${__MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD}" = "" ]; then
    __MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD="${-:+"-$-"}"
fi
if [ "$ZSH_VERSION" != "" ]; then
    # shellcheck disable=3041
    set -y
fi

__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__OPTIONS_OLD="${-:+"-$-"}"
set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then
    # NOTE: fence is created later

    # Call Stack Tracking needs to be in multiple parts, because aliases
    #   cannot be declared and used within the same if block

    #===============================================================================
    #region Call Stack Tracking Part 1

    PS4="+ \$(set +x; nullcall array_peek SHELL_CALL_STACK_DEST_PUUID 2>/dev/null || echo $0):\$LINENO: "

    #-------------------------------------------------------------------------------
    # line offset checking
    test_LINENO_GLOBAL_OFFSET() { echo "$LINENO"; }
    LINENO_GLOBAL_OFFSET="$(test_LINENO_GLOBAL_OFFSET)"
    LINENO_IS_RELATIVE=false
    if [ "$LINENO_GLOBAL_OFFSET" = "" ]; then
        LINENO_GLOBAL_OFFSET=0
    elif [ "$LINENO_GLOBAL_OFFSET" -le 1 ]; then
        LINENO_IS_RELATIVE=true
    else
        LINENO_GLOBAL_OFFSET=0
    fi
    unset -f test_LINENO_GLOBAL_OFFSET
    export LINENO_GLOBAL_OFFSET
    export LINENO_IS_RELATIVE

    OPTION_SETTRACE=false
    if [ "$(echo "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__OPTIONS_OLD}" | grep -e 'x')" != "" ]; then
        OPTION_SETTRACE=true
    fi
    export OPTION_SETTRACE

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init WAS_SOURCED
    WAS_SOURCED="__array__"
    export WAS_SOURCED
    __array__WAS_SOURCED="__array__"
    export __array__WAS_SOURCED
    __array__WAS_SOURCED__length=0
    export __array__WAS_SOURCED__length
    # unrolled array_init & array_export end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_SOURCE
    SHELL_SOURCE="__array__"
    export SHELL_SOURCE
    __array__SHELL_SOURCE="__array__"
    export __array__SHELL_SOURCE
    __array__SHELL_SOURCE__length=0
    export __array__SHELL_SOURCE__length
    # unrolled array_init & array_export end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_SOURCE_PUUID
    SHELL_SOURCE_PUUID="__array__"
    export SHELL_SOURCE_PUUID
    __array__SHELL_SOURCE_PUUID="__array__"
    export __array__SHELL_SOURCE_PUUID
    __array__SHELL_SOURCE_PUUID__length=0
    export __array__SHELL_SOURCE_PUUID__length
    # unrolled array_init & array_export end

    # unrolled dict_init & dict_init begin (optimized)
    # nullcall dict_init SHELL_SOURCE_PUUID_DICT
    SHELL_SOURCE_PUUID_DICT="__dict__"
    export SHELL_SOURCE_PUUID_DICT
    __dict__SHELL_SOURCE_PUUID_DICT="__dict__"
    export __dict__SHELL_SOURCE_PUUID_DICT
    __dict__SHELL_SOURCE_PUUID_DICT__length=0
    export __dict__SHELL_SOURCE_PUUID_DICT__length
    __dict__SHELL_SOURCE_PUUID_DICT__keys="__array__"
    export __dict__SHELL_SOURCE_PUUID_DICT__keys
    __array____dict__SHELL_SOURCE_PUUID_DICT__keys="__array__"
    export __array____dict__SHELL_SOURCE_PUUID_DICT__keys
    __array____dict__SHELL_SOURCE_PUUID_DICT__keys__length=0
    export __array____dict__SHELL_SOURCE_PUUID_DICT__keys__length
    # unrolled dict_init & dict_init end

    # unrolled dict_init & dict_init begin (optimized)
    # nullcall dict_init SHELL_DEF_SOURCE_PUUID
    # nullcall dict_export SHELL_DEF_SOURCE_PUUID
    SHELL_DEF_SOURCE_PUUID="__dict__"
    export SHELL_DEF_SOURCE_PUUID
    __dict__SHELL_DEF_SOURCE_PUUID="__dict__"
    export __dict__SHELL_DEF_SOURCE_PUUID
    __dict__SHELL_DEF_SOURCE_PUUID__length=0
    export __dict__SHELL_DEF_SOURCE_PUUID__length
    __dict__SHELL_DEF_SOURCE_PUUID__keys="__array__"
    export __dict__SHELL_DEF_SOURCE_PUUID__keys
    __array____dict__SHELL_DEF_SOURCE_PUUID__keys="__array__"
    export __array____dict__SHELL_DEF_SOURCE_PUUID__keys
    __array____dict__SHELL_DEF_SOURCE_PUUID__keys__length=0
    export __array____dict__SHELL_DEF_SOURCE_PUUID__keys__length
    # unrolled dict_init & dict_init end

    # unrolled dict_init & dict_init begin (optimized)
    # nullcall dict_init SHELL_DEF_LINENO
    # nullcall dict_export SHELL_DEF_LINENO
    SHELL_DEF_LINENO="__dict__"
    export SHELL_DEF_LINENO
    __dict__SHELL_DEF_LINENO="__dict__"
    export __dict__SHELL_DEF_LINENO
    __dict__SHELL_DEF_LINENO__length=0
    export __dict__SHELL_DEF_LINENO__length
    __dict__SHELL_DEF_LINENO__keys="__array__"
    export __dict__SHELL_DEF_LINENO__keys
    __array____dict__SHELL_DEF_LINENO__keys="__array__"
    export __array____dict__SHELL_DEF_LINENO__keys
    __array____dict__SHELL_DEF_LINENO__keys__length=0
    export __array____dict__SHELL_DEF_LINENO__keys__length
    # unrolled dict_init & dict_init end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_CALL_STACK
    # nullcall array_export SHELL_CALL_STACK
    SHELL_CALL_STACK="__array__"
    export SHELL_CALL_STACK
    __array__SHELL_CALL_STACK="__array__"
    export __array__SHELL_CALL_STACK
    __array__SHELL_CALL_STACK__length=0
    export __array__SHELL_CALL_STACK__length
    # unrolled array_init end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_CALL_STACK_SOURCE_PUUID
    SHELL_CALL_STACK_SOURCE_PUUID="__array__"
    export SHELL_CALL_STACK_SOURCE_PUUID
    __array__SHELL_CALL_STACK_SOURCE_PUUID="__array__"
    export __array__SHELL_CALL_STACK_SOURCE_PUUID
    __array__SHELL_CALL_STACK_SOURCE_PUUID__length=0
    export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
    # unrolled array_init end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_CALL_STACK_DEST_PUUID
    SHELL_CALL_STACK_DEST_PUUID="__array__"
    export SHELL_CALL_STACK_DEST_PUUID
    __array__SHELL_CALL_STACK_DEST_PUUID="__array__"
    export __array__SHELL_CALL_STACK_DEST_PUUID
    __array__SHELL_CALL_STACK_DEST_PUUID__length=0
    export __array__SHELL_CALL_STACK_DEST_PUUID__length
    # unrolled array_init end

    # unrolled array_init & array_export begin (optimized)
    # nullcall array_init SHELL_CALL_STACK_FUNCNAME
    SHELL_CALL_STACK_FUNCNAME="__array__"
    export SHELL_CALL_STACK_FUNCNAME
    __array__SHELL_CALL_STACK_FUNCNAME="__array__"
    export __array__SHELL_CALL_STACK_FUNCNAME
    __array__SHELL_CALL_STACK_FUNCNAME__length=0
    export __array__SHELL_CALL_STACK_FUNCNAME__length
    # unrolled array_init end

    #-------------------------------------------------------------------------------
    # def; keyword
    # 'true' is a command that returns 0 and is effectively a no-op command
    # so when 'def;' used to declare a function:
    #   def; foo() {}
    #          ^ NOTE: the semicolon
    # it will do essentially nothing (which is what we want!)
    alias nulldef="true"

    #endregion Call Stack Tracking Part 1
    #===============================================================================
fi

# NOTE: Separation b/c cannot define and then use aliases in same block

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then
    # NOTE: fence is created later

    #===============================================================================
    #region Call Stack Tracking Part 2

    #-------------------------------------------------------------------------------
    # "def;" keyword
    # when 'def;' used to declare a function:
    #   def; foo() {}
    #      ^ NOTE: the semicolon
    # it will track the puuid of the file where the function is declared and
    # the true line number where the function is declared in that file
    nulldef; def_G() {
        __MARXIMUS_SHELL_EXTENSIONS__def_G__OPTIONS_OLD="${-:+"-$-"}"
        set +x

        # incoming $LINENO
        __def_G_lineno=$1

        # get the current context's puuid from the call stack
        # unrolled array_peek begin (optimized)
        # __def_G_puuid="$(nullcall array_peek SHELL_CALL_STACK_SOURCE_PUUID)"
        __def_G_puuid__index=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length - 1 ))
        eval "__def_G_puuid=\${__array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__def_G_puuid__index}}"
        # unrolled array_peek end

        # get the real filepath of the puuid
        # unrolled dict_get_key begin (optimized)
        # __def_G_filepath="$(nullcall dict_get_key SHELL_SOURCE_PUUID_DICT "${__def_G_puuid}")"
        # shellcheck disable=SC2154
        __def_G_filepath__key_hash="$( (printf "%s" "${__def_G_puuid}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__def_G_puuid}" | shasum -a 1) | cut -d' ' -f1)"
        eval "__def_G_filepath=\"\${__dict__SHELL_SOURCE_PUUID_DICT__key__${__def_G_filepath__key_hash}}\""
        # unrolled dict_get_key end

        # get the context's func name from the call stack
        # unrolled array_peek begin (optimized)
        # __def_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"
        __def_G_parent_funcname__index=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
        eval "__def_G_parent_funcname=\${__array__SHELL_CALL_STACK_FUNCNAME__index__${__def_G_parent_funcname__index}}"
        # unrolled array_peek end

        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            # get the current parent's lineno
            # unrolled dict_get_key begin (optimized)
            # __def_G_parent_lineno_offset=$(nullcall dict_get_key SHELL_DEF_LINENO "${__def_G_parent_funcname}")
            # shellcheck disable=SC2154
            __def_G_parent_lineno_offset__key_hash="$( (printf "%s" "${__def_G_parent_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__def_G_parent_funcname}" | shasum -a 1) | cut -d' ' -f1)"
            eval "__def_G_parent_lineno_offset=\"\${__dict__SHELL_DEF_LINENO__key__${__def_G_parent_lineno_offset__key_hash}}\""
            # unrolled dict_get_key end

            # recalculate lineno to account for parent's lineno and the global offset
            # shellcheck disable=SC2154
            __def_G_lineno=$(( __def_G_lineno + __def_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
        fi

        # get the func's real name
        # shellcheck disable=SC2154
        # echo __def_G_funcname="\$(head -n \"$__def_G_lineno\" \"$__def_G_filepath\" | tail -n 1 | awk '{ print $2 }' | tr -d '()')"
        # shellcheck disable=SC2154
        __def_G_funcname="$(head -n "$__def_G_lineno" "$__def_G_filepath" | tail -n 1 | awk '{ print $2 }' | tr -d '()')"

        # unrolled dict_set_key & dict_export begin (optimized)
        # nullcall dict_set_key SHELL_DEF_SOURCE_PUUID "$__def_G_funcname" "$__def_G_puuid"
        # nullcall dict_export SHELL_DEF_SOURCE_PUUID
        # nullcall dict_set_key SHELL_DEF_LINENO "$__def_G_funcname" "$__def_G_lineno"
        # nullcall dict_export SHELL_DEF_LINENO
        __def_G_funcname__key_hash="$( (printf "%s" "${__def_G_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__def_G_funcname}" | shasum -a 1) | cut -d' ' -f1)"

        eval "__array____dict__SHELL_DEF_SOURCE_PUUID__keys__index__${__array____dict__SHELL_DEF_SOURCE_PUUID__keys__length}=\"${__def_G_funcname}\""
        eval "export __array____dict__SHELL_DEF_SOURCE_PUUID__keys__index__${__array____dict__SHELL_DEF_SOURCE_PUUID__keys__length}"
        __array____dict__SHELL_DEF_SOURCE_PUUID__keys__length=$(( __array____dict__SHELL_DEF_SOURCE_PUUID__keys__length + 1 ))
        export __array____dict__SHELL_DEF_SOURCE_PUUID__keys__length
        eval "__dict__SHELL_DEF_SOURCE_PUUID__key__${__def_G_funcname__key_hash}=\"${__def_G_puuid}\""
        eval "export __dict__SHELL_DEF_SOURCE_PUUID__key__${__def_G_funcname__key_hash}"
        __dict__SHELL_DEF_SOURCE_PUUID__length=$(( __dict__SHELL_DEF_SOURCE_PUUID__length + 1 ))
        export __dict__SHELL_DEF_SOURCE_PUUID__length

        eval "__array____dict__SHELL_DEF_LINENO__keys__index__${__array____dict__SHELL_DEF_LINENO__keys__length}=\"${__def_G_funcname}\""
        eval "export __array____dict__SHELL_DEF_LINENO__keys__index__${__array____dict__SHELL_DEF_LINENO__keys__length}"
        __array____dict__SHELL_DEF_LINENO__keys__length=$(( __array____dict__SHELL_DEF_LINENO__keys__length + 1 ))
        export __array____dict__SHELL_DEF_LINENO__keys__length
        eval "__dict__SHELL_DEF_LINENO__key__${__def_G_funcname__key_hash}=\"${__def_G_lineno}\""
        eval "export __dict__SHELL_DEF_LINENO__key__${__def_G_funcname__key_hash}"
        __dict__SHELL_DEF_LINENO__length=$(( __dict__SHELL_DEF_LINENO__length + 1 ))
        export __dict__SHELL_DEF_LINENO__length
        # unrolled dict_set_key & dict_export end

        if [ "${OPTION_SETTRACE}" = true ]; then
            echo "= ${__def_G_puuid}:${__def_G_lineno}:${__def_G_funcname}"
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS__def_G__OPTIONS_OLD}
    }
    # shellcheck disable=SC2142
    if [ "${OPTION_SETTRACE}" = true ]; then
        alias def="def_G \"\$LINENO\""
    else
        alias def="true"
    fi

    #endregion Call Stack Tracking Part 2
    #===============================================================================
fi

# NOTE: Separation b/c cannot define and then use aliases in same block

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then
    # NOTE: fence is created later

    #===============================================================================
    #region Call Stack Tracking Part 3

    #-------------------------------------------------------------------------------
    # nullcall keyword
    # emulates how 'call' works, but does not modify shell options nor track
    # the call stack
    nulldef; nullcall() {
        "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    # pushes function call context onto call stack
    nulldef; _call_stack_push_G() {
        # __call_G_source_puuid="$1"
        # __call_G_lineno="$2"
        # __call_G_dest_puuid="$3"
        # __call_G_dest_lineno="$4"
        # __call_G_funcname="$5"

        # unrolled array_push & array_export begin (optimized)
        # nullcall array_push SHELL_CALL_STACK "$1:$2:$3:$4:$5"
        # nullcall array_export SHELL_CALL_STACK
        eval "__array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}=\"$1:$2:$3:$4:$5\""
        eval "export __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
        __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length + 1 ))
        export __array__SHELL_CALL_STACK__length
        # unrolled array_push & array_export end

        # unrolled array_push & array_export begin (optimized)
        # nullcall array_push SHELL_CALL_STACK_SOURCE_PUUID "$1"
        # nullcall array_export SHELL_CALL_STACK_SOURCE_PUUID
        eval "__array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}=\"$1\""
        eval "export __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
        __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length + 1 ))
        export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
        # unrolled array_push & array_export end

        # nullcall array_push SHELL_CALL_STACK_SOURCE_LINENO "$2"
        # nullcall array_export SHELL_CALL_STACK_SOURCE_LINENO

        # unrolled array_push & array_export begin (optimized)
        # nullcall array_push SHELL_CALL_STACK_DEST_PUUID "$3"
        # nullcall array_export SHELL_CALL_STACK_DEST_PUUID
        eval "__array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}=\"$3\""
        eval "export __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
        __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length + 1 ))
        export __array__SHELL_CALL_STACK_DEST_PUUID__length
        # unrolled array_push & array_export end

        # nullcall array_push SHELL_CALL_STACK_DEST_LINENO "$4"
        # nullcall array_export SHELL_CALL_STACK_DEST_LINENO

        # unrolled array_push & array_export begin (optimized)
        # nullcall array_push SHELL_CALL_STACK_FUNCNAME "$5"
        # nullcall array_export SHELL_CALL_STACK_FUNCNAME
        eval "__array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}=\"$5\""
        eval "export __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
        __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length + 1 ))
        export __array__SHELL_CALL_STACK_FUNCNAME__length
        # unrolled array_push & array_export end
    }

    #-------------------------------------------------------------------------------
    # pops function call context off of call stack
    nulldef; _call_stack_pop_G() {
        # unrolled array_pop & array_export begin (optimized)
        # nullcall array_pop SHELL_CALL_STACK
        # nullcall array_export SHELL_CALL_STACK
        __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length - 1 ))
        export __array__SHELL_CALL_STACK__length
        eval "unset __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
        # unrolled array_pop & array_export end

        # unrolled array_pop & array_export begin (optimized)
        # nullcall array_pop SHELL_CALL_STACK_SOURCE_PUUID
        # nullcall array_export SHELL_CALL_STACK_SOURCE_PUUID
        __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length - 1 ))
        export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
        eval "unset __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
        # unrolled array_pop & array_export end

        # nullcall array_pop SHELL_CALL_STACK_SOURCE_LINENO
        # nullcall array_export SHELL_CALL_STACK_SOURCE_LINENO

        # unrolled array_pop & array_export begin (optimized)
        # nullcall array_pop SHELL_CALL_STACK_DEST_PUUID
        # nullcall array_export SHELL_CALL_STACK_DEST_PUUID
        __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length - 1 ))
        export __array__SHELL_CALL_STACK_DEST_PUUID__length
        eval "unset __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
        # unrolled array_pop & array_export end

        # nullcall array_pop SHELL_CALL_STACK_DEST_LINENO
        # nullcall array_export SHELL_CALL_STACK_DEST_LINENO

        # unrolled array_pop & array_export begin (optimized)
        # nullcall array_pop SHELL_CALL_STACK_FUNCNAME
        # nullcall array_export SHELL_CALL_STACK_FUNCNAME
        __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
        export __array__SHELL_CALL_STACK_FUNCNAME__length
        eval "unset __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
        # unrolled array_pop & array_export end
    }

    #-------------------------------------------------------------------------------
    # "call" keyword
    # calls specified function with args, tracking it via call stack
    # # non-minified:
    # nulldef; call_G() {
    #     # the lines "true lies" evaluates to a no-op, but lets us know to always ignore that line when traced because
    #     # it's puuid is always wrong, because we just popped SHELL_CALL_STACK_DEST_PUUID array and the PS4 prompt is
    #     # the new value, not the old value for where this line actually exists
    #     true lies && __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
    #     true lies && set +x
    #
    #     __call_G_lineno="$1"
    #     __call_G_funcname="$2"
    #     shift 1
    #
    #     # unrolled array_peek begin (optimized)
    #     # __call_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"
    #     # __call_G_parent_funcname__index=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
    #     # eval "__call_G_parent_funcname=\${__array__SHELL_CALL_STACK_FUNCNAME__index__${__call_G_parent_funcname__index}}"
    #     # unrolled array_peek end
    #
    #     # unrolled array_peek begin (optimized)
    #     # __call_G_source_puuid="$(nullcall array_peek SHELL_CALL_STACK_DEST_PUUID)"
    #     # __call_G_source_puuid__index=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length - 1 ))
    #     # eval "__call_G_source_puuid=\${__array__SHELL_CALL_STACK_DEST_PUUID__index__${__call_G_source_puuid__index}}"
    #     # unrolled array_peek end
    #
    #     # unrolled dict_get_key begin (optimized)
    #     # __call_G_dest_puuid="$(nullcall dict_get_key SHELL_DEF_SOURCE_PUUID "${__call_G_funcname}")"
    #     # __call_G_dest_lineno="$(nullcall dict_get_key SHELL_DEF_LINENO "${__call_G_funcname}")"
    #     __call_G_dest__key_hash="$( (printf "%s" "${__call_G_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__call_G_funcname}" | shasum -a 1) | cut -d' ' -f1)"
    #     eval "__call_G_dest_puuid=\"\${__dict__SHELL_DEF_SOURCE_PUUID__key__${__call_G_dest__key_hash}}\""
    #     eval "__call_G_dest_lineno=\"\${__dict__SHELL_DEF_LINENO__key__${__call_G_dest__key_hash}}\""
    #     # unrolled dict_get_key end
    #
    #     # # if __call_G_dest_puuid is invalid, assume our initial script
    #     # if [ "${__call_G_dest_puuid}" = "" ]; then
    #     #     __call_G_dest_puuid="${__array__SHELL_CALL_STACK_DEST_PUUID__index__0}"
    #     # fi
    #     # # if we don't know where something was declared, just use 0 (we don't want negative number or blank)
    #     # if [ "${__call_G_dest_lineno}" = "" ]; then
    #     #     __call_G_dest_lineno=0
    #     # fi
    #
    #     if [ "${LINENO_IS_RELATIVE}" = true ]; then
    #         # get the current parent's lineno
    #         # unrolled dict_get_key begin (optimized)
    #         # __call_G_parent_lineno_offset=$(nullcall dict_get_key SHELL_DEF_LINENO "${__call_G_parent_funcname}")
    #         # shellcheck disable=SC2154
    #         __call_G_parent_lineno_offset_key_hash="$( (printf "%s" "${__call_G_parent_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__call_G_parent_funcname}" | shasum -a 1) | cut -d' ' -f1)"
    #         eval "__call_G_parent_lineno_offset=\"\${__dict__SHELL_DEF_LINENO__key__${__call_G_parent_lineno_offset_key_hash}}\""
    #         # unrolled dict_get_key end
    #
    #         # recalculate lineno to account for parent's lineno and the global offset
    #         # shellcheck disable=SC2154
    #         __call_G_lineno=$(( __call_G_lineno + __call_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
    #     fi
    #
    #     if [ "${OPTION_SETTRACE}" = true ]; then
    #         # print number of dashes equal to call stack depth
    #         # unrolled array_get_length in next line
    #         for _i in $(seq 1 $__array__SHELL_CALL_STACK__length); do
    #             >&2 command printf -- "-"
    #         done
    #
    #         # shellcheck disable=SC2154
    #         >&2 printf -- " %s:%s:%s:%s %s\n" \
    #             "${__call_G_source_puuid}" \
    #             "${__call_G_lineno}" \
    #             "${__call_G_dest_puuid}" \
    #             "${__call_G_dest_lineno}" \
    #             "$*"
    #     fi
    #
    #     # unrolled _call_stack_push_G (shortened)
    #     # _call_stack_push_G \
    #     #     "${__call_G_source_puuid}" \
    #     #     "${__call_G_lineno}" \
    #     #     "${__call_G_dest_puuid}" \
    #     #     "${__call_G_dest_lineno}" \
    #     #     "${__call_G_funcname}"
    #     eval "__array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}=\"${__call_G_source_puuid}:${__call_G_lineno}:${__call_G_dest_puuid}:${__call_G_dest_lineno}:${__call_G_funcname}\""
    #     eval "export __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
    #     __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length + 1 ))
    #     export __array__SHELL_CALL_STACK__length
    #     eval "__array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}=\"${__call_G_source_puuid}\""
    #     eval "export __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
    #     __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length + 1 ))
    #     export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
    #     eval "__array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}=\"${__call_G_dest_puuid}\""
    #     eval "export __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
    #     __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length + 1 ))
    #     export __array__SHELL_CALL_STACK_DEST_PUUID__length
    #     eval "__array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}=\"${__call_G_funcname}\""
    #     eval "export __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
    #     __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length + 1 ))
    #     export __array__SHELL_CALL_STACK_FUNCNAME__length
    #     # unrolled _call_stack_push_G
    #
    #     set +x ${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}
    #
    #     true lies && "$@"
    #     __call_ret=$? && true lies
    #
    #     true lies && __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
    #     true lies && set +x
    #
    #     # unrolled _call_stack_pop_G (shortened)
    #     # _call_stack_pop_G
    #     __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length - 1 ))
    #     export __array__SHELL_CALL_STACK__length
    #     eval "unset __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
    #     __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length - 1 ))
    #     export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
    #     eval "unset __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
    #     __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length - 1 ))
    #     export __array__SHELL_CALL_STACK_DEST_PUUID__length
    #     eval "unset __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
    #     __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
    #     export __array__SHELL_CALL_STACK_FUNCNAME__length
    #     eval "unset __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
    #     # unrolled _call_stack_pop_G
    #
    #     set +x ${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}
    #
    #     true lies && return $__call_ret
    # }
    #
    # # minified:

    #-------------------------------------------------------------------------------
    # "call" keyword
    # calls specified function with args, tracking it via call stack
    nulldef; call_G() {
        true lies && __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
        true lies && set +x
        __call_G_lineno="$1"
        __call_G_funcname="$2"
        shift 1
        __call_G_parent_funcname__index=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
        eval "__call_G_parent_funcname=\${__array__SHELL_CALL_STACK_FUNCNAME__index__${__call_G_parent_funcname__index}}"
        __call_G_source_puuid__index=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length - 1 ))
        eval "__call_G_source_puuid=\${__array__SHELL_CALL_STACK_DEST_PUUID__index__${__call_G_source_puuid__index}}"
        __call_G_dest__key_hash="$( (printf "%s" "${__call_G_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__call_G_funcname}" | shasum -a 1) | cut -d' ' -f1)"
        eval "__call_G_dest_puuid=\"\${__dict__SHELL_DEF_SOURCE_PUUID__key__${__call_G_dest__key_hash}}\""
        eval "__call_G_dest_lineno=\"\${__dict__SHELL_DEF_LINENO__key__${__call_G_dest__key_hash}}\""
        # shellcheck disable=SC2154
        if [ "${__call_G_dest_puuid}" = "" ]; then
            __call_G_dest_puuid="${__array__SHELL_CALL_STACK_DEST_PUUID__index__0}"
        fi
        if [ "${__call_G_dest_lineno}" = "" ]; then
            __call_G_dest_lineno=0
        fi
        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            # shellcheck disable=SC2154
            __call_G_parent_lineno_offset_key_hash="$( (printf "%s" "${__call_G_parent_funcname}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__call_G_parent_funcname}" | shasum -a 1) | cut -d' ' -f1)"
            eval "__call_G_parent_lineno_offset=\"\${__dict__SHELL_DEF_LINENO__key__${__call_G_parent_lineno_offset_key_hash}}\""
            # shellcheck disable=SC2154
            __call_G_lineno=$(( __call_G_lineno + __call_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
        fi
        if [ "${OPTION_SETTRACE}" = true ]; then
            for _i in $(seq 1 $__array__SHELL_CALL_STACK__length); do
                >&2 command printf -- "-"
            done
            # shellcheck disable=SC2154
            >&2 printf -- " %s:%s:%s:%s %s\n" \
                "${__call_G_source_puuid}" \
                "${__call_G_lineno}" \
                "${__call_G_dest_puuid}" \
                "${__call_G_dest_lineno}" \
                "$*"
        fi
        eval "__array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}=\"${__call_G_source_puuid}:${__call_G_lineno}:${__call_G_dest_puuid}:${__call_G_dest_lineno}:${__call_G_funcname}\""
        eval "export __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
        __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length + 1 ))
        export __array__SHELL_CALL_STACK__length
        eval "__array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}=\"${__call_G_source_puuid}\""
        eval "export __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
        __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length + 1 ))
        export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
        eval "__array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}=\"${__call_G_dest_puuid}\""
        eval "export __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
        __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length + 1 ))
        export __array__SHELL_CALL_STACK_DEST_PUUID__length
        eval "__array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}=\"${__call_G_funcname}\""
        eval "export __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
        __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length + 1 ))
        export __array__SHELL_CALL_STACK_FUNCNAME__length
        set +x ${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}
        true lies && "$@"
        __call_ret=$? && true lies
        true lies && __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
        true lies && set +x
        __array__SHELL_CALL_STACK__length=$(( __array__SHELL_CALL_STACK__length - 1 ))
        export __array__SHELL_CALL_STACK__length
        eval "unset __array__SHELL_CALL_STACK__index__${__array__SHELL_CALL_STACK__length}"
        __array__SHELL_CALL_STACK_SOURCE_PUUID__length=$(( __array__SHELL_CALL_STACK_SOURCE_PUUID__length - 1 ))
        export __array__SHELL_CALL_STACK_SOURCE_PUUID__length
        eval "unset __array__SHELL_CALL_STACK_SOURCE_PUUID__index__${__array__SHELL_CALL_STACK_SOURCE_PUUID__length}"
        __array__SHELL_CALL_STACK_DEST_PUUID__length=$(( __array__SHELL_CALL_STACK_DEST_PUUID__length - 1 ))
        export __array__SHELL_CALL_STACK_DEST_PUUID__length
        eval "unset __array__SHELL_CALL_STACK_DEST_PUUID__index__${__array__SHELL_CALL_STACK_DEST_PUUID__length}"
        __array__SHELL_CALL_STACK_FUNCNAME__length=$(( __array__SHELL_CALL_STACK_FUNCNAME__length - 1 ))
        export __array__SHELL_CALL_STACK_FUNCNAME__length
        eval "unset __array__SHELL_CALL_STACK_FUNCNAME__index__${__array__SHELL_CALL_STACK_FUNCNAME__length}"
        set +x ${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}
        true lies && return $__call_ret
    }
    if [ "${OPTION_SETTRACE}" = true ]; then
        alias call="call_G \"\$LINENO\""
    else
        alias call="true;"
    fi

    #endregion Call Stack Tracking Part 3
    #===============================================================================
fi

# NOTE: Separation b/c cannot define and then use aliases in same block

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then
    #===============================================================================
    #region Fallbacks

    type BATTERIES_FORKING_INCLUDED_BASE_FENCE >/dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then

        # NOTE: some basic definitions to fallback to if bfi-base.sh failed to load
        #   if bfi-base.sh loads later, it will override these

        RET_SUCCESS=0; export RET_SUCCESS
        RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN
        RET_ERROR_SCRIPT_WAS_SOURCED=149; export RET_ERROR_SCRIPT_WAS_SOURCED
        RET_ERROR_USER_IS_ROOT=150; export RET_ERROR_USER_IS_ROOT
        RET_ERROR_SCRIPT_WAS_NOT_SOURCED=151; export RET_ERROR_SCRIPT_WAS_NOT_SOURCED
        RET_ERROR_USER_IS_NOT_ROOT=152; export RET_ERROR_USER_IS_NOT_ROOT
        RET_ERROR_DIRECTORY_NOT_FOUND=153; export RET_ERROR_DIRECTORY_NOT_FOUND
        RET_ERROR_COULD_NOT_SOURCE_FILE=161; export RET_ERROR_COULD_NOT_SOURCE_FILE

        if [ "${verbosity}" = "" ]; then
            verbosity=1; export verbosity
        fi

        #-------------------------------------------------------------------------------
        nulldef; date() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__date__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if [ "$(uname)" = "Darwin" ]; then
                command date -j "$@"
            else
                command date "$@"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__date__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__date__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_console() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "$@"
            command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success_final() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "SUCCESS: "
            command printf -- "$@"
            command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "SUCCESS: "
            command printf -- "$@"
            command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_fatal() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "FATAL: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_error() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "ERROR: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_warning() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "WARNING: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_header() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_header__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge -1 ]  ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "\n"
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_header__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_header__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_footer() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_footer__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 0 ]  ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_footer__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_footer__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_info_important() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "INFO: "
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_info() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "INFO: "
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_info_no_prefix() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_no_prefix__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_no_prefix__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_no_prefix__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_debug() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_debug__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 2 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "DEBUG: "
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_debug__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_debug__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_superdebug() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_superdebug__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 3 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "SUPERDEBUG: "
                command printf -- "$@"
                command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_superdebug__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_superdebug__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_ultradebug() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_ultradebug__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                command printf -- "ULTRADEBUG: " &&
                    command printf -- "$@" &&
                    command printf -- "\n"
            fi

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_ultradebug__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_ultradebug__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_file() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_file__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            true

            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_file__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_file__OPTIONS_OLD
        }
    fi

    #endregion Fallbacks
    #===============================================================================

    #===============================================================================
    #region RReadLink

    #-------------------------------------------------------------------------------
    nulldef; rreadlink() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__rreadlink__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        # Hide zsh subshell session closure spam (macOS only?)
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        # Execute the function in a *subshell* to localize variables and the
        #   effect of 'cd'.
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            target=$1
            fname=
            targetDir=
            CDPATH=

            # Try to make the execution environment as predictable as possible:
            # All commands below are invoked via 'command', so we must make sure
            # that 'command' itself is not redefined as an alias or shell function.
            # (NOTE: that command is too inconsistent across shells, so we don't
            # use it.)
            # 'command' is a *builtin* in bash, dash, ksh, zsh, and some platforms
            # do not even have an external utility version of it (e.g, Ubuntu).
            # 'command' bypasses aliases and shell functions and also finds builtins
            # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned
            # on for that #to happen.
            { \unalias command; \unset -f command; } >/dev/null 2>&1
            # shellcheck disable=SC2034
            # make zsh find *builtins* with 'command' too.
            [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on

            # Resolve potential symlinks until the ultimate target is found.
            while :; do
                    [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
                    # Change to target dir; necessary for correct resolution of
                    #   target path.
                    # shellcheck disable=SC2164
                    command cd "$(command dirname -- "$target")"
                    # Extract filename.
                    fname=$(command basename -- "$target")
                    [ "$fname" = '/' ] && fname='' # WARNING: curiously, 'basename /' returns '/'
                    if [ -L "$fname" ]; then
                        # Extract [next] target path, which may be defined
                        # relative to the symlink's own directory.
                        # NOTE: We parse 'ls -l' output to find the symlink target
                        #   which is the only POSIX-compliant, albeit
                        #   somewhat fragile, way.
                        target=$(command ls -l "$fname")
                        target=${target#* -> }
                        continue # Resolve [next] symlink target.
                    fi
                    break # Ultimate target reached.
            done
            targetDir=$(command pwd -P) # Get canonical dir. path
            # Output the ultimate target's canonical path.
            # NOTE: that we manually resolve paths ending in /. and /.. to make
            #   sure we have a normalized path.
            if [ "$fname" = '.' ]; then
                command printf '%s\n' "${targetDir%/}"
            elif [ "$fname" = '..' ]; then
                # NOTE: something like /var/.. will resolve to /private (assuming
                #   /var@ -> /private/var), i.e. the '..' is applied AFTER
                #   canonicalization.
                command printf '%s\n' "$(command dirname -- "${targetDir}")"
            else
                command printf '%s\n' "${targetDir%/}/$fname"
            fi

            return 0
        )
        # Store exit code to use later
        rreadlink_ret=$?
        # Undo hiding zsh subshell session closure spam (macOS only?)
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__rreadlink__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__rreadlink__OPTIONS_OLD

        # use exit code
        return $rreadlink_ret
    }

    #endregion RReadLink
    #===============================================================================
fi

#===============================================================================
#region Source/Invoke Check For Top Level File

#-------------------------------------------------------------------------------
nulldef; _shell_source_push_G() {
    # $1 == TEMP_WAS_SOURCED
    # $2 == TEMP_FILE_NAME

    # unrolled array_push & array_export begin (optimized)
    # nullcall array_push WAS_SOURCED "$1"
    # nullcall array_export WAS_SOURCED
    eval "__array__WAS_SOURCED__index__${__array__WAS_SOURCED__length}=\"$1\""
    eval "export __array__WAS_SOURCED__index__${__array__WAS_SOURCED__length}"
    __array__WAS_SOURCED__length=$(( __array__WAS_SOURCED__length + 1 ))
    export __array__WAS_SOURCED__length
    # unrolled array_push & array_export end

    # unrolled array_push & array_export begin (optimized)
    # nullcall array_push SHELL_SOURCE "$2"
    # nullcall array_export SHELL_SOURCE
    eval "__array__SHELL_SOURCE__index__${__array__SHELL_SOURCE__length}=\"$2\""
    eval "export __array__SHELL_SOURCE__index__${__array__SHELL_SOURCE__length}"
    __array__SHELL_SOURCE__length=$(( __array__SHELL_SOURCE__length + 1 ))
    export __array__SHELL_SOURCE__length
    # unrolled array_push & array_export end

    # unrolled push_puuid_for_abspath begin
    # nullcall push_puuid_for_abspath "$2"
    __puuid="$(od -x -N 16 /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')"
    __puuid__basename="${__puuid}_$(basename "$2")"
    if [ "${OPTION_SETTRACE}" = true ]; then
        command printf "# %s:'%s'\n" "${__puuid__basename}" "$2"
    fi
    eval "__array__SHELL_SOURCE_PUUID__index__${__array__SHELL_SOURCE_PUUID__length}=\"${__puuid__basename}\""
    eval "export __array__SHELL_SOURCE_PUUID__index__${__array__SHELL_SOURCE_PUUID__length}"
    __array__SHELL_SOURCE_PUUID__length=$(( __array__SHELL_SOURCE_PUUID__length + 1 ))
    export __array__SHELL_SOURCE_PUUID__length
    __puuid__basename__key_hash="$( (printf "%s" "${__puuid__basename}" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "${__puuid__basename}" | shasum -a 1) | cut -d' ' -f1)"
    eval "__array____dict__SHELL_SOURCE_PUUID_DICT__keys__index__${__array____dict__SHELL_SOURCE_PUUID_DICT__keys__length}=\"${__puuid__basename}\""
    eval "export __array____dict__SHELL_SOURCE_PUUID_DICT__keys__index__${__array____dict__SHELL_SOURCE_PUUID_DICT__keys__length}"
    __array____dict__SHELL_SOURCE_PUUID_DICT__keys__length=$(( __array____dict__SHELL_SOURCE_PUUID_DICT__keys__length + 1 ))
    export __array____dict__SHELL_SOURCE_PUUID_DICT__keys__length
    eval "__dict__SHELL_SOURCE_PUUID_DICT__key__${__puuid__basename__key_hash}=\"$2\""
    eval "export __dict__SHELL_SOURCE_PUUID_DICT__key__${__puuid__basename__key_hash}"
    __dict__SHELL_SOURCE_PUUID_DICT__length=$(( __dict__SHELL_SOURCE_PUUID_DICT__length + 1 ))
    export __dict__SHELL_SOURCE_PUUID_DICT__length
    # unrolled push_puuid_for_abspath end

    _call_stack_push_G "${__puuid__basename}" "0" "${__puuid__basename}" "1" "_"
}

#-------------------------------------------------------------------------------
nulldef; _shell_source_pop_G() {
    _call_stack_pop_G

    # unrolled array_pop & array_export begin (optimized)
    # nullcall array_pop SHELL_SOURCE_PUUID
    # nullcall array_export SHELL_SOURCE_PUUID
    __array__SHELL_SOURCE_PUUID__length=$(( __array__SHELL_SOURCE_PUUID__length - 1 ))
    export __array__SHELL_SOURCE_PUUID__length
    eval "unset __array__SHELL_SOURCE_PUUID__index__${__array__SHELL_SOURCE_PUUID__length}"
    # unrolled array_pop & array_export end

    # unrolled array_pop & array_export begin (optimized)
    # nullcall array_pop SHELL_SOURCE
    # nullcall array_export SHELL_SOURCE
    __array__SHELL_SOURCE__length=$(( __array__SHELL_SOURCE__length - 1 ))
    export __array__SHELL_SOURCE__length
    eval "unset __array__SHELL_SOURCE__index__${__array__SHELL_SOURCE__length}"
    # unrolled array_pop & array_export end

    # unrolled array_pop & array_export begin (optimized)
    # nullcall array_pop WAS_SOURCED
    # nullcall array_export WAS_SOURCED
    __array__WAS_SOURCED__length=$(( __array__WAS_SOURCED__length - 1 ))
    export __array__WAS_SOURCED__length
    eval "unset __array__WAS_SOURCED__index__${__array__WAS_SOURCED__length}"
    # unrolled array_pop & array_export end
}

# shellcheck disable=SC2218
nullcall log_ultradebug "env vars:\n%s" -- "$(env -0 | sort -z | tr '\0' '\n' | sed -e 's/%/%%/g')"

# NOTE: that all these detection methods only work for the FIRST file
#   that is invoked or sourced, all others must be handled by the
#   include_G, ensure_include_GXY, and invoke functions.
# unrolled array_get_length in next line:
if [ "${__array__SHELL_SOURCE__length}" -eq 0 ]; then
    TEMP_FILE_NAME=""
    TEMP_WAS_SOURCED="unknown"
    nullcall log_ultradebug "\$0=$0"
    nullcall log_ultradebug "\$*=$*"
    TEMP_ARG_ZERO="$0"
    nullcall log_ultradebug "\${TEMP_ARG_ZERO}=${TEMP_ARG_ZERO}"
    TEMP_ARG_ZERO="${TEMP_ARG_ZERO##*[/\\]}"
    nullcall log_ultradebug "\${TEMP_ARG_ZERO}=${TEMP_ARG_ZERO}"
    case "${TEMP_ARG_ZERO}" in
        bash|dash|sh|wsl-bash|wsl-dash|wsl-sh)  # zsh sourced handled later
            nullcall log_ultradebug "\$0 was a known shell (not zsh)."
            # bash sourced, dash sourced, sh(bash) sourced, sh(dash) sourced,
            # sh(zsh) sourced
            # shellcheck disable=SC2128
            if [ -n "${BASH_SOURCE}" ]; then
                # bash sourced, sh(bash) sourced
                nullcall log_ultradebug "\$BASH_SOURCE exists."
                # shellcheck disable=SC3054
                nullcall log_ultradebug "\${BASH_SOURCE[0]}=${BASH_SOURCE[0]}"
                # shellcheck disable=SC3054
                TEMP_FILE_NAME="${BASH_SOURCE[0]}"
            else
                # dash sourced, sh(dash) sourced, sh(zsh) sourced
                nullcall log_ultradebug "\$BASH_SOURCE does NOT exist."
                nullcall log_ultradebug "\(which lsof)=$(which lsof)"
                nullcall log_ultradebug "\$?=$?"
                x="$(lsof -p $$ -Fn0 | tail -1)"
                TEMP_FILE_NAME="${x#n}"
                if [ "$(command echo "${TEMP_FILE_NAME}" | grep -e "^->0x")" != "" ]; then
                    # sh(zsh) sourced
                    nullcall log_ultradebug "TEMP_FILE_NAME starts with '->0x', this is zsh sourced."
                    TEMP_FILE_NAME="${DOLLAR_UNDER}"
                # else
                #     # dash sourced, sh(dash) sourced
                #     true
                fi
            fi
            TEMP_WAS_SOURCED=true
            ;;
        ????????-????-????-????-????????????.sh|????????-????-????-????-????????????)
            nullcall log_ultradebug "\$0 resembles a uuid, probably is github sourced."
            # github sourced, multi-command
            TEMP_WAS_SOURCED=true
            nullcall log_ultradebug "$0"
            nullcall log_ultradebug "$*"
            nullcall log_ultradebug "env | sort:\n%s" "$(env | sort)"
            if [ "${TEMP_SHELL_SOURCE}" != "" ]; then
                TEMP_FILE_NAME="${TEMP_SHELL_SOURCE}"
            fi
            nullcall log_ultradebug "printenv | sort:\n%s" "$(printenv | sort)"
            ;;
        *)
            # bash invoked, dash invoked, sh(bash) invoked, zsh invoked
            # zsh sourced
            nullcall log_ultradebug "Some other shell?"
            nullcall log_ultradebug "\(which lsof)=$(which lsof)"
            nullcall log_ultradebug "\$?=$?"
            if [ "$(which lsof)" != "" ]; then
                x="$(lsof -p $$ -Fn0 | tail -1)"
                nullcall log_ultradebug "\$x=$x"
                x="${x#*n}"
                nullcall log_ultradebug "\$x=$x"
            else
                x="NONE"
                nullcall log_ultradebug "\$x=$x"
            fi
            if [ -f "$x" ]; then
                x="$(nullcall rreadlink "$x")"
                nullcall log_ultradebug "\$x=$x"
            fi
            TEMP_FILE_NAME="$(nullcall rreadlink "$0")"
            nullcall log_ultradebug "TEMP_FILE_NAME: ${TEMP_FILE_NAME}"
            nullcall log_ultradebug "x:              ${x}"
            if [ "${TEMP_FILE_NAME}" != "${x}" ]; then
                nullcall log_ultradebug "TEMP_FILE_NAME and x are different."
                if [ "$(echo "${x}" | grep -e 'pipe')" != "" ]; then
                    nullcall log_ultradebug "x is 'pipe', probably github invoked."
                    # github invoked
                    TEMP_WAS_SOURCED=false
                elif [ "${x}" = "NONE" ]; then
                    nullcall log_ultradebug "lsof not available, probably wsl invoked."
                    # wsl doesn't always have lsof, so invoked
                    TEMP_WAS_SOURCED=false
                else
                    # zsh sourced
                    nullcall log_ultradebug "x is NOT 'pipe', probably zsh sourced."
                    TEMP_WAS_SOURCED=true
                fi
            else
                nullcall log_ultradebug "TEMP_FILE_NAME and x are the SAME, likely invoked."
                # bash invoked, dash invoked, sh(bash) invoked, zsh invoked
                TEMP_WAS_SOURCED=false
                nullcall log_ultradebug "printenv | sort:\n%s" "$(printenv | sort)"
            fi
            ;;
    esac
    nullcall log_ultradebug "TEMP_FILE_NAME=${TEMP_FILE_NAME}"
    TEMP_FILE_NAME="$(nullcall rreadlink "${TEMP_FILE_NAME}")"
    nullcall log_ultradebug "TEMP_FILE_NAME=${TEMP_FILE_NAME}"

    nullcall _shell_source_push_G "${TEMP_WAS_SOURCED}" "${TEMP_FILE_NAME}"
fi

unset x
unset TEMP_ARG_ZERO
unset TEMP_FILE_NAME
unset TEMP_SHELL_SOURCE
unset TEMP_WAS_SOURCED
unset DOLLAR_UNDER

# TODO: create and use array_join to print these
# sometimes shellcheck thinks log_ultradebug is only defined later, not before
# shellcheck disable=SC2218
nullcall log_ultradebug "WAS_SOURCED: $WAS_SOURCED"
# shellcheck disable=SC2218
nullcall log_ultradebug "SHELL_SOURCE: $SHELL_SOURCE"
# shellcheck disable=SC2218
nullcall log_ultradebug "SHELL_SOURCE_PUUID: $SHELL_SOURCE_PUUID"

#endregion Source/Invoke Check For Top Level File
#===============================================================================

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then


    #===============================================================================
    #region Call Stack Tracking Part 4

    #-------------------------------------------------------------------------------
    def; print_call_stack() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__print_call_stack__OPTIONS_OLD="${-:+"-$-"}"
        set +x

        def; _print_call_stack() {
            >&2 command printf -- "%d: %s\n" "${index}" "${item}"
        }
        nullcall array_for_each SHELL_CALL_STACK _print_call_stack

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__print_call_stack__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__print_call_stack__OPTIONS_OLD
    }

    #endregion Call Stack Tracking Part 4
    #===============================================================================

    #===============================================================================
    #region puuid - Pseudo UUID

    #-------------------------------------------------------------------------------
    def; puuid() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        od -x -N 16 /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}'

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; push_puuid_for_abspath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__push_puuid_for_abspath__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __puuid="$(puuid)"
        __puuid__basename="${__puuid}_$(basename "$1")"
        if [ "${OPTION_SETTRACE}" = true ]; then
            command printf "# %s:'%s'\n" "${__puuid__basename}" "$1"
        fi
        nullcall array_push SHELL_SOURCE_PUUID "${__puuid__basename}"
        nullcall array_export SHELL_SOURCE_PUUID
        nullcall dict_set_key SHELL_SOURCE_PUUID_DICT "${__puuid__basename}" "$1"
        nullcall dict_export SHELL_SOURCE_PUUID_DICT
        unset __puuid__basename
        unset __puuid

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__push_puuid_for_abspath__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__push_puuid_for_abspath__OPTIONS_OLD
    }

    #endregion puuid - Pseudo UUID
    #===============================================================================

    #===============================================================================
    #region Array Implementation

    # # initialize an array:
    # NOTE: no $ sign on my_array_name below
    # array_init my_array_name

    # # manually iterating an array instead of array_for_each:
    # NOTE: no $ sign on my_array_name below
    # for index in $(seq 0 $(array_get_length my_array_name); do
    #     echo $(array_get_at_index my_array_name $index)
    # done

    # unrolled version of manually iterating an array instead of array_fo_each:
    # NOTE: no $ sign on my_array_name below
    # for index in $seq $__array__my_array_name__length
    #     echo "$(eval "\$__array__my_array_name__$index")"
    # done

    # # append to array:
    # NOTE: no $ sign on my_array_name
    # array_append my_array_name "my value"

    # # get item by __array__array_insert_index__iterator_index:
    # NOTE: no $ sign on my_array_name
    # array_get_at_index my_array_name $__array__array_insert_index__iterator_index

    # # get last item:
    # NOTE: no $ sign on my_array_name
    # array_get_last my_array_name

    # # copy an array:
    # NOTE: no $ sign on my_source_array_name
    # NOTE: no $ sign on my_destination_array_name
    # array_copy my_source_array_name my_destination_array_name

    # # remove last item:
    # NOTE: no $ sign on my_array_name
    # array_remove_last my_array_name

    # # get length:
    # NOTE: no $ sign on my_array_name
    # array_get_length my_array_name

    # # find __array__array_insert_index__iterator_index of item
    # NOTE: no $ sign on my_array_name
    # array_find_index_of my_array_name value_to_find
    # returns -1 if not found

    # # check if array contains item
    # NOTE: no $ sign on my_array_name
    # array_contains my_array_name value_to_find
    # returns 1 if not found
    # returns 0 if found

    # # using array_for_each:
    # def; my_func() {
    #     echo "${item}"
    # }
    # array_for_each the_array_name my_func
    ## NOTE: no $ on 'the_array_name' nor 'my_func'

    #-------------------------------------------------------------------------------
    # forward declarations for using array_for_each
    index=""
    item=""

    #-------------------------------------------------------------------------------
    def; __array_fix_index() {
        __array__array_fix_index__length="$(nullcall array_get_length "$1")"

        __array__array_fix_index__index="$2"

        if [ "${__array__array_fix_index__index}" -lt 0 ]; then
            __array__array_fix_index__index="$(( __array__array_fix_index__length + __array__array_fix_index__index ))"
        fi

        command printf "%d" "${__array__array_fix_index__index}"
    }

    #-------------------------------------------------------------------------------
    def; array_init() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        # TODO: error if new array already exists

        eval "$1=\"__array__\""
        eval "__array__$1=\"__array__\""
        eval "__array__${1}__length=0"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_destroy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        # TODO: error if array already does not exist

        for __array__destroy_var in $(set | sort | grep "__array__${1}__" | awk -F= '{ print $1 }' ); do
            eval "unset $__array__destroy_var"
        done
        unset __array__destroy_var
        eval "unset __array__$1"
        eval "unset $1"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_export() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        for __array__export_var in $(set | sort | grep "__array__${1}__" | awk -F= '{ print $1 }' ); do
            eval "export $__array__export_var"
        done
        unset __array__export_var
        eval "export __array__$1"
        eval "export $1"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_append() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_append__index=$(eval "echo \${__array__${1}__length}")
        eval "__array__${1}__index__${__array__array_append__index}=\"$2\""
        __array__array_append__new_length=$(eval "echo \$(( __array__${1}__length + 1 ))")
        eval "__array__${1}__length=$__array__array_append__new_length"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_copy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        # unrolled array_init begin
        # TODO: error if new array already exists
        eval "$2=\"__array__\""
        eval "__array__$2=\"__array__\""
        # NOTE: optimization, setting length early
        eval "__array__${2}__length=\${__array__${1}__length}"
        # unrolled array_init end

        for __array__array_copy__iterator_index in $(seq 0 "$(eval "echo \$(( __array__${1}__length - 1 ))")"); do
            eval "__array__${2}__index__${__array__array_copy__iterator_index}=\${__array__${1}__index__${__array__array_copy__iterator_index}}"
        done

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_insert_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_insert_index__length=0
        eval "__array__array_insert_index__length=\${__array__${1}__length}"

        __array__array_insert_index__index="$2"
        __array__array_insert_index__index="$(nullcall __array_fix_index "$1" "${__array__array_insert_index__index}")"

        # TODO: error if index is > than length

        if [ "$__array__array_insert_index__index" -lt "$__array__array_insert_index__length" ]; then
            for __array__array_insert_index__iterator_index in $(seq \
                $(( __array__array_insert_index__length - 1 )) \
                "$__array__array_insert_index__index" \
            ); do
                __array__array_insert_index__iterator_index__next=$(( __array__array_insert_index__iterator_index + 1 ))
                eval "__array__${1}__index__${__array__array_insert_index__iterator_index__next}=\${__array__${1}__index__${__array__array_insert_index__iterator_index}}"
            done
        fi

        eval "__array__${1}__index__${__array__array_insert_index__index}=\"$3\""

        __array__array_insert_index__new_length=$(eval "echo \$(( __array__${1}__length + 1 ))")
        eval "__array__${1}__length=$__array__array_insert_index__new_length"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_remove_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_remove_index__length=0
        eval "__array__array_remove_index__length=\${__array__${1}__length}"

        __array__array_remove_index__index="$2"
        __array__array_remove_index__index="$(nullcall __array_fix_index "$1" "${__array__array_remove_index__index}")"

        # TODO: error if index is >= length

        if [ "$__array__array_remove_index__index" -lt "$__array__array_remove_index__length" ]; then
            for __array__array_remove_index__iterator_index in $(seq \
                "$__array__array_remove_index__index" \
                $(( __array__array_remove_index__length - 1 )) \
            ); do
                __array__array_remove_index__iterator_index__next=$(( __array__array_remove_index__iterator_index + 1 ))
                eval "__array__${1}__index__${__array__array_remove_index__iterator_index}=\${__array__${1}__index__${__array__array_remove_index__iterator_index__next}}"
            done
        fi

        __array__array_remove_index__new_length=$(eval "echo \$(( __array__${1}__length - 1 ))")
        eval "__array__${1}__length=${__array__array_remove_index__new_length}"
        eval "unset __array__${1}__index__${__array__array_remove_index__new_length}"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_length() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        eval "command echo \"\${__array__${1}__length}\""

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_at_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_get_index__index="$2"
        __array__array_get_index__index="$(nullcall __array_fix_index "$1" "${__array__array_get_index__index}")"

        eval "command printf \"%s\" \"\${__array__${1}__index__${__array__array_get_index__index}}\""

        __array_get_at_index_ret=1
        if [ "$(eval "[ -n \"\${__array__${1}__index__${__array__array_get_index__index}}\" ] && echo true || echo false")" = true ]; then
            __array_get_at_index_ret=0
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD

        return $__array_get_at_index_ret
    }

    #-------------------------------------------------------------------------------
    def; array_find_index_of() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_find_index_of__length=0
        eval "__array__array_find_index_of__length=\${__array__${1}__length}"

        __array__array_find_index_of__return=1 # false

        if [ $__array__array_find_index_of__length -gt 0 ]; then
            for __array__array_find_index_of__index in $(seq \
                0 \
                $(( __array__array_find_index_of__length - 1 )) \
            ); do
                eval "item=\${__array__${1}__index__${__array__array_find_index_of__index}}"
                if [ "$item" = "$2" ]; then
                    command printf "%d" "$__array__array_find_index_of__index"
                    __array__array_find_index_of__return=0 # true
                fi
            done
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD

        return "$__array__array_find_index_of__return"
    }

    #-------------------------------------------------------------------------------
    def; array_contains() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        # returns 1 if not found, 0 if found
        array_find_index_of "$1" "$2" >/dev/null
        __array__contains__return=$?

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD

        return $__array__contains__return
    }

    # # using array_for_each:
    # def; my_func() {
    #     echo "${index}: ${item}"
    # }
    # array_for_each the_array_name my_func
    ## NOTE: no $ on 'the_array_name' nor 'my_func'

    #-------------------------------------------------------------------------------
    def; array_for_each() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD=e
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __array__array_for_each__array_name="$1"
        __array__array_for_each__func_name="$2"

        __array__array_for_each__length=0
        eval "__array__array_for_each__length=\${__array__${1}__length}"

        if [ $__array__array_for_each__length -gt 0 ]; then
            for index in $(seq \
                0 \
                $(( __array__array_for_each__length - 1 )) \
            ); do
                eval "item=\${__array__${__array__array_for_each__array_name}__index__${index}}"
                set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}
                unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
                eval "${__array__array_for_each__func_name}"
                __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD="${-:+"-$-"}"
                set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
            done
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_push() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_append "$@"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_pop() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_last "$@"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_peek() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_last "$@"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_insert_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_append "$@"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_insert_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_insert_index "$1" 0 "$2"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_at_index "$1" 0

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_at_index "$1" -1

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_remove_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_index "$1" 0

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_remove_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_index "$1" -1

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD
    }

    #endregion Array Implementation
    #===============================================================================

    #===============================================================================
    #region Dict Implementation

    #-------------------------------------------------------------------------------
    def; __dict_hash_key() {
        (printf "%s" "$1" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "$1" | shasum -a 1) | cut -d' ' -f1
    }

    #-------------------------------------------------------------------------------
    def; dict_init() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        eval "$1=\"__dict__\""
        eval "__dict__$1=\"__dict__\""
        eval "__dict__$1__length=0"
        nullcall array_init "__dict__$1__keys"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD

        return 0
    }

    #-------------------------------------------------------------------------------
    def; dict_destroy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_destroy__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        for __dict__destroy_var in $(set | sort | grep "__dict__$1__" | awk -F= '{ print $1 }' ); do
            eval "unset $__dict__destroy_var"
        done
        unset __dict__destroy_var
        eval "unset __dict__$1"
        eval "unset $1"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_destroy__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_destroy__OPTIONS_OLD

        return 0
    }

    #-------------------------------------------------------------------------------
    def; dict_export() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_export__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        for __dict__export_var in $(set | sort | grep "__dict__$1__" | awk -F= '{ print $1 }' ); do
            eval "export $__dict__export_var"
        done
        unset __dict__export_var
        eval "export __dict__$1"
        eval "export $1"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_export__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_export__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; dict_set_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __dict_set_key_ret=0

        if eval "[ ! -n \"\$__dict__$1\" ]"; then
            # dict not initialized
            __dict_set_key_ret=1
        else
            nullcall array_append "__dict__$1__keys" "$2"
            eval "__dict__$1__key__$(nullcall __dict_hash_key "$2")=\"$3\""
            eval "__dict__$1__length=\$(( __dict__$1__length + 1 ))"
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD

        return $__dict_set_key_ret
    }

    #-------------------------------------------------------------------------------
    def; dict_get_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __dict_get_key_ret=0

        if dict_has_key "$1" "$2"; then
            eval "printf \"%s\" \"\$__dict__$1__key__$(__dict_hash_key "$2")\""
        else
            __dict_get_key_ret=1
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD

        return $__dict_get_key_ret
    }

    #-------------------------------------------------------------------------------
    def; dict_unset_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __dict_unset_key_ret=0

        if eval "[ ! -n \"\$__dict__$1\" ]"; then
            # dict not initialized
            __dict_unset_key_ret=1
        fi

        if dict_has_key "$1" "$2"; then
            eval "unset __dict__$1__key__$(__dict_hash_key "$2")"
            eval "__dict__$1__length=\$(( __dict__$1__length - 1 ))"
        else
            __dict_unset_key_ret=1
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD

        return $__dict_unset_key_ret
    }

    #-------------------------------------------------------------------------------
    def; dict_has_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __dict_has_key_ret=0

        if eval "[ -n \"\$__dict__$1__key__$(__dict_hash_key "$2")\" ]"; then
            __dict_has_key_ret=0
        else
            __dict_has_key_ret=1
        fi

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD

        return $__dict_has_key_ret
    }

    #-------------------------------------------------------------------------------
    def; dict_for_each_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __dict__dict_for_each_key__temp_storage="$(eval command echo \"\$\{__dict__"$1"__keys\}\")"
        for key in $__dict__dict_for_each_key__temp_storage; do
            key="$(nullcall __array_unescape "$key")"
            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
        done
        IFS="$OIFS"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; dict_for_each_value() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __dict__dict_for_each_value__temp_storage="$(eval command echo \"\$\{__dict__"$1"__keys\}\")"
        for key in $__dict__dict_for_each_value__temp_storage; do
            key="$(nullcall __array_unescape "$key")"
            # shellcheck disable=SC2034
            value="$(dict_get_key "$key")"
            set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
        done
        IFS="$OIFS"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; dict_for_each_pair() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall dict_for_each_value "$@"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; dict_has_value() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        __dict__dict_has_value__return=1 # false

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __dict__dict_for_each_value__temp_storage="$(eval command echo \"\$\{__dict__"$1"__keys\}\")"
        for key in $__dict__dict_for_each_value__temp_storage; do
            key="$(nullcall __array_unescape "$key")"
            # shellcheck disable=SC2034
            value="$(dict_get_key "$key")"
            if [ "${value}" = "$2" ]; then
                __dict__dict_has_value__return=0 # true
                break
            fi
        done
        IFS="$OIFS"

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD

        return $__dict__dict_has_value__return
    }

    #endregion Dict Implementation
    #===============================================================================

    #===============================================================================
    #region Reflection Info Functions

    #-------------------------------------------------------------------------------
    def; get_my_real_fullpath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_fullpath__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                nullcall array_peek SHELL_SOURCE
            else
                echo "UNKNOWN"
                exit "${RET_ERROR_UNKNOWN}"
            fi

            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_fullpath__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_fullpath__OPTIONS_OLD

        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; get_my_real_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_basename__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                basename "$(nullcall array_peek SHELL_SOURCE)"
            else
                echo "UNKNOWN"
                exit "${RET_ERROR_UNKNOWN}"
            fi

            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_basename__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_basename__OPTIONS_OLD

        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; get_my_real_dir_fullpath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_fullpath__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                dirname "$(nullcall array_peek SHELL_SOURCE)"
            else
                echo "UNKNOWN"
                exit "${RET_ERROR_UNKNOWN}"
            fi

            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_fullpath__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_fullpath__OPTIONS_OLD

        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; get_my_real_dir_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_basename__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                basename "$(dirname "$(nullcall array_peek SHELL_SOURCE)")"
            else
                echo "UNKNOWN"
                exit "${RET_ERROR_UNKNOWN}"
            fi

            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_basename__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_basename__OPTIONS_OLD

        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; get_my_puuid_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_puuid_basename__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE_PUUID)" -gt 0 ]; then
                nullcall array_peek SHELL_SOURCE_PUUID
            else
                exit "${RET_ERROR_UNKNOWN}"
            fi

            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE

        set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_puuid_basename__OPTIONS_OLD}
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_puuid_basename__OPTIONS_OLD

        return $exit_ret
    }

    #endregion Reflection Info Functions
    #===============================================================================

    #===============================================================================
    #region Create Fence

    def; MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE() { true; }

    #endregion Create Fence
    #===============================================================================
fi

#===============================================================================
#region Announce Ourself Starting

__announce_prefix="Sourced"
if [ "$(nullcall array_peek WAS_SOURCED)" = false ]; then
    __announce_prefix="Invoked"
fi
nullcall log_debug "${__announce_prefix}: $(nullcall get_my_real_fullpath) ($$) [$(nullcall get_my_puuid_basename || echo "$0")]"
unset __announce_prefix

#endregion Announce Ourself
#===============================================================================

set +x ${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__OPTIONS_OLD}
unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__OPTIONS_OLD

#endregion marximus-shell-extensions Base Preamble
################################################################################

################################################################################
#region marximus-shell-extensions Extended Preamble

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_EXTENDED_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then

    #===============================================================================
    #region Create Fence

    def; MARXIMUS_SHELL_EXTENSIONS_EXTENDED_PREAMBLE_FENCE() { true; }

    #endregion Create Fence
    #===============================================================================

    #===============================================================================
    #region Include/Invoke Directives

    #-------------------------------------------------------------------------------
    def; include_G() {
        # intentionally no local scope so it modify globals
        if [ ! -f "$1" ]; then
            call log_warning "Could not source because file is missing: %s" "$1"
            return "${RET_ERROR_FILE_NOT_FOUND}"
        fi

        __LAST_INCLUDE="$(call rreadlink "$1")"

        call log_ultradebug "Sourcing: %s as %s" "$1" "${__LAST_INCLUDE}"

        nullcall _shell_source_push_G "true" "${__LAST_INCLUDE}"

        # shifts off path we are sourcing, but leaves other args intact so they can
        # be used by the sourced script; normally sourcing from within a shell
        # wouldn't allow this, but since we are inside a file already, it is
        # possible to do so
        shift

        # shellcheck disable=SC1090
        . "${__LAST_INCLUDE}"
        ret=$?

        nullcall _shell_source_pop_G

        return $ret
    }

    #-------------------------------------------------------------------------------
    def; ensure_include_GXY() {
        # intentionally no local scope so it can modify globals AND exit script

        call include_G "$@"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "Failed to source '%s'" "$1"
            if [ "$(call array_peek WAS_SOURCED)" = true ]; then
                exit "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
            else
                return "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
            fi
        fi
    }

    #-------------------------------------------------------------------------------
    def; invoke() {
        if [ ! -f "$1" ]; then
            call log_warning "Could not invoke because file is missing: %s" "$1"
            return "${RET_ERROR_FILE_NOT_FOUND}"
        fi

        __LAST_INCLUDE="$(call rreadlink "$1")"

        call log_ultradebug "Invoking: %s as %s" "$1" "${__LAST_INCLUDE}"

        nullcall _shell_source_push_G "false" "${__LAST_INCLUDE}"

        "$@"
        ret=$?

        nullcall _shell_source_pop_G

        return $ret
    }

    #endregion Include/Invoke Directives
    #===============================================================================

    #===============================================================================
    #region Root User Checking Functions

    #-------------------------------------------------------------------------------
    def; require_not_root_user_XY() {
        # intentionally no local scope so it can exit script

        if [ "${CI}" = true ] && [ "${PLATFORM_IS_WSL}" = true ]; then
            # github runner's WSL user is always root
            true
        else
            # shellcheck disable=SC3028
            if [ "$UID" = "0" ] || [ "$EUID" = "0" ] || [ "$(id -u)" = "0" ]; then
                call log_fatal "$(call get_my_real_basename) should not be run as root nor with sudo"
                if [ "$(call array_peek WAS_SOURCED)" = true ]; then
                    exit "${RET_ERROR_USER_IS_ROOT}"
                else
                    return "${RET_ERROR_USER_IS_ROOT}"
                fi
            fi
        fi
    }

    #-------------------------------------------------------------------------------
    def; require_root_user_XY() {
        # intentionally no local scope so it can exit script

        # shellcheck disable=SC3028
        if [ "$UID" != "0" ] && [ "$EUID" != "0" ] && [ "$(id -u)" != "0" ]; then
            call log_fatal "$(call get_my_real_basename) MUST be run as root or with sudo"
            if [ "$(call array_peek WAS_SOURCED)" = true ]; then
                exit "${RET_ERROR_USER_IS_NOT_ROOT}"
            else
                return "${RET_ERROR_USER_IS_NOT_ROOT}"
            fi
        fi
    }

    #endregion Root User Check
    #===============================================================================

    #===============================================================================
    #region File System Functions

    #-------------------------------------------------------------------------------
    def; windows_path_to_unix_path() {
        if \
            [ "${PLATFORM_IS_WSL}" = true ] &&
            [  "$(command echo "$1" | cut -c1)" != "/" ]
        then
            command printf "/"
            command printf "$(command echo "$1" | cut -c1 | tr '[:upper:]' '[:lower:]')"
            command printf "$(command echo "$1" | cut -c3- | sed -e 's/\\/\//g')"
        else
            command printf "$1"
        fi
        command printf "\n"
    }

    #-------------------------------------------------------------------------------
    def; ensure_cd() {
        # intentionally no local scope so that the cd command takes effect
        call log_superdebug "Changing current directory to '%s'" "$1"

        # shellcheck disable=SC2164
        cd "$1"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not cd into '%s'" "$1"
            return "${RET_ERROR_DIRECTORY_NOT_FOUND}"
        fi
    }

    #-------------------------------------------------------------------------------
    def; safe_rm() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            path_to_remove="$1"
            print_rm_error_message="$2"

            call log_superdebug "Safely removing '%s'" "${path_to_remove}"

            if \
                [ "${path_to_remove}" != "/" ] &&
                [ "${path_to_remove}" != "${HOME}" ] &&
                [ "${path_to_remove}" != "${TMPDIR}" ] &&
                [ "${path_to_remove}" != "/Applications" ] &&
                [ "${path_to_remove}" != "/bin" ] &&
                [ "${path_to_remove}" != "/boot" ] &&
                [ "${path_to_remove}" != "/cores" ] &&
                [ "${path_to_remove}" != "/dev" ] &&
                [ "${path_to_remove}" != "/etc" ] &&
                [ "${path_to_remove}" != "/home" ] &&
                [ "${path_to_remove}" != "/lib" ] &&
                [ "${path_to_remove}" != "/Library" ] &&
                [ "${path_to_remove}" != "/local" ] &&
                [ "${path_to_remove}" != "/media" ] &&
                [ "${path_to_remove}" != "/mnt" ] &&
                [ "${path_to_remove}" != "/opt" ] &&
                [ "${path_to_remove}" != "/private" ] &&
                [ "${path_to_remove}" != "/proc" ] &&
                [ "${path_to_remove}" != "/sbin" ] &&
                [ "${path_to_remove}" != "/srv" ] &&
                [ "${path_to_remove}" != "/System" ] &&
                [ "${path_to_remove}" != "/Users" ] &&
                [ "${path_to_remove}" != "/usr" ] &&
                [ "${path_to_remove}" != "/var" ] &&
                [ "${path_to_remove}" != "/Volumes" ] &&
                [ "${path_to_remove}" != "" ]
            then
                rm -rf "${path_to_remove}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    if \
                        [ "${print_rm_error_message}" = "" ] ||
                        [ "${print_rm_error_message}" = true ]
                    then
                        call log_error "failed to rm '%s'" "${path_to_remove}"
                    fi
                    exit "${RET_ERROR_RM_FAILED}"
                fi
            else
                call log_fatal "unsafe rm path '%s'" "${path_to_remove}"
                exit "${RET_ERROR_UNSAFE_RM_PATH}"
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; ensure_does_not_exist() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            path_to_remove="$1"

            call log_superdebug "Ensuring file or directory does not exist: '%s'" "${path_to_remove}"

            if \
                [ -f "${path_to_remove}" ] ||
                [ -d "${path_to_remove}" ]
            then
                call safe_rm "${path_to_remove}"
                ret=$?
                exit $ret
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; create_dir() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            destdir="$1"

            call ensure_does_not_exist "${destdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "failed to remove path '%s'" "${destdir}"
                exit $ret
            fi

            call log_superdebug "Creating directory '%s'" "${destdir}"

            mkdir -p "${destdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "failed to create directory '%s'" "${destdir}"
                exit "${RET_ERROR_CREATE_DIRECTORY_FAILED}"
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; ensure_dir() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            destdir="$1"

            call log_superdebug "Ensuring directory exists: '%s'" "${destdir}"

            if [ ! -d "${destdir}" ]; then
                call create_dir "${destdir}"
                ret=$?
                exit $ret
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; move_file() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            source_filepath="$1"
            dest_filepath="$2"

            call log_superdebug "Copying file '${source_filepath}' to '${dest_filepath}'"

            mv "${source_filepath}" "${dest_filepath}"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_debug "failed to move file from '%s' to '%s'" "${source_filepath}" "${dest_filepath}"
                exit "${RET_ERROR_COPY_FAILED}"
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; copy_file() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            source_filepath="$1"
            dest="$2"

            call log_superdebug "Copying file '${source_filepath}' to '${dest}'"

            cp "${source_filepath}" "${dest}"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_debug "failed to copy file from '%s' to '%s'" "${source_filepath}" "${dest}"
                exit "${RET_ERROR_COPY_FAILED}"
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; copy_dir() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            source_dir="$1"
            dest_dir="$2"

            call log_superdebug "Copying all files from '${source_dir}' to '${dest_dir}'"

            cp -r "${source_dir}"/. "${dest_dir}/"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_debug "failed to copy files from '%s' to '%s'" "${source_dir}" "${dest_dir}"
                exit "${RET_ERROR_COPY_FAILED}"
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #endregion File System Functions
    #===============================================================================

    #===============================================================================
    #region Temp Dir Functions

    #-------------------------------------------------------------------------------
    def; create_my_tempdir() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "${CI}" = true ]; then
                if [ "${GITHUB_ACTIONS}" = true ]; then
                    the_tempdir="${GITHUB_WORKSPACE}/bfi_temp/${GITHUB_ACTION}"
                else
                    the_tempdir="${HOME}/bfi_temp/$(call get_datetime_stamp_filename_formatted)"
                fi
            else
                the_tempdir=$(mktemp -d -t "$(call get_my_real_basename)-$(call get_datetime_stamp_filename_formatted).XXXXXXX")
                ret=$?
                if [ $ret -ne 0 ]; then
                    call log_fatal "failed to get temporary directory"
                    exit "${RET_ERROR_FAILED_TO_GET_TEMP_DIR}"
                fi
            fi

            the_tempdir="$(call windows_path_to_unix_path "${the_tempdir}")"

            command echo "${the_tempdir}"
            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; ensure_my_tempdir_G() {
        # intentionally no local scope b/c modifying a global

        if [ "${my_tempdir}" = "" ]; then
            my_tempdir="$(call create_my_tempdir)"
            ret=$?
            if [ $ret -ne 0 ]; then
                return $ret
            fi
        fi

        call ensure_dir "${my_tempdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            return $ret
        fi

        export my_tempdir

        return "${RET_SUCCESS}"
    }

    #endregion Temp Dir Functions
    #===============================================================================

    #===============================================================================
    #region DateTime Stamp Functions

    #-------------------------------------------------------------------------------
    def; get_datetime_stamp_human_formatted() {
        call date "${DATETIME_STAMP_HUMAN_FORMAT}"
    }

    #-------------------------------------------------------------------------------
    def; get_datetime_stamp_filename_formatted() {
        call date "${DATETIME_STAMP_FILENAME_FORMAT}"
    }

    #endregion DateTime Stamp Functions
    #===============================================================================

    #===============================================================================
    #region Object Identity Functions

    #-------------------------------------------------------------------------------
    def; is_integer() {
        case "${1#[+-]}"  in
            *[!0123456789]*)
                command echo "1"
                return 1
                ;;
            '')
                command echo "1"
                return 1
                ;;
            *)
                command echo "0"
                return 0
                ;;
        esac
        command echo "1"
        return 1
    }

    #endregion Object Identity Functions
    #===============================================================================

    #===============================================================================
    #region Text Formatting Functions

    #-------------------------------------------------------------------------------
    def; unident_text() {
        (
            text="$1"
            leading="$(echo "${text}" | head -n 1 | sed -e "s/\( *\)\(.*\)/\1/")"
            echo "${text}" | sed -e "s/\(${leading}\)\(.*\)/\2/"
        )
    }

    #endregion Text Formatting Functions
    #===============================================================================

fi

#endregion marximus-shell-extensions Extended Preamble
################################################################################

# TODO: needs a fence
# TODO: flag for not tracing batteries-forking-included functions

################################################################################
#region Public *

#===============================================================================
#region Includes

call ensure_include_GXY "$(get_my_real_dir_fullpath)/bfi-base.sh"

#endregion Includes
#===============================================================================

#===============================================================================
#region Return Codes



#endregion Return Codes
#===============================================================================

#===============================================================================
#region Public Constants

BFI_GITHUB_REPO_USER=MarximusMaximus
export BFI_GITHUB_REPO_USER
BFI_GITHUB_REPO_NAME=batteries-forking-included
export BFI_GITHUB_REPO_NAME

#endregion Public Constants
#===============================================================================

#===============================================================================
#region Public Globals

__parse_args_shift_by=0

should_print_usage=false; export should_print_usage
should_print_version=false; export should_print_version
colorized_output=true; export colorized_output
verbosity=1; export verbosity
quiet=false; export quiet
print_report=true; export print_report

if [ "${my_tempdir:-}" = "" ]; then
    my_tempdir=""; export my_tempdir
fi

git_exists=false; export git_exists
curl_exists=false; export curl_exists
wget_exists=false; export wget_exists
tar_exists=false; export tar_exists
unzip_exists=false; export unzip_exists
diff_exists=false; export diff_exists
md5_exists=false; export md5_exists

# used by update and bootstrap
project_dir=""; export project_dir
project_base_name=""; export project_base_name
bfi_dir=""; export bfi_dir

# used only by bootstrap
dev_mode="${BFI_DEV_MODE:-false}"; export dev_mode
dev_mode_unsticky=false
deploy_mode=false; export deploy_mode


#endregion Public Globals
#===============================================================================

#===============================================================================
#region Public Functions

#-------------------------------------------------------------------------------
def; print_usage__update() {
    # we do not use 'command' here b/c we want this to get output to the log file
    # but we don't use a log_* function b/c we don't want the console output to
    # have a timestamp just hanging out b/c it looks ugly
    printf "%s\n" "${usage_text__update}"
}

#-------------------------------------------------------------------------------
def; print_usage__bootstrap() {
    # we do not use 'command' here b/c we want this to get output to the log file
    # but we don't use a log_* function b/c we don't want the console output to
    # have a timestamp just hanging out b/c it looks ugly
    printf "%s\n" "${usage_text__bootstrap}"
}

#-------------------------------------------------------------------------------
def; print_usage() {
    (
        script_name=$(get_my_real_basename)
        case "${script_name}" in
            bfi-update.sh)
                call print_usage__update
                ;;
            bootstrap.sh)
                call print_usage__bootstrap
                ;;
        esac
    )
}

#-------------------------------------------------------------------------------
def; print_version() {
    printf "batteries-forking-included %s\n" "${BFI_VERSION}"
}

#-------------------------------------------------------------------------------
def; parse_args__common_doubledash() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash called with '%s'" "$*"

    __parse_args_shift_by=0

    case "$1" in
        -h|-\?|--help|--usage)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found usage arg"
            should_print_usage=true
            ;;

        -V|--version)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found version arg"
            should_print_version=true
            ;;
        -q|--quiet)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found quiet arg"
            quiet=true
            ;;
        +q|--no-quiet)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-quiet arg"
            quiet=false
            ;;

        -v|--verbose)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found verbose arg"
            temp_verbosity=$((temp_verbosity + 1))
            ;;
        +v|--no-verbose)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-verbose arg"
            temp_verbosity=$((temp_verbosity - 1))
            ;;

        --verbosity)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found verbosity arg"
            if [ -n "$2" ]; then
                temp_verbosity="$2"
                call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t temp_verbosity=%s" "${temp_verbosity}"
                shift
                __parse_args_shift_by=$(( __parse_args_shift_by + 1 ))
            else
                call print_usage
                call log_error "\"--verbosity\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
            fi
            ;;
        --verbosity=?*)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found verbosity=* arg"
            temp_verbosity="$1"
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t temp_verbosity=%s" "${temp_verbosity}"
            temp_verbosity="$(command echo "${project_dir}" | cut -c 15-)"
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t temp_verbosity=%s" "${temp_verbosity}"
            ;;
        --verbosity=)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found verbosity= arg"
            call print_usage
            call log_error "\"--verbosity\" requires a non-empty option argument."
            exit "${RET_ERROR_INVALID_ARGUMENT}"
            ;;

        -c|--color)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found color arg"
            colorized_output=true
            ;;
        +c|--no-color)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-color arg"
            colorized_output=false
            ;;

        -C|--alt-color)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found alt-color arg"
            alt_color=true
            ;;
        +C|--no-alt-color)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-alt-color arg"
            alt_color=false
            ;;

        -r|--report)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found report arg"
            print_report=true
            ;;
        +r|--no-report)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-report arg"
            print_report=false
            ;;

        -b|--bfi-dir)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found bfi-dir arg, \$2=%s" "$2"
            if [ -n "$2" ]; then
                bfi_dir="$2"
                call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t\t bfi_dir=%s" "${bfi_dir}"
                shift
                __parse_args_shift_by=$(( __parse_args_shift_by + 1 ))
            else
                call print_usage
                call log_error "\"--bfi-dir\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
            fi
            ;;
        -b=?*|--bfi-dir=?*)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found bfi-dir=* arg"
            bfi_dir="$1"
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t bfi_dir=%s" "${bfi_dir}"
            case "$1" in
                -b=?*)
                    bfi_dir="$(command echo "${bfi_dir}" | cut -c 4-)"
                    ;;
                --bfi-dir=?*)
                    bfi_dir="$(command echo "${bfi_dir}" | cut -c 11-)"
                    ;;
            esac
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t bfi_dir=%s" "${bfi_dir}"
            ;;
        -b=|--bfi-dir=)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found bfi-dir= arg"
            call print_usage
            call log_error "\"--bfi-dir\" requires a non-empty option argument."
            exit "${RET_ERROR_INVALID_ARGUMENT}"
            ;;

        -P|--project-base-name)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name arg"
            if [ -n "$2" ]; then
                project_base_name_temp="$2"
                call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                shift
                __parse_args_shift_by=$(( __parse_args_shift_by + 1 ))
            else
                call print_usage
                call log_error "\"--project-base-name\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
            fi
            ;;
        -P=?*|--project-base-name=?*)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name=* arg"
            project_base_name_temp="$1"
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
            case "$1" in
                -P=?*)
                    project_base_name_temp="$(command echo "${project_base_name_temp}" | cut -c 4-)"
                    ;;
                --project-base-name=?*)
                    project_base_name_temp="$(command echo "${project_base_name_temp}" | cut -c 21-)"
                    ;;
            esac
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
            ;;
        -P=|--project-base-name=)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name= arg"
            call print_usage
            call log_error "\"--project-base-name\" requires a non-empty option argument."
            exit "${RET_ERROR_INVALID_ARGUMENT}"
            ;;

        -p|--project-dir)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir arg"
            if [ -n "$2" ]; then
                project_dir="$2"
                call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                shift
                __parse_args_shift_by=$(( __parse_args_shift_by + 1 ))
            else
                call print_usage
                call log_error "\"--project-dir\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
            fi
            ;;
        -p=?*|--project-dir=?*)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir=* arg"
            project_dir="$1"
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
            case "$1" in
                -p=?*)
                    project_dir="$(command echo "${project_dir}" | cut -c 4-)"
                    ;;
                --project-dir=?*)
                    project_dir="$(command echo "${project_dir}" | cut -c 15-)"
                    ;;
            esac
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
            ;;
        -p=|--project-dir=)
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir= arg"
            call print_usage
            call log_error "\"--project-dir\" requires a non-empty option argument."
            exit "${RET_ERROR_INVALID_ARGUMENT}"
            ;;

        --?*)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found unknown arg"
            call log_warning "Unknown option (ignored): %s" "$1"
            ;;

        -?|+?)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found unknown flag"
            call log_warning "Unknown flag (ignored): %s" "$1"
            ;;

    esac

    return "${__parse_args_shift_by}"
}

#-------------------------------------------------------------------------------
def; parse_args__common_singledash() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash called with '%s'" "$*"
    call parse_args__common_doubledash "$@"
    return $?
}

#-------------------------------------------------------------------------------
def; parse_args__common_singledash_multi() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi called with '%s'" "$*"

    case "$1" in
        h|\?)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found usage flag"
            should_print_usage=true
            ;;
        V)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found version flag"
            should_print_version=true
            ;;
        q)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found quiet flag"
            quiet=true
            ;;
        v)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found verbose flag"
            temp_verbosity=$((temp_verbosity + 1)) # Each -v argument adds 1 to verbosity.
            ;;

        c)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found color flag"
            colorized_output=true
            ;;

        C)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found alt-color flag"
            alt_color=true
            ;;

        r)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found report flag"
            print_report=true
            ;;

        *)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found unknown flag"
            call log_warning "Unknown flag (ignored): %s" "$1"
            ;;
    esac
}

#-------------------------------------------------------------------------------
def; parse_args__common_singleplus() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus called with '%s'" "$*"
    call parse_args__common_doubledash "$@"
    return $?
}

#-------------------------------------------------------------------------------
def; parse_args__common_singleplus_multi() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi called with '%s'" "$*"

    case "$1" in
        h|\?)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found usage flag"
            should_print_usage=true
            ;;
        V)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found version flag"
            should_print_version=true
            ;;
        q)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-quiet flag"
            quiet=false
            ;;
        v)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found verbose flag"
            temp_verbosity=$((temp_verbosity - 1))
            ;;

        c)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-color flag"
            colorized_output=false;
            ;;

        C)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-alt-color flag"
            alt_color=false
            ;;

        r)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-report flag"
            print_report=false
            ;;

        *)
            call log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found unknown flag"
            call log_warning "Unknown flag (ignored): %s" "$1"
            ;;
    esac
}

#-------------------------------------------------------------------------------
def; parse_args__common_set_and_export() {
    verbosity="${temp_verbosity}"

    if [ "${alt_color}" = true ]; then
        colorized_output=alt
    fi

    project_dir="$(call rreadlink "${project_dir}")"

    if [ "${bfi_dir}" = "" ]; then
        bfi_dir="${project_dir}/../batteries-forking-included"
    fi
    bfi_dir=$(call rreadlink "${bfi_dir}")

    if [ "${project_base_name_temp}" = "" ]; then
        project_base_name="$(basename -- "${project_dir}")"
    else
        project_base_name="${project_base_name_temp}"
    fi

    export colorized_output
    export verbosity
    export quiet
    export should_print_usage
    export should_print_version
    export print_report
    export project_base_name
    export project_dir
    export bfi_dir

    # recalculate "constant" values
    call set_calculated_constants
    call set_ansi_code_color_constants

    call log_debug "colorized_output=%s" "${colorized_output}"
    call log_debug "verbosity=%d" "${verbosity}"
    call log_debug "quiet=%s" "${quiet}"
    call log_debug "should_print_usage=%s" "${should_print_usage}"
    call log_debug "should_print_version=%s" "${should_print_version}"
    call log_debug "print_report=%s" "${print_report}"
    call log_debug "project_dir=%s" "${project_dir}"
    call log_debug "project_base_name=%s" "${project_base_name}"
    call log_debug "bfi_dir=%s" "${bfi_dir}"

    if [ "${should_print_usage}" = true ]; then
        call print_usage
        exit "${RET_SUCCESS}"
    fi

    if [ "${should_print_version}" = true ]; then
        call print_version
        exit "${RET_SUCCESS}"
    fi
}

#-------------------------------------------------------------------------------
def; parse_args__bootstrap() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap called with '%s'" "$*"

    # temporarily just assign these to best guesses
    project_dir="$(pwd)"
    project_base_name="$(basename -- "${project_dir}")"

    project_base_name_temp=""

    temp_verbosity="${verbosity}"
    alt_color=false

    positional_arg_index=0

    if [ "$*" != "" ]; then
        while true; do
            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while; \$1='%s'; \$*='%s'" "$1" "$*"

            __parse_args_shift_by=0

            if [ $# -le 0 ]; then
                break
            fi

            if [ "$1" != "" ]; then
                case "$1" in
                    --)     # stop processing args
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found -- arg"
                        shift
                        break
                        ;;

                    -d|--dev|--developer)
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found dev arg"
                        dev_mode=true
                        dev_mode_unsticky=true
                        ;;
                    +d|--no-dev|--no-developer)
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found no-dev arg"
                        dev_mode=false
                        dev_mode_unsticky=true
                        ;;

                    -D|--deploy|--deployment)
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found deploy arg"
                        deploy_mode=true
                        ;;
                    +D|--no-deploy|--no-deployment)
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found no-deploy arg"
                        deploy_mode=false
                        ;;

                    --?*)
                        call parse_args__common_doubledash "$@"
                        shift $?
                        ;;

                    -?)
                        call parse_args__common_singledash "$@"
                        shift $?
                        ;;

                    -?*)    # positive flags
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found positive flags arg"
                        arg_remain="$1"

                        while true; do
                            arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                            arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                            if [ "${arg_char}" = "" ]; then
                                break
                            fi

                            case "${arg_char}" in
                                d)
                                    call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-);\t found dev flag"
                                    dev_mode=true;
                                    dev_mode_unsticky=true
                                    ;;

                                D)
                                    call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-);\t found deploy flag"
                                    deploy_mode=true;
                                    ;;

                                *)
                                    call parse_args__common_singledash_multi "${arg_char}"
                                    ;;
                            esac

                        done
                        ;;

                    +?)
                        call parse_args__common_singleplus "$@"
                        shift $?
                        ;;

                    +?*)    # negative flags
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found negative flags arg"
                        arg_remain="$1"

                        while true; do
                            arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                            arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                            call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                            if [ "${arg_char}" = "" ]; then
                                break
                            fi

                            case "${arg_char}" in
                                d)
                                    call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(+);\t found no-dev flag"
                                    dev_mode=false;
                                    dev_mode_unsticky=true
                                    ;;

                                D)
                                    call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(+);\t found no-deploy flag"
                                    deploy_mode=false;
                                    ;;

                                *)
                                    call parse_args__common_singleplus_multi "${arg_char}"
                                    ;;
                            esac

                        done
                        ;;

                    *)
                        call log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found positional arg #%d '%s'" "${positional_arg_index}" "$1"

                        case "${positional_arg_index}" in
                            # 0)
                            #     ;;
                            # 1)
                            #     ;;
                            *)
                                call log_warning "Extra positional arg (ignored): %s" "$1"
                                ;;
                        esac

                        positional_arg_index=$((positional_arg_index + 1))
                        ;;
                esac
            fi
            shift
        done
    fi

    # # if --file was provided, open it for writing, else duplicate stdout
    # if [ -n "$file" ]; then
    #     exec 3> "$file"
    # else
    #     exec 3>&1
    # fi

    call parse_args__common_set_and_export

    export dev_mode
    export dev_mode_unsticky
    export deploy_mode

    call log_debug "dev_mode=%s" "${dev_mode}"
    call log_debug "dev_mode_unsticky=%s" "${dev_mode_unsticky}"
    call log_debug "deploy_mode=%s" "${deploy_mode}"

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
def; parse_args__update() {
    call log_ultradebug "$(get_my_real_basename)::parse_args__update called with '%s'" "$*"

    # temporarily just assign these to best guesses
    project_dir="$(pwd)"

    temp_verbosity="${verbosity}"
    alt_color=false

    positional_arg_index=0

    if [ "$*" != "" ]; then
        while true; do
            call log_ultradebug "$(get_my_real_basename)::parse_args::while; \$1='%s'; \$*='%s'" "$1" "$*"

            __parse_args_shift_by=0

            if [ $# -le 0 ]; then
                break
            fi

            if [ "$1" != "" ]; then
                case "$1" in
                    --)     # stop processing args
                        call log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found -- arg"
                        shift
                        break
                        ;;

                    --?*)
                        call parse_args__common_doubledash "$@"
                        shift $?
                        ;;

                    -?)
                        call parse_args__common_singledash "$@"
                        shift $?
                        ;;

                    -?*)    # positive flags
                        call log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found positive flags arg"
                        arg_remain="$1"

                        while true; do
                            arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                            arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                            call log_ultradebug "$(get_my_real_basename)::parse_args::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                            if [ "${arg_char}" = "" ]; then
                                break
                            fi

                            case "${arg_char}" in
                                *)
                                    call parse_args__common_singledash_multi "${arg_char}"
                                    ;;
                            esac

                        done
                        ;;

                    +?*)    # negative flags
                        call log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found negative flags arg"
                        arg_remain="$1"

                        while true; do
                            arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                            arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                            call log_ultradebug "$(get_my_real_basename)::parse_args::while::while(+); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                            if [ "${arg_char}" = "" ]; then
                                break
                            fi

                            case "${arg_char}" in
                                *)
                                    call parse_args__common_singleplus_multi "${arg_char}"
                                    ;;
                            esac

                        done
                        ;;

                    *)
                        call log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found positional arg #%d '%s'" "${positional_arg_index}" "$1"

                        case "${positional_arg_index}" in
                            # 0)
                            #     ;;
                            # 1)
                            #     ;;
                            *)
                                call log_warning "Extra positional arg (ignored): %s" "$1"
                                ;;
                        esac

                        positional_arg_index=$((positional_arg_index + 1))
                        ;;
                esac
            fi
            shift
        done
    fi

    # # if --file was provided, open it for writing, else duplicate stdout
    # if [ -n "$file" ]; then
    #     exec 3> "$file"
    # else
    #     exec 3>&1
    # fi

    call parse_args__common_set_and_export

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
def; check_tools__begin() {
    call log_header "Checking tools"
}

#-------------------------------------------------------------------------------
def; check_tools__end() {
    call log_footer "Tools checked."
}

#-------------------------------------------------------------------------------
def; check_tools__detect_G() {
    # intentionally no local scope because modifying globals

    if [ "$(command -v git)" != "" ]; then
        git_exists=true
    fi
    export git_exists

    if [ "$(command -v curl)" != "" ]; then
        curl_exists=true
    fi
    export curl_exists

    if [ "$(command -v wget)" != "" ]; then
        wget_exists=true
    fi
    export wget_exists

    if [ "$(command -v tar)" != "" ]; then
        tar_exists=true
    fi
    export tar_exists

    if [ "$(command -v unzip)" != "" ]; then
        unzip_exists=true
    fi
    export unzip_exists

    if [ "$(command -v diff)" != "" ]; then
        diff_exists=true
    fi
    export diff_exists

    if [ "$(command -v md5)" != "" ]; then
        md5_exists=true
    fi
    export md5_exists
}

#-------------------------------------------------------------------------------
def; check_tools__require_extractable_X() {
    if \
        [ "${tar_exists}" = false ] &&
        [ "${unzip_exists}" = false ]
    then
        call log_fatal "no way to extract from compressed file available (no tar, no unzip)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
def; check_tools__require_clonable_X() {
    if \
        [ "${git_exists}" = false ] &&
        [ "${curl_exists}" = false ] &&
        [ "${wget_exists}" = false ]
    then
        call log_fatal "no way to clone repo available (no git, no curl, no wget)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi

    if [ "${git_exists}" = false ]; then
        check_tools__require_extractable_X
    fi
}

#-------------------------------------------------------------------------------
def; check_tools__require_downloadable_X() {
    if \
        [ "${curl_exists}" = false ] &&
        [ "${wget_exists}" = false ]
    then
        call log_fatal "no way to download available (no curl, no wget)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
def; check_tools__require_comparible_X() {
    if \
        [ "${diff_exists}" = false ] &&
        [ "${md5_exists}" = false ]
    then
        call log_fatal "no way to compare files (no diff, no md5)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
def; download_url_to_path() {
    (
        URL="$1"
        output="$2"

        call check_tools__require_downloadable_X

        if [ "${curl_exists}" = true ]; then
            call log_info "Using curl to download '${URL}' to '${output}'"
            call teetty_G "2>&1 curl -# -L \"${URL}\" --fail --output \"${output}\""
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "failed to download ${URL} (curl)"
                exit "${RET_ERROR_DOWNLOAD_FAILED}"
            fi
        elif [ "${wget_exists}" = true ]; then
            call log_info "Using wget to download '${URL}' to '${output}'"
            call teetty_G "wget \"${URL}\" -O \"${output}\""
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "failed to download ${URL} (wget)"
                exit "${RET_ERROR_DOWNLOAD_FAILED}"
            fi
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; extract_tarball() {
    (
        file=$1
        dest=$2

        call log_info "Extracting tarball '%s' to '%s'" "${file}" "${dest}"

        _dest=""
        if [ "${dest}" != "" ]; then
            _dest=" -C "
        fi

        call teetty_G tar -xzvf "${file}" --strip=1"${_dest}""${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "failed to extract ${file} compressed file (tar)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; extract_zipball() {
    (
        file=$1
        dest=$2

        call log_info "Extracting zipball '%s' to '%s'" "${file}" "${dest}"

        call create_dir "${my_tempdir}/extracted"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        call teetty_G unzip -v -d "${my_tempdir}/extracted" "${file}"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "failed to extract  ${file} compressed file (unzip)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi

        if [ "${dest}" = "" ]; then
            dest=$(pwd)
        fi

        call move_file "${my_tempdir}/extracted/*/*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "failed to move extracted files into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi

        call move_file "${my_tempdir}/extracted/*/.*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "failed to move extracted files dotfiles into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; download_and_extract() {
    (
        repo_url=$1
        file_basename=$2
        destdir="$3"

        call check_tools__require_downloadable_X
        call check_tools__require_extractable_X

        URL="${repo_url}"
        filepath="${my_tempdir}/${file_basename}"

        if [ "${tar_exists}" = true ]; then
            URL="${URL}/tarball"
            filepath="${filepath}.tar.gz"
        elif [ "${unzip_exists}" = true ]; then
            URL="${URL}/zipball"
            filepath="${filepath}.zip"
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            call log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        call download_url_to_path "${URL}" "${filepath}"

        call create_dir "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        if [ "${tar_exists}" = true ]; then
            call extract_tarball "${my_tempdir}/${file_basename}.tar.gz" "${destdir}"
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        elif [ "${unzip_exists}" = true ]; then
            call extract_zipball "${my_tempdir}/${file_basename}.zip" "${destdir}"
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            call log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; ensure_conda() {
    (
        call log_header "Checking For Conda..."

        if [ ! -f "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh" ]; then
            call log_footer "Conda Not Found."

            call log_header "Installing Conda..."

            call ensure_my_tempdir_G
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            call ensure_dir "${my_tempdir}/downloads"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            file_to_download="Miniforge3-${CONDA_FORGE_PLATFORM}-${CONDA_FORGE_ARCH}.${CONDA_FORGE_EXT}"
            URL="https://github.com/conda-forge/miniforge/releases/latest/download/${file_to_download}"
            conda_installer="${my_tempdir}/downloads/${file_to_download}"

            call download_url_to_path "${URL}" "${conda_installer}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            call teetty_G chmod +x "${my_tempdir}/downloads/${file_to_download}"

            dirname_CONDA_INSTALL_PATH="$(dirname "${CONDA_INSTALL_PATH}")"
            if [ ! -d "${dirname_CONDA_INSTALL_PATH}" ]; then
                call log_console "${ANSI_BELL}${ANSI_WARNING} '${dirname_CONDA_INSTALL_PATH}' doesn't exist, we need sudo to create it, either enter your password below OR exit this script (CTRL+C multiple times) and run the following commands and rerun this script.${ANSI_RESET}\nsudo mkdir \"${dirname_CONDA_INSTALL_PATH}\"\nsudo chown \"${REAL_USER}\":\"${DEFAULT_ADMIN_GROUP}\" \"${dirname_CONDA_INSTALL_PATH}\"\nsudo -k"
                (
                    sudo mkdir "${dirname_CONDA_INSTALL_PATH}"
                    sudo chown "${REAL_USER}":"${DEFAULT_ADMIN_GROUP}" "${dirname_CONDA_INSTALL_PATH}"
                    sudo -k
                )
            fi

            call log_info "Installing Conda with PREFIX='${CONDA_INSTALL_PATH}'"

            call teetty_G "2>&1 CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true \"${conda_installer}\" -b -f -p \"${CONDA_INSTALL_PATH}\""
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "Failed to install Conda."
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            else
                call log_footer "Conda Install Completed."
                exit "${RET_SUCCESS}"
            fi
        else
            call log_footer "Conda Found."
            exit "${RET_SUCCESS}"
        fi
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; conda_update_base() {
    (
        call log_header "Updating Base Conda Environment..."

        call teetty_G conda activate base
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "'conda activate base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
        fi

        call teetty_G "2>&1 CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda update -n base conda -v -y --prune"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "'conda update -n base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
        fi

        call teetty_G "2>&1 CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda update -n base --all -v -y --prune"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "'conda update -n base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
        fi

        call log_footer "Base Conda Environment Updated."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

# TODO: rename conda_setup_env to conda_setup_project_env
# TODO: create new conda_setup_env that takes name + file

#-------------------------------------------------------------------------------
def; conda_setup_env() {
    (
        call log_header "Looking for %s Conda Environment..." "${project_base_name}"

        found_env=$(conda env list | awk -v project_base_name="${project_base_name}" '{if ($1 == project_base_name) print $1}')

        if [ "${found_env}" = "" ]; then
            call log_footer "%s Conda Environment not found." "${project_base_name}"
        else
            call log_footer "%s Conda Environment found." "${project_base_name}"
        fi

        if [ "${found_env}" = "" ]; then
            call log_header "Installing %s Conda Environment..." "${project_base_name}"

            call teetty_G "2>&1 CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda env create --name \"${project_base_name}\" --file ./conda-environment.yml -v"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "'conda create --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            call log_footer "%s Conda Environment Installed." "${project_base_name}"
        else
            call log_header "Updating %s Conda Environment..." "${project_base_name}"

            call teetty_G "2>&1 CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda env update --name \"${project_base_name}\" --file ./conda-environment.yml --prune -v"
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "'conda update --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            call log_footer "%s Conda Environment Updated." "${project_base_name}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; conda_env_read_sticky_config() {
    call log_header "Loading sticky configuration options..."

    call log_superdebug "dev_mode_unsticky=${dev_mode_unsticky}"
    if [ "${dev_mode_unsticky}" != true ]; then
        call log_superdebug "doing dev_mode=\"\$\{BFI_DEV_MODE:-\$\{dev_mode\}\}\""
        dev_mode="${BFI_DEV_MODE:-${dev_mode}}"
    else
        call log_superdebug "SKIPPING dev_mode=\"\$\{BFI_DEV_MODE:-\$\{dev_mode\}\}\""
    fi
    export dev_mode
    call log_debug "dev_mode=%s" "${dev_mode}"

    call log_footer "Sticky configuration options loaded."
}

#-------------------------------------------------------------------------------
def; conda_env_write_sticky_config() {
    call log_header "Writing sticky configuration options..."

    call ensure_dir "${CONDA_PREFIX}"/etc/conda/activate.d
    call ensure_dir "${CONDA_PREFIX}"/etc/conda/deactivate.d
    touch "${CONDA_PREFIX}"/etc/conda/activate.d/env_vars.sh
    touch "${CONDA_PREFIX}"/etc/conda/deactivate.d/env_vars.sh

    activate_env_vars_text="\
        BFI_DEV_MODE=\"${dev_mode}\"
    "
    activate_env_vars_text="$(call unident_text "${activate_env_vars_text}")"
    echo "${activate_env_vars_text}" >"${CONDA_PREFIX}"/etc/conda/activate.d/env_vars.sh

    deactivate_env_vars_text="\
        unset BFI_DEV_MODE
    "
    deactivate_env_vars_text="$(call unident_text "${deactivate_env_vars_text}")"
    echo "${deactivate_env_vars_text}" >"${CONDA_PREFIX}"/etc/conda/deactivate.d/env_vars.sh

    call log_footer "Sticky configuration options written."
}

#-------------------------------------------------------------------------------
def; poetry_install() {
    (
        call log_header "Checking for Poetry Settings..."

        poetry_found="$(grep '\[tool.poetry\]' pyproject.toml)"

        if [ "${poetry_found}" != "" ]; then
            call log_footer "Poetry Settings Found."
        else
            call log_footer "Poetry Settings Not Found. Skipping."
        fi

        if [ "${poetry_found}" != "" ]; then
            call log_header "Running 'poetry install'..."

            poetry_verbosity=""
            if [ "${verbosity}" -ge 2 ]; then
                poetry_verbosity=" -v"
                for _i in $(seq 1 "${verbosity}"); do
                    poetry_verbosity="${poetry_verbosity}v"
                done
            fi

            poetry_ansi="--ansi"
            if [ "${colorized_output}" = false ]; then
                poetry_ansi=" --no-ansi"
            fi

            poetry_no_dev=""
            if [ "${dev_mode}" = false ] && [ "${BFI_DEV_MODE:-false}" = false ]; then
                poetry_no_dev=" --without dev"
            fi

            poetry_args="${poetry_ansi}${poetry_verbosity}${poetry_no_dev}"

            call log_debug "poetry install args: ${poetry_args}"

            # shellcheck disable=SC2086  # we actually want the variable to get split
            call teetty_G poetry install --sync ${poetry_args}
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "'poetry install' exited with error code: %d" "$ret"
                exit "${RET_ERROR_POETRY_INSTALL_FAILED}"
            fi

            call log_header "'poetry install' Completed."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; pip_uninstall() {
    (
        call log_header "Checking for pip-uninstall.txt..."

        if [ -f ./pip-uninstall.txt ]; then
            call log_footer "pip-uninstall.txt Found."

            call log_header "Checking pip-uninstall.txt size..."

            uninstall_size="$(wc -c <"pip-uninstall.txt")"
            if [ "${uninstall_size}" -ne 0 ]; then
                call log_footer "pip-uninstall.txt Not Empty."

                call log_header "Running 'pip uninstall'..."

                call teetty_G pip uninstall --yes --no-input --verbose --requirement pip-uninstall.txt
                ret=$?
                if [ $ret -ne 0 ]; then
                    call log_fatal "'pip uninstall' exited with error code: %d" "$ret"
                    exit "${RET_ERROR_PIP_UNINSTALL_FAILED}"
                fi

                call log_footer "'pip uninstall' Completed."
            else
                call log_footer "pip-uninstall.txt Empty. Skipping pip uninstall."
            fi
        else
            call log_footer "pip-uninstall.txt Not Found. Skipping pip uninstall."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; pip_install() {
    (
        pip_requirements_found=false

        if [ "${dev_mode}" = true ] || [ "${BFI_DEV_MODE:-false}" = true ]; then
            call log_header "Running in dev mode, checking for pip-requirements-dev.txt..."
            if [ -f ./pip-requirements-dev.txt ]; then
                call log_footer "pip-requirements-dev.txt Found."
                pip_requirements_found=true
            else
                call log_footer "pip-requirements-dev.txt Not Found."
            fi
        fi

        if [ "${pip_requirements_found}" = false ]; then
            call log_header "Checking for pip-requirements.txt..."
            if [ -f ./pip-requirements-dev.txt ]; then
                call log_footer "pip-requirements.txt Found."
            else
                call log_footer "pip-requirements.txt Not Found. Skipping pip install."
            fi
        fi

        if [ "${pip_requirements_found}" = true ]; then
            ret="${RET_ERROR_UNKNOWN}"

            if \
                {
                    [ "${dev_mode}" = true ] ||
                    [ "${BFI_DEV_MODE:-false}" = true ]
                } &&
                [ -f ./pip-requirements-dev.txt ]
            then
                call log_header "Running 'pip install' using 'pip-requirements-dev.txt'..."
                call teetty_G pip install --upgrade --no-input --verbose --requirement pip-requirements-dev.txt
                ret=$?
            elif [ -f ./pip-requirements.txt ]; then
                call log_header "Running 'pip install' using 'pip-requirements.txt'..."
                call teetty_G pip install --upgrade --no-input --verbose --requirement pip-requirements.txt
                ret=$?
            fi

            if [ $ret -ne 0 ]; then
                call log_fatal "'pip install' exited with error code: %d" "$ret"
                exit "${RET_ERROR_PIP_INSTALL_FAILED}"
            fi

            call log_footer "'pip install' Completed."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; run_post_bootstrap_script() {
    call log_header "Running 'post-bootstrap.sh'"

    # be sure to run in post-setup in it's own subshell
    # (the default script also does this itself, but we can't trust that
    #   to still exist after user edits)
    (
        call ensure_include_GXY "${project_dir}"/post-bootstrap.sh
        call post_bootstrap
        ret=$?
        exit $ret
    )
    ret=$?

    if [ $ret -ne 0 ]; then
        call log_fatal "'post-bootstrap.sh' exited with error code: %d" "$ret"
    else
        call log_footer "'post-bootstrap.sh' Completed."
    fi

    return $ret
}

#-------------------------------------------------------------------------------
def; ensure_batteries_forking_included() {
    (
        call log_header "Ensuring batteries-forking-included exists..."

        call check_tools__require_downloadable_X

        call log_superdebug "bfi_dir=${bfi_dir}"

        if \
            [ ! -d "${bfi_dir}" ] ||
            [ ! -d "${bfi_dir}/.git" ] ||
            [ ! -f "${bfi_dir}/src/batteries_forking_included/template/bfi-update.sh" ]
        then
            # batteries-forking-included missing, let's download it
            call ensure_cd "${bfi_dir}/.."
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            if [ "${git_exists}" = true ]; then
                call teetty_G git clone "https://github.com/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}.git"
                ret=$?
                if [ $ret -ne 0 ]; then
                    call log_fatal "failed to clone https://github.com/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}.git"
                    exit "${RET_ERROR_GIT_CLONE_FAILED}"
                fi

                call log_footer "batteries-forking-included cloned."
            elif \
                [ "${curl_exists}" = true ] ||
                [ "${wget_exists}" = true ]
            then
                call download_and_extract "https://api.github.com/repos/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}" "${BFI_GITHUB_REPO_NAME}" "${bfi_dir}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                # create download timestamp
                touch "${bfi_dir}"/LAST_DOWNLOADED

                call log_footer "batteries-forking-included downloaded."
            else # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                call log_fatal "no way to download available (no git, no curl, no wget)"
                exit "${RET_ERROR_TOOL_MISSING}"
            fi
        else
            call log_footer "batteries-forking-included exists."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; update_batteries_forking_included_repo() {
    (
        call log_header "Updating batteries-forking-included"

        call check_tools__require_downloadable_X

        if [ "${git_exists}" = true ]; then
            call ensure_cd "${bfi_dir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            current_branch="$(git rev-parse --abbrev-ref HEAD)"
            if [ "${current_branch}" != "main" ]; then
                call log_warning "batteries-forking-included's current branch is not main"
                # this is fine, so just bail early
                exit "${RET_SUCCESS}"
            fi

            ahead_by="$(git rev-list --left-right --count origin/main...main | awk '{print $2}')"
            is_dirty="$(git status --porcelain --untracked-files=all)"
            if \
                [ "${is_dirty}" = "" ] &&
                [ "${ahead_by}" -eq 0 ]
            then
                # not dirty
                call teetty_G git fetch
                ret=$?
                if [ $ret -ne 0 ]; then
                    call log_fatal "git fetch failed"
                    exit "${RET_ERROR_GIT_FETCH_FAILED}"
                fi

                call teetty_G git reset --hard origin/main
                ret=$?
                if [ $ret -ne 0 ]; then
                    call log_fatal "git reset failed"
                    exit "${RET_ERROR_GIT_RESET_FAILED}"
                fi

                call log_footer "batteries-forking-included updated."
            else
                call log_warning "batteries-forking-included has local changes, did not update from the upstream"
                # this is fine, so just bail early
                exit "${RET_SUCCESS}"
            fi
        elif \
            [ "${curl_exists}" = true ] ||
            [ "${wget_exists}" = true ]
        then
            # check all files in "repo" if their date is newer than
            # our timestamp file, if yes, is_dirty will be true
            # shellcheck disable=SC2012
            is_dirty="$(ls -lt | head -2 | tail -1 | grep -v "LAST_DOWNLOADED")"

            if [ "${is_dirty}" = "" ]; then
                call safe_rm "${bfi_dir}"
                ret=$?
                if [ "$(call return_code_is_error $ret)" = true ]; then
                    exit $ret
                fi

                call download_and_extract "https://api.github.com/repos/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}" "${BFI_GITHUB_REPO_NAME}" "${bfi_dir}"
                ret=$?
                if [ "$(call return_code_is_error $ret)" = true ]; then
                    exit $ret
                fi

                call log_footer "batteries-forking-included updated."
            else
                call log_warning "batteries-forking-included has local changes, did not update from the upstream"
                # this is fine, so just bail early
                exit "${RET_SUCCESS}"
            fi
        else # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            call log_fatal "no way to download available (no git, no curl, no wget)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; copy_temporary_template_files() {
    (
        call log_header "Creating a copy of template files"

        call create_dir "${my_tempdir}/template"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call log_debug "Copying files"

        call copy_dir "${bfi_dir}/src/batteries_forking_included/template/" "${my_tempdir}/template/"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            call log_fatal "failed to copy files from '%s' to '%s'" "${bfi_dir}/src/batteries_forking_included/template/" "${my_tempdir}/template/"
            exit "${RET_ERROR_COPY_FAILED}"
        fi

        call log_footer "Copy of template files created."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; is_file_same() {
    # exit code 0 == same
    # exit code 1 == different
    # exit code 2 == there was an error
    (
        left_file="$1"
        right_file="$2"

        call log_debug "Comparing '%s' and '%s'" "${left_file}" "${right_file}"

        call check_tools__require_comparible_X

        if [ "${diff_exists}" = true ]; then
            diff "${left_file}" "${right_file}" >/dev/null
            ret=$?
            if [ $ret -gt 2 ]; then
                exit 2
            fi
            exit $ret
        elif [ "${md5_exists}" = true ]; then
            left_md5="$(md5 -q "${left_file}")"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit 2
            fi

            right_md5="$(md5 -q "${right_file}")"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit 2
            fi

            if [ "${left_md5}" = "${right_md5}" ]; then
                exit 0
            else
                exit 1
            fi
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            call log_fatal "no way to comapre files (no diff, no md5)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; check_and_update_file() {
    (
        filename="$1"
        make_backup="$2"

        if [ ! -f "${my_tempdir}/template/${filename}" ]; then
            call log_warning "Expected a file, but found a directory: %s" "${my_tempdir}/template/${filename}"
            exit "${RET_WARNING_NOT_A_FILE}"
        fi

        needs_copy=false

        if [ ! -f "${project_dir}/${filename}" ]; then
            needs_copy=true
            call log_info "${filename} missing from project. Will be copied."
        fi

        if [ "${needs_copy}" = false ]; then
            call is_file_same "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
            ret=$?
            if [ $ret -gt 2 ]; then
                exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
            elif [ $ret -eq 1 ]; then
                needs_copy=true
                call log_info "${filename} needs to be updated."
            else
                call log_success "${filename} did not change. Already up to date."
            fi
        fi

        if [ "${needs_copy}" = true ]; then
            call log_info "Copying latest ${filename}..."

            if [ "${make_backup}" = true ]; then
                if [ -f "${project_dir}/${filename}" ]; then
                    backup_filepath="${project_dir}/${filename}.$(call get_datetime_stamp_filename_formatted).old"
                    call log_info "Creating backup at ${backup_filepath}"
                    call copy_file "${project_dir}/${filename}" "${backup_filepath}"
                    ret=$?
                    if [ "$(call return_code_is_error $ret)" = true ]; then
                        exit $ret
                    fi
                fi
            fi

            call safe_rm "${project_dir}/${filename}"
            ret=$?
            if [ "$(call return_code_is_error $ret)" = true ]; then
                exit $ret
            fi

            call move_file "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
            if [ "$(call return_code_is_error $ret)" = true ]; then
                call log_fatal "failed to move '%s' to '%s'" "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
                exit "${RET_ERROR_MOVE_FAILED}"
            fi

            call safe_rm "${my_tempdir}/template/${filename}"

            call log_success "${filename} updated successfully."

            if [ "$(dirname "$(call array_get_last SHELL_SOURCE)")" = "${project_dir}" ]; then
                exit "${RET_SUCCESS_SPECIAL}"
            else
                exit "${RET_SUCCESS}"
            fi
        else
            call safe_rm "${my_tempdir}/template/${filename}"

            exit "${RET_SUCCESS}"
        fi
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; rerun_update_X() {
    call log_info_important "Need to re-run bfi-update.sh"
    call log_info_important "re-running command as '%s %s'" "$(get_my_real_dir_fullpath)/bfi-update.sh" "$* --no-report"

    # call ourselves again
    call invoke "$(get_my_real_dir_fullpath)/bfi-update.sh" "$@" --no-report
    ret=$?
    exit $ret
}

#-------------------------------------------------------------------------------
def; compare_and_update_files() {
    (
        call log_header "Comparing template files to current project's files..."

        call check_tools__require_comparible_X

        needs_rerun=false

        # special handling for bfi-update.sh b/c we might need to rerun
        call check_and_update_file "bfi-update.sh" "false"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            needs_rerun=true
        fi

        # special handling for bfi-base.sh b/c we might need to rerun
        call check_and_update_file "bfi-base.sh" "false"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            needs_rerun=true
        fi

        # special handling for bfi-update.sh b/c we might need to rerun
        call check_and_update_file "batteries-forking-included.sh" "false"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            needs_rerun=true
        fi

        # check if any of the above files require a rerun
        if [ "${needs_rerun}" = true ]; then
            call rerun_update_X "$@"
        fi

        # special handling for post-boostrap.sh b/c users edit that file

        # split first part of template post-bootstrap.sh (BFI FIRST PART)
        awk '{print; if (match($0,"    \# WARNING: DO NOT EDIT ABOVE THIS LINE")) exit}' "${my_tempdir}"/template/post-bootstrap.sh >"${my_tempdir}"/template/post-bootstrap.sh-part1
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh-part1
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # split middle part of project post-bootstrap.sh (USER PART)
        middle_file="${project_dir}"/post-bootstrap.sh
        if [ ! -f "${project_dir}"/post-bootstrap.sh ]; then
            middle_file="${my_tempdir}"/template/post-bootstrap.sh
        fi
        awk -v do_print=0 '{if (match($0,"    \# WARNING: DO NOT EDIT BELOW THIS LINE")) do_print=0; if (do_print==1) print; if (match($0,"    # WARNING: DO NOT EDIT ABOVE THIS LINE")) do_print=1}' "${middle_file}" >"${my_tempdir}"/template/post-bootstrap.sh-part2
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not create %s" "${my_tempdir}"template/post-bootstrap.sh-part2
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # split last part of template post-bootstrap.sh (BFI LAST PART)
        awk -v found=0 '{if (match($0,"    \# WARNING: DO NOT EDIT BELOW THIS LINE")) found=1; if (found==1) print}' "${my_tempdir}"/template/post-bootstrap.sh >"${my_tempdir}"/template/post-bootstrap.sh-part3
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh-part3
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # delete original template post-boostrap.sh
        call safe_rm "${my_tempdir}"/template/post-bootstrap.sh
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # recombine three parts into new template post-boostrap.sh
        cat "${my_tempdir}"/template/post-bootstrap.sh-part1 \
            "${my_tempdir}"/template/post-bootstrap.sh-part2 \
            "${my_tempdir}"/template/post-bootstrap.sh-part3 \
            >"${my_tempdir}"/template/post-bootstrap.sh
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        chmod +x "${my_tempdir}"/template/post-bootstrap.sh
        if [ $ret -ne 0 ]; then
            call log_fatal "Could not chmod +x %s" "${my_tempdir}/template/post-bootstrap.sh"
            exit "${RET_ERROR_COULD_NOT_CHMOD}"
        fi

        # delete the three parts
        call safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part1
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi
        call safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part2
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi
        call safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part3
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call check_and_update_file "post-bootstrap.sh" "true"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # switch to the template dir so we can loop over all the remaining files
        call ensure_cd "${my_tempdir}/template"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # process remaining files
        for filename in *; do
            call check_and_update_file "${filename}" "false"
            ret=$?
            if [ "$(call return_code_is_error $ret)" = true ]; then
                exit $ret
            fi
        done

        call log_footer "Comparison of template files to current project's files completed."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
def; batteries_forking_included__bootstrap() {
    call log_ultradebug "batteries_forking_included__bootstrap called with '%s'" "$*"

    call ensure_my_tempdir_G
    ret=$?
    if [ "$(call return_code_is_error $ret)" = true ]; then
        exit $ret
    fi

    call parse_args__bootstrap "$@"
    ret=$?
    if [ "$(call return_code_is_error $ret)" = true ]; then
        return $ret
    fi

    # # bail early before actually doing anything
    # return 0

    (
        call require_not_root_user_XY

        call check_tools__begin
        call check_tools__detect_G
        call check_tools__end

        call ensure_cd "${project_dir}"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call ensure_conda
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_init_G
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_full_deactivate_G
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_update_base
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # poetry show | awk '{if ($1 !~ /six|packaging|pyparsing/ ) {print "pypi::" $1}}' >"$CONDA_PREFIX"/conda-meta/pinned

        call conda_setup_env
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_activate_env_G "${project_base_name}"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_env_read_sticky_config
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_env_write_sticky_config
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_full_deactivate_G
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call conda_activate_env_G "${project_base_name}"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call poetry_install
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call pip_uninstall
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call pip_install
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call run_post_bootstrap_script
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    call report_all $exit_ret "${print_report}" "$(get_my_real_basename)"
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
def; batteries_forking_included__update() {
    call log_ultradebug "batteries_forking_included__update called with '%s'" "$*"

    call ensure_my_tempdir_G
    ret=$?
    if [ "$(call return_code_is_error $ret)" = true ]; then
        exit $ret
    fi

    call parse_args__update "$@"
    ret=$?
    if [ "$(call return_code_is_error $ret)" = true ]; then
        return $ret
    fi

    # # bail early before actually doing anything
    # return 0

    (
        call require_not_root_user_XY

        call check_tools__begin
        call check_tools__detect_G
        call check_tools__end

        call ensure_batteries_forking_included
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call update_batteries_forking_included_repo
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call copy_temporary_template_files
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        call compare_and_update_files "$@"
        ret=$?
        if [ "$(call return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    call report_all $exit_ret "${print_report}" "$(get_my_real_basename)"
    ret=$?
    return $ret
}

#endregion Public Functions
#===============================================================================

#endregion Public
################################################################################

(
    ############################################################################
    #region Private *

    #===========================================================================
    #region Private Constants

    SET_OMEGA_DEBUG=false

    #endregion Constants
    #===========================================================================

    #===========================================================================
    #region Private Globals

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        call log_ultradebug "%s: OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        call log_ultradebug "%s: SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    fi

    #endregion "Globals"
    #===========================================================================

    #===========================================================================
    #region Private Functions

    #---------------------------------------------------------------------------
    def; __main() {
        call log_fatal "$(get_my_real_basename) must be sourced"
        return "${RET_ERROR_SCRIPT_WAS_NOT_SOURCED}"
    }

    #---------------------------------------------------------------------------
    __sourced_main () {
        return "${RET_SUCCESS}"
    }

    #endregion Private Functions
    #===========================================================================

    #endregion Private *
    ############################################################################

    ############################################################################
    #region Immediate

    if [ "${_IS_UNDER_TEST}" = "true" ]; then
        type inject_monkeypatch >/dev/null 2>&1
        monkeypatch_ret=$?
        if [ $monkeypatch_ret -eq 0 ]; then
            call inject_monkeypatch
        fi
    fi

    if {
        [ "$(call array_get_last WAS_SOURCED)" = false ] ||
        {
            [ "${_CALL_MAIN_ANYWAY}" = true ] &&
            # only if we are directly sourced from the shell,
            # or we were directly sourced by a PytestShellScriptTestHarness script
            [ "$(call array_get_length WAS_SOURCED)" -le 2 ]
        }
    } then
        call __main "$@"
        ret=$?
    else
        call __sourced_main "$@"
        ret=$?
    fi
    exit $ret

    #endregion Immediate
    ############################################################################
)
ret=$?

################################################################################
#region marximus-shell-extensions Postamble

#===============================================================================
#region PytestShellScriptTestHarness Postamble

if [ "${_IS_UNDER_TEST}" = "true" ]; then
    type inject_monkeypatch >/dev/null 2>&1
    monkeypatch_ret=$?
    if [ $monkeypatch_ret -eq 0 ]; then
        call inject_monkeypatch
    fi
fi

#endregion PytestShellScriptTestHarness Postamble
#===============================================================================

#===============================================================================
#region Announce Ourself Ending

__announce_prefix="Source"
if [ "$(nullcall array_peek WAS_SOURCED)" = false ]; then
    __announce_prefix="Invoke"
fi
nullcall log_debug "${__announce_prefix} Completed: $(nullcall get_my_real_fullpath) ($$) [$(nullcall get_my_puuid_basename || echo "$0")]"
unset __announce_prefix

#endregion Announce Ourselves Ending
#===============================================================================

#===============================================================================
#region Exit Or Return

# NOTE: we have to return here if we were sourced otherwise we kill the shell
_THIS_FILE_WAS_SOURCED="$(call array_peek WAS_SOURCED)"
# If we were the top level include we need to remove ourselves and clean up,
# otherwise, the invoker/includer will do so via the include_G/invoke functions
if {
    [ "$(call array_get_length WAS_SOURCED)" -eq 1 ] &&
    [ "${_THIS_FILE_WAS_SOURCED}" = true ]
}; then
    call array_destroy WAS_SOURCED
    call array_destroy SHELL_SOURCE
    call array_destroy SHELL_SOURCE_PUUID
    if [ "$ZSH_VERSION" != "" ]; then
        # shellcheck disable=3041
        set +yx "${__MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD}"
    else
        set +x ${__MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD}
    fi
    unset __MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD
fi
if [ "${_THIS_FILE_WAS_SOURCED}" = false ]; then
    exit $ret
else
    return $ret
fi

#endregion Exit Or Return
#===============================================================================

#endregion marximus-shell-extensions Postamble
################################################################################
