#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"
export DOLLAR_UNDER

TEMP_SHELL_SOURCE="./bootstrap.sh"

if [ "${DO_SET_X_BOOTSTRAP}" = true ]; then
    set -x
fi

# NOTE: see usage from batteries-forking-included.sh for command line arguments

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

    PS4="+ \$(set +x; get_my_puuid_basename 2>/dev/null || echo $0):\$LINENO: "

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

    OPTION_SETTRACE=true
    if [ "$(echo $- | grep -e 'x')" != "" ]; then
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

        # for debugging only, might remove later
        __def_G_puuid_temp="$1"

        # incoming $LINENO
        __def_G_lineno=$2

        # get the current context's puuid from the call stack
        __def_G_puuid="$(nullcall array_peek SHELL_CALL_STACK_SOURCE_PUUID)"
        # get the real filepath of the puuid
        __def_G_filepath="$(nullcall dict_get_key "${__def_G_puuid}")"
        # get the context's func name from the call stack
        __def_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"
        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            # get the current parent's lineno
            __def_G_parent_lineno_offset=$(nullcall dict_get_key SHELL_DEF_LINENO "${__def_G_parent_funcname}")
            # recalculate lineno to account for parent's lineno and the global offset
            __def_G_lineno=$(( __def_G_lineno + __def_G_parent_lineno_offset - LINENO_GLOBAL_OFFSET ))
        fi
        # get the func's real name
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
    alias def="def_G \"\$(set +x; get_my_puuid_basename 2>/dev/null || echo \$0\") \"\$LINENO\""

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
        # __call_G_funcname="$3"

        nullcall array_push SHELL_CALL_STACK "$1:$2:$3"
        nullcall array_export SHELL_CALL_STACK

        nullcall array_push SHELL_CALL_STACK_SOURCE_PUUID "$1"
        nullcall array_export SHELL_CALL_STACK_SOURCE_PUUID

        nullcall array_push SHELL_CALL_STACK_SOURCE_LINENO "$2"
        nullcall array_export SHELL_CALL_STACK_SOURCE_LINENO

        nullcall array_push SHELL_CALL_STACK_FUNCNAME "$3"
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

        __call_G_source_puuid="$1"
        __call_G_lineno="$2"
        __call_G_funcname="$3"
        shift 2

        if [ "${LINENO_IS_RELATIVE}" = true ]; then
            __call_G_parent_funcname="$(nullcall array_peek SHELL_CALL_STACK_FUNCNAME)"
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

            >&2 printf -- " %s\n" "$*"
        fi

        nullcall _call_stack_push_G "${__call_G_source_puuid}" "${__call_G_lineno}" "${__call_G_funcname}"

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

        >&2 command printf -- "CALL STACK:\n"
        nullcall print_call_stack

        nullcall _call_stack_pop_G

        set +x "${__MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD}"
        unset __MARXIMUS_SHELL_EXTENSIONS__call_G__OPTIONS_OLD

        return $__call_ret
    }
    # normally aliases cannot use positional parameters BUT
    # this works in bash, dash, zsh b/c we're just using $0
    # shellcheck disable=SC2142
    alias call="call_G \"\$(set +x; nullcall array_peek SHELL_CALL_STACK_SOURCE_PUUID 2>/dev/null || nullcall get_my_puuid_basename 2>/dev/null || echo \$0)\" \"\$LINENO\""

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
            nullcall array_init SHELL_SOURCE_PUUID
        fi
        if [ "${SHELL_SOURCE_PUUID_DICT}" = "" ]; then
            nullcall dict_init SHELL_SOURCE_PUUID_DICT
        fi

        __puuid="$(puuid)"
        __puuid__basename="${__puuid}_$(basename "$1")"
        if [ "${OPTION_SETTRACE}" = true ]; then
            command printf "# %s:'%s'\n" "${__puuid__basename}" "$1"
        fi
        nullcall array_append SHELL_SOURCE_PUUID "${__puuid__basename}"
        nullcall dict_set_key SHELL_SOURCE_PUUID_DICT "${__puuid__basename}" "$1"
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
            eval "__dict__$1__key__$(nullcall __dict_hash_key "$2")=\"$3\""
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
            eval "printf \"%s\" \"\$__dict__$1__key__$(__dict_hash_key "$2")\""
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
    nulldef; dict_has_key() {
        __MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__dict_has_key__OPTIONS_OLD="${-:+"-$-"}"
        set "$(set +x; [ -n "${__MARXIMUS_SHELL_EXTENSIONS_BASE_PREAMBLE__ENABLE_TRACE}" ] && echo -x || echo +x)"

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
}

#-------------------------------------------------------------------------------
nulldef; _shell_source_pop_G() {
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

    # TODO: no vars?
    __call_G_source_puuid="$(nullcall array_get_last SHELL_SOURCE_PUUID)"
    __call_G_lineno="${LINENO_GLOBAL_OFFSET}"  # TODO: 1?
    __call_G_funcname="_"

    nullcall _call_stack_push_G "$__call_G_source_puuid" $__call_G_lineno "$__call_G_funcname"

    unset __call_G_funcname
    unset __call_G_lineno
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

        call _shell_source_push_G "true" "${__LAST_INCLUDE}"

        call _call_stack_push_G "${__LAST_INCLUDE}" "${LINENO_GLOBAL_OFFSET}" "_"

        # shifts off path we are sourcing, but leaves other args intact so they can
        # be used by the sourced script, this is a feature that normal most shells
        # do not support by default
        shift

        # shellcheck disable=SC1090
        . "${__LAST_INCLUDE}"
        ret=$?

        call _call_stack_pop_G

        call _shell_source_pop_G

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

        call _shell_source_push_G "false" "${__LAST_INCLUDE}"

        call _call_stack_push_G "${__LAST_INCLUDE}" "${LINENO_GLOBAL_OFFSET}" "_"

        "$@"
        ret=$?

        call _call_stack_pop_G

        call _shell_source_pop_G

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
#region Includes

call ensure_include_GXY "$(get_my_real_dir_fullpath)/bfi-base.sh"
call ensure_include_GXY "$(get_my_real_dir_fullpath)/batteries-forking-included.sh"

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

    SET_OMEGA_DEBUG=false

    #endregion Constants
    #===========================================================================

    #===========================================================================
    #region "Globals"

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
    def; __main () {
        # command echo "OMEGA_DEBUG=${OMEGA_DEBUG}"
        call log_ultradebug "$(get_my_real_basename) called with '%s'" "$*"

        call batteries_forking_included__bootstrap "$@"
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
