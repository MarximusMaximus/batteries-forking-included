#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"

# WARNING: Don't forget to update the version number in pyproject.toml
BFI_VERSION="0.1.2.dev0"
export BFI_VERSION

# TODO: flag for not tracing marximus-shell-extensions extended preamble functions
# TODO: flag for not tracing bfi-base functions

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
set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
    if [ "$LINENO_GLOBAL_OFFSET" -le 1 ]; then
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

    #-------------------------------------------------------------------------------
    # nulldef; keyword
    # 'true' is a command that returns 0 and is effectively a no-op command
    # so when 'nulldef;' used to declare a function:
    #   nulldef; foo() {}
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
    # nullcall keyword
    # emulates how 'call' works, but does not modify shell options nor track
    # the call stack
    nulldef; nullcall() {
        "$@"
        _nullcall_ret=$?
        return $_nullcall_ret
    }

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
        __def_G_puuid="$(nullcall array_peek SHELL_CALL_STACK_SOURCE_PUUID)"
        # get the real filepath of the puuid
        __def_G_filepath="$(nullcall dict_get_key SHELL_SOURCE_PUUID_DICT "${__def_G_puuid}")"
        # get the context's func name from the call stack
        __def_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"
        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            # get the current parent's lineno
            __def_G_parent_lineno_offset=$(nullcall dict_get_key SHELL_DEF_LINENO "${__def_G_parent_funcname}")
            # recalculate lineno to account for parent's lineno and the global offset
            __def_G_lineno=$(( __def_G_lineno + __def_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
        fi
        # get the func's real name
        # echo __def_G_funcname="\$(head -n \"$__def_G_lineno\" \"$__def_G_filepath\" | tail -n 1 | awk '{ print $2 }' | tr -d '()')"
        __def_G_funcname="$(head -n "$__def_G_lineno" "$__def_G_filepath" | tail -n 1 | awk '{ print $2 }' | tr -d '()')"

        nullcall dict_set_key SHELL_DEF_SOURCE_PUUID "$__def_G_funcname" "$__def_G_puuid"
        nullcall dict_export SHELL_DEF_SOURCE_PUUID
        nullcall dict_set_key SHELL_DEF_LINENO "$__def_G_funcname" "$__def_G_lineno"
        nullcall dict_export SHELL_DEF_LINENO

        if [ "${OPTION_SETTRACE}" = true ]; then
            echo "= ${__def_G_puuid}:${__def_G_lineno}:${__def_G_funcname}"
        fi

        unset __def_G_funcname
        unset __def_G_parent_lineno_offset
        unset __def_G_parent_funcname
        unset __def_G_filepath
        unset __def_G_puuid
        unset __def_G_lineno
        unset __def_G_puuid_temp

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__def_G__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS__def_G__OPTIONS_OLD
    }
    # normally aliases cannot use positional parameters BUT
    # this works in bash, dash, zsh b/c we're just using $0
    # shellcheck disable=SC2142
    # alias def="sh -c \"echo = \$(get_my_puuid_basename):\$LINENO:\\\$(head -n \$LINENO \\\"\$(get_my_real_fullpath)\\\" | tail -n 1 | awk '{ print \\\$2 }' | tr -d '()')\""
    alias def="def_G \"\$LINENO\""

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
    # pushes function call context onto call stack
    nulldef; _call_stack_push_G() {
        # __call_G_source_puuid="$1"
        # __call_G_lineno="$2"
        # __call_G_dest_puuid="$3"
        # __call_G_dest_lineno="$4"
        # __call_G_funcname="$5"

        nullcall array_push SHELL_CALL_STACK "$1:$2:$3:$4:$5"
        nullcall array_export SHELL_CALL_STACK

        nullcall array_push SHELL_CALL_STACK_SOURCE_PUUID "$1"
        nullcall array_export SHELL_CALL_STACK_SOURCE_PUUID

        nullcall array_push SHELL_CALL_STACK_SOURCE_LINENO "$2"
        nullcall array_export SHELL_CALL_STACK_SOURCE_LINENO

        nullcall array_push SHELL_CALL_STACK_DEST_PUUID "$3"
        nullcall array_export SHELL_CALL_STACK_DEST_PUUID

        nullcall array_push SHELL_CALL_STACK_DEST_LINENO "$4"
        nullcall array_export SHELL_CALL_STACK_DEST_LINENO

        nullcall array_push SHELL_CALL_STACK_FUNCNAME "$5"
        nullcall array_export SHELL_CALL_STACK_FUNCNAME
    }

    #-------------------------------------------------------------------------------
    # pops function call context off of call stack
    nulldef; _call_stack_pop_G() {
        nullcall array_pop SHELL_CALL_STACK
        nullcall array_export SHELL_CALL_STACK

        nullcall array_pop SHELL_CALL_STACK_SOURCE_PUUID
        nullcall array_export SHELL_CALL_STACK_SOURCE_PUUID

        nullcall array_pop SHELL_CALL_STACK_SOURCE_LINENO
        nullcall array_export SHELL_CALL_STACK_SOURCE_LINENO

        nullcall array_pop SHELL_CALL_STACK_DEST_PUUID
        nullcall array_export SHELL_CALL_STACK_DEST_PUUID

        nullcall array_pop SHELL_CALL_STACK_DEST_LINENO
        nullcall array_export SHELL_CALL_STACK_DEST_LINENO

        nullcall array_pop SHELL_CALL_STACK_FUNCNAME
        nullcall array_export SHELL_CALL_STACK_FUNCNAME
    }

    #-------------------------------------------------------------------------------
    # "call" keyword
    # calls specified function with args, tracking it via call stack
    nulldef; call_G() {
        # NOTE: intentionally not using call inside this function
        __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
        set +x

        __call_G_lineno="$1"
        __call_G_funcname="$2"
        shift 1

        __call_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"

        __call_G_source_puuid=""
        if [ "${__call_G_parent_funcname}" = "_" ]; then
            __call_G_source_puuid="$(nullcall array_peek SHELL_CALL_STACK_SOURCE_PUUID)"
        else
            __call_G_source_puuid="$(nullcall dict_get_key SHELL_DEF_SOURCE_PUUID "${__call_G_parent_funcname}")"
        fi

        __call_G_dest_puuid="$(nullcall dict_get_key SHELL_DEF_SOURCE_PUUID "${__call_G_funcname}")"
        __call_G_dest_lineno="$(nullcall dict_get_key SHELL_DEF_LINENO "${__call_G_funcname}")"

        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            # get the current parent's lineno
            __call_G_parent_lineno_offset=$(nullcall dict_get_key SHELL_DEF_LINENO "${__call_G_parent_funcname}")
            # recalculate lineno to account for parent's lineno and the global offset
            __call_G_lineno=$(( __call_G_lineno + __call_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
        fi

        if [ "${OPTION_SETTRACE}" = true ]; then
            # print number of dashes equal to call stack depth
            for _i in $(seq 1 "$(nullcall array_get_length SHELL_CALL_STACK)"); do
                >&2 command printf -- "-"
            done

            >&2 printf -- " %s:%s:%s:%s %s\n" \
                "${__call_G_source_puuid}" \
                "${__call_G_lineno}" \
                "${__call_G_dest_puuid}" \
                "${__call_G_dest_lineno}" \
                "$*"
        fi

        nullcall _call_stack_push_G \
            "${__call_G_source_puuid}" \
            "${__call_G_lineno}" \
            "${__call_G_dest_puuid}" \
            "${__call_G_dest_lineno}" \
            "${__call_G_funcname}"

        unset __call_G_parent_lineno_offset
        unset __call_G_parent_funcname
        unset __call_G_funcname
        unset __call_G_lineno
        unset __call_G_source_puuid

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD

        "$@"
        __call_ret=$?

        __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD="${-:+"-$-"}"
        set +x

        nullcall _call_stack_pop_G

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD

        return $__call_ret
    }
    # normally aliases cannot use positional parameters BUT
    # this works in bash, dash, zsh b/c we're just using $0
    # shellcheck disable=SC2142
    alias call="call_G \"\$LINENO\""

    #-------------------------------------------------------------------------------
    nulldef; print_call_stack() {
        __MARXIMUS_SHELL_EXTENSIONS__print_call_stack__OPTIONS_OLD="${-:+"-$-"}"
        set +x

        nulldef; _print_call_stack() {
            >&2 command printf -- "%s\n" "${item}"
        }
        nullcall array_for_each SHELL_CALL_STACK _print_call_stack

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__print_call_stack__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS__print_call_stack__OPTIONS_OLD
    }

    #endregion Call Stack Tracking Part 3
    #===============================================================================
fi

# NOTE: Separation b/c cannot define and then use aliases in same block

# fence to prevent redefinition
type MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then
    #===============================================================================
    #region Create Fence

    nulldef; MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE_FENCE() { true; }

    #endregion Create Fence
    #===============================================================================

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            command printf -- "$@"
            command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_console__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success_final() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            nullcall log_success "$@"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success_final__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_success() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            command printf -- "SUCCESS: "
            command printf -- "$@"
            command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_success__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_fatal() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            >&2 command printf -- "FATAL: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_fatal__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_error() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            >&2 command printf -- "ERROR: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_error__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_warning() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            >&2 command printf -- "WARNING: "
            >&2 command printf -- "$@"
            >&2 command printf -- "\n"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_warning__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_header() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_header__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

            nullcall log_info "$@"

            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info_important__OPTIONS_OLD
        }

        #-------------------------------------------------------------------------------
        nulldef; log_info() {
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__log_info__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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

    #===============================================================================
    #region puuid - Pseudo UUID

    #-------------------------------------------------------------------------------
    nulldef; puuid() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}'

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__puuid__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; push_puuid_for_abspath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__push_puuid_for_abspath__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        if [ "${SHELL_SOURCE_PUUID}" = "" ]; then
            SHELL_SOURCE_PUUID=""
            nullcall array_init SHELL_SOURCE_PUUID
        fi
        if [ "${SHELL_SOURCE_PUUID_DICT}" = "" ]; then
            SHELL_SOURCE_PUUID_DICT=""
            nullcall dict_init SHELL_SOURCE_PUUID_DICT
        fi

        __puuid="$(puuid)"
        __puuid__basename="${__puuid}_$(basename "$1")"
        if [ "${OPTION_SETTRACE}" = true ]; then
            command printf "# %s:'%s'\n" "${__puuid__basename}" "$1"
        fi
        nullcall array_append SHELL_SOURCE_PUUID "${__puuid__basename}"
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

    # # manually iterating an array:
    # OIFS="$IFS"
    # IFS="${_ARRAY__SEP}"
    # NOTE: there IS a $ sign on my_array_name below
    # for item in $my_array_name; do
    #     echo $item
    # done
    # IFS="$OIFS"

    # # append to array:
    # NOTE: no $ sign on my_array_name
    # array_append my_array_name "my value"

    # # get item by index:
    # NOTE: no $ sign on my_array_name
    # array_get_at_index my_array_name $index

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

    # # find index of item
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

    _ARRAY__SEP="$(command printf "\t")"; export _ARRAY__SEP
    #                                      x12345678x
    _ARRAY__SEP__ESCAPED="$(command printf "\\\\\\\\t")"; export _ARRAY__SEP__ESCAPED

    #-------------------------------------------------------------------------------
    nulldef; __array_escape() {
        #                                        x1234x                                  x12x1234567890123456x
        command echo "$1" | sed -e "s/${_ARRAY__SEP}/\\\\${_ARRAY__SEP__ESCAPED}/g" -e 's/\\/\\\\\\\\\\\\\\\\/g'
    }

    #-------------------------------------------------------------------------------
    nulldef; __array_unescape() {
        # NOTE: This doesn't look like the inverse of what __array_escape does, but
        #   it works correctly, so don't try to "fix" it
        #                                           x1234x12x           x12345678x
        command printf "$(command echo "$1" | sed -e 's/\\\\/\\/g' -e "s/\\\\\\\\${_ARRAY__SEP__ESCAPED}/${_ARRAY__SEP}/g")"
    }

    #-------------------------------------------------------------------------------
    nulldef; __array_fix_index() {
        __array__array_fix_index__length="$(nullcall array_get_length "$1")"

        __array__array_fix_index__index="$2"

        if [ "${__array__array_fix_index__index}" -lt 0 ]; then
            __array__array_fix_index__index="$(( __array__array_fix_index__length + __array__array_fix_index__index ))"
        fi

        command printf "%d" "${__array__array_fix_index__index}"
    }

    #-------------------------------------------------------------------------------
    nulldef; array_init() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        eval "$1=\"\""

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_init__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_destroy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        eval "unset $1"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_destroy__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_export() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        eval "export $1"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_export__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_append() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__array_append__temp_value=$(nullcall __array_escape "$2")
        __array__array_append__temp_storage="$(eval command echo \"\$\{"$1"\}\")"
        if [ "${__array__array_append__temp_storage}" = "" ]; then
            eval "$1=\"${__array__array_append__temp_value}\""
        else
            # WARNING: DO NOT ESCAPE THE { } AROUND $1 HERE
            eval "$1=\"\${$1}$_ARRAY__SEP${__array__array_append__temp_value}\""
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_push() {
        nullcall array_append "$@"
    }

    #-------------------------------------------------------------------------------
    nulldef; array_append_back() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_back__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_append "$1" "$2"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_back__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_back__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_append_front() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_front__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_insert_index "$1" 0 "$2"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_front__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_append_front__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_get_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_get_at_index "$1" 0

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_get_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_get_at_index "$1" -1

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_peek() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_get_last "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_peek__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_copy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__array_copy__temp_storage="$(eval command echo \"\$\{"$1"\}\")"

        nullcall array_init "$2"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        for item in ${__array__array_copy__temp_storage}; do
            item="$(nullcall __array_unescape "${item}")"
            nullcall array_append "$2" "${item}"
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_copy__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_remove_first() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_remove_index "$1" 0

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_first__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_remove_last() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_remove_index "$1" -1

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_last__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_pop() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall array_remove_last "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_pop__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_insert_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__array_insert_index__temp_array=""
        nullcall array_copy "$1" __array__array_insert_index__temp_array

        __array__array_insert_index__last_index="$(nullcall array_get_length "$1")"

        __array__array_insert_index__count=0

        __array__array_insert_index__index="$2"
        __array__array_insert_index__index="$(nullcall __array_fix_index "$1" "${__array__array_insert_index__index}")"

        __array__array_insert_index__inserted=false

        nullcall array_init "$1"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        for item in ${__array__array_insert_index__temp_array}; do
            item="$(nullcall __array_unescape "${item}")"
            if [ "${__array__array_insert_index__count}" -eq "${__array__array_insert_index__index}"  ]; then
                nullcall array_append "$1" "$3"
                __array__array_insert_index__inserted=true
            fi
            nullcall array_append "$1" "${item}"
            __array__array_insert_index__count=$(( __array__array_insert_index__count + 1 ))
        done

        if \
            [ "${__array__array_insert_index__last_index}" -eq "${__array__array_insert_index__count}" ] &&
            [ "${__array__array_insert_index__inserted}" = false  ]
        then
            nullcall array_append "$1" "$3"
        fi

        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_insert_index__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_remove_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__array_remove_index__temp_array=""
        nullcall array_copy "$1" __array__array_remove_index__temp_array

        __array__array_remove_index__index="$2"
        __array__array_remove_index__index="$(nullcall __array_fix_index "$1" "${__array__array_remove_index__index}")"

        __array__array_remove_index__count=0

        nullcall array_init "$1"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        for item in ${__array__array_remove_index__temp_array}; do
            item="$(nullcall __array_unescape "${item}")"
            if [ "${__array__array_remove_index__count}" -ne "${__array__array_remove_index__index}" ]; then
                nullcall array_append "$1" "${item}"
            fi
            __array__array_remove_index__count=$(( __array__array_remove_index__count + 1 ))
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_remove_index__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_get_length() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __array__array_get_length__temp_storage="$(eval command echo \"\$\{"$1"\}\")"
        __array__array_get_length__count=0
        for item in $__array__array_get_length__temp_storage; do
            __array__array_get_length__count=$(( __array__array_get_length__count + 1 ))
        done
        IFS="$OIFS"
        command echo "${__array__array_get_length__count}"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_length__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; array_get_at_index() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"

        __array__array_get_index__index="$2"
        __array__array_get_index__index="$(nullcall __array_fix_index "$1" "${__array__array_get_index__index}")"

        __array__array_get_index__temp_storage="$(eval command echo \"\$\{"$1"\}\")"
        __array__array_get_index__count=0
        __array__array_get_index__found=false

        for item in $__array__array_get_index__temp_storage; do
            if [ "${__array__array_get_index__count}" -eq "${__array__array_get_index__index}" ]; then
                item="$(nullcall __array_unescape "$item")"
                command printf "%s" "${item}"
                __array__array_get_index__found=true
                break
            fi
            __array__array_get_index__count=$(( __array__array_get_index__count + 1 ))
        done
        IFS="$OIFS"

        __array_get_at_index_ret=1
        if [ "${__array__array_get_index__found}" = true ]; then
            __array_get_at_index_ret=0
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_get_at_index__OPTIONS_OLD

        return $__array_get_at_index_ret
    }

    #-------------------------------------------------------------------------------
    nulldef; array_find_index_of() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__array_find_index_of__return=-1
        __array__array_find_index_of__index=0

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __array__array_find_index_of__temp_storage="$(eval command echo \"\$\{"$1"\}\")"
        for item in $__array__array_find_index_of__temp_storage; do
            item="$(nullcall __array_unescape "$item")"
            if [ "$item" = "$2" ]; then
                __array__array_find_index_of__return=$__array__array_find_index_of__index
                break
            fi
            __array__array_find_index_of__index=$(( __array__array_find_index_of__index + 1 ))
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_find_index_of__OPTIONS_OLD

        return $__array__array_find_index_of__return
    }

    #-------------------------------------------------------------------------------
    nulldef; array_contains() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __array__contains__return=1  # false value

        if [ "$(array_find_index_of "$1" "$2")" -ne -1 ]; then
            __array__contains__return=0  # true value
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_contains__OPTIONS_OLD

        return $__array__contains__return
    }

    # # using array_for_each:
    # def; my_func() {
    #     echo "${item}"
    # }
    # array_for_each the_array_name my_func
    ## NOTE: no $ on 'the_array_name' nor 'my_func'

    #-------------------------------------------------------------------------------
    nulldef; array_for_each() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __ARRAY__ARRAY_FOR_EACH__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
        for item in $__ARRAY__ARRAY_FOR_EACH__TEMP_STORAGE; do
            item="$(nullcall __array_unescape "$item")"
            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__array_for_each__OPTIONS_OLD
    }

    #endregion Array Implementation
    #===============================================================================

    #===============================================================================
    #region Dict Implementation

    #-------------------------------------------------------------------------------
    nulldef; __dict_hash_key() {
        (printf "%s" "$1" | sha1sum 2>/dev/null; test $? = 127 && printf "%s" "$1" | shasum -a 1) | cut -d' ' -f1
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_init() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        eval "$1=\"__dict__\""
        eval "__dict__$1=\"__dict__\""
        eval "__dict__$1__length=0"
        nullcall array_init "__dict__$1__keys"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_init__OPTIONS_OLD

        return 0
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_destroy() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_destroy__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
    nulldef; dict_export() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_export__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
    nulldef; dict_set_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __dict_set_key_ret=0

        if eval "[ ! -n \"\$__dict__$1\" ]"; then
            # dict not initialized
            __dict_set_key_ret=1
        else
            nullcall array_append "__dict__$1__keys" "$2"
            eval "__dict__$1__key_$(nullcall __dict_hash_key "$2")=\"$3\""
            eval "__dict__$1__length=\$(( __dict__$1__length + 1 ))"
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_set_key__OPTIONS_OLD

        return $__dict_set_key_ret
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_get_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __dict_get_key_ret=0

        if dict_has_key "$1" "$2"; then
            eval "printf \"%s\" \"\$__dict__$1__key_$(__dict_hash_key "$2")\""
        else
            __dict_get_key_ret=1
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_get_key__OPTIONS_OLD

        return $__dict_get_key_ret
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_unset_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __dict_unset_key_ret=0

        if eval "[ ! -n \"\$__dict__$1\" ]"; then
            # dict not initialized
            __dict_unset_key_ret=1
        fi

        if dict_has_key "$1" "$2"; then
            eval "unset __dict__$1__key_$(__dict_hash_key "$2")"
            eval "__dict__$1__length=\$(( __dict__$1__length - 1 ))"
        else
            __dict_unset_key_ret=1
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_unset_key__OPTIONS_OLD

        return $__dict_unset_key_ret
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_has_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        __dict_has_key_ret=0

        if eval "[ -n \"\$__dict__$1__key_$(__dict_hash_key "$2")\" ]"; then
            __dict_has_key_ret=0
        else
            __dict_has_key_ret=1
        fi

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD

        return $__dict_has_key_ret
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_for_each_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        OIFS="$IFS"
        IFS="${_ARRAY__SEP}"
        __dict__dict_for_each_key__temp_storage="$(eval command echo \"\$\{__dict__"$1"__keys\}\")"
        for key in $__dict__dict_for_each_key__temp_storage; do
            key="$(nullcall __array_unescape "$key")"
            set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}"
            unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD
            eval "$2"
            __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD="${-:+"-$-"}"
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_key__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_for_each_value() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
            set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"
        done
        IFS="$OIFS"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_for_each_pair() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        nullcall dict_for_each_value "$@"

        set +x "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_pair__OPTIONS_OLD
    }

    #-------------------------------------------------------------------------------
    nulldef; dict_has_value() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_for_each_value__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
    nulldef; get_my_real_fullpath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_fullpath__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                nullcall array_get_last SHELL_SOURCE
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
    nulldef; get_my_real_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_basename__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                basename "$(nullcall array_get_last SHELL_SOURCE)"
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
    nulldef; get_my_real_dir_fullpath() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_fullpath__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                dirname "$(nullcall array_get_last SHELL_SOURCE)"
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
    nulldef; get_my_real_dir_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_real_dir_basename__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE)" -gt 0 ]; then
                basename "$(dirname "$(nullcall array_get_last SHELL_SOURCE)")"
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
    nulldef; get_my_puuid_basename() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__get_my_puuid_basename__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            if [ "$(nullcall array_get_length SHELL_SOURCE_PUUID)" -gt 0 ]; then
                nullcall array_get_last SHELL_SOURCE_PUUID
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
fi

#===============================================================================
#region Source/Invoke Check For Top Level File

#-------------------------------------------------------------------------------
nulldef; _shell_source_push_G() {
    # $1 == TEMP_WAS_SOURCED
    # $2 == TEMP_FILE_NAME

    nullcall array_append WAS_SOURCED "$1"
    nullcall array_export WAS_SOURCED
    nullcall array_append SHELL_SOURCE "$2"
    nullcall array_export SHELL_SOURCE
    nullcall push_puuid_for_abspath "$2"
    nullcall array_export SHELL_SOURCE_PUUID

    temp_puuid="$(nullcall array_peek SHELL_SOURCE_PUUID)"
    nullcall _call_stack_push_G "${temp_puuid}" "0" "${temp_puuid}" "1" "_"
}

#-------------------------------------------------------------------------------
nulldef; _shell_source_pop_G() {
    nullcall _call_stack_pop_G

    nullcall array_remove_last SHELL_SOURCE_PUUID
    nullcall array_export SHELL_SOURCE_PUUID
    nullcall array_remove_last SHELL_SOURCE
    nullcall array_export SHELL_SOURCE
    nullcall array_remove_last WAS_SOURCED
    nullcall array_export WAS_SOURCED
}

# shellcheck disable=SC2218
nullcall log_ultradebug "env vars:\n%s" -- "$(env -0 | sort -z | tr '\0' '\n' | sed -e 's/%/%%/g')"

if [ "${WAS_SOURCED}" = "" ]; then
    WAS_SOURCED=""
    nullcall array_init WAS_SOURCED
fi
if [ "${SHELL_SOURCE}" = "" ]; then
    SHELL_SOURCE=""
    nullcall array_init SHELL_SOURCE
fi
if [ "${SHELL_SOURCE_PUUID}" = "" ]; then
    SHELL_SOURCE_PUUID=""
    nullcall array_init SHELL_SOURCE_PUUID
fi

# NOTE: that all these detection methods only work for the FIRST file
#   that is invoked or sourced, all others must be handled by the
#   include_G, ensure_include_GXY, and invoke functions.
if [ "$(nullcall array_get_length SHELL_SOURCE)" -eq 0 ]; then
    TEMP_FILE_NAME=""
    TEMP_WAS_SOURCED="unknown"
    nullcall log_ultradebug "\$0=$0"
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

if [ "${SHELL_DEF_SOURCE_PUUID}" = "" ]; then
    nullcall dict_init SHELL_DEF_SOURCE_PUUID
    nullcall dict_export SHELL_DEF_SOURCE_PUUID
fi
if [ "${SHELL_DEF_LINENO}" = "" ]; then
    nullcall dict_init SHELL_DEF_LINENO
    nullcall dict_export SHELL_DEF_LINENO
fi

if [ "${SHELL_CALL_STACK}" = "" ]; then
    nullcall array_init SHELL_CALL_STACK
    nullcall array_init SHELL_CALL_STACK_SOURCE_PUUID
    nullcall array_init SHELL_CALL_STACK_SOURCE_LINENO
    nullcall array_init SHELL_CALL_STACK_FUNCNAME

    __call_G_source_puuid="$(nullcall array_get_last SHELL_SOURCE_PUUID)"
    nullcall _call_stack_push_G "$__call_G_source_puuid" "0" "$__call_G_source_puuid" "1" "_"
    unset __call_G_source_puuid
fi

unset x
unset TEMP_ARG_ZERO
unset TEMP_FILE_NAME
unset TEMP_SHELL_SOURCE
unset TEMP_WAS_SOURCED
unset DOLLAR_UNDER

# sometimes shellcheck thinks log_ultradebug is only defined later, not before
# shellcheck disable=SC2218
nullcall log_ultradebug "WAS_SOURCED: $WAS_SOURCED"
# shellcheck disable=SC2218
nullcall log_ultradebug "SHELL_SOURCE: $SHELL_SOURCE"
# shellcheck disable=SC2218
nullcall log_ultradebug "SHELL_SOURCE_PUUID: $SHELL_SOURCE_PUUID"

#endregion Source/Invoke Check For Top Level File
#===============================================================================

#===============================================================================
#region Announce Ourself Starting

__announce_prefix="Sourced"
if [ "$(nullcall array_get_last WAS_SOURCED)" = false ]; then
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
            if [ "$(call array_get_first WAS_SOURCED)" = true ]; then
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
            if [ $UID -eq 0 ] || [ $EUID -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
                call log_fatal "$(call get_my_real_basename) should not be run as root nor with sudo"
                if [ "$(call array_get_first WAS_SOURCED)" = true ]; then
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
        if [ $UID -ne 0 ] && [ $EUID -ne 0 ] && [ "$(id -u)" -ne 0 ]; then
            call log_fatal "$(call get_my_real_basename) MUST be run as root or with sudo"
            if [ "$(call array_get_first WAS_SOURCED)" = true ]; then
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
#region Public *

# fence to prevent redefinition
type BATTERIES_FORKING_INCLUDED_BASE_FENCE >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then

    #===============================================================================
    #region Create Fence

    def; BATTERIES_FORKING_INCLUDED_BASE_FENCE() { true; }

    #endregion Create Fence
    #===============================================================================

    #===============================================================================
    #region Return Codes

    RET_SUCCESS=0; export RET_SUCCESS

    RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN

    # Local Errors 2-63 (61)
    # define these in individual scripts

    # Local Warnings 64-125 (61)
    # define these in individual scripts

    # Important OS Errors 126-127 (2)
    RET_ERROR_SHELL_PERMISSION_DENIED=126; export RET_ERROR_SHELL_PERMISSION_DENIED  # Reserved by OS 'shellname: permission denied: path'
    RET_ERROR_SHELL_FILE_NOT_FOUND=127; export RET_ERROR_SHELL_FILE_NOT_FOUND  # Reserved by OS  'shellname: path: No such file or directory'

    # Global Errors 128-191 (63, but 16 are reserved, so really 47)
    RET_ERROR_UNKNOWN_128=128; export RET_ERROR_UNKNOWN_128
    RET_ERROR_SIGHUP=129 ; export RET_ERROR_SIGHUP  #  SIGHUP  1
    RET_ERROR_SIGINT=130 ; export RET_ERROR_SIGINT  #  SIGINT  2
    RET_ERROR_SIGQUIT=131; export RET_ERROR_SIGQUIT #  SIGQUIT 3
    RET_ERROR_SIGILL=132 ; export RET_ERROR_SIGILL  #  SIGILL  4
    RET_ERROR_SIGTRAP=133; export RET_ERROR_SIGTRAP #  SIGTRAP 5
    RET_ERROR_SIGABRT=134; export RET_ERROR_SIGABRT #  SIGABRT 6
    RET_ERROR_SIG135=135 ; export RET_ERROR_SIG135  #  Uncommon, might be SIGBUS (linux) or SIGEMT (macOS)
    RET_ERROR_SIGFPE=136 ; export RET_ERROR_SIGFPE  #  SIGFPE  8
    RET_ERROR_SIGKILL=137; export RET_ERROR_SIGKILL #  SIGKILL 9
    RET_ERROR_SIG138=138 ; export RET_ERROR_SIG138  #  Uncommon, might be SIGUSR1 (linux) or SIGBUS (macOS)
    RET_ERROR_SIGSEGV=139; export RET_ERROR_SIGSEGV #  SIGSEGV 11
    RET_ERROR_SIG140=140 ; export RET_ERROR_SIG140  #  Uncommon, might be SIGUSR2 (linux) or SIGSYS (macOS)
    RET_ERROR_SIGPIPE=141; export RET_ERROR_SIGPIPE #  SIGPIPE 13
    RET_ERROR_SIGALRM=142; export RET_ERROR_SIGALRM #  SIGALRM 14
    RET_ERROR_SIGTERM=143; export RET_ERROR_SIGTERM #  SIGTERM 15
    # Signals above 16 are less commonly seen,
    # listed here for informational purposes:
    # Linux:            macOS:
    # SIGCHLD   17      SIGURG    16
    # SIGCONT   18      SIGSTOP   17
    # SIGSTOP   19      SIGTSTP   18
    # SIGTSTP   20      SIGCONT   19
    # SIGTTIN   21      SIGCHLD   20
    # SIGTTOU   22      SIGTTIN   21
    # SIGURG    23      SIGTTOU   22
    # SIGXCPU   24      SIGIO     23
    # SIGXFSZ   25      SIGXCPU   24
    # SIGVTALRM 26      SIGXFSZ   25
    # SIGPROF   27      SIGVTALRM 26
    # SIGWINCH  28      SIGPROF   27
    # SIGIO     29      SIGWINCH  28
    # SIGPWR    30      SIGINFO   29
    # SIGSYS    31      SIGUSR1   30
    # SIGRTMIN  34      SIGUSR2   31
    RET_ERROR_CONDA_ACTIVATE_FAILED=144; export RET_ERROR_CONDA_ACTIVATE_FAILED
    RET_ERROR_CONDA_INSTALL_FAILED=145; export RET_ERROR_CONDA_INSTALL_FAILED
    RET_ERROR_PIP_INSTALL_FAILED=146; export RET_ERROR_PIP_INSTALL_FAILED
    RET_ERROR_CONDA_DEACTIVATE_FAILED=147; export RET_ERROR_CONDA_DEACTIVATE_FAILED
    RET_ERROR_PIP_UNINSTALL_FAILED=148; export RET_ERROR_PIP_UNINSTALL_FAILED
    RET_ERROR_SCRIPT_WAS_SOURCED=149; export RET_ERROR_SCRIPT_WAS_SOURCED
    RET_ERROR_USER_IS_ROOT=150; export RET_ERROR_USER_IS_ROOT
    RET_ERROR_SCRIPT_WAS_NOT_SOURCED=151; export RET_ERROR_SCRIPT_WAS_NOT_SOURCED
    RET_ERROR_USER_IS_NOT_ROOT=152; export RET_ERROR_USER_IS_NOT_ROOT
    RET_ERROR_DIRECTORY_NOT_FOUND=153; export RET_ERROR_DIRECTORY_NOT_FOUND
    RET_ERROR_FILE_NOT_FOUND=154; export RET_ERROR_FILE_NOT_FOUND
    RET_ERROR_FILE_COULD_NOT_BE_ACCESSED=155; export RET_ERROR_FILE_COULD_NOT_BE_ACCESSED
    RET_ERROR_INVALID_INVOCATION=156; export RET_ERROR_INVALID_INVOCATION
    RET_ERROR_COULD_NOT_EXECUTE=157; export RET_ERROR_COULD_NOT_EXECUTE
    RET_ERROR_INVALID_ARGUMENT=158; export RET_ERROR_INVALID_ARGUMENT
    RET_ERROR_CONDA_INIT_FAILED=159; export RET_ERROR_CONDA_INIT_FAILED
    RET_ERROR_POETRY_INSTALL_FAILED=160; export RET_ERROR_POETRY_INSTALL_FAILED
    RET_ERROR_COULD_NOT_SOURCE_FILE=161; export RET_ERROR_COULD_NOT_SOURCE_FILE
    RET_ERROR_GIT_CLONE_FAILED=162; export RET_ERROR_GIT_CLONE_FAILED
    RET_ERROR_GIT_FETCH_FAILED=163; export RET_ERROR_GIT_FETCH_FAILED
    RET_ERROR_GIT_RESET_FAILED=164; export RET_ERROR_GIT_RESET_FAILED
    RET_ERROR_RM_FAILED=165; export RET_ERROR_RM_FAILED
    RET_ERROR_COPY_FAILED=166; export RET_ERROR_COPY_FAILED
    RET_ERROR_UNSAFE_RM_PATH=167; export RET_ERROR_UNSAFE_RM_PATH
    RET_ERROR_CHANGE_DIRECTORY_FAILED=168; export RET_ERROR_CHANGE_DIRECTORY_FAILED
    RET_ERROR_MOVE_FAILED=169; export RET_ERROR_MOVE_FAILED
    RET_ERROR_TOOL_MISSING=170; export RET_ERROR_TOOL_MISSING
    RET_ERROR_FAILED_TO_GET_TEMP_DIR=171; export RET_ERROR_FAILED_TO_GET_TEMP_DIR
    RET_ERROR_DOWNLOAD_FAILED=172; export RET_ERROR_DOWNLOAD_FAILED
    RET_ERROR_EXTRACTION_FAILED=173; export RET_ERROR_EXTRACTION_FAILED
    RET_ERROR_CREATE_DIRECTORY_FAILED=174; export RET_ERROR_CREATE_DIRECTORY_FAILED
    RET_ERROR_COULD_NOT_CREATE_TEMP_FILE=178; export RET_ERROR_COULD_NOT_CREATE_TEMP_FILE
    #RET_ERROR_GET_SUBCOMMAND_RETURN_CODE_FAILED=179; export RET_ERROR_GET_SUBCOMMAND_RETURN_CODE_FAILED
    RET_ERROR_FAILED_TO_CREATE_FIFO=180; export RET_ERROR_FAILED_TO_CREATE_FIFO
    RET_ERROR_NOT_A_FILE=181; export RET_ERROR_NOT_A_FILE
    RET_ERROR_NOT_A_DIRECTORY=182; export RET_ERROR_NOT_A_DIRECTORY
    RET_ERROR_COULD_NOT_CHOWN=183; export RET_ERROR_COULD_NOT_CHOWN
    RET_ERROR_COULD_NOT_CHMOD=184; export RET_ERROR_COULD_NOT_CHMOD

    # Global Warnings 192-251 (59, but 2 specially reserved, so really 57)
    RET_WARNING_UNKNOWN=192; export RET_WARNING_UNKNOWN
    RET_WARNING_MULTIPLE=193; export RET_WARNING_MULTIPLE
    RET_WARNING_NOT_A_FILE=194; export RET_WARNING_NOT_A_FILE
    RET_WARNING_NOT_A_DIRECTORY=195; export RET_WARNING_NOT_A_DIRECTORY

    # Special code for unit testing to use to raise an assertion error
    RET_UNIT_TEST_ASSERTION=252; export RET_UNIT_TEST_ASSERTION

    # Special code for a special success (for use by functions to return
    #   success + other state)
    RET_SUCCESS_SPECIAL=253; export RET_SUCCESS_SPECIAL

    #RET_TOMBSTONE=254; export RET_TOMBSTONE

    # Reserved b/c shell weirdness
    RET_ERROR_UNKNOWN_255=255; export RET_ERROR_UNKNOWN_255
    RET_ERROR_UNKNOWN_NEG1=-1; export RET_ERROR_UNKNOWN_NEG1

    # Ranges
    RET_CODE_LOCAL_ERROR_RANGE_START=1; export RET_CODE_LOCAL_ERROR_RANGE_START
    RET_CODE_LOCAL_ERROR_RANGE_END=63; export RET_CODE_LOCAL_ERROR_RANGE_END
    RET_CODE_LOCAL_WARNING_RANGE_START=64; export RET_CODE_LOCAL_WARNING_RANGE_START
    RET_CODE_LOCAL_WARNING_RANGE_END=125; export RET_CODE_LOCAL_WARNING_RANGE_END
    RET_CODE_GLOBAL_ERROR_RANGE_START=128; export RET_CODE_GLOBAL_ERROR_RANGE_START
    RET_CODE_GLOBAL_ERROR_RANGE_END=191; export RET_CODE_GLOBAL_ERROR_RANGE_END
    RET_CODE_GLOBAL_WARNING_RANGE_START=192; export RET_CODE_GLOBAL_WARNING_RANGE_START
    RET_CODE_GLOBAL_WARNING_RANGE_END=251; export RET_CODE_GLOBAL_WARNING_RANGE_END

    #-------------------------------------------------------------------------------
    def; return_code_is_error() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            val=$1
            val=$(( val + 0 ))
            if \
                {
                    [ $val -ge "${RET_CODE_LOCAL_ERROR_RANGE_START}" ] &&
                    [ $val -le "${RET_CODE_LOCAL_ERROR_RANGE_END}" ]
                } ||
                {
                    [ $val -ge "${RET_CODE_GLOBAL_ERROR_RANGE_START}" ] &&
                    [ $val -le "${RET_CODE_GLOBAL_ERROR_RANGE_END}" ]
                } ||
                [ $val -eq "${RET_ERROR_SHELL_PERMISSION_DENIED}" ] ||
                [ $val -eq "${RET_ERROR_SHELL_FILE_NOT_FOUND}" ] ||
                [ $val -eq "${RET_ERROR_UNKNOWN}" ] ||
                [ $val -eq "${RET_ERROR_UNKNOWN_128}" ] ||
                [ $val -eq "${RET_ERROR_UNKNOWN_255}" ] ||
                [ $val -eq "${RET_ERROR_UNKNOWN_NEG1}" ] ||
                [ $val -lt 0 ]
            then
                command printf "true"
                exit 0
            else
                command printf "false"
                exit 1
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; return_code_is_warning() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            val=$1
            val=$(( val + 0 ))
            if \
                {
                    [ $val -ge "${RET_CODE_LOCAL_WARNING_RANGE_START}" ] &&
                    [ $val -le "${RET_CODE_LOCAL_WARNING_RANGE_END}" ]
                } ||
                {
                    [ $val -ge "${RET_CODE_GLOBAL_WARNING_RANGE_START}" ] &&
                    [ $val -le "${RET_CODE_GLOBAL_WARNING_RANGE_END}" ]
                } ||
                [ $val -eq "${RET_WARNING_UNKNOWN}" ] ||
                [ $val -eq "${RET_WARNING_MULTIPLE}" ]
            then
                command printf "true"
                exit 0
            else
                command printf "false"
                exit 1
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; return_code_is_success() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            val=$1
            val=$(( val + 0 ))
            if \
                [ $val -eq "${RET_SUCCESS}" ] ||
                [ $val -eq "${RET_SUCCESS_SPECIAL}" ]
            then
                command printf "true"
                exit 0
            else
                command printf "false"
                exit 1
            fi
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #endregion Return Codes
    #===============================================================================

    #===============================================================================
    #region Constants

    DATETIME_STAMP_HUMAN_FORMAT="+%Y-%m-%d %H:%M:%S"; export DATETIME_STAMP_HUMAN_FORMAT
    DATETIME_STAMP_FILENAME_FORMAT="+%Y%m%dT%H%M%S"; export DATETIME_STAMP_FILENAME_FORMAT

    #endregion Constants
    #===============================================================================

    #===============================================================================
    #region Platform Constants

    PLATFORM="$(uname)"; export PLATFORM
    REAL_PLATFORM="${REAL_PLATFORM:-${PLATFORM}}"; export REAL_PLATFORM

    ARCH="$(uname -m)"; export ARCH
    REAL_ARCH="${REAL_ARCH:-${ARCH}}"; export REAL_ARCH

    DEFAULT_ADMIN_GROUP="staff"; export DEFAULT_ADMIN_GROUP

    CONDA_FORGE_PLATFORM="UNKNOWN"; export CONDA_FORGE_PLATFORM
    CONDA_FORGE_ARCH="UNKNOWN"; export CONDA_FORGE_ARCH
    CONDA_FORGE_EXT="sh"; export CONDA_FORGE_EXT

    LINUX_BASE_FLAVOR="NOT_LINUX"; export LINUX_BASE_FLAVOR
    LINUX_BASE_FLAVOR_VERSION="NOT_LINUX"; export LINUX_BASE_FLAVOR_VERSION

    CONDA_INSTALL_PATH="/opt/conda/miniforge"; export CONDA_INSTALL_PATH
    if [ "${CI}" = true ]; then
        if [ "${GITHUB_ACTIONS}" = true ]; then
            CONDA_INSTALL_PATH="${HOME}/opt/conda/miniforge"; export CONDA_INSTALL_PATH
            mkdir -p "${CONDA_INSTALL_PATH}"
        fi
    fi

    if [ "${REAL_PLATFORM}" = "Darwin" ]; then
        def; date() {
            command date -j "$@"
        }

        DEFAULT_ADMIN_GROUP="staff"; export DEFAULT_ADMIN_GROUP

        CONDA_FORGE_PLATFORM="MacOSX"; export CONDA_FORGE_PLATFORM
        CONDA_FORGE_EXT="sh"; export CONDA_FORGE_EXT
    elif \
        [ "${REAL_PLATFORM}" = "Linux" ] ||
        [ "$(echo "${REAL_PLATFORM}" | grep -e 'MINGW64_NT' )" != "" ]
    then
        def; date() {
            command date "$@"
        }

        LINUX_BASE_FLAVOR_VERSION="$(cat /proc/version)"; export LINUX_BASE_FLAVOR_VERSION

        LINUX_BASE_FLAVOR="UNKNOWN_LINUX"
        DEFAULT_ADMIN_GROUP="wheel"
        if [ "$(echo "${LINUX_BASE_FLAVOR_VERSION}" | grep "[dD]ebian" )" != "" ]; then
            LINUX_BASE_FLAVOR="Debian"
            DEFAULT_ADMIN_GROUP="sudo";
        elif [ "$(echo "${LINUX_BASE_FLAVOR_VERSION}" | grep "[uU]buntu" )" != "" ]; then
            LINUX_BASE_FLAVOR="Ubuntu"
            # version of command with leading cat is easier to read
            # shellcheck disable=SC2002
            __LINUX_BASE_FLAVOR_VERSION_UBUNTU="$(cat /etc/os-release | awk -F = '/VERSION_ID/ {print $2}' | sed -e 's/"//g')"
            __LINUX_BASE_FLAVOR_VERSION_UBUNTU_MAJOR="$(echo "${__LINUX_BASE_FLAVOR_VERSION_UBUNTU}" |  awk -F . '{print $1}')"
            __LINUX_BASE_FLAVOR_VERSION_UBUNTU_MINOR="$(echo "${__LINUX_BASE_FLAVOR_VERSION_UBUNTU}" |  awk -F . '{print $2}')"
            if [ "${__LINUX_BASE_FLAVOR_VERSION_UBUNTU_MAJOR}" -le 10 ]; then
                DEFAULT_ADMIN_GROUP="sudo"
            elif [ "${__LINUX_BASE_FLAVOR_VERSION_UBUNTU_MAJOR}" -eq 11 ]; then
                if [ "${__LINUX_BASE_FLAVOR_VERSION_UBUNTU_MINOR}" -le 10 ]; then
                    DEFAULT_ADMIN_GROUP="sudo"
                else
                    DEFAULT_ADMIN_GROUP="admin"
                fi
            else
                DEFAULT_ADMIN_GROUP="admin"
            fi
        elif [ "$(echo "${LINUX_BASE_FLAVOR_VERSION}" | grep "[rR]ed [hHat]" )" != "" ]; then
            LINUX_BASE_FLAVOR="Fedora"
            DEFAULT_ADMIN_GROUP="wheel";
        fi
        export LINUX_BASE_FLAVOR
        export DEFAULT_ADMIN_GROUP

        CONDA_FORGE_PLATFORM="Linux"; export CONDA_FORGE_PLATFORM
        CONDA_FORGE_EXT="sh"; export CONDA_FORGE_EXT
    fi

    case "${REAL_ARCH}" in
        i386)
            CONDA_FORGE_ARCH="x86_64"; export CONDA_FORGE_ARCH
            ;;
        i486)
            CONDA_FORGE_ARCH="x86_64"; export CONDA_FORGE_ARCH
            ;;
        amd64)
            CONDA_FORGE_ARCH="x86_64"; export CONDA_FORGE_ARCH
            ;;
        x86_64)
            CONDA_FORGE_ARCH="x86_64"; export CONDA_FORGE_ARCH
            ;;
        aarch64)
            CONDA_FORGE_ARCH="aarch64"; export CONDA_FORGE_ARCH
            ;;
        arm)
            if [ "${REAL_PLATFORM}" = "Darwin" ]; then
                CONDA_FORGE_ARCH="arm64"; export CONDA_FORGE_ARCH
            elif [ "${REAL_PLATFORM}" = "Linux" ]; then
                CONDA_FORGE_ARCH="aarch64"; export CONDA_FORGE_ARCH
            fi
            ;;
        arm64)
            if [ "${REAL_PLATFORM}" = "Darwin" ]; then
                CONDA_FORGE_ARCH="arm64"; export CONDA_FORGE_ARCH
            elif [ "${REAL_PLATFORM}" = "Linux" ]; then
                CONDA_FORGE_ARCH="aarch64"; export CONDA_FORGE_ARCH
            fi
            ;;
    esac

    PLATFORM_IS_WSL=false
    if \
        [ "$(uname -a | grep '\(microsoft\|Microsoft\|WSL\)')" != "" ] ||
        [ "$(echo "${REAL_PLATFORM}" | grep -e 'MINGW64_NT' )" != "" ] ||
        [ "${WSL_DISTRO_NAME}" != "" ]
    then
        PLATFORM_IS_WSL=true
    fi
    export PLATFORM_IS_WSL;

    #endregion Platform Constants
    #===============================================================================

    #===============================================================================
    #region Calculated "Constants"

    def; set_calculated_constants() {
        # CONDA_BASE_DIR_FULLPATH="$(dirname "$(dirname "${CONDA_EXE}")")"
        # export CONDA_BASE_DIR_FULLPATH
        true
    }
    call set_calculated_constants

    #endregion Calculated "Constants"
    #===============================================================================

    #===============================================================================
    #region Colorized Output Constants & Helper Functions

    ANSI_CODE_START="\033["; export ANSI_CODE_START
    ANSI_CODE_END="m"; export ANSI_CODE_END

    #-------------------------------------------------------------------------------
    def; get_ansi_code() {
        # $1 = mode
        # $2 = default color
        # $3 = alternate color
        # $4 = override trailing character

        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            mode_sep=";"
            if [ "$1" = "" ]; then
                mode_sep=""
            fi

            ending="$4"
            if [ "${ending}" = "" ]; then
                ending="${ANSI_CODE_END}"
            fi
            tput_colors=16
            if [ "$TERM" != "" ]; then
                tput_colors="$(tput colors 2>/dev/null)"
                if [ "${tput_colors}" = "" ]; then
                    tput_colors=16
                fi
            fi
            # because "colorize_output" may or may not exist
            # shellcheck disable=SC2154
            if {
                [ "$ending" = "m" ] &&
                {
                    [ "$(command echo "$TERM" | grep 'mono')" != "" ] ||
                    [ "${tput_colors}" -lt 16 ] ||
                    [ "${NO_COLOR}" != "" ] ||
                    [ "${colorized_output}" = false ]
                }
            }; then
                # mode/color in monocolor terminal
                if [ "$1" != "" ]; then
                    # mode specified
                    command printf "${ANSI_CODE_START}$1${ending}"
                else
                    # no mode specified
                    command printf ""
                fi
            else
                # 16+ color terminal or not a color/mode
                if [ "$ending" = "m" ] && [ "${colorized_output}" = "alt" ] && [ "$3" != "" ]; then
                    # a color or mode in alt-color w/ alt-value specified
                    command printf "${ANSI_CODE_START}$1${mode_sep}$3${ending}"
                elif [ "$2" != "" ]; then
                    # anything in color w/ value specified
                    command printf "${ANSI_CODE_START}$1${mode_sep}$2${ending}"
                elif [ "$1" != "" ]; then
                    # only a mode specified (no value specified)
                    command printf "${ANSI_CODE_START}$1${ending}"
                else
                    # nothing specified
                    command printf ""
                fi
            fi

            exit 0
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor() {
        call get_ansi_code '' "$1" '' "$2"
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_up() {
        call get_ansi_code_cursor "$1" 'A'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_down() {
        call get_ansi_code_cursor "$1" 'B'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_right() {
        call get_ansi_code_cursor "$1" 'C'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_left() {
        call get_ansi_code_cursor "$1" 'D'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_nextline() {
        call get_ansi_code_cursor "$1" 'E'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_prevline() {
        call get_ansi_code_cursor "$1" 'F'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_col() {
        call get_ansi_code_cursor "$1" 'G'
    }

    #-------------------------------------------------------------------------------
    def; get_ansi_code_cursor_pos() {
        call get_ansi_code_cursor "$1;$2" 'H'
    }

    #-------------------------------------------------------------------------------
    def; set_ansi_code_constants() {
        ANSI_FG_BLACK="$(call get_ansi_code '0' '30')"; export ANSI_FG_BLACK
        ANSI_FG_RED="$(call get_ansi_code '0' '31')"; export ANSI_FG_RED
        ANSI_FG_GREEN="$(call get_ansi_code '0' '32')"; export ANSI_FG_GREEN
        ANSI_FG_YELLOW="$(call get_ansi_code '0' '33')"; export ANSI_FG_YELLOW
        ANSI_FG_BLUE="$(call get_ansi_code '0' '34')"; export ANSI_FG_BLUE
        ANSI_FG_MAGENTA="$(call get_ansi_code '0' '35')"; export ANSI_FG_MAGENTA
        ANSI_FG_CYAN="$(call get_ansi_code '0' '36')"; export ANSI_FG_CYAN
        ANSI_FG_WHITE="$(call get_ansi_code '0' '37')"; export ANSI_FG_WHITE

        ANSI_BLACK="${ANSI_FG_BLACK}"; export ANSI_BLACK
        ANSI_RED="${ANSI_FG_RED}"; export ANSI_RED
        ANSI_GREEN="${ANSI_FG_GREEN}"; export ANSI_GREEN
        ANSI_YELLOW="${ANSI_FG_YELLOW}"; export ANSI_YELLOW
        ANSI_BLUE="${ANSI_FG_BLUE}"; export ANSI_BLUE
        ANSI_MAGENTA="${ANSI_FG_MAGENTA}"; export ANSI_MAGENTA
        ANSI_CYAN="${ANSI_FG_CYAN}"; export ANSI_CYAN
        ANSI_WHITE="${ANSI_FG_WHITE}"; export ANSI_WHITE

        ANSI_FG_BOLD_BLACK="$(call get_ansi_code '1' '30')"; export ANSI_FG_BOLD_BLACK
        ANSI_FG_BOLD_RED="$(call get_ansi_code '1' '31')"; export ANSI_FG_BOLD_RED
        ANSI_FG_BOLD_GREEN="$(call get_ansi_code '1' '32')"; export ANSI_FG_BOLD_GREEN
        ANSI_FG_BOLD_YELLOW="$(call get_ansi_code '1' '33')"; export ANSI_FG_BOLD_YELLOW
        ANSI_FG_BOLD_BLUE="$(call get_ansi_code '1' '34')"; export ANSI_FG_BOLD_BLUE
        ANSI_FG_BOLD_MAGENTA="$(call get_ansi_code '1' '35')"; export ANSI_FG_BOLD_MAGENTA
        ANSI_FG_BOLD_CYAN="$(call get_ansi_code '1' '36')"; export ANSI_FG_BOLD_CYAN
        ANSI_FG_BOLD_WHITE="$(call get_ansi_code '1' '37')"; export ANSI_FG_BOLD_WHITE

        ANSI_BOLD_BLACK="${ANSI_FG_BOLD_BLACK}"; export ANSI_BOLD_BLACK
        ANSI_BOLD_RED="${ANSI_FG_BOLD_RED}"; export ANSI_BOLD_RED
        ANSI_BOLD_GREEN="${ANSI_FG_BOLD_GREEN}"; export ANSI_BOLD_GREEN
        ANSI_BOLD_YELLOW="${ANSI_FG_BOLD_YELLOW}"; export ANSI_BOLD_YELLOW
        ANSI_BOLD_BLUE="${ANSI_FG_BOLD_BLUE}"; export ANSI_BOLD_BLUE
        ANSI_BOLD_MAGENTA="${ANSI_FG_BOLD_MAGENTA}"; export ANSI_BOLD_MAGENTA
        ANSI_BOLD_CYAN="${ANSI_FG_BOLD_CYAN}"; export ANSI_BOLD_CYAN
        ANSI_BOLD_WHITE="${ANSI_FG_BOLD_WHITE}"; export ANSI_BOLD_WHITE

        # NOTE: backgrounds do not use the mode arg
        ANSI_BG_BLACK="$(call get_ansi_code '' '0;40')"; export ANSI_BG_BLACK
        ANSI_BG_RED="$(call get_ansi_code '' '0;41')"; export ANSI_BG_RED
        ANSI_BG_GREEN="$(call get_ansi_code '' '0;42')"; export ANSI_BG_GREEN
        ANSI_BG_YELLOW="$(call get_ansi_code '' '0;43')"; export ANSI_BG_YELLOW
        ANSI_BG_BLUE="$(call get_ansi_code '' '0;44')"; export ANSI_BG_BLUE
        ANSI_BG_MAGENTA="$(call get_ansi_code '' '0;45')"; export ANSI_BG_MAGENTA
        ANSI_BG_CYAN="$(call get_ansi_code '' '0;46')"; export ANSI_BG_CYAN
        ANSI_BG_WHITE="$(call get_ansi_code '' '0;47')"; export ANSI_BG_WHITE

        # NOTE: backgrounds do not use the mode arg
        ANSI_BG_BOLD_BLACK="$(call get_ansi_code '' '1;40')"; export ANSI_BG_BOLD_BLACK
        ANSI_BG_BOLD_RED="$(call get_ansi_code '' '1;41')"; export ANSI_BG_BOLD_RED
        ANSI_BG_BOLD_GREEN="$(call get_ansi_code '' '1;42')"; export ANSI_BG_BOLD_GREEN
        ANSI_BG_BOLD_YELLOW="$(call get_ansi_code '' '1;43')"; export ANSI_BG_BOLD_YELLOW
        ANSI_BG_BOLD_BLUE="$(call get_ansi_code '' '1;44')"; export ANSI_BG_BOLD_BLUE
        ANSI_BG_BOLD_MAGENTA="$(call get_ansi_code '' '1;45')"; export ANSI_BG_BOLD_MAGENTA
        ANSI_BG_BOLD_CYAN="$(call get_ansi_code '' '1;46')"; export ANSI_BG_BOLD_CYAN
        ANSI_BG_BOLD_WHITE="$(call get_ansi_code '' '1;47')"; export ANSI_BG_BOLD_WHITE

        ANSI_UNDERLINE="$(call get_ansi_code '4' '')"; export ANSI_UNDERLINE
        ANSI_UNDERLINE_OFF="$(call get_ansi_code '24' '')"; export ANSI_UNDERLINE_OFF

        ANSI_FG_UNDERLINE_BLACK="$(call get_ansi_code '0;4' '30')"; export ANSI_FG_UNDERLINE_BLACK
        ANSI_FG_UNDERLINE_RED="$(call get_ansi_code '0;4' '31')"; export ANSI_FG_UNDERLINE_RED
        ANSI_FG_UNDERLINE_GREEN="$(call get_ansi_code '0;4' '32')"; export ANSI_FG_UNDERLINE_GREEN
        ANSI_FG_UNDERLINE_YELLOW="$(call get_ansi_code '0;4' '33')"; export ANSI_FG_UNDERLINE_YELLOW
        ANSI_FG_UNDERLINE_BLUE="$(call get_ansi_code '0;4' '34')"; export ANSI_FG_UNDERLINE_BLUE
        ANSI_FG_UNDERLINE_MAGENTA="$(call get_ansi_code '0;4' '35')"; export ANSI_FG_UNDERLINE_MAGENTA
        ANSI_FG_UNDERLINE_CYAN="$(call get_ansi_code '0;4' '36')"; export ANSI_FG_UNDERLINE_CYAN
        ANSI_FG_UNDERLINE_WHITE="$(call get_ansi_code '0;4' '37')"; export ANSI_FG_UNDERLINE_WHITE

        ANSI_FG_BOLD_UNDERLINE_BLACK="$(call get_ansi_code '1;4' '30')"; export ANSI_FG_BOLD_UNDERLINE_BLACK
        ANSI_FG_BOLD_UNDERLINE_RED="$(call get_ansi_code '1;4' '31')"; export ANSI_FG_BOLD_UNDERLINE_RED
        ANSI_FG_BOLD_UNDERLINE_GREEN="$(call get_ansi_code '1;4' '32')"; export ANSI_FG_BOLD_UNDERLINE_GREEN
        ANSI_FG_BOLD_UNDERLINE_YELLOW="$(call get_ansi_code '1;4' '33')"; export ANSI_FG_BOLD_UNDERLINE_YELLOW
        ANSI_FG_BOLD_UNDERLINE_BLUE="$(call get_ansi_code '1;4' '34')"; export ANSI_FG_BOLD_UNDERLINE_BLUE
        ANSI_FG_BOLD_UNDERLINE_MAGENTA="$(call get_ansi_code '1;4' '35')"; export ANSI_FG_BOLD_UNDERLINE_MAGENTA
        ANSI_FG_BOLD_UNDERLINE_CYAN="$(call get_ansi_code '1;4' '36')"; export ANSI_FG_BOLD_UNDERLINE_CYAN
        ANSI_FG_BOLD_UNDERLINE_WHITE="$(call get_ansi_code '1;4' '37')"; export ANSI_FG_BOLD_UNDERLINE_WHITE

        ANSI_CLEAR_LINE="$(call get_ansi_code '' '2' '' 'K')"; export ANSI_CLEAR_LINE
        ANSI_RESET_LINE="$(call get_ansi_code '' '2' '' 'K')$(call get_ansi_code '1' '' 'G')"; export ANSI_RESET_LINE

        ANSI_CLEAR_SCREEN="$(call get_ansi_code '' '2' '' 'J')"; export ANSI_CLEAR_SCREEN
        ANSI_RESET_SCREEN="$(call get_ansi_code '' '2' '' 'J')$(call get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_SCREEN

        ANSI_CLEAR_HISTORY="$(call get_ansi_code '' '3' '' 'J')"; export ANSI_CLEAR_HISTORY
        ANSI_RESET_HISTORY="$(call get_ansi_code '' '3' '' 'J')$(call get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_HISTORY

        ANSI_RESET_CURSOR_LINE="$(call get_ansi_code '' '1' '' 'G')"; export ANSI_RESET_CURSOR_LINE
        ANSI_RESET_CURSOR_SCREEN="$(call get_ansi_code '' '1;1' '' 'H')"; export ANSI_RESET_CURSOR_SCREEN

        ANSI_CURSOR_UP="$(call get_ansi_code_cursor_up '1')"; export ANSI_CURSOR_UP
        ANSI_CURSOR_DOWN="$(call get_ansi_code_cursor_down '1')"; export ANSI_CURSOR_DOWN
        ANSI_CURSOR_RIGHT="$(call get_ansi_code_cursor_right '1')"; export ANSI_CURSOR_RIGHT
        ANSI_CURSOR_LEFT="$(call get_ansi_code_cursor_left '1')"; export ANSI_CURSOR_LEFT
        ANSI_CURSOR_NEXTLINE="$(call get_ansi_code_cursor_nextline '1')"; export ANSI_CURSOR_NEXTLINE
        ANSI_CURSOR_PREVLINE="$(call get_ansi_code_cursor_prevline '1')"; export ANSI_CURSOR_PREVLINE

        ANSI_BELL="\007🔔 "; export ANSI_BELL
        ANSI_RESET="${ANSI_CODE_START}0${ANSI_CODE_END}"; export ANSI_RESET

        ANSI_COLOR_SUCCESS="$(call get_ansi_code '1' '32' '34')"; export ANSI_COLOR_SUCCESS          # bright green/blue
        ANSI_COLOR_FATAL="$(call get_ansi_code '1' '31')"; export ANSI_COLOR_FATAL                   # bright red
        ANSI_COLOR_ERROR="$(call get_ansi_code '0' '31')"; export ANSI_COLOR_ERROR                   # darkred
        ANSI_COLOR_WARNING="$(call get_ansi_code '1' '33')"; export ANSI_COLOR_WARNING               # bright yellow
        ANSI_COLOR_HEADER="$(call get_ansi_code '1;4' '36')"; export ANSI_COLOR_HEADER               # bright cyan, underlined
        ANSI_COLOR_FOOTER="$(call get_ansi_code '0' '36')"; export ANSI_COLOR_FOOTER                 # bright darkcyan
        ANSI_COLOR_INFO="$(call get_ansi_code '1' '37')"; export ANSI_COLOR_INFO                     # bright white
        ANSI_COLOR_DEBUG="$(call get_ansi_code '0' '37')"; export ANSI_COLOR_DEBUG                   # lightgrey
        ANSI_COLOR_SUPERDEBUG="$(call get_ansi_code '1' '30')"; export ANSI_COLOR_SUPERDEBUG         # grey
        ANSI_COLOR_ULTRADEBUG="$(call get_ansi_code '0' '35' '33')"; export ANSI_COLOR_ULTRADEBUG    # darkmagenta/darkyellow

        ANSI_SUCCESS="${ANSI_COLOR_SUCCESS}SUCCESS: "; export ANSI_SUCCESS
        ANSI_FATAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 FATAL: "; export ANSI_FATAL
        ANSI_ERROR="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ ERROR: "; export ANSI_ERROR
        ANSI_WARNING="${ANSI_COLOR_WARNING}⚠️ WARNING: "; export ANSI_WARNING
        ANSI_HEADER="${ANSI_COLOR_HEADER}"; export ANSI_HEADER
        ANSI_FOOTER="${ANSI_COLOR_FOOTER}"; export ANSI_FOOTER
        ANSI_INFO="${ANSI_COLOR_INFO}INFO: "; export ANSI_INFO
        ANSI_CONSOLE="${ANSI_COLOR_INFO}"; export ANSI_CONSOLE
        ANSI_DEBUG="${ANSI_COLOR_DEBUG}DEBUG: "; export ANSI_DEBUG
        ANSI_SUPERDEBUG="${ANSI_COLOR_SUPERDEBUG}SUPERDEBUG: "; export ANSI_SUPERDEBUG
        ANSI_ULTRADEBUG="${ANSI_COLOR_ULTRADEBUG}ULTRADEBUG: "; export ANSI_ULTRADEBUG
        ANSI_FILE="${ANSI_COLOR_ULTRADEBUG}"; export ANSI_FILE

        ANSI_INFO_IMPORTANT="${ANSI_COLOR_WARNING}INFO: "; export ANSI_INFO_IMPORTANT
        ANSI_INFO_NO_PREFIX="${ANSI_COLOR_INFO}"; export ANSI_INFO_NO_PREFIX

        ANSI_SUCCESS_FINAL="${ANSI_COLOR_SUCCESS}${ANSI_BELL}✅ SUCCESS: "; export ANSI_SUCCESS_FINAL
        ANSI_FATAL_FINAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 FATAL: "; export ANSI_FATAL_FINAL
        ANSI_ERROR_FINAL="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ ERROR: "; export ANSI_ERROR_FINAL
        ANSI_WARNING_FINAL="${ANSI_COLOR_WARNING}${ANSI_BELL}⚠️ WARNING: "; export ANSI_WARNING_FINAL
    }
    call set_ansi_code_constants

    #endregion Colorized Output Constants
    #===============================================================================

    #===============================================================================
    #region Logging Helpers

    LOG_LEVEL_SUCCESS=-5; export LOG_LEVEL_SUCCESS
    LOG_LEVEL_FATAL=-4; export LOG_LEVEL_FATAL
    LOG_LEVEL_ERROR=-3; export LOG_LEVEL_ERROR
    LOG_LEVEL_WARNING=-2; export LOG_LEVEL_WARNING
    LOG_LEVEL_HEADER=-1; export LOG_LEVEL_HEADER
    LOG_LEVEL_FOOTER=0; export LOG_LEVEL_FOOTER
    LOG_LEVEL_INFO=1; export LOG_LEVEL_INFO
    LOG_LEVEL_DEBUG=2; export LOG_LEVEL_DEBUG
    LOG_LEVEL_SUPERDEBUG=3; export LOG_LEVEL_SUPERDEBUG
    LOG_LEVEL_ULTRADEBUG=4; export LOG_LEVEL_ULTRADEBUG

    LOG_LEVEL_CONSOLE=-99; export LOG_LEVEL_CONSOLE
    LOG_LEVEL_FILE=-99; export LOG_LEVEL_FILE

    LOG_LEVEL_INFO_IMPORTANT=${LOG_LEVEL_INFO}; export LOG_LEVEL_INFO_IMPORTANT
    LOG_LEVEL_INFO_NO_PREFIX=${LOG_LEVEL_INFO}; export LOG_LEVEL_INFO_NO_PREFIX

    LOG_LEVEL_SUCCESS_FINAL=${LOG_LEVEL_SUCCESS}; export LOG_LEVEL_SUCCESS_FINAL
    LOG_LEVEL_FATAL_FINAL=${LOG_LEVEL_FATAL}; export LOG_LEVEL_FATAL_FINAL
    LOG_LEVEL_ERROR_FINAL=${LOG_LEVEL_ERROR}; export LOG_LEVEL_ERROR_FINAL
    LOG_LEVEL_WARNING_FINAL=${LOG_LEVEL_WARNING}; export LOG_LEVEL_WARNING_FINAL

    #-------------------------------------------------------------------------------
    def; create_fifo() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            n=0
            until
                fifo=$1.$$.$n
                mkfifo -m 600 -- "$fifo" 2> /dev/null
            do
                n=$((n + 1))
                # give up after 20 attempts as it could be a permanent condition
                # that prevents us from creating fifos. You'd need to raise that
                # limit if you intend to create (and use at the same time)
                # more than 20 fifos in your script
                [ "$n" -lt 20 ] || exit "${RET_ERROR_FAILED_TO_CREATE_FIFO}"
            done
            command printf '%s\n' "$fifo"
            exit "${RET_SUCCESS}"
        )
        exit_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $exit_ret
    }

    #-------------------------------------------------------------------------------
    def; cleanup_fifo() {
        rm -f -- "$1"
    }

    #-------------------------------------------------------------------------------
    def; teetty_G() {
        if [ "${my_tempdir}" = "" ]; then
            call ensure_my_tempdir_G
        fi

        # create fifos for subprocess to output to
        _stdout_fifo="$(call create_fifo "${my_tempdir}/stdout_fifo")"
        teetty_ret=$?
        if [ $teetty_ret -ne 0 ]; then
            return $teetty_ret
        fi
        _stderr_fifo="$(call create_fifo "${my_tempdir}/stderr_fifo")"
        teetty_ret=$?
        if [ $teetty_ret -ne 0 ]; then
            return $teetty_ret
        fi

        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            # output from fifo to console streams + files (in background processes)
            # shellcheck disable=SC2002
            ( cat "${_stdout_fifo}" | tee -a "${FULL_LOG}" & )
            _stdout_bg_task=$!
            # shellcheck disable=SC2002
            ( cat "${_stderr_fifo}" | tee -a "${ERROR_LOG}" "${ERROR_AND_FATAL_LOG}" >&2 & )
            _stderr_bg_task=$!
        else
            # output from fifo to files (in background processes)
            # shellcheck disable=SC2002
            ( cat "${_stdout_fifo}" | tee -a "${FULL_LOG}" >/dev/null & )
            _stdout_bg_task=$!
            # shellcheck disable=SC2002
            ( cat "${_stderr_fifo}" | tee -a "${ERROR_LOG}" "${ERROR_AND_FATAL_LOG}" >/dev/null & )
            _stderr_bg_task=$!
        fi

        # escapes command so we can use it in eval
        esceval() {
            command printf '%s ' "$@" | sed "s/'/'\\\\''/g"
        }

        # run the subprocess outputingg to the fifos
        eval "$(esceval "$@")" > "${_stdout_fifo}" 2> "${_stderr_fifo}"
        teetty_ret=$?

        # process has ended, if the fifos background processes
        # have not ended, end them
        kill -9 "${_stdout_bg_task}" 2>/dev/null
        kill -9 "${_stderr_bg_task}" 2>/dev/null

        # remove the fifo files
        call cleanup_fifo "${_stdout_fifo}"
        call cleanup_fifo "${_stderr_fifo}"

        # Return the status code of the subprocess
        return $teetty_ret
    }

    #-------------------------------------------------------------------------------
    def; format_log_message() {
        # $1 = prefix
        # $2 = suffix
        # $3 = string or format
        # ... = string
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            prefix="$1"
            suffix="$2"
            shift 2

            # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
            inner_text="$(command printf -- "$@"; command echo EOL)"
            command printf -- "%s %s%s%s\n" "$(call get_datetime_stamp_human_formatted)" "${prefix}" "${inner_text%EOL}" "${suffix}"

            exit "${RET_SUCCESS}"
        )
        log_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $log_ret
    }

    def; log_() {
        # $1 = type e.g. SUCCESS, FATAL, ERROR, WARNING, etc
        # $2 = string or format string
        # ... = variables to be used in format string
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            log_type="$1"
            shift

            output_to_stderr=false
            if {
                [ "$(echo "${log_type}" | grep -e 'FATAL')" != "" ] ||
                [ "$(echo "${log_type}" | grep -e 'ERROR')" != "" ] ||
                [ "$(echo "${log_type}" | grep -e 'WARNING')" != "" ]
            }; then
                output_to_stderr=true
            fi

            # NOTE: we echo EOL and then remove it when we call format_log_message
            #   to keep trailing whitespace
            prefix="$(eval echo "\${ANSI_${log_type}}EOL")"
            # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
            message="$(call format_log_message "${prefix%EOL}" "${ANSI_RESET}" "$@"; command echo EOL)"
            required_verbosity="$(eval echo "\${LOG_LEVEL_${log_type}}")"
            if [ "$required_verbosity" = "" ]; then
                call log_error "Invalid Log Type Specified: %s" "$log_type"
                required_verbosity="${LOG_LEVEL_INFO}"
            fi
            if \
                { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${required_verbosity}" ]  ;} ||
                [ "${OMEGA_DEBUG:-}" = true ] ||
                [ "${OMEGA_DEBUG:-}" = "all" ]
            then
                if [ "${log_type}" != "FILE" ]; then
                    if [ "${output_to_stderr}" = true ]; then
                        >&2 command printf -- "${message%EOL}"
                    else
                        command printf -- "${message%EOL}"
                    fi
                fi
            fi

            if {
                [ "${log_type}" != "CONSOLE" ] &&
                [ "${FULL_LOG}" != "" ]
            }; then
                >>"${FULL_LOG}" command printf -- "${message%EOL}"
            fi

            if {
                [ "$(echo "${log_type}" | grep -e 'FATAL')" != "" ] ||
                [ "$(echo "${log_type}" | grep -e 'ERROR')" != "" ]
            }; then
                >>"${ERROR_AND_FATAL_LOG}" command printf -- "${message%EOL}"
            fi

            if {
                [ "$(echo "${log_type}" | grep -e 'FATAL')" != "" ]
            }; then
                >>"${FATAL_LOG}" command printf -- "${message%EOL}"
            fi

            if {
                [ "$(echo "${log_type}" | grep -e 'ERROR')" != "" ]
            }; then
                >>"${ERROR_LOG}" command printf -- "${message%EOL}"
            fi

            if {
                [ "$(echo "${log_type}" | grep -e 'WARNING')" != "" ]
            }; then
                >>"${WARNING_LOG}" command printf -- "${message%EOL}"
            fi

            exit "${RET_SUCCESS}"
        )
        log_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $log_ret
    }

    #-------------------------------------------------------------------------------
    def; log_console() {
        call log_ CONSOLE "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_success() {
        call log_ SUCCESS "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_success_final() {
        call log_ SUCCESS_FINAL "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_fatal() {
        call log_ FATAL "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_fatal_final() {
        call log_ FATAL_FINAL "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_error() {
        call log_ ERROR "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_error_final() {
        call log_ ERROR_FINAL "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_warning() {
        call log_ WARNING "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_warning_final() {
        call log_ WARNING_FINAL "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_header() {
        call log_ HEADER "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_footer() {
        call log_ FOOTER "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_info_important() {
        call log_ INFO_IMPORTANT "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_info() {
        call log_ INFO "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_info_no_prefix() {
        call log_ INFO_NO_PREFIX "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_debug() {
        call log_ DEBUG "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_superdebug() {
        call log_ SUPERDEBUG "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_ultradebug() {
        call log_ ULTRADEBUG "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; log_file() {
        call log_ FILE "$@"
        return $?
    }

    #-------------------------------------------------------------------------------
    def; report_() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            report_name="$1"
            report_log="$2"
            should_print="$3"

            if [ "${should_print}" = "" ]; then
                should_print=true
            fi

            prefix="$(eval echo "\${ANSI_COLOR_$(echo "${report_name}" | tr "[:lower:]" "[:upper:]")}EOL")"

            if [ "${should_print}" = true ]; then
                if [ "$(wc -c <"${report_log}")" -gt 0 ]; then
                    message="${prefix%EOL}The following ${report_name}(s) occurred:${ANSI_RESET}\n"
                    >&2 command printf -- "${message}"
                    >>"${FULL_LOG}" command printf -- "${message}"

                    >&2 command sed 's/^/\t/' "${report_log}"
                    >>"${FULL_LOG}" command sed 's/^/\t/' "${report_log}"
                fi
            else
                call log_ultradebug "Skipping ${report_name} Report b/c should_print is '%s'." "${should_print}"
            fi

            exit "${RET_SUCCESS}"
        )
        report_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $report_ret
    }

    #-------------------------------------------------------------------------------
    def; report_errors() {
        call report_ "Error" "${ERROR_AND_FATAL_LOG}" "$1"
    }

    #-------------------------------------------------------------------------------
    def; report_warnings() {
        call report_ "Warning" "${WARNING_LOG}" "$1"
    }

    #-------------------------------------------------------------------------------
    def; report_final_status() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            ret="$1"
            should_print="$2"
            shift 2
            message="$(command printf -- "$@"; command echo EOL)"

            LOG_FATAL_COUNT="$(wc -l <"${FATAL_LOG}")"
            LOG_ERROR_COUNT="$(wc -l <"${ERROR_LOG}")"
            LOG_WARNING_COUNT="$(wc -l <"${WARNING_LOG}")"

            # fixup return code in case it is wrong
            if [ "$ret" -eq 0 ]; then
                if [ "${LOG_FATAL_COUNT}" -gt 0 ]; then
                    ret="${RET_ERROR_UNKNOWN}"
                elif [ "${LOG_ERROR_COUNT}" -gt 0 ]; then
                    ret="${RET_ERROR_UNKNOWN}"
                elif [ "${LOG_WARNING_COUNT}" -gt 0 ]; then
                    if [ "${LOG_WARNING_COUNT}" -gt 1 ]; then
                        ret="${RET_WARNING_MULTIPLE}"
                    else
                        ret="${RET_WARNING_UNKNOWN}"
                    fi
                fi
            fi

            if [ "${should_print}" = true ]; then
                fatal_text=""
                plural=""
                if [ "${LOG_FATAL_COUNT}" -gt 1 ]; then
                    plural="s"
                fi
                if [ "${LOG_FATAL_COUNT}" -gt 0 ]; then
                    fatal_text="$(command printf "%d Fatal Error%s" "${LOG_FATAL_COUNT}" "${plural}")"
                fi

                error_text=""
                plural=""
                if [ "${LOG_ERROR_COUNT}" -gt 1 ]; then
                    plural="s"
                fi
                if [ "${LOG_ERROR_COUNT}" -gt 0 ]; then
                    error_text="$(command printf "%d Error%s" "${LOG_ERROR_COUNT}" "${plural}")"
                fi

                warning_text=""
                plural=""
                if [ "${LOG_WARNING_COUNT}" -gt 1 ]; then
                    plural="s"
                fi
                if [ "${LOG_WARNING_COUNT}" -gt 0 ]; then
                    warning_text="$(command printf "%d Warning%s" "${LOG_WARNING_COUNT}" "${plural}")"
                fi

                before_error_text=""
                before_warning_text=""
                if {
                    [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                    [ "${LOG_ERROR_COUNT}" -gt 0 ] &&
                    [ "${LOG_WARNING_COUNT}" -gt 0 ]
                }; then
                    before_error_text=", "
                    before_warning_text=", and "
                elif {
                    [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                    [ "${LOG_WARNING_COUNT}" -gt 0 ]
                }; then
                    before_warning_text=" and "
                elif {
                    [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                    [ "${LOG_ERROR_COUNT}" -gt 0 ]
                }; then
                    before_error_text=" and "
                elif {
                    [ "${LOG_ERROR_COUNT}" -gt 0 ] &&
                    [ "${LOG_WARNING_COUNT}" -gt 0 ]
                }; then
                    before_warning_text=" and "
                fi

                stored_ret=$ret
                call log_info "%s exiting with return code: %d" "${message%EOL}"  "$ret"
                if [ "$stored_ret" -eq 0 ]; then
                    call log_success_final "%s Completed Successfully." "${message%EOL}"
                elif [ "${LOG_FATAL_COUNT}" -gt 0 ]; then
                    call log_fatal_final "%s Had %s%s%s%s%s." "${message%EOL}" "${fatal_text}" "${before_error_text}" "${error_text}" "${before_warning_text}" "${warning_text}"
                elif [ "${LOG_ERROR_COUNT}" -gt 0 ]; then
                    call log_error_final "%s Had %s%s%s." "${message%EOL}" "${error_text}" "${before_warning_text}" "${warning_text}"
                elif [ "${LOG_WARNING_COUNT}" -gt 0 ]; then
                    call log_warning_final "%s Had %s." "${message%EOL}" "${warning_text}"
                fi
            else
                call log_ultradebug "Skipping Final Report b/c should_print is '%s'." "${should_print}"
            fi

            exit "$ret"
        )
        report_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $report_ret
    }

    #-------------------------------------------------------------------------------
    def; report_all() {
        PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE
        (
            SHELL_SESSION_FILE=""
            export SHELL_SESSION_FILE

            input_ret="$1"
            should_print="$2"
            program_name="$3"

            if [ "${should_print}" = true ]; then
                call log_header "Report:"
            else
                call log_ultradebug "Skipping Report header b/c should_print is '%s'." "${should_print}"
            fi

            call report_warnings "${should_print}"
            call report_errors "${should_print}"
            call report_final_status "${input_ret}" "${should_print}" "${program_name}"
            ret=$?
            if [ "${should_print}" = true ]; then
                message="$(command printf "Fully detailed log is available at '%s'\n" "${FULL_LOG}")"
                >&2 command printf "${message}\n"
                >>"${FULL_LOG}" command printf "${message}\n"
            else
                call log_ultradebug "Skipping Full Report b/c should_print is '%s'." "${should_print}"
            fi
            exit $ret
        )
        report_ret=$?
        SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
        export SHELL_SESSION_FILE
        return $report_ret
    }

    #-------------------------------------------------------------------------------
    # need to make sure these are the REAL paths, so we can compare them
    if [ "${CONSTANTS_TEMP_DIR}" != "" ]; then
        CONSTANTS_TEMP_DIR="$(call rreadlink "${CONSTANTS_TEMP_DIR}")"
    fi
    if [ "${my_tempdir}" != "" ]; then
        my_tempdir="$(call rreadlink "${my_tempdir}")"
    fi

    if {
        [ "${CONSTANTS_TEMP_DIR}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        call ensure_my_tempdir_G
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        CONSTANTS_TEMP_DIR="${my_tempdir}"
        export CONSTANTS_TEMP_DIR

        CONSTANTS_TEMP_LOG_DIR="${CONSTANTS_TEMP_DIR}"/log

        if [ "${CI}" = true ]; then
            CONSTANTS_TEMP_LOG_DIR="${CONSTANTS_TEMP_LOG_DIR}"/$(call get_datetime_stamp_filename_formatted)_$$
        fi

        call ensure_dir "${CONSTANTS_TEMP_LOG_DIR}"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi
        export CONSTANTS_TEMP_LOG_DIR
    fi
    if {
        [ "${FATAL_LOG}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        FATAL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/fatal_only.txt
        export FATAL_LOG
        command printf '' >"${FATAL_LOG}"
    fi
    if {
        [ "${ERROR_LOG}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        ERROR_LOG="${CONSTANTS_TEMP_LOG_DIR}"/errors_only.txt
        export ERROR_LOG
        command printf '' >"${ERROR_LOG}"
    fi
    if {
        [ "${ERROR_AND_FATAL_LOG}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        ERROR_AND_FATAL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/errors_and_fatals_only.txt
        export ERROR_AND_FATAL_LOG
        command printf '' >"${ERROR_AND_FATAL_LOG}"
    fi
    if {
        [ "${WARNING_LOG}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        WARNING_LOG="${CONSTANTS_TEMP_LOG_DIR}"/warnings_only.txt
        export WARNING_LOG
        command printf '' >"${WARNING_LOG}"
    fi
    if {
        [ "${FULL_LOG}" = "" ] ||
        # if we are directly included by the top level file,
        # we do not want to inherit the tempdir or logs from
        # whatever may have invoked that top level file
        [ "$(call array_get_length WAS_SOURCED)" -le 2 ] ||
        # if my_tempdir was changed, we want to use the new
        # tempdir for everything
        [ "${CONSTANTS_TEMP_DIR}" = "${my_tempdir}" ]
    } then
        FULL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/log.txt
        export FULL_LOG
        command printf '' >"${FULL_LOG}"
    fi

    call log_ultradebug "CONSTANTS_TEMP_LOG_DIR=%s" "${CONSTANTS_TEMP_LOG_DIR}"
    call log_ultradebug "FULL_LOG=%s" "${FULL_LOG}"
    call log_ultradebug "ERROR_AND_FATAL_LOG=%s" "${ERROR_AND_FATAL_LOG}"
    call log_ultradebug "FATAL_LOG=%s" "${FATAL_LOG}"
    call log_ultradebug "ERROR_LOG=%s" "${ERROR_LOG}"
    call log_ultradebug "WARNING_LOG=%s" "${WARNING_LOG}"

    #endregion Logging Helpers
    #===============================================================================

    #===============================================================================
    #region Conda Helpers

    #-------------------------------------------------------------------------------
    def; conda_init_G() {
        # intentionally no local scope so it modify globals

        if [ "$1" != "quiet" ]; then
            call log_header "Initializing Conda..."
        else
            call log_ultradebug "Initializing Conda..."
        fi

        # shellcheck disable=SC1091
        call include_G "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "'. conda.sh' failed with error code: %d" "$ret"
            return "${RET_ERROR_CONDA_INIT_FAILED}"
        fi
        PATH="${CONDA_INSTALL_PATH}/bin:$PATH"
        export PATH

        call teetty_G "type conda | head -n 1"
        call teetty_G conda --version

        if [ "$1" != "quiet" ]; then
            call log_footer "Conda Initialized."
        else
            call log_ultradebug "Conda Initialized."
        fi

        return "${RET_SUCCESS}"
    }

    #-------------------------------------------------------------------------------
    def; conda_full_deactivate_G() {
        # intentionally no local scope so it modify globals

        if [ "$1" != "quiet" ]; then
            call log_header "Deactivating Current Conda Environments..."
        else
            call log_ultradebug "Deactivating Current Conda Environments..."
        fi

        while [ "${CONDA_SHLVL}" -gt 0 ]; do
            call teetty_G conda deactivate
            ret=$?
            if [ $ret -ne 0 ]; then
                call log_fatal "'conda deactivate' exited with error code: %d" "$ret"
                return "${RET_ERROR_CONDA_DEACTIVATE_FAILED}"
            fi
        done

        if [ "$1" != "quiet" ]; then
            call log_footer "Conda Environments Deactivated."
        else
            call log_ultradebug "Conda Environments Deactivated."
        fi

        return "${RET_SUCCESS}"
    }

    #-------------------------------------------------------------------------------
    def; conda_activate_env_G() {
        if [ "$2" != "quiet" ]; then
            call log_header "Activating %s Conda Environment..." "$1"
        else
            call log_ultradebug "Activating %s Conda Environment..." "$1"
        fi

        call teetty_G conda activate "$1"
        ret=$?
        if [ $ret -ne 0 ]; then
            call log_fatal "'conda activate \"%s\"' exited with error code: %d" "$1" "$ret"
            return "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
        fi

        if [ "$2" != "quiet" ]; then
            call log_footer "%s Conda Environment Activated." "$1"
        else
            call log_ultradebug "%s Conda Environment Activated." "$1"
        fi

        return "${RET_SUCCESS}"
    }

    #endregion Conda Helpers
    #===============================================================================

fi

#endregion Public *
################################################################################

PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
SHELL_SESSION_FILE=""
export SHELL_SESSION_FILE
(
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE

    ############################################################################
    #region Private *

    #===========================================================================
    #region Private Functions

    #---------------------------------------------------------------------------
    def; __main() {
        call log_fatal "$(call get_my_real_basename) must be sourced"
        return "${RET_ERROR_SCRIPT_WAS_NOT_SOURCED}"
    }

    #---------------------------------------------------------------------------
    def; __sourced_main() {
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

    #endregion Immedate
    ############################################################################
)
ret=$?
SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
export SHELL_SESSION_FILE

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
if [ "$(nullcall array_get_last WAS_SOURCED)" = false ]; then
    __announce_prefix="Invoke"
fi
nullcall log_debug "${__announce_prefix} Completed: $(nullcall get_my_real_fullpath) ($$) [$(nullcall get_my_puuid_basename || echo "$0")]"
unset __announce_prefix

#endregion Announce Ourselves Ending
#===============================================================================

#===============================================================================
#region Exit Or Return

# NOTE: we have to return here if we were sourced otherwise we kill the shell
_THIS_FILE_WAS_SOURCED="$(call array_get_last WAS_SOURCED)"
# If we were the top level include we need to remove ourselves and clean up,
# otherwise, the invoker/includer will do so via the include_G/invoke functions
if {
    [ "$(call array_get_length WAS_SOURCED)" -eq 1 ] &&
    [ "${_THIS_FILE_WAS_SOURCED}" = true ]
}; then
    call array_remove_last WAS_SOURCED
    export WAS_SOURCED
    call array_remove_last SHELL_SOURCE
    export SHELL_SOURCE
    call array_remove_last SHELL_SOURCE_PUUID
    export SHELL_SOURCE_PUUID
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
