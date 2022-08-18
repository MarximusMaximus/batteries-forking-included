#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"
export DOLLAR_UNDER

TEMP_SHELL_SOURCE="./activate.sh"

if [ "${DO_SET_X_ACTIVATE}" = true ]; then
    set -x
fi

################################################################################
#region Reduced Preamble

#===============================================================================
#region Fallbacks

type BATTERIES_FORKING_INCLUDED_CONSTANTS_LOADED >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then

    # NOTE: some basic definitions to fallback to if constants.sh failed to load
    #   if constant.sh loads, it will override these

    #-------------------------------------------------------------------------------
    log_debug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 2 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "DEBUG: "
            command printf -- "$@"
            command printf -- "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_ultradebug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "ULTRADEBUG: "
            command printf -- "$@"
            command printf -- "\n"
        fi
    }
fi

#endregion Fallbacks
#===============================================================================

#===============================================================================
#region RReadLink

#-------------------------------------------------------------------------------
rreadlink() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    ( # Execute the function in a *subshell* to localize variables and the effect of 'cd'.
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        target=$1
        fname=
        targetDir=
        CDPATH=

        # Try to make the execution environment as predictable as possible:
        # All commands below are invoked via 'command', so we must make sure that 'command'
        # itself is not redefined as an alias or shell function.
        # (NOTE: that command is too inconsistent across shells, so we don't use it.)
        # 'command' is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
        # an external utility version of it (e.g, Ubuntu).
        # 'command' bypasses aliases and shell functions and also finds builtins
        # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
        # to happen.
        { \unalias command; \unset -f command; } >/dev/null 2>&1
        # shellcheck disable=SC2034
        [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on # make zsh find *builtins* with 'command' too.

        while :; do # Resolve potential symlinks until the ultimate target is found.
                [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
                # shellcheck disable=SC2164
                command cd "$(command dirname -- "$target")" # Change to target dir; necessary for correct resolution of target path.
                fname=$(command basename -- "$target") # Extract filename.
                [ "$fname" = '/' ] && fname='' # WARNING: curiously, 'basename /' returns '/'
                if [ -L "$fname" ]; then
                    # Extract [next] target path, which may be defined
                    # relative to the symlink's own directory.
                    # NOTE: We parse 'ls -l' output to find the symlink target
                    # NOTE:     which is the only POSIX-compliant, albeit somewhat fragile, way.
                    target=$(command ls -l "$fname")
                    target=${target#* -> }
                    continue # Resolve [next] symlink target.
                fi
                break # Ultimate target reached.
        done
        targetDir=$(command pwd -P) # Get canonical dir. path
        # Output the ultimate target's canonical path.
        # NOTE: that we manually resolve paths ending in /. and /.. to make sure we have a normalized path.
        if [ "$fname" = '.' ]; then
            command printf '%s\n' "${targetDir%/}"
        elif [ "$fname" = '..' ]; then
            # NOTE: something like /var/.. will resolve to /private (assuming /var@ -> /private/var),
            # NOTE:     i.e. the '..' is applied AFTER canonicalization.
            command printf '%s\n' "$(command dirname -- "${targetDir}")"
        else
            command printf '%s\n' "${targetDir%/}/$fname"
        fi

        return 0
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#endregion RReadLink
#===============================================================================

#===============================================================================
#region Array Implementation

# # initialize an array:
# NOTE: no $ sign on my_array_name
# array_init my_array_name

# # manually iterating an array:
# OIFS="$IFS"
# IFS="${_ARRAY__SEP}"
# NOTE: there IS a $ sign on my_array_name
# for item in $my_array_name; do
#     echo $item
# done
# IFS="$OIFS"

# # append to array:
# NOTE: no $ sign on my_array_name
# array_append my_array_name "my value"

# # get item by index:
# NOTE: no $ sign on my_array_name
# array_get_index my_array_name $index

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

if [ "$ZSH_VERSION" != "" ]; then
    setopt sh_word_split
fi

_ARRAY__SEP="$(command printf "\t")"; export _ARRAY__SEP
#                                      x12345678x
_ARRAY__SEP__ESCAPED="$(command printf "\\\\\\\\t")"; export _ARRAY__SEP__ESCAPED

#-------------------------------------------------------------------------------
_array_escape() {
    #                                        x1234x                                  x12x1234567890123456x
    command echo "$1" | sed -e "s/${_ARRAY__SEP}/\\\\${_ARRAY__SEP__ESCAPED}/g" -e 's/\\/\\\\\\\\\\\\\\\\/g'
}

#-------------------------------------------------------------------------------
_array_unescape() {
    # NOTE: This doesn't look like the inverse of what _array_escape does, but
    #   it works correctly
    #                                           x1234x12x           x12345678x
    command printf "$(command echo "$1" | sed -e 's/\\\\/\\/g' -e "s/\\\\\\\\${_ARRAY__SEP__ESCAPED}/${_ARRAY__SEP}/g")"
}

#-------------------------------------------------------------------------------
_array_fix_index() {
    __ARRAY__ARRAY_FIX_INDEX__LENGTH="$(array_get_length "$1")"

    __ARRAY__ARRAY_FIX_INDEX__INDEX="$2"

    if [ "${__ARRAY__ARRAY_FIX_INDEX__INDEX}" -lt 0 ]; then
        __ARRAY__ARRAY_FIX_INDEX__INDEX="$(( __ARRAY__ARRAY_FIX_INDEX__LENGTH + __ARRAY__ARRAY_FIX_INDEX__INDEX ))"
        # __ARRAY__ARRAY_FIX_INDEX__INDEX="$(( __ARRAY__ARRAY_FIX_INDEX__INDEX + 1 ))"
    fi

    command printf "%d" "${__ARRAY__ARRAY_FIX_INDEX__INDEX}"
}

#-------------------------------------------------------------------------------
array_init() {
    eval "$1=\"\""
}

#-------------------------------------------------------------------------------
array_append() {
    __ARRAY__ARRAY_APPEND__TEMP_VALUE=$(_array_escape "$2")
    __ARRAY__ARRAY_APPEND__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
    if [ "${__ARRAY__ARRAY_APPEND__TEMP_STORAGE}" = "" ]; then
        eval "$1=\"${__ARRAY__ARRAY_APPEND__TEMP_VALUE}\""
    else
        # WARNING: DO NOT ESCAPE THE { } AROUND $1 HERE
        eval "$1=\"\${$1}$_ARRAY__SEP${__ARRAY__ARRAY_APPEND__TEMP_VALUE}\""
    fi
}

#-------------------------------------------------------------------------------
array_append_back() {
    array_append "$1" "$2"
}

#-------------------------------------------------------------------------------
array_append_front() {
    array_insert_index "$1" 0 "$2"
}

#-------------------------------------------------------------------------------
array_get_first() {
    array_get_index "$1" 0
}

#-------------------------------------------------------------------------------
array_get_last() {
    array_get_index "$1" -1
}

#-------------------------------------------------------------------------------
array_copy() {
    __ARRAY__ARRAY_COPY__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"

    array_init "$2"

    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    for item in ${__ARRAY__ARRAY_COPY__TEMP_STORAGE}; do
        item="$(_array_unescape "${item}")"
        array_append "$2" "${item}"
    done
    IFS="$OIFS"
}

#-------------------------------------------------------------------------------
array_remove_first() {
    array_remove_index "$1" 0
}

#-------------------------------------------------------------------------------
array_remove_last() {
    array_remove_index "$1" -1
}

#-------------------------------------------------------------------------------
array_insert_index() {
    array_copy "$1" __ARRAY__ARRAY_INSERT_INDEX__TEMP_ARRAY

    __ARRAY__ARRAY_INSERT_INDEX__LAST_INDEX="$(array_get_length "$1")"

    __ARRAY__ARRAY_INSERT_INDEX__COUNT=0

    __ARRAY__ARRAY_INSERT_INDEX__INDEX="$2"
    __ARRAY__ARRAY_INSERT_INDEX__INDEX="$(_array_fix_index "$1" "${__ARRAY__ARRAY_INSERT_INDEX__INDEX}")"

    __ARRAY__ARRAY_INSERT_INDEX__INSERTED=false

    array_init "$1"

    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    for item in ${__ARRAY__ARRAY_INSERT_INDEX__TEMP_ARRAY}; do
        item="$(_array_unescape "${item}")"
        if [ "${__ARRAY__ARRAY_INSERT_INDEX__COUNT}" -eq "${__ARRAY__ARRAY_INSERT_INDEX__INDEX}"  ]; then
            array_append "$1" "$3"
            __ARRAY__ARRAY_INSERT_INDEX__INSERTED=true
        fi
        array_append "$1" "${item}"
        __ARRAY__ARRAY_INSERT_INDEX__COUNT=$(( __ARRAY__ARRAY_INSERT_INDEX__COUNT + 1 ))
    done

    if \
        [ "${__ARRAY__ARRAY_INSERT_INDEX__LAST_INDEX}" -eq "${__ARRAY__ARRAY_INSERT_INDEX__COUNT}" ] &&
        [ "${__ARRAY__ARRAY_INSERT_INDEX__INSERTED}" = false  ]
    then
        array_append "$1" "$3"
    fi

    IFS="$OIFS"
}

#-------------------------------------------------------------------------------
array_remove_index() {
    array_copy "$1" __ARRAY__ARRAY_REMOVE_INDEX__TEMP_ARRAY

    __ARRAY__ARRAY_REMOVE_INDEX__INDEX="$2"
    __ARRAY__ARRAY_REMOVE_INDEX__INDEX="$(_array_fix_index "$1" "${__ARRAY__ARRAY_REMOVE_INDEX__INDEX}")"

    __ARRAY__ARRAY_REMOVE_INDEX__COUNT=0

    array_init "$1"

    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    for item in ${__ARRAY__ARRAY_REMOVE_INDEX__TEMP_ARRAY}; do
        item="$(_array_unescape "${item}")"
        if [ "${__ARRAY__ARRAY_REMOVE_INDEX__COUNT}" -ne  "${__ARRAY__ARRAY_REMOVE_INDEX__INDEX}"  ]; then
            array_append "$1" "${item}"
        fi
        __ARRAY__ARRAY_REMOVE_INDEX__COUNT=$(( __ARRAY__ARRAY_REMOVE_INDEX__COUNT + 1 ))
    done
    IFS="$OIFS"
}

#-------------------------------------------------------------------------------
array_get_length() {
    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    __ARRAY__ARRAY_GET_LENGTH__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
    __ARRAY__ARRAY_GET_LENGTH__COUNT=0
    for item in $__ARRAY__ARRAY_GET_LENGTH__TEMP_STORAGE; do
        __ARRAY__ARRAY_GET_LENGTH__COUNT=$(( __ARRAY__ARRAY_GET_LENGTH__COUNT + 1 ))
    done
    IFS="$OIFS"
    command echo "${__ARRAY__ARRAY_GET_LENGTH__COUNT}"
}

#-------------------------------------------------------------------------------
array_get_index() {
    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"

    __ARRAY__ARRAY_GET_INDEX__INDEX="$2"
    __ARRAY__ARRAY_GET_INDEX__INDEX="$(_array_fix_index "$1" "${__ARRAY__ARRAY_GET_INDEX__INDEX}")"

    __ARRAY__ARRAY_GET_INDEX__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
    __ARRAY__ARRAY_GET_INDEX__COUNT=0
    __ARRAY__ARRAY_GET_INDEX__FOUND=false

    for item in $__ARRAY__ARRAY_GET_INDEX__TEMP_STORAGE; do
        if [ "${__ARRAY__ARRAY_GET_INDEX__COUNT}" -eq "${__ARRAY__ARRAY_GET_INDEX__INDEX}" ]; then
            item="$(_array_unescape "$item")"
            command printf "%s" "${item}"
            __ARRAY__ARRAY_GET_INDEX__FOUND=true
            break
        fi
        __ARRAY__ARRAY_GET_INDEX__COUNT=$(( __ARRAY__ARRAY_GET_INDEX__COUNT + 1 ))
    done
    IFS="$OIFS"

    if [ "${__ARRAY__ARRAY_GET_INDEX__FOUND}" = true ]; then
        return 0
    fi
    return 1
}

# # using array_for_each:
# my_func() {
#     echo "${item}"
# }
# array_for_each the_array_name my_func
## NOTE: no $ on 'the_array_name' nor 'my_func'

#-------------------------------------------------------------------------------
array_for_each() {
    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    __ARRAY__ARRAY_FOR_EACH__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
    for item in $__ARRAY__ARRAY_FOR_EACH__TEMP_STORAGE; do
        item="$(_array_unescape "$item")"
        eval "$2"
    done
    IFS="$OIFS"
}

#endregion Arrays
#===============================================================================

#===============================================================================
#region Helper Functions

#-------------------------------------------------------------------------------
get_my_real_fullpath() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        if [ "$(array_get_length SHELL_SOURCE)" -gt 0 ]; then
            array_get_last SHELL_SOURCE
        else
            echo "UNKNOWN"
            exit 1 # "${RET_ERROR_UNKNOWN}"
        fi

        exit 0 # "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
get_my_real_basename() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        if [ "$(array_get_length SHELL_SOURCE)" -gt 0 ]; then
            basename "$(array_get_last SHELL_SOURCE)"
        else
            echo "UNKNOWN"
            exit 1 # "${RET_ERROR_UNKNOWN}"
        fi

        exit 0 # "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
get_my_real_dir_basename() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        if [ "$(array_get_length SHELL_SOURCE)" -gt 0 ]; then
            basename "$(dirname "$(array_get_last SHELL_SOURCE)")"
        else
            echo "UNKNOWN"
            exit 1 # "${RET_ERROR_UNKNOWN}"
        fi

        exit 0 # "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#endregion Helper Functions
#===============================================================================

#===============================================================================
#region Source/Invoke Check For Top Level File

log_ultradebug "env vars:\n%s" "$(env -0 | sort -z | tr '\0' '\n')"

if [ "${WAS_SOURCED}" = "" ]; then
    WAS_SOURCED=""
    array_init WAS_SOURCED
fi
if [ "${SHELL_SOURCE}" = "" ]; then
    SHELL_SOURCE=""
    array_init SHELL_SOURCE
fi

# NOTE: that all these detection methods only work for the FIRST file
#   that is invoked or sourced, all others must be handled by the
#   include_G, ensure_include_GXY, and invoke functions.
if [ "$(array_get_length SHELL_SOURCE)" -eq 0 ]; then
    TEMP_FILE_NAME=""
    log_ultradebug "\$0=$0"
    TEMP_ARG_ZERO="$0"
    log_ultradebug "\${TEMP_ARG_ZERO}=${TEMP_ARG_ZERO}"
    TEMP_ARG_ZERO="${TEMP_ARG_ZERO##*[/\\]}"
    log_ultradebug "\${TEMP_ARG_ZERO}=${TEMP_ARG_ZERO}"
    case "${TEMP_ARG_ZERO}" in
        bash|dash|sh|sw-bash|sw-dash|sw-sh)  # zsh handled later
            log_ultradebug "\$0 was a known shell (not zsh)."
            # # bash, dash, sh(bash), sh(dash), sh(zsh) sourced
            # shellcheck disable=SC2128
            if [ -n "${BASH_SOURCE}" ]; then
                # bash, sh(bash) sourced
                log_ultradebug "\$BASH_SOURCE exists."
                # shellcheck disable=SC3054
                log_ultradebug "\${BASH_SOURCE[0]}=${BASH_SOURCE[0]}"
                # shellcheck disable=SC3054
                TEMP_FILE_NAME="${BASH_SOURCE[0]}"
            else
                log_ultradebug "\$BASH_SOURCE does NOT exist."
                log_ultradebug "\(which lsof)=$(which lsof)"
                log_ultradebug "\$?=$?"
                # dash, sh(dash) sourced
                x="$(lsof -p $$ -Fn0 | tail -1)"
                TEMP_FILE_NAME="${x#n}"
                if [ "$(command echo "${TEMP_FILE_NAME}" | grep -e "^->0x")" != "" ]; then
                    # sh(zsh) sourced
                    log_ultradebug "TEMP_FILE_NAME starts with '->0x', this is zsh sourced."
                    TEMP_FILE_NAME="${DOLLAR_UNDER}"
                fi
            fi
            array_append WAS_SOURCED true
            ;;
        ????????-????-????-????-????????????.sh|????????-????-????-????-????????????)
            log_ultradebug "\$0 resembles a uuid, probably is github sourced."
            # github sourced, multi-command
            array_append WAS_SOURCED true
            log_ultradebug "$0"
            log_ultradebug "$*"
            env | sort
            if [ "${TEMP_SHELL_SOURCE}" != "" ]; then
                TEMP_FILE_NAME="${TEMP_SHELL_SOURCE}"
            fi
            printenv | sort
            ;;
        *)
            # bash, dash, sh(bash), zsh invoked
            # zsh sourced
            log_ultradebug "Some other shell?"
            log_ultradebug "\(which lsof)=$(which lsof)"
            log_ultradebug "\$?=$?"
            if [ "$(which lsof)" != "" ]; then
                x="$(lsof -p $$ -Fn0 | tail -1)"
                x="${x#*n}"
            else
                x="NONE"
            fi
            if [ -f "$x" ]; then
                x="$(rreadlink "$x")"
            fi
            TEMP_FILE_NAME="$(rreadlink "$0")"
            log_ultradebug "TEMP_FILE_NAME: ${TEMP_FILE_NAME}"
            log_ultradebug "x:              ${x}"
            if [ "${TEMP_FILE_NAME}" != "${x}" ]; then
                log_ultradebug "TEMP_FILE_NAME and x are different."
                if [ "$(echo "${x}" | grep -e 'pipe')" != "" ]; then
                    log_ultradebug "x is 'pipe', probably github invoked."
                    # github invoked
                    array_append WAS_SOURCED false
                elif [ "${x}" = "NONE" ]; then
                    log_ultradebug "lsof not available, probably wsl invoked."
                    # wsl doesn't always have lsof, so invoked
                    array_append WAS_SOURCED false
                else
                    log_ultradebug "x is NOT 'pipe', probably zsh sourced."
                    # zsh sourced
                    array_append WAS_SOURCED true
                fi
            else
                log_ultradebug "TEMP_FILE_NAME and x are the SAME, likely invoked."
                # bash, dash, sh(bash), zsh invoked
                array_append WAS_SOURCED false
            fi
            ;;
    esac
    log_ultradebug "TEMP_FILE_NAME=${TEMP_FILE_NAME}"
    TEMP_FILE_NAME="$(rreadlink "${TEMP_FILE_NAME}")"
    log_ultradebug "TEMP_FILE_NAME=${TEMP_FILE_NAME}"
    array_append SHELL_SOURCE "${TEMP_FILE_NAME}"
fi

unset x
unset TEMP_ARG_ZERO
unset TEMP_FILE_NAME
unset TEMP_SHELL_SOURCE
unset DOLLAR_UNDER

export WAS_SOURCED
export SHELL_SOURCE

# sometimes shellcheck thinks log_ultradebug is only defined later, not before
# shellcheck disable=SC2218
log_ultradebug "WAS_SOURCED: $WAS_SOURCED"
# shellcheck disable=SC2218
log_ultradebug "SHELL_SOURCE: $SHELL_SOURCE"

#endregion Source/Invoke Check For Top Level File
#===============================================================================

#===============================================================================
#region Announce Ourself

if [ "$(array_get_last WAS_SOURCED)" = false ]; then
    log_debug "Invoked: $(get_my_real_fullpath) ($$)"
else
    log_debug "Sourced: $(get_my_real_fullpath) ($$)"
fi

#endregion Announce Ourself
#===============================================================================

#endregion Preamble
################################################################################

################################################################################
#region Immediate

# NOTE: generally no privates, subshells, or functions b/c we need to modify the
# environment, but pollute it as little as possible with private names (e.g. __main)

__bfi_activate_environment() {
    if [ "$(array_get_last WAS_SOURCED)" = false ]; then
        >&2 command printf "FATAL: $(get_my_real_basename) should not be invoked, only sourced\n"
        return 151 # "${RET_ERROR_SCRIPT_WAS_NOT_SOURCED}"
    fi

    CONDA_INSTALL_PATH="/opt/conda/miniforge"; export CONDA_INSTALL_PATH
    if [ "${CI}" = true ]; then
        if [ "${GITHUB_ACTIONS}" = true ]; then
            CONDA_INSTALL_PATH="${HOME}/opt/conda/miniforge"; export CONDA_INSTALL_PATH
            mkdir -p "${CONDA_INSTALL_PATH}"
        fi
    fi

    # shellcheck disable=SC1091
    . "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"
    ret=$?
    if [ $ret -ne 0 ]; then
        >&2 command printf "FATAL: '. conda.sh' failed with error code: %d\n" "$ret"
        return 159 # "${RET_ERROR_CONDA_INIT_FAILED}"
    fi
    PATH="${CONDA_INSTALL_PATH}/bin:$PATH"
    export PATH

    type conda | head -n 1
    conda --version

    while [ "${CONDA_SHLVL}" -gt 0 ]; do
        conda deactivate
        ret=$?
        if [ $ret -ne 0 ]; then
            >&2 command printf "FATAL: 'conda deactivate' exited with error code: %d\n" "$ret"
            return 147 # "${RET_ERROR_CONDA_DEACTIVATE_FAILED}"
        fi
    done

    conda activate "$(get_my_real_dir_basename)"
    ret=$?
    if [ $ret -ne 0 ]; then
        >&2 command printf "FATAL: 'conda activate \"%s\"' exited with error code: %d\n" "$(get_my_real_dir_basename)" "$ret"
        return 144 # "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
    fi

    command printf "%s Conda Environment Activated.\n" "$(get_my_real_dir_basename)"

    return 0 # "${RET_SUCCESS}"
}
if [ "${_IS_UNDER_TEST}" = "true" ]; then
    type inject_monkeypatch >/dev/null 2>&1
    monkeypatch_ret=$?
    if [ $monkeypatch_ret -eq 0 ]; then
        inject_monkeypatch
    fi
fi
__bfi_activate_environment
ret=$?

#endregion Immediate
################################################################################

################################################################################
#region Postamble

#===============================================================================
#region PytestShellTestHarness Postamble

if [ "${_IS_UNDER_TEST}" = "true" ]; then
    type inject_monkeypatch >/dev/null 2>&1
    monkeypatch_ret=$?
    if [ $monkeypatch_ret -eq 0 ]; then
        inject_monkeypatch
    fi
fi

#endregion PytestShellTestHarness Postamble
#===============================================================================

#===============================================================================
#region Track Sourcing

if [ "$(array_get_last WAS_SOURCED)" = true ]; then
    log_debug "Source Completed: $(get_my_real_fullpath) ($$)"
else
    log_debug "Invoke Completed: $(get_my_real_basename) ($$)"
fi

#endregion Track Sourcing
#===============================================================================

# NOTE: we have to return here if we were sourced otherwise we kill the shell
_THIS_FILE_WAS_SOURCED="$(array_get_last WAS_SOURCED)"
if [ "$(array_get_length WAS_SOURCED)" -eq 1 ]; then
    unset WAS_SOURCED
    unset SHELL_SOURCE
else
    array_remove_last WAS_SOURCED
    array_remove_last SHELL_SOURCE
    export WAS_SOURCED
    export SHELL_SOURCE
fi
if [ "${_THIS_FILE_WAS_SOURCED}" = false ]; then
    exit $ret
else
    return $ret
fi

#endregion Postamble
################################################################################
