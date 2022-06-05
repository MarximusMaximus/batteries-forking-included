#!/usr/bin/env sh

# NOTE: see usage from batteries-forking-included.sh for command line arguments

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

#-------------------------------------------------------------------------------
require_not_root_user_X() {
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

#-------------------------------------------------------------------------------
require_root_user_X() {
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

include_G() {
    # intentionally no local scope so it modify globals

    # shellcheck disable=SC1090
    . "$1"
    return $?
}

ensure_include_GX() {
    # intentionally no local scope so it can modify globals AND exit script

    include_G "$1"
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
    (
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
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
ensure_does_not_exist() {
    (
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
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
create_dir() {
    (
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
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
ensure_dir() {
    (
        destdir="$1"

        log_superdebug "Ensuring directory exists: '%s'" "${destdir}"

        if [ ! -d "${destdir}" ]; then
            create_dir "${destdir}"
            ret=$?
            exit $ret
        fi
    )
    ret=$?
    return $ret
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
    (
        the_tempdir=$(mktemp -d -t "${MY_BASENAME:-UNKNOWN}-$(get_datetime_stamp_filename_formatted)")
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to get temporary directory"
            exit "${RET_ERROR_FAILED_TO_GET_TEMP_DIR}"
        fi
        command echo "${the_tempdir}"
        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
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
    (
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
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
copy_file() {
    (
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
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
copy_dir() {
    (
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
    ret=$?
    return $ret
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
get_my_real_basename() {
    (
        last_was_sourced="$(array_get_last WAS_SOURCED)"
        last_was_sourced_is_integer="$(is_integer "${last_was_sourced}")"
        if [ "${last_was_sourced_is_integer}" -eq 0 ]; then
            if [ "${last_was_sourced}" -eq 0 ]; then
                command echo "${MY_BASENAME}"
            else
                if [ "$(array_get_length SOURCED_BASENAME)" -gt 0 ]; then
                    command echo "$(array_get_last SOURCED_BASENAME)"
                else
                    command echo "UNKNOWN"
                fi
            fi
        else
            command echo "${MY_BASENAME}"
        fi

        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
}

#endregion Helper Functions
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
    BATTERIES_FORKING_INCLUDED_FULLPATH="${MY_DIR_FULLPATH}/../batteries-forking-included"
    export BATTERIES_FORKING_INCLUDED_FULLPATH

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

(
    ############################################################################
    #region Includes

    ensure_include_GX "${MY_DIR_FULLPATH}/batteries-forking-included.sh"

    #endregion Includes
    ############################################################################

    ############################################################################
    #region Private Constants

    SET_OMEGA_DEBUG=false

    #endregion Constants
    ############################################################################

    ############################################################################
    #region "Globals"

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        log_ultradebug "%s: OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "%s: SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    fi

    #endregion "Globals"
    ############################################################################

    ############################################################################
    #region Private Functions

    __main () {
        # command echo "OMEGA_DEBUG=${OMEGA_DEBUG}"
        log_ultradebug "${MY_BASENAME} called with '%s'" "$*"

        batteries_forking_included__bootstrap "$@"
        ret=$?
        return $ret
    }

    #---------------------------------------------------------------------------
    __sourced_main () {
        log_fatal "$(array_get_last SOURCED_BASENAME) should not be sourced"
        return "${RET_ERROR_SCRIPT_WAS_SOURCED}"
    }

    #endregion Functions
    ############################################################################

    ############################################################################
    #region Immediate

    if [ "$(array_get_last WAS_SOURCED)" -eq 0 ]; then
        __main "$@"
        ret=$?
    else
        __sourced_main
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
