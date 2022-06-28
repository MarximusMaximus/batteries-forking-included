#!/usr/bin/env sh
# "$_" undefined in POSIX, we only use it for specific shells
# shellcheck disable=SC3028
DOLLAR_UNDER="$_"

# WARNING: Don't forget to update the version number in pyproject.toml
BFI_VERSION="0.1.1"
export BFI_VERSION

################################################################################
#region Preamble

#===============================================================================
#region Fallbacks

type BATTERIES_FORKING_INCLUDED_CONSTANTS_LOADED >/dev/null 2>&1
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
    date() {
        if [ "$(uname)" = "Darwin" ]; then
            command date -j "$@"
        else
            command date "$@"
        fi
    }

    #-------------------------------------------------------------------------------
    log_console() {
        command printf -- "$@"
        command printf -- "\n"
    }

    #-------------------------------------------------------------------------------
    log_success_final() {
        log_success "$@"
    }

    #-------------------------------------------------------------------------------
    log_success() {
        command printf -- "SUCCESS: "
        command printf -- "$@"
        command printf -- "\n"
    }

    #-------------------------------------------------------------------------------
    log_fatal() {
        >&2 command printf -- "FATAL: "
        >&2 command printf -- "$@"
        >&2 command printf -- "\n"
    }

    #-------------------------------------------------------------------------------
    log_error() {
        >&2 command printf -- "ERROR: "
        >&2 command printf -- "$@"
        >&2 command printf -- "\n"
    }

    #-------------------------------------------------------------------------------
    log_warning() {
        >&2 command printf -- "WARNING: "
        >&2 command printf -- "$@"
        >&2 command printf -- "\n"
    }

    #-------------------------------------------------------------------------------
    log_header() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge -1 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "\n"
            command printf -- "$@"
            command printf -- "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_footer() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 0 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "$@"
            command printf -- "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_info_important() {
        log_info "$@"
    }

    #-------------------------------------------------------------------------------
    log_info() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "INFO: "
            command printf -- "$@"
            command printf -- "\n"
        fi
    }

    #-------------------------------------------------------------------------------
    log_info_noprefix() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "$@"
            command printf -- "\n"
        fi
    }

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
    log_superdebug() {
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 3 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "SUPERDEBUG: "
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

    #-------------------------------------------------------------------------------
    log_file() {
        true
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
#region Root User Check

#-------------------------------------------------------------------------------
require_not_root_user_XY() {
    # intentionally no local scope so it can exit script

    if [ "${CI}" = true ] && [ "${PLATFORM_IS_WSL}" = true ]; then
        # github runner's WSL user is always root
        true
    else
        # shellcheck disable=SC3028
        if [ $UID -eq 0 ] || [ $EUID -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
            log_fatal "$(get_my_real_basename) should not be run as root nor with sudo"
            if [ "$(array_get_first WAS_SOURCED)" = true ]; then
                exit "${RET_ERROR_USER_IS_ROOT}"
            else
                return "${RET_ERROR_USER_IS_ROOT}"
            fi
        fi
    fi
}

#-------------------------------------------------------------------------------
require_root_user_XY() {
    # intentionally no local scope so it can exit script

    # shellcheck disable=SC3028
    if [ $UID -ne 0 ] && [ $EUID -ne 0 ] && [ "$(id -u)" -ne 0 ]; then
        log_fatal "$(get_my_real_basename) MUST be run as root or with sudo"
        if [ "$(array_get_first WAS_SOURCED)" = true ]; then
            exit "${RET_ERROR_USER_IS_NOT_ROOT}"
        else
            return "${RET_ERROR_USER_IS_NOT_ROOT}"
        fi
    fi
}

#endregion Root User Check
#===============================================================================

#===============================================================================
#region Include/Invoke Directives

#-------------------------------------------------------------------------------
include_G() {
    # intentionally no local scope so it modify globals

    if [ ! -f "$1" ]; then
        log_warning "Could not source because file is missing: %s" "$1"
        return "${RET_ERROR_FILE_NOT_FOUND}"
    fi

    array_append SHELL_SOURCE "$1"
    export SHELL_SOURCE
    array_append WAS_SOURCED true
    export WAS_SOURCED

    # shellcheck disable=SC1090
    . "$1"
    ret=$?

    array_remove_last WAS_SOURCED
    export WAS_SOURCED
    array_remove_last SHELL_SOURCE
    export SHELL_SOURCE

    return $ret
}

#-------------------------------------------------------------------------------
ensure_include_GXY() {
    # intentionally no local scope so it can modify globals AND exit script

    include_G "$1"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "Failed to source '%s'" "$1"
        if [ "$(array_get_first WAS_SOURCED)" = true ]; then
            exit "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
        else
            return "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
        fi
    fi
}

#-------------------------------------------------------------------------------
invoke() {
    array_append SHELL_SOURCE "$1"
    export SHELL_SOURCE
    array_append WAS_SOURCED false
    export WAS_SOURCED

    "$@"
    ret=$?

    array_remove_last WAS_SOURCED
    export WAS_SOURCED
    array_remove_last SHELL_SOURCE
    export SHELL_SOURCE

    return $ret
}

#endregion Include/Invoke Directives
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
windows_path_to_unix_path() {
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
ensure_cd() {
    # intentionally no local scope so that the cd command takes effect
    log_superdebug "Changing current directory to '%s'" "$1"

    # shellcheck disable=SC2164
    cd "$1"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "Could not cd into '%s'" "$1"
        return "${RET_ERROR_DIRECTORY_NOT_FOUND}"
    fi
}

#-------------------------------------------------------------------------------
safe_rm() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        path_to_remove="$1"
        print_rm_error_message="$2"

        log_superdebug "Safely removing '%s'" "${path_to_remove}"

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
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
ensure_does_not_exist() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        path_to_remove="$1"

        log_superdebug "Ensuring file or directory does not exist: '%s'" "${path_to_remove}"

        if \
            [ -f "${path_to_remove}" ] ||
            [ -d "${path_to_remove}" ]
        then
            safe_rm "${path_to_remove}"
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
create_dir() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        destdir="$1"

        ensure_does_not_exist "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to remove path '%s'" "${destdir}"
            exit $ret
        fi

        log_superdebug "Creating directory '%s'" "${destdir}"

        mkdir -p "${destdir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to create directory '%s'" "${destdir}"
            exit "${RET_ERROR_CREATE_DIRECTORY_FAILED}"
        fi
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
ensure_dir() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        destdir="$1"

        log_superdebug "Ensuring directory exists: '%s'" "${destdir}"

        if [ ! -d "${destdir}" ]; then
            create_dir "${destdir}"
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
get_datetime_stamp_human_formatted()
{
    date "${DATETIME_STAMP_HUMAN_FORMAT}"
}

#-------------------------------------------------------------------------------
get_datetime_stamp_filename_formatted()
{
    date "${DATETIME_STAMP_FILENAME_FORMAT}"
}

#-------------------------------------------------------------------------------
create_my_tempdir() {
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
                the_tempdir="${HOME}/bfi_temp/$(get_datetime_stamp_filename_formatted)"
            fi
        else
            the_tempdir=$(mktemp -d -t "$(get_my_real_basename)-$(get_datetime_stamp_filename_formatted).XXXXXXX")
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to get temporary directory"
                exit "${RET_ERROR_FAILED_TO_GET_TEMP_DIR}"
            fi
        fi

        the_tempdir="$(windows_path_to_unix_path "${the_tempdir}")"

        command echo "${the_tempdir}"
        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
ensure_my_tempdir_G() {
    # intentionally no local scope b/c modifying a global

    if [ "${my_tempdir}" = "" ]; then
        my_tempdir="$(create_my_tempdir)"
        ret=$?
        if [ $ret -ne 0 ]; then
            return $ret
        fi
    fi

    ensure_dir "${my_tempdir}"
    ret=$?
    if [ $ret -ne 0 ]; then
        return $ret
    fi

    export my_tempdir

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
move_file() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        source_filepath="$1"
        dest_filepath="$2"

        log_superdebug "Copying file '${source_filepath}' to '${dest_filepath}'"

        mv "${source_filepath}" "${dest_filepath}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_debug "failed to move file from '%s' to '%s'" "${source_filepath}" "${dest_filepath}"
            exit "${RET_ERROR_COPY_FAILED}"
        fi
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
copy_file() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        source_filepath="$1"
        dest="$2"

        log_superdebug "Copying file '${source_filepath}' to '${dest}'"

        cp "${source_filepath}" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_debug "failed to copy file from '%s' to '%s'" "${source_filepath}" "${dest}"
            exit "${RET_ERROR_COPY_FAILED}"
        fi
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
copy_dir() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        source_dir="$1"
        dest_dir="$2"

        log_superdebug "Copying all files from '${source_dir}' to '${dest_dir}'"

        cp -r "${source_dir}"/. "${dest_dir}/"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_debug "failed to copy files from '%s' to '%s'" "${source_dir}" "${dest_dir}"
            exit "${RET_ERROR_COPY_FAILED}"
        fi
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
is_integer()
{
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
            exit "${RET_ERROR_UNKNOWN}"
        fi

        exit "${RET_SUCCESS}"
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
            exit "${RET_ERROR_UNKNOWN}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
get_my_real_dir_fullpath() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        if [ "$(array_get_length SHELL_SOURCE)" -gt 0 ]; then
            dirname "$(array_get_last SHELL_SOURCE)"
        else
            echo "UNKNOWN"
            exit "${RET_ERROR_UNKNOWN}"
        fi

        exit "${RET_SUCCESS}"
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
            exit "${RET_ERROR_UNKNOWN}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
}

#-------------------------------------------------------------------------------
unident_text() {
    (
        text="$1"
        leading="$(echo "${text}" | head -n 1 | sed -e "s/\( *\)\(.*\)/\1/")"
        echo "${text}" | sed -e "s/\(${leading}\)\(.*\)/\2/"
    )
}

#endregion Helper Functions
#===============================================================================

#===============================================================================
#region Source/Invoke Check For Top Level File

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
            if [ "${TEMP_FILE_NAME}" != "${x}" ]; then
                log_ultradebug "TEMP_FILE_NAME and x are different."
                if [ "${x}" = "pipe" ]; then
                    log_ultradebug "x is 'pipe', probably github invoked."
                    # github invoked
                    array_append WAS_SOURCED false
                elif [ "${x}" = "NONE" ]; then
                    log_ultradebug "lsof not available, probably wsl invoked."
                    # wsl doesn't have lsof, so invoked
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
#region Public *

#===============================================================================
#region Create Fence

BATTERIES_FORKING_INCLUDED_CONSTANTS_LOADED() { true; }

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

# Special code for a special success (for use by functions to return
#   success + other state)
RET_SUCCESS_SPECIAL=252; export RET_SUCCESS_SPECIAL

# Special code for when Version gets printed out
RET_SUCCESS_VERSION_PRINTED=253; export RET_SUCCESS_VERSION_PRINTED

# Special code for when Usage gets printed out
RET_SUCCESS_USAGE_PRINTED=254; export RET_SUCCESS_USAGE_PRINTED

# Reserved b/c shell weirdness
RET_ERROR_UNKNOWN_255=255; export RET_ERROR_UNKNOWN_255
RET_ERROR_UNKNOWN_NEG1=-1; export RET_ERROR_UNKNOWN_NEG1

# Ranges
RET_CODE_LOCAL_ERROR_RANGE_START=1; export RET_CODE_LOCAL_ERROR_RANGE_START
RET_CODE_LOCAL_ERROR_RANGE_END=63; export RET_CODE_LOCAL_ERROR_RANGE_END
RET_CODE_LOCAL_WARNING_RANGE_START=64; export RET_CODE_LOCAL_WARNING_RANGE_START
RET_CODE_LOCAL_WARNING_RANGE_END=127; export RET_CODE_LOCAL_WARNING_RANGE_END
RET_CODE_GLOBAL_ERROR_RANGE_START=128; export RET_CODE_GLOBAL_ERROR_RANGE_START
RET_CODE_GLOBAL_ERROR_RANGE_END=191; export RET_CODE_GLOBAL_ERROR_RANGE_END
RET_CODE_GLOBAL_WARNING_RANGE_START=192; export RET_CODE_GLOBAL_WARNING_RANGE_START
RET_CODE_GLOBAL_WARNING_RANGE_END=251; export RET_CODE_GLOBAL_WARNING_RANGE_END

#-------------------------------------------------------------------------------
return_code_is_error() {
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
return_code_is_warning() {
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
return_code_is_success() {
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
            [ $val -eq "${RET_SUCCESS_USAGE_PRINTED}" ] ||
            [ $val -eq "${RET_SUCCESS_VERSION_PRINTED}" ] ||
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
    date() {
        command date -j "$@"
    }

    DEFAULT_ADMIN_GROUP="staff"; export DEFAULT_ADMIN_GROUP

    CONDA_FORGE_PLATFORM="MacOSX"; export CONDA_FORGE_PLATFORM
    CONDA_FORGE_EXT="sh"; export CONDA_FORGE_EXT
elif \
    [ "${REAL_PLATFORM}" = "Linux" ] ||
    [ "$(echo "${REAL_PLATFORM}" | grep -e 'MINGW64_NT' )" != "" ]
then
    date() {
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
    [ "$(echo "${REAL_PLATFORM}" | grep -e 'MINGW64_NT' )" != "" ]
then
    PLATFORM_IS_WSL=true
fi
export PLATFORM_IS_WSL;

#endregion Platform Constants
#===============================================================================

#===============================================================================
#region Calculated "Constants"

set_calculated_constants() {
    # CONDA_BASE_DIR_FULLPATH="$(dirname "$(dirname "${CONDA_EXE}")")"
    # export CONDA_BASE_DIR_FULLPATH
    true
}
set_calculated_constants

#endregion Calculated "Constants"
#===============================================================================

#===============================================================================
#region Colorized Output Constants & Helper Functions

ANSI_CODE_START="\033["; export ANSI_CODE_START
ANSI_CODE_END="m"; export ANSI_CODE_END

#-------------------------------------------------------------------------------
get_ansi_code()
{
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        ending="$3"
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
        if [ "$(command echo "$TERM" | grep 'mono')" != "" ] ||
            [ "${tput_colors}" -lt 16 ] ||
            [ "${NO_COLOR}" != "" ] ||
            [ "${colorized_output}" = false ];
        then
            command printf ""
        elif [ "${colorized_output}" = "alt" ] && [ "$2" != "" ]; then
            command printf "${ANSI_CODE_START}$2${ending}"
        else
            command printf "${ANSI_CODE_START}$1${ending}"
        fi

        exit 0
    )
    exit_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $exit_ret
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

    ANSI_SUCCESS="${ANSI_COLOR_SUCCESS}"; export ANSI_SUCCESS
    ANSI_FATAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 "; export ANSI_FATAL
    ANSI_ERROR="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ "; export ANSI_ERROR
    ANSI_WARNING="${ANSI_COLOR_WARNING}⚠️ "; export ANSI_WARNING
    ANSI_IMPORTANT="${ANSI_COLOR_WARNING}"; export ANSI_WARNING
    ANSI_HEADER="${ANSI_COLOR_HEADER}"; export ANSI_HEADER
    ANSI_FOOTER="${ANSI_COLOR_FOOTER}"; export ANSI_FOOTER
    ANSI_INFO="${ANSI_COLOR_INFO}"; export ANSI_INFO
    ANSI_DEBUG="${ANSI_COLOR_DEBUG}"; export ANSI_DEBUG
    ANSI_SUPERDEBUG="${ANSI_COLOR_SUPERDEBUG}"; export ANSI_SUPERDEBUG
    ANSI_ULTRADEBUG="${ANSI_COLOR_ULTRADEBUG}"; export ANSI_ULTRADEBUG

    ANSI_SUCCESS_FINAL="${ANSI_COLOR_SUCCESS}${ANSI_BELL}✅ "; export ANSI_SUCCESS_FINAL
    ANSI_FATAL_FINAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 "; export ANSI_FATAL_FINAL
    ANSI_ERROR_FINAL="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ "; export ANSI_ERROR_FINAL
    ANSI_WARNING_FINAL="${ANSI_COLOR_WARNING}${ANSI_BELL}⚠️ "; export ANSI_WARNING_FINAL
}
set_ansi_code_constants

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

# #-------------------------------------------------------------------------------
# teeoutput() {
#     _stdout=$1
#     _stderr=$2
#     shift 2

#     # Run the script through /bin/sh with fake tty
#     if \
#         { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
#         [ "${OMEGA_DEBUG:-}" = true ] ||
#         [ "${OMEGA_DEBUG:-}" = "all" ]
#     then
#         {
#             {
#                 {
#                     "$@"
#                     ret=$?
#                 } | tee -a "${_stdout}";  # capture stdout to files
#             } 2>&1 1>&3 | tee -a "${_stderr}";  # redirect stdout to 3, redirect stderr to stdout, capture "stdout(stderr)" to files
#         } 3>&1 1>&2  # redirect stdout(stderr) to stderr, redirect 3(stdout) to stdout
#     else
#         "$@" 1>>"${_stdout}" 2>>"${_stderr}"
#         # ret=$?
#     fi

#     # Return the status code
#     return $ret
# }

# #-------------------------------------------------------------------------------
# teetty_G() {
#     _stdout=$1
#     _stderr=$2
#     shift 2

#     # Create a temporary file for storing the status code
#     tmp=$(mktemp)
#     ret=$?
#     if \
#         [ $ret -ne 0 ] ||
#         [ "$tmp" = "" ] ||
#         [ ! -f "$tmp" ]
#     then
#         exit "${RET_ERROR_COULD_NOT_CREATE_TEMP_FILE}"
#     fi

#     # Produce a script that runs the command provided to teetty_G as
#     # arguments and stores the status code in the temporary file
#     esceval()
#     {
#         command printf '%s ' "$@" | sed "s/'/'\\\\''/g"
#     }
#     _cmd="$(esceval "$@"); command echo \$? > $tmp"

#     # Run the script through /bin/sh with fake tty
#     if \
#         { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
#         [ "${OMEGA_DEBUG:-}" = true ] ||
#         [ "${OMEGA_DEBUG:-}" = "all" ]
#     then
#         {
#             {
#                 {
#                     if [ "$(uname)" = "Darwin" ]; then
#                         # MacOS
#                         script -Fq /dev/null /bin/sh -c "$_cmd"
#                     else
#                         script -qfc "/bin/sh -c $(esceval "$_cmd")" /dev/null
#                     fi
#                 } | tee -a "${_stdout}";  # capture stdout to files
#             } 2>&1 1>&3 | tee -a "${_stderr}";  # redirect stdout to 3, redirect stderr to stdout, capture "stdout(stderr)" to files
#         } 3>&1 1>&2  # redirect stdout(stderr) to stderr, redirect 3(stdout) to stdout
#     else
#         {
#             {
#                 {
#                     if [ "$(uname)" = "Darwin" ]; then
#                         # MacOS
#                         script -Fq /dev/null /bin/sh -c "$_cmd"
#                     else
#                         script -qfc "/bin/sh -c $(esceval "$_cmd")" /dev/null
#                     fi
#                 } | cat >> "${_stdout}";  # capture stdout to files
#             } 2>&1 1>&3 | cat >> "${_stderr}";  # redirect stdout to 3, redirect stderr to stdout, capture "stdout(stderr)" to files
#         } 3>&1 1>&2  # redirect stdout(stderr) to stderr, redirect 3(stdout) to stdout
#     fi

#     # Ensure that the status code was written to the temporary file or
#     # fail with status 128
#     if [ ! -s "$tmp" ]; then
#         return "${RET_ERROR_GET_SUBCOMMAND_RETURN_CODE_FAILED}"
#     fi

#     # Collect the status code from the temporary file
#     ret=$(cat "$tmp")
#     ret=$(( ret + 0 ))

#     # Remove the temporary file
#     rm -f "$tmp"

#     # Return the status code
#     return $ret
# }

#-------------------------------------------------------------------------------
create_fifo() {
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
cleanup_fifo() {
    rm -f -- "$1"
}

#-------------------------------------------------------------------------------
teetty_G() {
    _stdout="$1"
    _stderr="$2"
    shift 2

    if [ "${my_tempdir}" = "" ]; then
        ensure_my_tempdir_G
    fi

    _stdout_fifo="$(create_fifo "${my_tempdir}/stdout_fifo")"
    ret=$?
    if [ $ret -ne 0 ]; then
        return $ret
    fi
    _stderr_fifo="$(create_fifo "${my_tempdir}/stderr_fifo")"
    ret=$?
    if [ $ret -ne 0 ]; then
        return $ret
    fi

    if \
        { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
        [ "${OMEGA_DEBUG:-}" = true ] ||
        [ "${OMEGA_DEBUG:-}" = "all" ]
    then
        # shellcheck disable=SC2002
        ( cat "${_stdout_fifo}" | tee -a "${_stdout}" & )
        _stdout_bg_task=$!
        # shellcheck disable=SC2002
        ( cat "${_stderr_fifo}" | tee -a "${_stderr}" & )
        _stderr_bg_task=$!
    else
        # shellcheck disable=SC2002
        ( cat "${_stdout_fifo}" >> "${_stdout}" & )
        _stdout_bg_task=$!
        # shellcheck disable=SC2002
        ( cat "${_stderr_fifo}" >> "${_stderr}" & )
        _stderr_bg_task=$!
    fi

    esceval()
    {
        command printf '%s ' "$@" | sed "s/'/'\\\\''/g"
    }

    eval "$(esceval "$@")" > "${_stdout_fifo}" 2> "${_stderr_fifo}"
    ret=$?

    kill -9 "${_stdout_bg_task}" 2>/dev/null
    kill -9 "${_stderr_bg_task}" 2>/dev/null

    cleanup_fifo "${_stdout_fifo}"
    cleanup_fifo "${_stderr_fifo}"

    # Return the status code
    return $ret
}

#-------------------------------------------------------------------------------
format_log_message()
{
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
        command printf -- "%s %s%s%s\n" "$(get_datetime_stamp_human_formatted)" "${prefix}" "${inner_text%EOL}" "${suffix}"

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_console()
{
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)"
        command printf -- "${message%EOL}"

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_success() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_SUCCESS}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_SUCCESS}" ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_success_final() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_SUCCESS_FINAL}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            [ "${quiet:-}" != true ] ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_fatal() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_FATAL}FATAL: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            [ "${verbosity:-0}" -ge "${LOG_LEVEL_FATAL}" ] ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${FATAL_LOG}" != "" ]; then
            >>"${FATAL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_AND_FATAL_LOG}" != "" ]; then
            >>"${ERROR_AND_FATAL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_fatal_final() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_FATAL_FINAL}FATAL: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            [ "${verbosity:-0}" -ge "${LOG_LEVEL_FATAL}" ] ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${FATAL_LOG}" != "" ]; then
            >>"${FATAL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_AND_FATAL_LOG}" != "" ]; then
            >>"${ERROR_AND_FATAL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_error() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_ERROR}ERROR: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            [ "${verbosity:-0}" -ge "${LOG_LEVEL_ERROR}" ] ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_LOG}" != "" ]; then
            >>"${ERROR_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_AND_FATAL_LOG}" != "" ]; then
            >>"${ERROR_AND_FATAL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_error_final() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_ERROR_FINAL}ERROR: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            [ "${verbosity:-0}" -ge "${LOG_LEVEL_ERROR}" ] ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_LOG}" != "" ]; then
            >>"${ERROR_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${ERROR_AND_FATAL_LOG}" != "" ]; then
            >>"${ERROR_AND_FATAL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_warning() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_WARNING}WARNING: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_WARNING}" ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${WARNING_LOG}" != "" ]; then
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
log_warning_final() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_WARNING_FINAL}WARNING: " "${ANSI_RESET}" "$@"; command echo EOL)"

        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_WARNING}" ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            >&2 command printf -- "${message%EOL}"
        fi

        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi
        if [ "${WARNING_LOG}" != "" ]; then
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
log_header() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_HEADER}" "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_HEADER}" ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "\n"
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "\n"
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_footer() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_FOOTER}" "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_FOOTER}" ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_info_important() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_IMPORTANT}INFO: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_info() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}INFO: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_info_noprefix() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_INFO}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_debug() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_DEBUG}DEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_DEBUG}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_superdebug() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_SUPERDEBUG}SUPERDEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_SUPERDEBUG}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_ultradebug() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_ULTRADEBUG}ULTRADEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)"
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge "${LOG_LEVEL_ULTRADEBUG}" ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

#-------------------------------------------------------------------------------
log_file() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)"
        if [ "${FULL_LOG}" != "" ]; then
            >>"${FULL_LOG}" command printf -- "${message%EOL}"
        fi

        exit "${RET_SUCCESS}"
    )
    log_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $log_ret
}

# #-------------------------------------------------------------------------------
# printf() {
#     log_file "$@"
#     command printf -- "$@"
# }

# #-------------------------------------------------------------------------------
# echo() {
#     log_file "$@"
#     command echo "$@"
# }

#-------------------------------------------------------------------------------
report_errors() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        should_print="$1"
        if [ "${should_print}" = true ]; then
            if [ "$(wc -c <"${ERROR_AND_FATAL_LOG}")" -gt 0 ]; then
                message="${ANSI_COLOR_ERROR}The following errors occurred:${ANSI_RESET}\n"
                >&2 command printf -- "${message}"
                >>"${FULL_LOG}" command printf -- "${message}"

                >&2 command sed 's/^/\t/' "${ERROR_AND_FATAL_LOG}"
                >>"${FULL_LOG}" command sed 's/^/\t/' "${ERROR_AND_FATAL_LOG}"
            fi
        else
            log_ultradebug "Skipping Error Report b/c should_print is '%s'." "${should_print}"
        fi

        exit "${RET_SUCCESS}"
    )
    report_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $report_ret
}

#-------------------------------------------------------------------------------
report_warnings() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        should_print="$1"
        if [ "${should_print}" = true ]; then
            if [ "$(wc -c <"${WARNING_LOG}")" -gt 0 ]; then
                message="${ANSI_COLOR_WARNING}The following warnings occurred:${ANSI_RESET}\n"
                >&2 command printf -- "${message}"
                >>"${FULL_LOG}" command printf "${message}"

                >&2 sed 's/^/\t/' "${WARNING_LOG}"
                >>"${FULL_LOG}" sed 's/^/\t/' "${WARNING_LOG}"
            fi
        else
            log_ultradebug "Skipping Warning Report b/c should_print is '%s'." "${should_print}"
        fi

        exit "${RET_SUCCESS}"
    )
    report_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $report_ret
}

#-------------------------------------------------------------------------------
report_final_status() {
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
            if \
                [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                [ "${LOG_ERROR_COUNT}" -gt 0 ] &&
                [ "${LOG_WARNING_COUNT}" -gt 0 ]
            then
                before_error_text=", "
                before_warning_text=", and "
            elif \
                [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                [ "${LOG_WARNING_COUNT}" -gt 0 ]
            then
                before_warning_text=" and "
            elif \
                [ "${LOG_FATAL_COUNT}" -gt 0 ] &&
                [ "${LOG_ERROR_COUNT}" -gt 0 ]
            then
                before_error_text=" and "
            elif \
                [ "${LOG_ERROR_COUNT}" -gt 0 ] &&
                [ "${LOG_WARNING_COUNT}" -gt 0 ]
            then
                before_warning_text=" and "
            fi

            stored_ret=$ret
            log_info "%s exiting with return code: %d" "${message%EOL}"  "$ret"
            if [ "$stored_ret" -eq 0 ]; then
                log_success_final "%s Completed Successfully." "${message%EOL}"
            elif [ "${LOG_FATAL_COUNT}" -gt 0 ]; then
                log_fatal_final "%s Had %s%s%s%s%s." "${message%EOL}" "${fatal_text}" "${before_error_text}" "${error_text}" "${before_warning_text}" "${warning_text}"
            elif [ "${LOG_ERROR_COUNT}" -gt 0 ]; then
                log_error_final "%s Had %s%s%s." "${message%EOL}" "${error_text}" "${before_warning_text}" "${warning_text}"
            elif [ "${LOG_WARNING_COUNT}" -gt 0 ]; then
                log_warning_final "%s Had %s." "${message%EOL}" "${warning_text}"
            fi
        else
            log_ultradebug "Skipping Final Report b/c should_print is '%s'." "${should_print}"
        fi

        exit "$ret"
    )
    report_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $report_ret
}

#-------------------------------------------------------------------------------
report_all() {
    PSHELL_SESSION_FILE="${SHELL_SESSION_FILE}"
    SHELL_SESSION_FILE=""
    export SHELL_SESSION_FILE
    (
        SHELL_SESSION_FILE=""
        export SHELL_SESSION_FILE

        # input_ret="$1"
        should_print="$2"

        if [ "${should_print}" = true ]; then
            log_header "Report:"
        else
            log_ultradebug "Skipping Report header b/c should_print is '%s'." "${should_print}"
        fi

        report_warnings "${should_print}"
        report_errors "${should_print}"
        report_final_status "$@"
        ret=$?
        if [ "${should_print}" = true ]; then
            message="$(command printf "Fully detailed log is available at '%s'\n" "${FULL_LOG}")"
            >&2 command printf "${message}\n"
            >>"${FULL_LOG}" command printf "${message}\n"
        else
            log_ultradebug "Skipping Full Log path b/c should_print is '%s'." "${should_print}"
        fi
        exit $ret
    )
    report_ret=$?
    SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
    export SHELL_SESSION_FILE
    return $report_ret
}

#-------------------------------------------------------------------------------
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${CONSTANTS_TEMP_DIR}" = "" ]
then
    ensure_my_tempdir_G
    ret=$?
    if [ $ret -ne 0 ]; then
        exit $ret
    fi

    CONSTANTS_TEMP_DIR="${my_tempdir}"
    export CONSTANTS_TEMP_DIR

    CONSTANTS_TEMP_LOG_DIR="${CONSTANTS_TEMP_DIR}"/log

    ensure_dir "${CONSTANTS_TEMP_LOG_DIR}"
    ret=$?
    if [ $ret -ne 0 ]; then
        exit $ret
    fi
    export CONSTANTS_TEMP_LOG_DIR
fi
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${FATAL_LOG}" = "" ]
then
    FATAL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/fatal_only.txt
    export FATAL_LOG
    command printf '' >"${FATAL_LOG}"
fi
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${ERROR_LOG}" = "" ]
then
    ERROR_LOG="${CONSTANTS_TEMP_LOG_DIR}"/errors_only.txt
    export ERROR_LOG
    command printf '' >"${ERROR_LOG}"
fi
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${ERROR_AND_FATAL_LOG}" = "" ]
then
    ERROR_AND_FATAL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/errors_and_fatals_only.txt
    export ERROR_AND_FATAL_LOG
    command printf '' >"${ERROR_AND_FATAL_LOG}"
fi
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${WARNING_LOG}" = "" ]
then
    WARNING_LOG="${CONSTANTS_TEMP_LOG_DIR}"/warnings_only.txt
    export WARNING_LOG
    command printf '' >"${WARNING_LOG}"
fi
if \
    [ "$(array_get_length WAS_SOURCED)" -le 2 ] ||
    [ "${FULL_LOG}" = "" ]
then
    FULL_LOG="${CONSTANTS_TEMP_LOG_DIR}"/log.txt
    export FULL_LOG
    command printf '' >"${FULL_LOG}"
fi

#endregion Logging Helpers
#===============================================================================

#===============================================================================
#region Conda Helpers

#-------------------------------------------------------------------------------
conda_init_G() {
    # intentionally no local scope so it modify globals

    if [ "$1" != "quiet" ]; then
        log_header "Initializing Conda..."
    fi

    # shellcheck disable=SC1091
    include_G "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'. conda.sh' failed with error code: %d" "$ret"
        return "${RET_ERROR_CONDA_INIT_FAILED}"
    fi
    PATH="${CONDA_INSTALL_PATH}/bin:$PATH"
    export PATH

    teetty_G "${FULL_LOG}" "${FULL_LOG}" "type conda | head -n 1"
    teetty_G "${FULL_LOG}" "${FULL_LOG}" conda --version

    if [ "$1" != "quiet" ]; then
        log_footer "Conda Initialized."
    fi

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
conda_full_deactivate_G() {
    # intentionally no local scope so it modify globals

    if [ "$1" != "quiet" ]; then
        log_header "Deactivating Current Conda Environments..."
    fi

    while [ "${CONDA_SHLVL}" -gt 0 ]; do
        teetty_G "${FULL_LOG}" "${FULL_LOG}" conda deactivate
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "'conda deactivate' exited with error code: %d" "$ret"
            return "${RET_ERROR_CONDA_DEACTIVATE_FAILED}"
        fi
    done

    if [ "$1" != "quiet" ]; then
        log_footer "Conda Environments Deactivated."
    fi

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
conda_activate_env_G() {
    if [ "$2" != "quiet" ]; then
        log_header "Activating %s Conda Environment..." "$1"
    fi

    teetty_G "${FULL_LOG}" "${FULL_LOG}" conda activate "$1"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'conda activate \"%2\"' exited with error code: %d" "$1" "$ret"
        return "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
    fi

    if [ "$2" != "quiet" ]; then
        log_footer "%s Conda Environment Activated." "$1"
    fi

    return "${RET_SUCCESS}"
}

#endregion Conda Helpers
#===============================================================================

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
    __main() {
        log_fatal "$(get_my_real_basename) must be sourced"
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

    if [ "$(array_get_last WAS_SOURCED)" = false ]; then
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
SHELL_SESSION_FILE="${PSHELL_SESSION_FILE}"
export SHELL_SESSION_FILE

################################################################################
#region Postamble

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
