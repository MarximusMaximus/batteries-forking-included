#!/usr/bin/env sh
# shellcheck disable=SC2034


################################################################################
#region Preamble

#===============================================================================
#region Fallbacks

type CONDA_BOOTSTRAPPER_CONSTANTS_LOADED >/dev/null 2>&1
ret=$?
if [ $ret -ne 0 ]; then

    # NOTE: some basic definitions to fallback to if constants.sh failed to load
    #   if constant.sh loads, it will override these

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
    log_fatal() {
        >&2 command printf "FATAL: "
        >&2 command printf "$@"
        >&2 command printf "\n"
    }

    #-------------------------------------------------------------------------------
    log_error() {
        >&2 command printf "ERROR: "
        >&2 command printf "$@"
        >&2 command printf "\n"
    }

    #-------------------------------------------------------------------------------
    log_warning() {
        >&2 command printf "WARNING: "
        >&2 command printf "$@"
        >&2 command printf "\n"
    }

    #-------------------------------------------------------------------------------
    log_info() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf "INFO: "
            command printf "$@"
            command printf "\n"
        fi

    }

    #-------------------------------------------------------------------------------
    log_debug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 2 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf "DEBUG: "
            command printf "$@"
            command printf "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_superdebug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 3 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf "SUPERDEBUG: "
            command printf "$@"
            command printf "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_ultradebug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf "ULTRADEBUG: "
            command printf "$@"
            command printf "\n"
        fi
    }
fi

#endregion Fallbacks
#===============================================================================

#===============================================================================
#region RReadLink

#-------------------------------------------------------------------------------
rreadlink() {
    ( # Execute the function in a *subshell* to localize variables and the effect of `cd`.

        target=$1
        fname=
        targetDir=
        CDPATH=

        # Try to make the execution environment as predictable as possible:
        # All commands below are invoked via `command`, so we must make sure that `command`
        # itself is not redefined as an alias or shell function.
        # (NOTE: that command is too inconsistent across shells, so we don't use it.)
        # `command` is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
        # an external utility version of it (e.g, Ubuntu).
        # `command` bypasses aliases and shell functions and also finds builtins
        # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
        # to happen.
        { \unalias command; \unset -f command; } >/dev/null 2>&1
        # shellcheck disable=SC2034
        [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on # make zsh find *builtins* with `command` too.

        while :; do # Resolve potential symlinks until the ultimate target is found.
                [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
                # shellcheck disable=SC2164
                command cd "$(command dirname -- "$target")" # Change to target dir; necessary for correct resolution of target path.
                fname=$(command basename -- "$target") # Extract filename.
                [ "$fname" = '/' ] && fname='' # WARNING: curiously, `basename /` returns '/'
                if [ -L "$fname" ]; then
                    # Extract [next] target path, which may be defined
                    # relative to the symlink's own directory.
                    # NOTE: We parse `ls -l` output to find the symlink target
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
        elif    [ "$fname" = '..' ]; then
            # NOTE: something like /var/.. will resolve to /private (assuming /var@ -> /private/var),
            # NOTE:     i.e. the '..' is applied AFTER canonicalization.
            command printf '%s\n' "$(command dirname -- "${targetDir}")"
        else
            command printf '%s\n' "${targetDir%/}/$fname"
        fi
    )
}

#endregion RReadLink
#===============================================================================

#===============================================================================
#region Root User Check

require_not_root_user() {
    # intentionally no local scope so it can exit script

    # shellcheck disable=SC3028
    if [ $UID -eq 0 ] || [ $EUID -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
        if [ "$(array_get_last WAS_SOURCED)" -eq 0 ]; then
            log_fatal "${MY_BASENAME} should not be run as root nor with sudo"
        else
            log_fatal "$(array_get_last SOURCED_BASENAME) should not be run as root nor with sudo"
        fi
        exit "${RET_ERROR_USER_IS_ROOT}"
    fi
}

require_root_user() {
    # intentionally no local scope so it can exit script

    # shellcheck disable=SC3028
    if [ $UID -ne 0 ] && [ $EUID -ne 0 ] && [ "$(id -u)" -ne 0 ]; then
        if [ "$(array_get_last WAS_SOURCED)" -eq 0 ]; then
            log_fatal "${MY_BASENAME} MUST be run as root or with sudo"
        else
            log_fatal "$(array_get_last SOURCED_BASENAME) MUST be run as root or with sudo"
        fi
        exit "${RET_ERROR_USER_IS_NOT_ROOT}"
    fi
}

#endregion Root User Check
#===============================================================================

#===============================================================================
#region Include Directives

include() {
    # intentionally no local scope so it modify globals

    # shellcheck disable=SC1090
    . "$1"
    return $?
}

ensure_include() {
    # intentionally no local scope so it can modify globals AND exit script

    include "$1"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "Failed to source '%s'" "$1"
        exit "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
    fi
}

#endregion Include Directives
#===============================================================================

#===============================================================================
#region Arrays

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

_ARRAY__SEP="$(printf "\t")"; export _ARRAY__SEP
#                           x12345678x
_ARRAY__SEP__ESCAPED="$(printf "\\\\\\\\t")"; export _ARRAY__SEP__ESCAPED

#-------------------------------------------------------------------------------
_array_escape() {
    #                                      x1234x                               x12x1234567890123456x
    command echo "$1" | sed "s/${_ARRAY__SEP}/\\\\${_ARRAY__SEP__ESCAPED}/g" | sed 's/\\/\\\\\\\\\\\\\\\\/g'
}

#-------------------------------------------------------------------------------
_array_unescape() {
    # NOTE: This doesn't look like the inverse of what _array_escape does, but
    #   it works correctly
    #                                           x1234x12x           x12345678x
    command printf "$(command echo "$1" | sed 's/\\\\/\\/g' | sed "s/\\\\\\\\${_ARRAY__SEP__ESCAPED}/${_ARRAY__SEP}/g")"
}

_array_fix_index() {
    __ARRAY__ARRAY_FIX_INDEX__LENGTH="$(array_get_length "$1")"

    __ARRAY__ARRAY_FIX_INDEX__INDEX="$2"

    if [ "${__ARRAY__ARRAY_FIX_INDEX__INDEX}" -lt 0 ]; then
        __ARRAY__ARRAY_FIX_INDEX__INDEX="$(( __ARRAY__ARRAY_FIX_INDEX__LENGTH + __ARRAY__ARRAY_FIX_INDEX__INDEX ))"
        # __ARRAY__ARRAY_FIX_INDEX__INDEX="$(( __ARRAY__ARRAY_FIX_INDEX__INDEX + 1 ))"
    fi

    printf "%d" "${__ARRAY__ARRAY_FIX_INDEX__INDEX}"
}

array_init() {
    eval "$1=\"\""
}

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

array_append_back() {
    array_append "$1" "$2"
}

array_append_front() {
    array_insert_index "$1" 0 "$2"
}

array_get_first() {
    array_get_index "$1" 0
}

array_get_last() {
    array_get_index "$1" -1
}

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

array_remove_first() {
    array_remove_index "$1" 0
}

array_remove_last() {
    array_remove_index "$1" -1
}

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

array_get_length() {
    OIFS="$IFS"
    IFS="${_ARRAY__SEP}"
    __ARRAY__ARRAY_GET_LENGTH__TEMP_STORAGE="$(eval command echo \"\$\{"$1"\}\")"
    __ARRAY__ARRAY_GET_LENGTH__COUNT=0
    for item in $__ARRAY__ARRAY_GET_LENGTH__TEMP_STORAGE; do
        __ARRAY__ARRAY_GET_LENGTH__COUNT=$(( __ARRAY__ARRAY_GET_LENGTH__COUNT + 1 ))
    done
    IFS="$OIFS"
    printf "%d" "${__ARRAY__ARRAY_GET_LENGTH__COUNT}"
}

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
#region source check

if [ "${WAS_SOURCED}" = "" ]; then
    array_init WAS_SOURCED
fi

# WARNING: _THIS_FILE_WAS_SOURCED is not script safe, it only is valid during
#   and immediately after the block that set it; other scripts that get sourced
#   WILL overwrite it
_THIS_FILE_WAS_SOURCED=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) _THIS_FILE_WAS_SOURCED=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    # shellcheck disable=SC2296
    [ "$(cd "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] && _THIS_FILE_WAS_SOURCED=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && _THIS_FILE_WAS_SOURCED=1
else # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) _THIS_FILE_WAS_SOURCED=1;; esac
fi
array_append WAS_SOURCED "${_THIS_FILE_WAS_SOURCED}"
export WAS_SOURCED

#endregion source check
#===============================================================================


if [ "$(array_get_last WAS_SOURCED)" -eq 0 ]; then
    #===========================================================================
    #region Self Referentials

    MY_FULLPATH="$(rreadlink "$0")"
    export MY_FULLPATH
    MY_BASENAME="$(basename "${MY_FULLPATH}")"
    export MY_BASENAME
    MY_DIR_FULLPATH="$(dirname -- "${MY_FULLPATH}")"
    export MY_DIR_FULLPATH
    MY_DIR_BASENAME="$(basename -- "${MY_DIR_FULLPATH}")"
    export MY_DIR_BASENAME
    CONDA_BOOTSTRAPPER_FULLPATH="${MY_DIR_FULLPATH}/../conda-bootstrapper"
    export CONDA_BOOTSTRAPPER_FULLPATH

    #endregion Self Referentials
    #===========================================================================

    #===========================================================================
    #region Announce Ourself (Not Sourced)

    log_debug "Invoked: ${MY_FULLPATH} ($$)"

    #endregion Announce Ourself (Not Sourced)

    #===========================================================================
else
    #===========================================================================
    #region Track Sourcing

    # make best effort to figure out our name if we were sourced and print it

    if [ "${SOURCED_FULLPATH}" = "" ]; then
        array_init SOURCED_FULLPATH
    fi
    if [ "${SOURCED_BASENAME}" = "" ]; then
        array_init SOURCED_BASENAME
    fi
    if [ "${SOURCED_DIR_FULLPATH}" = "" ]; then
        array_init SOURCED_DIR_FULLPATH
    fi
    if [ "${SOURCED_DIR_BASENAME}" = "" ]; then
        array_init SOURCED_DIR_BASENAME
    fi

    OUR_SOURCED_FULLPATH=""
    # bash
    if test -n "$BASH"; then
        # shellcheck disable=SC3028,SC3054
        OUR_SOURCED_FULLPATH=${BASH_SOURCE[0]}
    # ksh
    elif test -n "$TMOUT"; then
        # shellcheck disable=SC2296
        OUR_SOURCED_FULLPATH=${.sh.file}
    # zsh
    elif test -n "$ZSH_NAME" ; then
        # shellcheck disable=SC2296
        OUR_SOURCED_FULLPATH=${(%):-%x}
    # dash
    elif test "${0##*/}" = dash; then
        x=$(lsof -p $$ -Fn0 | tail -1); OUR_SOURCED_FULLPATH=${x#n}
    fi

    if [ "${OUR_SOURCED_FULLPATH}" != "" ]; then
        array_append SOURCED_FULLPATH "$(rreadlink "${OUR_SOURCED_FULLPATH}")"
        array_append SOURCED_BASENAME "$(basename "${OUR_SOURCED_FULLPATH}")"
        array_append SOURCED_DIR_FULLPATH "$(dirname -- "${OUR_SOURCED_FULLPATH}")"
        array_append SOURCED_DIR_BASENAME "$(basename -- "${SOURCED_DIR_FULLPATH}")"
    else
        array_append SOURCED_FULLPATH ""
        array_append SOURCED_BASENAME ""
        array_append SOURCED_DIR_FULLPATH ""
        array_append SOURCED_DIR_BASENAME ""
    fi
    export SOURCED_FULLPATH
    export SOURCED_BASENAME
    export SOURCED_DIR_FULLPATH
    export SOURCED_DIR_BASENAME

    #endregion Track Sourcing
    #===========================================================================

    #===========================================================================
    #region Announce Ourself (Sourced)

    if [ "${OUR_SOURCED_FULLPATH}" != "" ]; then
        log_debug "Sourced: $(array_get_last SOURCED_FULLPATH) ($$)"
    else
        log_debug "Sourced: Unknown Path ($$)"
    fi

    #endregion Announce Ourself (Sourced)
    #===========================================================================
fi

#endregion Preamble
################################################################################

################################################################################
#region Public *

#===============================================================================
#region Create Fence

CONDA_BOOTSTRAPPER_CONSTANTS_LOADED() { true; }

#endregion Create Fence
#===============================================================================

#===============================================================================
#region Return Codes

RET_SUCCESS=0; export RET_SUCCESS

RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN

# Local Errors 2-63 (61)
# define these in individual scripts

# Local Warnings 64-127 (63)
# define these in individual scripts

# Global Errors 128-191 (63, but 16 are pre-reserved, so really 47)
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

# Global Warnings 192-253 (61, but 2 reserved, so really 59)
RET_WARNING_UNKNOWN=192; export RET_WARNING_UNKNOWN
RET_WARNING_MULTIPLE=193; export RET_WARNING_MULTIPLE


# Special code for when Usage gets printed out
RET_ERROR_USAGE_PRINTED=254; export RET_ERROR_USAGE_PRINTED

# Reserved b/c shell weirdness
RET_ERROR_UNKNOWN_255=255; export RET_ERROR_UNKNOWN_255
RET_ERROR_UNKNOWN_NEG1=-1; export RET_ERROR_UNKNOWN_NEG1

#endregion Return Codes
#===============================================================================

#===============================================================================
#region Constants

CONDA_INSTALL_PATH="/opt/conda/miniforge"
DATETIME_STAMP_FORMAT="+%Y-%m-%d %H:%M:%S"

#endregion Constants
#===============================================================================

#===============================================================================
#region Platform Constants

PLATFORM=$(uname)
export PLATFORM
REAL_PLATFORM=${REAL_PLATFORM:-${PLATFORM}}
export REAL_PLATFORM

if [ "${REAL_PLATFORM}" = "Darwin" ]; then
    date() {
        command date -j "$@"
    }
elif [ "${REAL_PLATFORM}" = "Linux" ]; then
    date() {
        command date "$@"
    }
fi

PLATFORM_IS_WSL=false
if [ "$(uname -a | grep '\(microsoft\|Microsoft\|WSL\)')" != "" ]; then
    PLATFORM_IS_WSL=true
fi

#endregion Platform Constants
#===============================================================================

#===============================================================================
#region Calculated "Constants"

set_calculated_constants() {
    CONDA_BASE_DIR_FULLPATH="$(dirname "$(dirname "${CONDA_EXE}")")"; export CONDA_BASE_DIR_FULLPATH
}
set_calculated_constants

#endregion Calculated "Constants"
#===============================================================================

#===============================================================================
#region Colorized Output Constants & Helper Functions

ANSI_CODE_START="\033["
ANSI_CODE_END="m"

#-------------------------------------------------------------------------------
get_ansi_code()
{
    (
        ending="$3"
        if [ "${ending}" = "" ]; then
            ending="${ANSI_CODE_END}"
        fi
        # shellcheck disable=SC2154 # because "colorize_output" may or may not exist
        if [ "$(command echo "${TERM}" | grep 'mono')" != "" ] ||
            [ "$(tput colors)" -lt 16 ] ||
            [ "${NO_COLOR}" != "" ] ||
            [ "${colorized_output}" = false ];
        then
            command printf ""
        elif [ "${colorized_output}" = "alt" ] && [ "$2" != "" ]; then
            # shellcheck disable=SC2059
            command printf "${ANSI_CODE_START}$2${ending}"
        else
            # shellcheck disable=SC2059
            command printf "${ANSI_CODE_START}$1${ending}"
        fi
    )
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_up() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'A')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_down() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'B')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_right() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'C')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_left() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'D')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_nextline() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'E')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_prevline() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'F')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_col() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'G')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_pos() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1;$2" '' 'H')"
}

#-------------------------------------------------------------------------------
set_ansi_code_constants() {
    ANSI_FG_BLACK="$(get_ansi_code '0;30')"; export ANSI_FG_BLACK
    ANSI_FG_RED="$(get_ansi_code '0;31')"; export ANSI_FG_RED
    ANSI_FG_GREEN="$(get_ansi_code '0;32')"; export ANSI_FG_GREEN
    ANSI_FG_YELLOW="$(get_ansi_code '0;33')"; export ANSI_FG_YELLOW
    ANSI_FG_BLUE="$(get_ansi_code '0;34')"; export ANSI_FG_BLUE
    ANSI_FG_MAGENTA="$(get_ansi_code '0;35')"; export ANSI_FG_MAGENTA
    ANSI_FG_CYAN="$(get_ansi_code '0;36')"; export ANSI_FG_CYAN
    ANSI_FG_WHITE="$(get_ansi_code '0;37')"; export ANSI_FG_WHITE

    ANSI_BLACK="${ANSI_FG_BLACK}"; export ANSI_BLACK
    ANSI_RED="${ANSI_FG_RED}"; export ANSI_RED
    ANSI_GREEN="${ANSI_FG_GREEN}"; export ANSI_GREEN
    ANSI_YELLOW="${ANSI_FG_YELLOW}"; export ANSI_YELLOW
    ANSI_BLUE="${ANSI_FG_BLUE}"; export ANSI_BLUE
    ANSI_MAGENTA="${ANSI_FG_MAGENTA}"; export ANSI_MAGENTA
    ANSI_CYAN="${ANSI_FG_CYAN}"; export ANSI_CYAN
    ANSI_WHITE="${ANSI_FG_WHITE}"; export ANSI_WHITE

    ANSI_FG_BOLD_BLACK="$(get_ansi_code '1;30')"; export ANSI_FG_BOLD_BLACK
    ANSI_FG_BOLD_RED="$(get_ansi_code '1;31')"; export ANSI_FG_BOLD_RED
    ANSI_FG_BOLD_GREEN="$(get_ansi_code '1;32')"; export ANSI_FG_BOLD_GREEN
    ANSI_FG_BOLD_YELLOW="$(get_ansi_code '1;33')"; export ANSI_FG_BOLD_YELLOW
    ANSI_FG_BOLD_BLUE="$(get_ansi_code '1;34')"; export ANSI_FG_BOLD_BLUE
    ANSI_FG_BOLD_MAGENTA="$(get_ansi_code '1;35')"; export ANSI_FG_BOLD_MAGENTA
    ANSI_FG_BOLD_CYAN="$(get_ansi_code '1;36')"; export ANSI_FG_BOLD_CYAN
    ANSI_FG_BOLD_WHITE="$(get_ansi_code '1;37')"; export ANSI_FG_BOLD_WHITE

    ANSI_BOLD_BLACK="${ANSI_FG_BOLD_BLACK}"; export ANSI_BOLD_BLACK
    ANSI_BOLD_RED="${ANSI_FG_BOLD_RED}"; export ANSI_BOLD_RED
    ANSI_BOLD_GREEN="${ANSI_FG_BOLD_GREEN}"; export ANSI_BOLD_GREEN
    ANSI_BOLD_YELLOW="${ANSI_FG_BOLD_YELLOW}"; export ANSI_BOLD_YELLOW
    ANSI_BOLD_BLUE="${ANSI_FG_BOLD_BLUE}"; export ANSI_BOLD_BLUE
    ANSI_BOLD_MAGENTA="${ANSI_FG_BOLD_MAGENTA}"; export ANSI_BOLD_MAGENTA
    ANSI_BOLD_CYAN="${ANSI_FG_BOLD_CYAN}"; export ANSI_BOLD_CYAN
    ANSI_BOLD_WHITE="${ANSI_FG_BOLD_WHITE}"; export ANSI_BOLD_WHITE

    ANSI_BG_BLACK="$(get_ansi_code '0;40')"; export ANSI_BG_BLACK
    ANSI_BG_RED="$(get_ansi_code '0;41')"; export ANSI_BG_RED
    ANSI_BG_GREEN="$(get_ansi_code '0;42')"; export ANSI_BG_GREEN
    ANSI_BG_YELLOW="$(get_ansi_code '0;43')"; export ANSI_BG_YELLOW
    ANSI_BG_BLUE="$(get_ansi_code '0;44')"; export ANSI_BG_BLUE
    ANSI_BG_MAGENTA="$(get_ansi_code '0;45')"; export ANSI_BG_MAGENTA
    ANSI_BG_CYAN="$(get_ansi_code '0;46')"; export ANSI_BG_CYAN
    ANSI_BG_WHITE="$(get_ansi_code '0;47')"; export ANSI_BG_WHITE

    ANSI_BG_BOLD_BLACK="$(get_ansi_code '1;40')"; export ANSI_BG_BOLD_BLACK
    ANSI_BG_BOLD_RED="$(get_ansi_code '1;41')"; export ANSI_BG_BOLD_RED
    ANSI_BG_BOLD_GREEN="$(get_ansi_code '1;42')"; export ANSI_BG_BOLD_GREEN
    ANSI_BG_BOLD_YELLOW="$(get_ansi_code '1;43')"; export ANSI_BG_BOLD_YELLOW
    ANSI_BG_BOLD_BLUE="$(get_ansi_code '1;44')"; export ANSI_BG_BOLD_BLUE
    ANSI_BG_BOLD_MAGENTA="$(get_ansi_code '1;45')"; export ANSI_BG_BOLD_MAGENTA
    ANSI_BG_BOLD_CYAN="$(get_ansi_code '1;46')"; export ANSI_BG_BOLD_CYAN
    ANSI_BG_BOLD_WHITE="$(get_ansi_code '1;47')"; export ANSI_BG_BOLD_WHITE

    ANSI_UNDERLINE="$(get_ansi_code '4')"; export ANSI_UNDERLINE
    ANSI_UNDERLINE_OFF="$(get_ansi_code '24')"; export ANSI_UNDERLINE_OFF

    ANSI_FG_UNDERLINE_BLACK="$(get_ansi_code '0;4;30')"; export ANSI_FG_UNDERLINE_BLACK
    ANSI_FG_UNDERLINE_RED="$(get_ansi_code '0;4;31')"; export ANSI_FG_UNDERLINE_RED
    ANSI_FG_UNDERLINE_GREEN="$(get_ansi_code '0;4;32')"; export ANSI_FG_UNDERLINE_GREEN
    ANSI_FG_UNDERLINE_YELLOW="$(get_ansi_code '0;4;33')"; export ANSI_FG_UNDERLINE_YELLOW
    ANSI_FG_UNDERLINE_BLUE="$(get_ansi_code '0;4;34')"; export ANSI_FG_UNDERLINE_BLUE
    ANSI_FG_UNDERLINE_MAGENTA="$(get_ansi_code '0;4;35')"; export ANSI_FG_UNDERLINE_MAGENTA
    ANSI_FG_UNDERLINE_CYAN="$(get_ansi_code '0;4;36')"; export ANSI_FG_UNDERLINE_CYAN
    ANSI_FG_UNDERLINE_WHITE="$(get_ansi_code '0;4;37')"; export ANSI_FG_UNDERLINE_WHITE

    ANSI_FG_BOLD_UNDERLINE_BLACK="$(get_ansi_code '1;4;30')"; export ANSI_FG_BOLD_UNDERLINE_BLACK
    ANSI_FG_BOLD_UNDERLINE_RED="$(get_ansi_code '1;4;31')"; export ANSI_FG_BOLD_UNDERLINE_RED
    ANSI_FG_BOLD_UNDERLINE_GREEN="$(get_ansi_code '1;4;32')"; export ANSI_FG_BOLD_UNDERLINE_GREEN
    ANSI_FG_BOLD_UNDERLINE_YELLOW="$(get_ansi_code '1;4;33')"; export ANSI_FG_BOLD_UNDERLINE_YELLOW
    ANSI_FG_BOLD_UNDERLINE_BLUE="$(get_ansi_code '1;4;34')"; export ANSI_FG_BOLD_UNDERLINE_BLUE
    ANSI_FG_BOLD_UNDERLINE_MAGENTA="$(get_ansi_code '1;4;35')"; export ANSI_FG_BOLD_UNDERLINE_MAGENTA
    ANSI_FG_BOLD_UNDERLINE_CYAN="$(get_ansi_code '1;4;36')"; export ANSI_FG_BOLD_UNDERLINE_CYAN
    ANSI_FG_BOLD_UNDERLINE_WHITE="$(get_ansi_code '1;4;37')"; export ANSI_FG_BOLD_UNDERLINE_WHITE

    ANSI_CLEAR_LINE="$(get_ansi_code '2' '' 'K')"; export ANSI_CLEAR_LINE
    ANSI_RESET_LINE="$(get_ansi_code '2' '' 'K')$(get_ansi_code '1' '' 'G')"; export ANSI_RESET_LINE

    ANSI_CLEAR_SCREEN="$(get_ansi_code '2' '' 'J')"; export ANSI_CLEAR_SCREEN
    ANSI_RESET_SCREEN="$(get_ansi_code '2' '' 'J')$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_SCREEN

    ANSI_CLEAR_HISTORY="$(get_ansi_code '3' '' 'J')"; export ANSI_CLEAR_HISTORY
    ANSI_RESET_HISTORY="$(get_ansi_code '3' '' 'J')$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_HISTORY

    ANSI_RESET_CURSOR_LINE="$(get_ansi_code '1' '' 'G')"; export ANSI_RESET_CURSOR_LINE
    ANSI_RESET_CURSOR_SCREEN="$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_CURSOR_SCREEN

    ANSI_CURSOR_UP="$(get_ansi_code '1' '' 'A')"; export ANSI_CURSOR_UP
    ANSI_CURSOR_DOWN="$(get_ansi_code '1' '' 'B')"; export ANSI_CURSOR_DOWN
    ANSI_CURSOR_RIGHT="$(get_ansi_code '1' '' 'C')"; export ANSI_CURSOR_RIGHT
    ANSI_CURSOR_LEFT="$(get_ansi_code '1' '' 'D')"; export ANSI_CURSOR_LEFT
    ANSI_CURSOR_NEXTLINE="$(get_ansi_code '1' '' 'E')"; export ANSI_CURSOR_NEXTLINE
    ANSI_CURSOR_PREVLINE="$(get_ansi_code '1' '' 'F')"; export ANSI_CURSOR_PREVLINE

    ANSI_BELL="\007🔔 "; export ANSI_BELL
    ANSI_RESET="$(get_ansi_code '0')"; export ANSI_RESET

    ANSI_COLOR_SUCCESS="$(get_ansi_code '1;32' '1;34')"; export ANSI_COLOR_SUCCESS          # bright green/blue
    ANSI_COLOR_FATAL="$(get_ansi_code '1;31')"; export ANSI_COLOR_FATAL                     # bright red
    ANSI_COLOR_ERROR="$(get_ansi_code '0;31')"; export ANSI_COLOR_ERROR                     # darkred
    ANSI_COLOR_WARNING="$(get_ansi_code '1;33')"; export ANSI_COLOR_WARNING                 # bright yellow
    ANSI_COLOR_HEADER="$(get_ansi_code '1;4;36')"; export ANSI_COLOR_HEADER                 # bright cyan, underlined
    ANSI_COLOR_FOOTER="$(get_ansi_code '0;24;36')"; export ANSI_COLOR_FOOTER                # bright darkcyan, not underlined
    ANSI_COLOR_INFO="$(get_ansi_code '1;37')"; export ANSI_COLOR_INFO                       # bright white
    ANSI_COLOR_DEBUG="$(get_ansi_code '0;37')"; export ANSI_COLOR_DEBUG                     # lightgrey
    ANSI_COLOR_SUPERDEBUG="$(get_ansi_code '1;30')"; export ANSI_COLOR_SUPERDEBUG           # grey
    ANSI_COLOR_ULTRADEBUG="$(get_ansi_code '0;35' '0;33')"; export ANSI_COLOR_ULTRADEBUG    # darkmagenta/darkyellow

    ANSI_SUCCESS_FINAL="${ANSI_COLOR_SUCCESS}${ANSI_BELL}✅ "; export ANSI_SUCCESS_FINAL
    ANSI_SUCCESS="${ANSI_COLOR_SUCCESS}"; export ANSI_SUCCESS
    ANSI_FATAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 "; export ANSI_FATAL
    ANSI_ERROR="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ "; export ANSI_ERROR
    ANSI_WARNING="${ANSI_COLOR_WARNING}⚠️ "; export ANSI_WARNING
    ANSI_HEADER="${ANSI_COLOR_HEADER}"; export ANSI_HEADER
    ANSI_FOOTER="${ANSI_COLOR_FOOTER}"; export ANSI_FOOTER
    ANSI_INFO="${ANSI_COLOR_INFO}"; export ANSI_INFO
    ANSI_DEBUG="${ANSI_COLOR_DEBUG}"; export ANSI_DEBUG
    ANSI_SUPERDEBUG="${ANSI_COLOR_SUPERDEBUG}"; export ANSI_SUPERDEBUG
    ANSI_ULTRADEBUG="${ANSI_COLOR_ULTRADEBUG}"; export ANSI_ULTRADEBUG
}
set_ansi_code_constants

#endregion Colorized Output Constants
#===============================================================================

#===============================================================================
#region Logging Helpers

#-------------------------------------------------------------------------------
get_datetime_stamp()
{
    date "${DATETIME_STAMP_FORMAT}"
}

#-------------------------------------------------------------------------------
format_log_message()
{
    (
        prefix="$1"
        suffix="$2"
        shift 2

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        inner_text="$(command printf -- "$@"; command echo EOL)"
        command printf -- "%s %s%s%s\n" "$(get_datetime_stamp)" "${prefix}" "${inner_text%EOL}" "${suffix}"
    )
}

#-------------------------------------------------------------------------------
log_console()
{
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)"
        command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_success_final() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUCCESS_FINAL}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            [ "${quiet:-}" != true ]||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_success() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUCCESS}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            [ "${quiet:-}" != true ]||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_fatal() {
    # NOTE: outside the local scope to modify global var
    LOG_FATAL_COUNT=$((LOG_FATAL_COUNT + 1)); export LOG_FATAL_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_FATAL}FATAL: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${ERROR_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_error() {
    # NOTE: outside the local scope to modify global var
    LOG_ERROR_COUNT=$((LOG_ERROR_COUNT + 1)); export LOG_ERROR_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_ERROR}ERROR: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${ERROR_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_warning() {
    # NOTE: outside the local scope to modify global var
    LOG_WARNING_COUNT=$((LOG_WARNING_COUNT + 1)); export LOG_WARNING_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_WARNING}WARNING: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${WARNING_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_header() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_HEADER}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge -1 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_footer() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_FOOTER}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 0 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_info() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}INFO: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_info_noprefix() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_debug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_DEBUG}DEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 2 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_superdebug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUPERDEBUG}SUPERDEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 3 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_ultradebug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_ULTRADEBUG}ULTRADEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_file() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
printf() {
    log_file "$@"
    command printf -- "$@"
}

#-------------------------------------------------------------------------------
echo() {
    log_file "$@"
    command echo "$@"
}

#-------------------------------------------------------------------------------
report_errors() {
    (
        if [ "$(wc -c <"${ERROR_LOG}")" -gt 0 ]; then
            message="${ANSI_COLOR_ERROR}The following errors occurred:${ANSI_RESET}\n"
            >&2 command printf -- "${message}"
            >>"${FULL_LOG}" command printf -- "${message}"

            >&2 command sed 's/^/\t/' "${ERROR_LOG}"
            >>"${FULL_LOG}" command sed 's/^/\t/' "${ERROR_LOG}"
        fi
    )
}

#-------------------------------------------------------------------------------
report_warnings() {
    (
        if [ "$(wc -c <"${WARNING_LOG}")" -gt 0 ]; then
            message="${ANSI_COLOR_WARNING}The following warnings occurred:${ANSI_RESET}\n"
            >&2 command printf -- "${message}"
            >>"${FULL_LOG}" command printf "${message}"

            >&2 sed 's/^/\t/' "${WARNING_LOG}"
            >>"${FULL_LOG}" sed 's/^/\t/' "${WARNING_LOG}"
        fi
    )
}

#-------------------------------------------------------------------------------
report_final_status() {
    (
        ret=$1
        shift
        message="$(command printf -- "$@"; command echo EOL)"

        # fixup return code in case it is wrong
        if [ "$ret" -eq 0 ]; then
            if [ ${LOG_FATAL_COUNT} -gt 0 ]; then
                ret=${RET_ERROR_UNKNOWN}
            elif [ ${LOG_ERROR_COUNT} -gt 0 ]; then
                ret=${RET_ERROR_UNKNOWN}
            elif [ ${LOG_WARNING_COUNT} -gt 0 ]; then
                if [ ${LOG_WARNING_COUNT} -gt 1 ]; then
                    ret=${RET_WARNING_MULTIPLE}
                else
                    ret=${RET_WARNING_UNKNOWN}
                fi
            fi
        fi

        fatal_text=""
        plural=""
        if [ ${LOG_FATAL_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_FATAL_COUNT} -gt 0 ]; then
            fatal_text="$(command printf "%d Fatal Error%s" "${LOG_FATAL_COUNT}" "${plural}")"
        fi

        error_text=""
        plural=""
        if [ ${LOG_ERROR_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_ERROR_COUNT} -gt 0 ]; then
            error_text="$(command printf "%d Error%s" "${LOG_ERROR_COUNT}" "${plural}")"
        fi

        warning_text=""
        plural=""
        if [ ${LOG_WARNING_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_WARNING_COUNT} -gt 0 ]; then
            warning_text="$(command printf "%d Warning%s" "${LOG_WARNING_COUNT}" "${plural}")"
        fi

        before_error_text=""
        before_warning_text=""
        if \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_ERROR_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_error_text=", "
            before_warning_text=", and "
        elif \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_warning_text=" and "
        elif \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_ERROR_COUNT} -gt 0 ]
        then
            before_error_text=" and "
        elif \
            [ ${LOG_ERROR_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_warning_text=" and "
        fi

        log_info "%s exiting with return code: %d" "${message%EOL}"  "$ret"
        if [ "$ret" -eq 0 ]; then
            log_success_final "%s Completed Successfully." "${message%EOL}"
        elif [ ${LOG_FATAL_COUNT} -gt 0 ]; then
            log_fatal "%s Had %s%s%s%s%s." "${message%EOL}" "${fatal_text}" "${before_error_text}" "${error_text}" "${before_warning_text}" "${warning_text}"
        elif [ ${LOG_ERROR_COUNT} -gt 0 ]; then
            log_error "%s Had %s%s%s." "${message%EOL}" "${error_text}" "${before_warning_text}" "${warning_text}"
        elif [ ${LOG_WARNING_COUNT} -gt 0 ]; then
            log_warning "%s Had %s." "${message%EOL}" "${warning_text}"
        fi

        exit "$ret"
    )
}

#-------------------------------------------------------------------------------
report_all() {
    (
        report_warnings
        report_errors
        >&2 command printf "Fully detailed log is available at '%s'\n" "${FULL_LOG}"
        report_final_status "$@"
        ret=$?
        exit $ret
    )
}

if [ "${CONSTANTS_TEMP_DIR}" = "" ]; then
    CONSTANTS_TEMP_DIR=$(mktemp -d -t constants.sh-XXXXXXXX)
    export CONSTANTS_TEMP_DIR
    mkdir -p "${CONSTANTS_TEMP_DIR}"
fi
if [ "${ERROR_LOG}" = "" ]; then
    ERROR_LOG="${CONSTANTS_TEMP_DIR}"/errors_only.txt
    export ERROR_LOG
    command printf '' >"${ERROR_LOG}"
fi
if [ "${WARNING_LOG}" = "" ]; then
    WARNING_LOG="${CONSTANTS_TEMP_DIR}"/warnings_only.txt
    export WARNING_LOG
    command printf '' >"${WARNING_LOG}"
fi
if [ "${FULL_LOG}" = "" ]; then
    FULL_LOG="${CONSTANTS_TEMP_DIR}"/log.txt
    export FULL_LOG
    command printf '' >"${FULL_LOG}"
fi

if [ "${LOG_FATAL_COUNT}" = "" ]; then
    LOG_FATAL_COUNT=0; export LOG_FATAL_COUNT
fi
if [ "${LOG_ERROR_COUNT}" = "" ]; then
    LOG_ERROR_COUNT=0; export LOG_ERROR_COUNT
fi
if [ "${LOG_WARNING_COUNT}" = "" ]; then
    LOG_WARNING_COUNT=0; export LOG_WARNING_COUNT
fi

#endregion Logging Helpers
#===============================================================================

#endregion Public *
################################################################################

(
    ############################################################################
    #region Private *

    #===========================================================================
    #region Private Functions

    #---------------------------------------------------------------------------
    __main() {
        log_fatal "${MY_BASENAME} must be sourced"
        return "${RET_ERROR_SCRIPT_WAS_NOT_SOURCED}"
    }

    #---------------------------------------------------------------------------
    __sourced_main() {
        return "${RET_SUCCESS}"
    }

    #endregion Private Functions
    #===========================================================================

    #endregion Private *
    ############################################################################

    ############################################################################
    #region Immediate

    require_not_root_user

    if [ "$(array_get_last WAS_SOURCED)" -eq 0 ]; then
        __main "$@"
        ret=$?
    else
        __sourced_main "$@"
        ret=$?
    fi
    exit $ret

    #endregion Immedate
    ############################################################################
)
ret=$?

################################################################################
#region Postamble

#===============================================================================
#region Track Sourcing

if [ "$(array_get_last WAS_SOURCED)" -eq 1 ]; then
    OUR_SOURCED_FULLPATH="$(array_get_last SOURCED_FULLPATH)"
    if [ "${OUR_SOURCED_FULLPATH}" != "" ]; then
        log_debug "Source Completed: $(array_get_last SOURCED_FULLPATH) ($$)"
    else
        log_debug "Source Completed: Unknown Path ($$)"
    fi

    array_remove_last SOURCED_FULLPATH
    export SOURCED_FULLPATH
    array_remove_last SOURCED_BASENAME
    export SOURCED_BASENAME
    array_remove_last SOURCED_DIR_FULLPATH
    export SOURCED_DIR_FULLPATH
    array_remove_last SOURCED_DIR_BASENAME
    export SOURCED_DIR_BASENAME
else
    log_debug "Invoke Completed: ${MY_FULLPATH} ($$)"
fi

#endregion Track Sourcing
#===============================================================================

# NOTE: we have to return here if we were sourced otherwise we kill the shell
_THIS_FILE_WAS_SOURCED="$(array_get_last WAS_SOURCED)"
array_remove_last WAS_SOURCED
export WAS_SOURCED
if [ "${_THIS_FILE_WAS_SOURCED}" -eq 0 ]; then
    exit $ret
else
    return $ret
fi

#endregion Postamble
################################################################################
