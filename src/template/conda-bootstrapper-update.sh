#!/usr/bin/env sh


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
    ( # Execute the function in a *subshell* to localize variables and the effect of 'cd'.

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

_ARRAY__SEP="$(command printf "\t")"; export _ARRAY__SEP
#                           x12345678x
_ARRAY__SEP__ESCAPED="$(command printf "\\\\\\\\t")"; export _ARRAY__SEP__ESCAPED

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
    # Detects 'sh' and 'dash'; add additional shell filenames as needed.
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
#region Additional Fallbacks

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

#endregion Additional Fallbacks
#===============================================================================

#===============================================================================
#region Includes

include "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"

#endregion Includes
#===============================================================================

#===============================================================================
#region Public Constants

GITHUB_REPO_USER=MarximusMaximus
GITHUB_REPO_NAME=conda-bootstrapper

#endregion Public Constants
#===============================================================================

#===============================================================================
#region Public Globals

git_exists=false; export git_exists
curl_exists=false; export curl_exists
wget_exists=false; export wget_exists
tar_exists=false; export tar_exists
unzip_exists=false; export unzip_exists
diff_exists=false; export diff_exists
md5_exists=false; export md5_exists

if [ "${my_tempdir:-}" = "" ]; then
    my_tempdir=""; export my_tempdir
fi

#endregion Public Globals
#===============================================================================

#===============================================================================
#region Public Functions

ensure_cd() {
    # intentionally no local scope so that the cd command takes effect

    path_to_cd="$1"

    log_info "Changing current directory to '%s'" "${path_to_cd}"

    # shellcheck disable=SC2164
    cd "${path_to_cd}"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "Could not cd into '%s'" "${path_to_cd}"
        return "${RET_ERROR_DIRECTORY_NOT_FOUND}"
    fi
}

safe_rm() {
    (
        path_to_remove="$1"
        print_rm_error_message="$2"

        log_info "Safely removing '%s'" "${path_to_remove}"

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
                    log_error "failed to rm '%s'" "${path_to_remove}"
                fi
                exit "${RET_ERROR_RM_FAILED}"
            fi
        else
            log_fatal "unsafe rm path '%s'" "${path_to_remove}"
            exit "${RET_ERROR_UNSAFE_RM_PATH}"
        fi
    )
}

ensure_does_not_exist() {
    (
        path_to_remove="$1"

        log_info "Ensuring does not exist: '%s'" "${path_to_remove}"

        if \
            [ -f "${path_to_remove}" ] ||
            [ -d "${path_to_remove}" ]
        then
            safe_rm "${path_to_remove}"
            ret=$?
            exit $ret
        fi
    )
}

check_tools() {
    # intentionally no local scope because modifying globals

    log_info "Checking tools"

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

    if \
        [ "${git_exists}" = false ] &&
        [ "${curl_exists}" = false ] &&
        [ "${wget_exists}" = false ]
    then
        log_fatal "conda-bootstrapper missing and no way to download available (no git, no curl, no wget)"
        return "${RET_ERROR_TOOL_MISSING}"
    fi

    if \
        [ "${git_exists}" = false ] &&  # we only need to extract if git isn't available
        [ "${tar_exists}" = false ] &&
        [ "${unzip_exists}" = false ]
    then
        log_fatal "conda-bootstrapper missing and no way to extract from compressed file available (no tar, no unzip)"
        return "${RET_ERROR_TOOL_MISSING}"
    fi

    if \
        [ "${diff_exists}" = false ] &&
        [ "${md5_exists}" = false ]
    then
        log_fatal "no way to comapre files (no diff, no md5)"
        return "${RET_ERROR_TOOL_MISSING}"
    fi
}

create_dir() {
    (
        destdir="$1"

        log_info "Creating directory '%s'" "${destdir}"

        ensure_does_not_exist "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to remove path '%s'" "${destdir}"
            exit $ret
        fi

        mkdir -p "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to create directory '%s'" "${destdir}"
            exit "${RET_ERROR_CREATE_DIRECTORY_FAILED}"
        fi
    )
}

ensure_dir() {
    (
        destdir="$1"

        log_info "Ensuring directory exists: '%s'" "${destdir}"

        if [ ! -d "${destdir}" ]; then
            create_dir "${destdir}"
            ret=$?
            exit $ret
        fi
    )
}

create_my_tempdir() {
    # intentionally no local scope b/c modifying a global

    log_info "Creating temporary directory"

    my_tempdir=$(mktemp -d -t conda-bootstrapper-update.XXXXXXXX)
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "failed to get temporary directory"
        return "${RET_ERROR_FAILED_TO_GET_TEMP_DIR}"
    fi

    ensure_dir "${my_tempdir}"
    if [ $ret -ne 0 ]; then
        return $ret
    fi

    export my_tempdir
}

download_via_curl() {
    (
        repo_url=$1
        file_basename=$2
        directory="$3"

        if [ "${tar_exists}" = true ]; then
            log_info "Downloading as tarball via curl: '%s'" "${repo_url}"
            curl -L "${repo_url}/tarball" --output "${directory}/${file_basename}.tar.gz"
            ret=$?
        elif [ "${unzip_exists}" = true ]; then
            log_info "Downloading as zipball via curl: '%s'" "${repo_url}"
            curl -L "${repo_url}/zipball" --output "${directory}/${file_basename}.zip"
            ret=$?
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi
        if [ $ret -ne 0 ]; then
            log_fatal "failed to download ${file_basename} compressed file (curl)"
            exit "${RET_ERROR_DOWNLOAD_FAILED}"
        fi
    )
}

download_via_wget() {
    (
        repo_url=$1
        file_basename=$2
        directory="$3"

        if [ "${tar_exists}" = true ]; then
            log_info "Downloading as tarball via wget: '%s'" "${repo_url}"
            wget "${repo_url}/tarball" -O "${directory}/${file_basename}.tar.gz"
            ret=$?
        elif [ "${unzip_exists}" = true ]; then
            log_info "Downloading as zipball via wget: '%s'" "${repo_url}"
            wget "${repo_url}/zipball" -O "${directory}/${file_basename}.zip"
            ret=$?
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi
        if [ $ret -ne 0 ]; then
            log_fatal "failed to download ${file_basename} compressed file (wget)"
            exit "${RET_ERROR_DOWNLOAD_FAILED}"
        fi
    )
}

extract_tarball() {
    (
        file=$1
        dest=$2

        log_info "Extracting tarball '%s' to '%s'" "${file}" "${dest}"

        _dest=""
        if [ "${dest}" != "" ]; then
            _dest=" -C "
        fi

        tar -xzf "${file}" --strip=1"${_dest}""${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to extract ${file} compressed file (tar)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi
    )
}

extract_zipball() {
    (
        file=$1
        dest=$2

        log_info "Extracting zipball '%s' to '%s'" "${file}" "${dest}"

        create_dir "${my_tempdir}/extracted"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        unzip -d "${my_tempdir}/extracted" "${file}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to extract  ${file} compressed file (unzip)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi

        mv "${my_tempdir}/extracted/*/*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to move extracted files into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi

        mv "${my_tempdir}/extracted/*/.*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to move extracted files dotfiles into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi
    )
}

download_and_extract() {
    (
        repo_url=$1
        file_basename=$2
        destdir="$3"

        if [ "${curl_exists}" = true ]; then
            download_via_curl "${repo_url}" "${file_basename}" "${my_tempdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        elif [ "${wget_exists}" = true ]; then
            download_via_wget "${repo_url}" "${file_basename}" "${my_tempdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        fi

        create_dir "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        if [ "${tar_exists}" = true ]; then
            extract_tarball "${my_tempdir}/${file_basename}.tar.gz" "${destdir}"
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        elif [ "${unzip_exists}" = true ]; then
            extract_zipball "${my_tempdir}/${file_basename}.tar.gz" "${destdir}"
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi
    )
}

ensure_conda_bootstrapper() {
    (
        log_info "Ensuring conda-bootstrapper exists"

        if [ ! -d "${CONDA_BOOTSTRAPPER_FULLPATH}" ]; then
            # conda-bootstrapper missing, let's download it
            # shellcheck disable=SC2164
            cd "${CONDA_BOOTSTRAPPER_FULLPATH}/.."
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to cd into '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/.."
                exit "${RET_ERROR_CHANGE_DIRECTORY_FAILED}"
            fi

            if [ "${git_exists}" = true ]; then
                git clone "https://github.com/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}.git"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "failed to clone https://github.com/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}.git"
                    exit "${RET_ERROR_GIT_CLONE_FAILED}"
                fi
            elif \
                [ "${curl_exists}" = true ] ||
                [ "${wget_exists}" = true ]
            then
                download_and_extract "https://api.github.com/repos/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}" "${GITHUB_REPO_NAME}" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                # create download timestamp
                touch "${CONDA_BOOTSTRAPPER_FULLPATH}"/LAST_DOWNLOADED
            else # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "no way to download available (no git, no curl, no wget)"
                exit "${RET_ERROR_TOOL_MISSING}"
            fi
        fi
    )
}

update_condabootstrapper() {
    (
        log_info "Updating conda-bootstrapper"

        if [ "${git_exists}" = true ]; then
            # shellcheck disable=SC2164
            cd "${CONDA_BOOTSTRAPPER_FULLPATH}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to cd into '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                exit "${RET_ERROR_CHANGE_DIRECTORY_FAILED}"
            fi

            current_branch="$(git rev-parse --abbrev-ref HEAD)"
            if [ "${current_branch}" != "main" ]; then
                log_warning "conda-bootstrapper's current branch is not main"
                # this is fine, so just bail early
                exit 0
            fi

            ahead_by="$(git rev-list --left-right --count origin/main...main | awk '{print $2}')"
            is_dirty="$(git status --porcelain --untracked-files=all)"
            if \
                [ "${is_dirty}" = "" ] &&
                [ "${ahead_by}" -eq 0 ]
            then
                # not dirty
                git fetch
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "git fetch failed"
                    exit "${RET_ERROR_GIT_FETCH_FAILED}"
                fi

                git reset --hard origin/main
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "git reset failed"
                    exit "${RET_ERROR_GIT_RESET_FAILED}"
                fi
            else
                log_warning "conda-bootstrapper has local changes"
                # this is fine, so just bail early
                exit 0
            fi
        elif \
            [ "${curl_exists}" = true ] ||
            [ "${wget_exists}" = true ]
        then
            # shellcheck disable=SC2012
            is_dirty="$(ls -lt | head -2 | tail -1 | grep -v "LAST_DOWNLOADED")"

            if [ "${is_dirty}" = "" ]; then
                safe_rm "${CONDA_BOOTSTRAPPER_FULLPATH}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                download_and_extract "https://api.github.com/repos/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}" "${GITHUB_REPO_NAME}" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            else
                log_warning "conda-bootstrapper has local changes"
                # this is fine, so just bail early
                exit 0
            fi
        else # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "no way to download available (no git, no curl, no wget)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi
    )
}

copy_temporary_template_files() {
    (
        log_info "Creating a copy of template files"

        create_dir "${my_tempdir}/template"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        cp "${CONDA_BOOTSTRAPPER_FULLPATH}/src/template"/* "${my_tempdir}/template/"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to copy files from '%s' to '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/src/template/*" "${my_tempdir}/template/"
            exit "${RET_ERROR_COPY_FAILED}"
        fi
    )
}

is_file_same() {
    # exit code 0 == same
    # exit code 1 == different
    # exit code 2 == there was an error
    (
        left_file="$1"
        right_file="$2"

        log_info "Comparing '%s' and '%s'" "${left_file}" "${right_file}"

        if [ "${diff_exists}" = true ]; then
            diff "${left_file}" "${right_file}"
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
            log_fatal "no way to comapre files (no diff, no md5)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi
    )
}

compare_and_update_files() {
    (
        # this file gets edited by users, we don't want it to get tested
        safe_rm "${my_tempdir}/template/post-bootstrap.sh"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        is_file_same "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
        ret=$?
        if [ $ret -gt 2 ]; then
            exit $ret
        elif [ $ret -eq 1 ]; then
            log_info "conda-bootstrapper-update.sh changed, copying and re-running"

            # we need to update ourself, and then call ourself again
            safe_rm "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi


            mv "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
            if [ $ret -ne 0 ]; then
                log_fatal "failed to copy '%s' to '%s'" "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
                exit "${RET_ERROR_COPY_FAILED}"
            fi

            log_info "conda-bootstrapper-update.sh copied successfully"

            log_info "re-running command as '%s %s'" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh" "$*"

            # call ourselves again
            "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh" "$@"
            ret=$?
            exit $ret
        else
            log_info "conda-bootstrapper-update.sh did not change"

            # we need to remove the temporary template version of ourself,
            # so that we can just iterate the rest of the files
            safe_rm "${my_tempdir}/template/conda-bootstrapper-update.sh"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            ensure_cd "${my_tempdir}/template"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            for filename in *; do
                if [ ! -f "${filename}" ]; then
                    continue
                fi

                needs_copy=false

                if [ ! -f "${MY_DIR_FULLPATH}/${filename}" ]; then
                    needs_copy=true
                fi

                if [ "${needs_copy}" = false ]; then
                    is_file_same "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                    ret=$?
                    if [ $ret -gt 2 ]; then
                        exit $ret
                    elif [ $ret -eq 1 ]; then
                        needs_copy=true
                    else
                        log_info "${filename} did not change"
                    fi
                fi

                if [ "${needs_copy}" = true ]; then
                    # file is different, needs to be updated
                    log_info "${filename} needs to be copied, copying"

                    safe_rm "${MY_DIR_FULLPATH}/${filename}"
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        exit $ret
                    fi

                    mv "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                    if [ $ret -ne 0 ]; then
                        log_fatal "failed to copy '%s' to '%s'" "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                        exit "${RET_ERROR_COPY_FAILED}"
                    fi

                    log_info "${filename} copied successfully"
                fi
            done
        fi
    )
}

#endregion Public Functions
#===============================================================================

#endregion Public *
################################################################################

(
    ############################################################################
    #region Private *

    #===========================================================================
    #region Private Constants

    SET_OMEGA_DEBUG=true

    #endregion Constants
    #===========================================================================

    #===========================================================================
    #region Return Codes



    #endregion Return Codes
    #===========================================================================

    #===========================================================================
    #region Private Globals

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        log_ultradebug "%s: OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "$(get_my_true_basename)" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "%s: SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "$(get_my_true_basename)" "${SET_OMEGA_DEBUG}"
    fi

    if [ "${verbosity}" = "" ]; then
        verbosity=99; export verbosity
    fi

    #endregion Private Globals
    #===========================================================================

    #===========================================================================
    #region Private Functions

    #---------------------------------------------------------------------------
    __main() {
        log_ultradebug "${MY_BASENAME} called with '%s'" "$*"

        (
            check_tools
            ret=$?
            if [ $ret -ne 0 ];then
                return $ret
            fi

            create_my_tempdir
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            ensure_conda_bootstrapper
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            # re-include constants.sh if the fence value is missing,
            # in case file didn't exist earlier
            type CONDA_BOOTSTRAPPER_CONSTANTS_LOADED >/dev/null 2>&1
            ret=$?
            if [ $ret -ne 0 ]; then
                ensure_include "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
            fi

            update_condabootstrapper
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            ensure_cd "${MY_DIR_FULLPATH}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            copy_temporary_template_files
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            compare_and_update_files "$@"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            exit "${RET_SUCCESS}"
        )
        ret=$?
        report_all $ret "${MY_BASENAME}"
        ret=$?
        return $ret
    }

    #endregion Private Functions
    #===========================================================================

    __sourced_main() {
        return "${RET_SUCCESS}"
    }

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

    #endregion Immediate
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
