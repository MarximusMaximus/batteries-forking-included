#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"
export DOLLAR_UNDER

TEMP_SHELL_SOURCE="./run.sh"

if [ "${DO_SET_X_RUN}" = true ]; then
    set -x
fi

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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__def_G__OPTIONS_OLD}"
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
    #     set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
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
    #     set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
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
        set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
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
        set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__date__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__date__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_console() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "$@"
            command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success_final() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "SUCCESS: "
            command printf -- "$@"
            command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            command printf -- "SUCCESS: "
            command printf -- "$@"
            command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_fatal() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "FATAL: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_error() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "ERROR: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_warning() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            >&2 command printf -- "WARNING: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_header__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_footer__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_no_prefix__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_debug__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_superdebug__OPTIONS_OLD}"
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

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_ultradebug__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_ultradebug__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_file() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_file__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

            true

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_file__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__rreadlink__OPTIONS_OLD}"
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
    # HACK: for some reason we're losing the command line args, so let's store them
    COMMANDLINE_ARGS=$(printf '%s\n' "$@")
    export COMMANDLINE_ARGS
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__print_call_stack__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__push_puuid_for_abspath__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_length() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        eval "command echo \"\${__array__${1}__length}\""

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD}"
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
                set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}"
                unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
                eval "${__array__array_for_each__func_name}"
                __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD="${-:+"-$-"}"
                set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
            done
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_push() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_append "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_push__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_pop() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_last "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_peek() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_last "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_insert_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_append "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_insert_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_insert_index "$1" 0 "$2"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_at_index "$1" 0

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_get_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_get_at_index "$1" -1

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_remove_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_index "$1" 0

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; array_remove_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall array_remove_index "$1" -1

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_destroy__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_export__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD}"
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
            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}"
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
            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
            set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    def; dict_for_each_pair() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD="${-:+"-$-"}"
        set +x; if [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ]; then set -x; else set +x; fi

        nullcall dict_for_each_value "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_fullpath__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_basename__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_fullpath__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_basename__OPTIONS_OLD}"
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

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_puuid_basename__OPTIONS_OLD}"
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

set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__OPTIONS_OLD}"
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

################################################################################
#region Includes

call ensure_include_GXY "$(get_my_real_dir_fullpath)/bfi-base.sh"

#endregion Includes
################################################################################

################################################################################
#region Public *


#endregion Public *
################################################################################

(
    ############################################################################
    #region Private *

    #===========================================================================
    #region Private Constants

    # TODO: support OMEGA_DEBUG

    RUN_EXEC="python"
    RUN_ARGS="$(call get_my_real_dir_fullpath)"/bin/"$(call get_my_real_dir_basename)".py

    #endregion Private Constants
    #===========================================================================

    #===========================================================================
    #region Private Functions

    def; __bfi_run() {
        (
            call conda_init_G "quiet"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            call conda_full_deactivate_G "quiet"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            call conda_activate_env_G "$(call get_my_real_dir_basename)" "quiet"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            if [ "${BFI_ORIGINAL_EXEC_NAME}" = "" ]; then
                BFI_ORIGINAL_EXEC_NAME="$0"
            fi
            export BFI_ORIGINAL_EXEC_NAME

            TEMP_RUN_EXEC="$1"
            if [ "${TEMP_RUN_EXEC}" != "" ]; then
                if [ ! -f "$1" ]; then
                    if [ "$(type -- "${TEMP_RUN_EXEC}" 2>&1 | grep "\(is a shell builtin\|not found\|is a function\)" )" = "" ]; then
                        # arg 1 is neither a shell builtin nor just a file
                        # (when it is just a file, 'type' prints "not found")
                        TEMP_RUN_EXEC="$(which "$1")"
                    fi
                fi
                if [ "${TEMP_RUN_EXEC}" = "" ]; then
                    TEMP_RUN_EXEC="$1"
                fi

                if [ -f "${TEMP_RUN_EXEC}" ]; then
                    # deal with symlinks
                    # (handles files without an extension pointing to a file that does,
                    # e.g. bfi -> batteries-forking-included.py)
                    TEMP_RUN_EXEC="$(call rreadlink "${TEMP_RUN_EXEC}")"
                    # arg 1 is might be an executable, see if we should run that instead
                    if [ "$(file "${TEMP_RUN_EXEC}" | grep 'script' )" != "" ]; then
                        # arg 1 is a script
                        RUN_ARGS="$1"   # use original $1 so that we get the name the user passed in
                        if [ ! -e "${RUN_ARGS}" ]; then
                            TEMP_RUN_ARGS="$(which "${RUN_ARGS}")"
                            ret=$?
                            if [ $ret -eq 0 ]; then
                                RUN_ARGS="${TEMP_RUN_ARGS}"
                            fi
                        fi
                        shebang=$(head -n 1 "${TEMP_RUN_EXEC}")
                        if [ "$(echo "${TEMP_RUN_EXEC}" | grep ".py" )" != "" ]; then
                            # NOTE: we are doing this so that .py scripts that use an
                            #   alternative !# such as #!bash to run a shell script preamble
                            #   work properly
                            # python script, or symlink without an extension to a
                            # python script with a .py ext
                            RUN_EXEC=python
                            TEMP_RUN_EXEC=
                            if [ "$(echo "${shebang}" | grep "#!")" = "" ]; then
                                # no shebang, wtf?!
                                true    # no op
                            elif [ "$(echo "${shebang}" | awk '{print $1}')" = "#!/usr/bin/env" ]; then
                                # shebang is asking /usr/bin/env to find the executable
                                # awk removes the '#!/usr/bin/env' part
                                TEMP_RUN_EXEC="$(echo "${shebang}" | awk '{$1=""; print $0}' )"
                            else
                                # shebang is the executable, remove '#!' from string
                                # cut removes '#!'
                                TEMP_RUN_EXEC="$(echo "${shebang}" | cut -c 3- )"
                            fi
                            # cleanup TEMP_RUN_EXEC
                            # sed (1st) removes leading spaces
                            # sed (2nd) removes trailing spaces
                            TEMP_RUN_EXEC="$(echo "${TEMP_RUN_EXEC}" | sed -r 's/^ *//' | sed -r 's/ *$//' )"
                            if [ "${TEMP_RUN_EXEC}" != "" ]; then
                                "${TEMP_RUN_EXEC}" -c \
                                    "import sys; print(f\"{[ getattr(sys, x) for x in dir(sys) if x == 'version' ][-1]}\")" \
                                    >/dev/null 2>/dev/null
                                ret=$?
                                if [ $ret -eq 0 ]; then
                                    # TEMP_RUN_EXEC is some kind of python binary
                                    RUN_EXEC="${TEMP_RUN_EXEC}"
                                fi
                            fi
                        else
                            # .sh or other
                            # TODO: What about python scripts that do not end in .py? AND use a non-python shebang?
                            if [ "$(echo "${shebang}" | grep "#!")" = "" ]; then
                                # no shebang, wtf?!
                                call log_error "First arg is an executable script, but does not have a shebang.\n"
                                exit "${RET_ERROR_COULD_NOT_EXECUTE}"
                            elif [ "$(echo "${shebang}" | awk '{print $1}')" = "#!/usr/bin/env" ]; then
                                # shebang is asking /usr/bin/env to find the executable
                                # awk removes the '#!/usr/bin/env' part
                                RUN_EXEC="$(echo "${shebang}" | awk '{$1=""; print $0}' )"
                            else
                                # shebang is the executable, remove '#!' from string
                                # cut removes '#!'
                                RUN_EXEC="$(echo "${shebang}" | cut -c 3- )"
                            fi
                        fi
                    elif [ -x "${TEMP_RUN_EXEC}" ]; then
                        # arg 1 is directly an exec
                        RUN_EXEC="${TEMP_RUN_EXEC}"
                        RUN_ARGS=""
                    fi
                    shift
                elif [ "$(type -- "${TEMP_RUN_EXEC}" 2>&1 | grep "\(is a shell builtin\|is a function\)" )" != "" ]; then
                    # arg 1 is directly an shell builtin or shell function
                    RUN_EXEC="${TEMP_RUN_EXEC}"
                    RUN_ARGS=""
                    shift
                else
                    # arg 1 is likely an argument to the script,
                    # leave RUN_EXEC and RUN_ARGS as is
                    true
                fi
            fi

            # remove the "stop processing args" delimiter
            # (allows first real arg to what we're running to be an executable file)
            if [ "$1" = "--" ]; then
                shift
            fi

            # cleanup RUN_EXEC
            # sed (1st) removes leading spaces
            # sed (2nd) removes trailing spaces
            # if your executable actually has leading or trailing spaces in its name...
            #          ...STOP THAT MALARKY!
            RUN_EXEC="$(echo "${RUN_EXEC}" | sed -r 's/^ *//' | sed -r 's/ *$//' )"

            printf "Conda environment is %s\n" "${CONDA_DEFAULT_ENV}"

            printf "%s is " "${RUN_EXEC}"
            which "${RUN_EXEC}"
            if {
                [ "${RUN_EXEC}" != "echo" ] &&
                [ "${RUN_EXEC}" != "printf" ] &&
                [ "$(echo "${RUN_EXEC}" | grep "/echo$")" != "" ] &&
                [ "$(echo "${RUN_EXEC}" | grep "/printf$")" != "" ]
            }; then
                "${RUN_EXEC}" -c \
                    "import sys; print(f\"{[ getattr(sys, x) for x in dir(sys) if x == 'version' ][-1]}\")" \
                    >/dev/null 2>/dev/null
                ret=$?
                if [ $ret -eq 0 ]; then
                    # RUN_EXEC is some sort of python binary
                    "${RUN_EXEC}" --version
                fi
            fi

            if [ "${RUN_ARGS}" = "" ]; then
                # used when directly executing a binary executable,
                # shell builtin, or function
                echo Executing: /usr/bin/env "${RUN_EXEC}" "$*"
                /usr/bin/env "${RUN_EXEC}" "$@"
                ret=$?
            else
                # used when executing a script via a binary executable
                echo Executing: /usr/bin/env "${RUN_EXEC}" "${RUN_ARGS}" "$*"
                /usr/bin/env "${RUN_EXEC}" "${RUN_ARGS}" "$@"
                ret=$?
            fi

            exit $ret
        )
        ret=$?
        return $ret
    }

    #---------------------------------------------------------------------------
    def; __main () {
        # command echo "OMEGA_DEBUG=${OMEGA_DEBUG}"
        call log_ultradebug "$(get_my_real_basename) called with '%s'" "$*"

        call __bfi_run "$@"
        ret=$?
        return $ret
    }

    #---------------------------------------------------------------------------
    def; __sourced_main () {
        call log_fatal "$(get_my_real_basename) should not be sourced"
        return "${RET_ERROR_SCRIPT_WAS_SOURCED}"
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

    # HACK: for some reason we're losing the command line args, so let's re-instate them
    OLDIFS="$IFS"
    IFS=$(printf "\n\t")
    # shellcheck disable=SC2086
    set -- $COMMANDLINE_ARGS
    IFS="$OLDIFS"

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
        set +x "${__MARXIMUS_SHELL_EXTENSIONS__GLOBAL__OPTIONS_OLD}"
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
