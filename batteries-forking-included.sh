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
    -p[=]PROJECT_DIR, --project-dir[=]PROJECT_DIR
                        override to use specified project dir
                        default: current working directory of invocation

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

    __LAST_INCLUDE="$(rreadlink "$1")"

    log_ultradebug "Sourcing: %s as %s" "$1" "${__LAST_INCLUDE}"

    array_append SHELL_SOURCE "${__LAST_INCLUDE}"
    export SHELL_SOURCE
    array_append WAS_SOURCED true
    export WAS_SOURCED

    # shellcheck disable=SC1090
    . "${__LAST_INCLUDE}"
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
    if [ ! -f "$1" ]; then
        log_warning "Could not invoke because file is missing: %s" "$1"
        return "${RET_ERROR_FILE_NOT_FOUND}"
    fi

    __LAST_INCLUDE="$(rreadlink "$1")"

    log_ultradebug "Invoking: %s as %s" "$1" "${__LAST_INCLUDE}"

    array_append SHELL_SOURCE "${__LAST_INCLUDE}"
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
#region Includes

ensure_include_GXY "$(get_my_real_dir_fullpath)/bfi-base.sh"

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

# used ony by bootstrap
project_base_name=""; export project_base_name
dev_mode="${BFI_DEV_MODE:-false}"; export dev_mode
dev_mode_unsticky=false
deploy_mode=false; export deploy_mode


#endregion Public Globals
#===============================================================================

#===============================================================================
#region Public Functions

#-------------------------------------------------------------------------------
print_usage__update() {
    # we do not use 'command' here b/c we want this to get output to the log file
    # but we don't use a log_* function b/c we don't want the console output to
    # have a timestamp just hanging out b/c it looks ugly
    printf "%s\n" "${usage_text__update}"
}

#-------------------------------------------------------------------------------
print_usage__bootstrap() {
    # we do not use 'command' here b/c we want this to get output to the log file
    # but we don't use a log_* function b/c we don't want the console output to
    # have a timestamp just hanging out b/c it looks ugly
    printf "%s\n" "${usage_text__bootstrap}"
}

#-------------------------------------------------------------------------------
print_version() {
    printf "batteries-forking-included %s\n" "${BFI_VERSION}./"
}

#-------------------------------------------------------------------------------
parse_args__common_doubledash() {
    case "$1" in
        -h|-\?|--help|--usage)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found usage arg"
            should_print_usage=true
            ;;

        -V|--version)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found version arg"
            should_print_version=true
            ;;
        -q|--quiet)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found quiet arg"
            quiet=true
            ;;
        +q|--no-quiet)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-quiet arg"
            quiet=false
            ;;

        -v|--verbose)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found verbose arg"
            temp_verbosity=$((temp_verbosity + 1))
            ;;
        +v|--no-verbose)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-verbose arg"
            temp_verbosity=$((temp_verbosity - 1))
            ;;

        -c|--color)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found color arg"
            colorized_output=true
            ;;
        +c|--no-color)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-color arg"
            colorized_output=false
            ;;

        -C|--alt-color)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found alt-color arg"
            alt_color=true
            ;;
        +C|--no-alt-color)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-alt-color arg"
            alt_color=false
            ;;

        -r|--report)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found report arg"
            print_report=true
            ;;
        +r|--no-report)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found no-report arg"
            print_report=false
            ;;

        --?*)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_doubledash;\t found unknown arg"
            log_warning " Unknown option (ignored): %s" "$1" >&2
            ;;
    esac
}

#-------------------------------------------------------------------------------
parse_args__common_singledash() {
    parse_args__common_doubledash "$1"
}

#-------------------------------------------------------------------------------
parse_args__common_singledash_multi() {
    case "$1" in
        h|\?)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found usage flag"
            should_print_usage=true
            ;;
        V)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found version flag"
            should_print_version=true
            ;;
        q)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found quiet flag"
            quiet=true
            ;;
        v)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found verbose flag"
            temp_verbosity=$((temp_verbosity + 1)) # Each -v argument adds 1 to verbosity.
            ;;

        c)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found color flag"
            colorized_output=true
            ;;

        C)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found alt-color flag"
            alt_color=true
            ;;

        r)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singledash_multi;\t found report flag"
            print_report=true
            ;;

        *)
            log_warning "Unknown flag (ignored): %s" "$1"
            ;;
    esac
}

#-------------------------------------------------------------------------------
parse_args__common_singleplus() {
    parse_args__common_doubledash "$1"
}

#-------------------------------------------------------------------------------
parse_args__common_singleplus_multi() {
    case "$1" in
        h|\?)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found usage flag"
            should_print_usage=true
            ;;
        V)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found version flag"
            should_print_version=true
            ;;
        q)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-quiet flag"
            quiet=false
            ;;
        v)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found verbose flag"
            temp_verbosity=$((temp_verbosity - 1))
            ;;

        c)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-color flag"
            colorized_output=false;
            ;;

        C)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-alt-color flag"
            alt_color=false
            ;;

        r)
            log_ultradebug "$(get_my_real_basename)::parse_args__common_singleplus_multi;\t found no-report flag"
            print_report=false
            ;;

        *)
            log_warning "Unknown flag (ignored): %s" "$1"
            ;;
    esac
}

#-------------------------------------------------------------------------------
parse_args__common_set_and_export() {
    verbosity="${temp_verbosity}"

    if [ "${alt_color}" = true ]; then
        colorized_output=alt
    fi

    export colorized_output
    export verbosity
    export quiet
    export should_print_usage
    export should_print_version
    export print_report

    # recalculate "constant" values
    set_calculated_constants
    set_ansi_code_constants

    log_debug "colorized_output=%s" "${colorized_output}"
    log_debug "verbosity=%d" "${verbosity}"
    log_debug "quiet=%s" "${quiet}"
    log_debug "should_print_usage=%s" "${should_print_usage}"
    log_debug "should_print_version=%s" "${should_print_version}"
    log_debug "print_report=%s" "${print_report}"

    if [ "${should_print_version}" = true ]; then
        print_version
        exit "${RET_SUCCESS_VERSION_PRINTED}"
    fi
}

#-------------------------------------------------------------------------------
parse_args__bootstrap() {
    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap called with '%s'" "$*"

    # temporarily just assign these to best guesses
    project_dir="$(pwd)"
    project_base_name="$(basename -- "${project_dir}")"

    project_base_name_temp=""

    temp_verbosity="${verbosity}"
    alt_color=false

    positional_arg_index=0

    while true; do
        log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while; \$1='%s'; \$*='%s'" "$1" "$*"

        if [ $# -le 0 ]; then
            break
        fi

        case "$1" in
            --)     # stop processing args
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found -- arg"
                shift
                break
                ;;

            -d|--dev|--developer)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found dev arg"
                dev_mode=true
                dev_mode_unsticky=true
                ;;
            +d|--no-dev|--no-developer)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found no-dev arg"
                dev_mode=false
                dev_mode_unsticky=true
                ;;

            -D|--deploy|--deployment)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found deploy arg"
                deploy_mode=true
                ;;
            +D|--no-deploy|--no-deployment)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found no-deploy arg"
                deploy_mode=false
                ;;

            -p|--project-dir)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir arg"
                if [ -n "$2" ]; then
                    project_dir="$2"
                    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                    shift
                else
                    print_usage
                    log_error "\"--project-dir\" requires a non-empty option argument."
                    exit "${RET_ERROR_INVALID_ARGUMENT}"
                fi
                ;;
            -p=?*|--project-dir=?*)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir=* arg"
                project_dir="$1"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                project_dir="$(command echo "${project_dir}" | cut -c 15-)"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                ;;
            -p=|--project-dir=)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir= arg"
                print_usage
                log_error "\"--project-dir\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
                ;;

            -P|--project-base-name)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name arg"
                if [ -n "$2" ]; then
                    project_base_name_temp="$2"
                    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                    shift
                else
                    print_usage
                    log_error "\"--project-base-name\" requires a non-empty option argument."
                    exit "${RET_ERROR_INVALID_ARGUMENT}"
                fi
                ;;
            -P=?*|--project-base-name=?*)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name=* arg"
                project_base_name_temp="$1"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                project_base_name_temp="$(command echo "${project_base_name_temp}" | cut -c 21-)"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                ;;
            -P=|--project-base-name=)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-base-name= arg"
                print_usage
                log_error "\"--project-base-name\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
                ;;

            --?*)
                parse_args__common_doubledash "$1"
                ;;

            -?)
                parse_args__common_singledash "$1"
                ;;

            -?*)    # positive flags
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found positive flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        d)
                            log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-);\t found dev flag"
                            dev_mode=true;
                            dev_mode_unsticky=true
                            ;;

                        D)
                            log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-);\t found deploy flag"
                            deploy_mode=true;
                            ;;

                        *)
                            parse_args__common_singledash_multi "${arg_char}"
                            ;;
                    esac

                done
                ;;

            +?*)    # negative flags
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found negative flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        d)
                            log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(+);\t found no-dev flag"
                            dev_mode=false;
                            dev_mode_unsticky=true
                            ;;

                        D)
                            log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while::while(+);\t found no-deploy flag"
                            deploy_mode=false;
                            ;;

                        *)
                            parse_args__common_singleplus_multi "${arg_char}"
                            ;;
                    esac

                done
                ;;

            *)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found positional arg #%d '%s'" "${positional_arg_index}" "$1"

                case "${positional_arg_index}" in
                    # 0)
                    #     ;;
                    # 1)
                    #     ;;
                    *)
                        log_warning "Extra positional arg (ignored): %s" "$1"
                        ;;
                esac

                positional_arg_index=$((positional_arg_index + 1))
                ;;
        esac
        shift
    done

    # # if --file was provided, open it for writing, else duplicate stdout
    # if [ -n "$file" ]; then
    #     exec 3> "$file"
    # else
    #     exec 3>&1
    # fi

    parse_args__common_set_and_export

    project_dir="$(rreadlink "${project_dir}")"

    export project_dir
    if [ "${project_base_name_temp}" = "" ]; then
        project_base_name="$(basename -- "${project_dir}")"
    else
        project_base_name="${project_base_name_temp}"
    fi
    export project_base_name
    export dev_mode
    export dev_mode_unsticky
    export deploy_mode

    batteries_forking_included_dir_fullpath="${project_dir}/../batteries-forking-included"
    export batteries_forking_included_dir_fullpath

    log_debug "project_dir=%s" "${project_dir}"
    log_debug "project_base_name=%s" "${project_base_name}"
    log_debug "dev_mode=%s" "${dev_mode}"
    log_debug "dev_mode_unsticky=%s" "${dev_mode_unsticky}"
    log_debug "deploy_mode=%s" "${deploy_mode}"

    if [ "${should_print_usage}" = true ]; then
        print_usage__bootstrap
        exit "${RET_SUCCESS_USAGE_PRINTED}"
    fi

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
parse_args__update() {
    log_ultradebug "$(get_my_real_basename)::parse_args__update called with '%s'" "$*"

    # temporarily just assign these to best guesses
    project_dir="$(pwd)"

    temp_verbosity="${verbosity}"
    alt_color=false

    positional_arg_index=0

    while true; do
        log_ultradebug "$(get_my_real_basename)::parse_args::while; \$1='%s'; \$*='%s'" "$1" "$*"

        if [ $# -le 0 ]; then
            break
        fi

        case "$1" in
            --)     # stop processing args
                log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found -- arg"
                shift
                break
                ;;

            -p|--project-dir)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir arg"
                if [ -n "$2" ]; then
                    project_dir="$2"
                    log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                    shift
                else
                    print_usage
                    log_error "\"--project-dir\" requires a non-empty option argument."
                    exit "${RET_ERROR_INVALID_ARGUMENT}"
                fi
                ;;
            -p=?*|--project-dir=?*)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir=* arg"
                project_dir="$1"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                project_dir="$(command echo "${project_dir}" | cut -c 15-)"
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t\t project_dir=%s" "${project_dir}"
                ;;
            -p=|--project-dir=)
                log_ultradebug "$(get_my_real_basename)::parse_args__bootstrap::while;\t found project-dir= arg"
                print_usage
                log_error "\"--project-dir\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
                ;;

            --?*)
                parse_args__common_doubledash "$1"
                ;;

            -?)
                parse_args__common_singledash "$1"
                ;;

            -?*)    # positive flags
                log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found positive flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "$(get_my_real_basename)::parse_args::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        *)
                            parse_args__common_singledash_multi "${arg_char}"
                            ;;
                    esac

                done
                ;;

            +?*)    # negative flags
                log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found negative flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "$(get_my_real_basename)::parse_args::while::while(+); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        *)
                            parse_args__common_singleplus_multi "${arg_char}"
                            ;;
                    esac

                done
                ;;

            *)
                log_ultradebug "$(get_my_real_basename)::parse_args::while;\t found positional arg #%d '%s'" "${positional_arg_index}" "$1"

                case "${positional_arg_index}" in
                    # 0)
                    #     ;;
                    # 1)
                    #     ;;
                    *)
                        log_warning "Extra positional arg (ignored): %s" "$1"
                        ;;
                esac

                positional_arg_index=$((positional_arg_index + 1))
                ;;
        esac
        shift
    done

    # # if --file was provided, open it for writing, else duplicate stdout
    # if [ -n "$file" ]; then
    #     exec 3> "$file"
    # else
    #     exec 3>&1
    # fi

    parse_args__common_set_and_export

    project_dir="$(rreadlink "${project_dir}")"

    export project_dir

    batteries_forking_included_dir_fullpath="${project_dir}/../batteries-forking-included"
    export batteries_forking_included_dir_fullpath

    log_debug "project_dir=%s" "${project_dir}"

    if [ "${should_print_usage}" = true ]; then
        print_usage__update
        exit "${RET_SUCCESS_USAGE_PRINTED}"
    fi

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
check_tools__begin() {
    log_header "Checking tools"
}

#-------------------------------------------------------------------------------
check_tools__end() {
    log_footer "Tools checked."
}

#-------------------------------------------------------------------------------
check_tools__detect_G() {
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
check_tools__require_extractable_X() {
    if \
        [ "${tar_exists}" = false ] &&
        [ "${unzip_exists}" = false ]
    then
        log_fatal "no way to extract from compressed file available (no tar, no unzip)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
check_tools__require_clonable_X() {
    if \
        [ "${git_exists}" = false ] &&
        [ "${curl_exists}" = false ] &&
        [ "${wget_exists}" = false ]
    then
        log_fatal "no way to clone repo available (no git, no curl, no wget)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi

    if [ "${git_exists}" = false ]; then
        require_extractable
    fi
}

#-------------------------------------------------------------------------------
check_tools__require_downloadable_X() {
    if \
        [ "${curl_exists}" = false ] &&
        [ "${wget_exists}" = false ]
    then
        log_fatal "no way to download available (no curl, no wget)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
check_tools__require_comparible_X() {
    if \
        [ "${diff_exists}" = false ] &&
        [ "${md5_exists}" = false ]
    then
        log_fatal "no way to compare files (no diff, no md5)"
        exit "${RET_ERROR_TOOL_MISSING}"
    fi
}

#-------------------------------------------------------------------------------
download_url_to_path() {
    (
        URL="$1"
        output="$2"

        check_tools__require_downloadable_X

        if [ "${curl_exists}" = true ]; then
            log_info "Using curl to download '${URL}' to '${output}'"
            teetty_G "${FULL_LOG}" "${FULL_LOG}" curl -# -L "${URL}" --fail --output "${output}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to download ${URL} (curl)"
                exit "${RET_ERROR_DOWNLOAD_FAILED}"
            fi
        elif [ "${wget_exists}" = true ]; then
            log_info "Using wget to download '${URL}' to '${output}'"
            teetty_G "${FULL_LOG}" "${FULL_LOG}" wget "${URL}" -O "${output}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to download ${URL} (wget)"
                exit "${RET_ERROR_DOWNLOAD_FAILED}"
            fi
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
extract_tarball() {
    (
        file=$1
        dest=$2

        log_info "Extracting tarball '%s' to '%s'" "${file}" "${dest}"

        _dest=""
        if [ "${dest}" != "" ]; then
            _dest=" -C "
        fi

        teetty_G "${FULL_LOG}" "${FULL_LOG}"  tar -xzvf "${file}" --strip=1"${_dest}""${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to extract ${file} compressed file (tar)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
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

        teetty_G "${FULL_LOG}" "${FULL_LOG}" unzip -v -d "${my_tempdir}/extracted" "${file}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to extract  ${file} compressed file (unzip)"
            exit "${RET_ERROR_EXTRACTION_FAILED}"
        fi

        if [ "${dest}" = "" ]; then
            dest=$(pwd)
        fi

        move_file "${my_tempdir}/extracted/*/*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to move extracted files into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi

        move_file "${my_tempdir}/extracted/*/.*" "${dest}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to move extracted files dotfiles into place from temporary directory"
            exit "${RET_ERROR_MOVE_FAILED}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
download_and_extract() {
    (
        repo_url=$1
        file_basename=$2
        destdir="$3"

        check_tools__require_downloadable_X
        check_tools__require_extractable_X

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
            log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        download_url_to_path "${URL}" "${filepath}"

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
            extract_zipball "${my_tempdir}/${file_basename}.zip" "${destdir}"
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        else  # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "No way to extract from compressed file available (no tar, no unzip)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
ensure_conda() {
    (
        log_header "Checking For Conda..."

        if [ ! -f "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh" ]; then
            log_footer "Conda Not Found."

            log_header "Installing Conda..."

            ensure_my_tempdir_G
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            ensure_dir "${my_tempdir}/downloads"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            file_to_download="Miniforge3-${CONDA_FORGE_PLATFORM}-${CONDA_FORGE_ARCH}.${CONDA_FORGE_EXT}"
            URL="https://github.com/conda-forge/miniforge/releases/latest/download/${file_to_download}"
            conda_installer="${my_tempdir}/downloads/${file_to_download}"

            download_url_to_path "${URL}" "${conda_installer}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            teetty_G "${FULL_LOG}" "${FULL_LOG}" chmod +x "${my_tempdir}/downloads/${file_to_download}"

            dirname_CONDA_INSTALL_PATH="$(dirname "${CONDA_INSTALL_PATH}")"
            if [ ! -d "${dirname_CONDA_INSTALL_PATH}" ]; then
                log_console "${ANSI_BELL}${ANSI_WARNING} '${dirname_CONDA_INSTALL_PATH}' doesn't exist, we need sudo to create it, either enter your password below OR exit this script (CTRL+C multiple times) and run the following commands and rerun this script.${ANSI_RESET}\nsudo mkdir \"${dirname_CONDA_INSTALL_PATH}\"\nsudo chown \"${REAL_USER}\":\"${DEFAULT_ADMIN_GROUP}\" \"${dirname_CONDA_INSTALL_PATH}\"\nsudo -k"
                (
                    sudo mkdir "${dirname_CONDA_INSTALL_PATH}"
                    sudo chown "${REAL_USER}":"${DEFAULT_ADMIN_GROUP}" "${dirname_CONDA_INSTALL_PATH}"
                    sudo -k
                )
            fi

            log_info "Installing Conda with PREFIX='${CONDA_INSTALL_PATH}'"

            teetty_G "${FULL_LOG}" "${FULL_LOG}" "${conda_installer}" -b -f -p "${CONDA_INSTALL_PATH}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "Failed to install Conda."
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            else
                log_footer "Conda Install Completed."
                exit "${RET_SUCCESS}"
            fi
        else
            log_footer "Conda Found."
            exit "${RET_SUCCESS}"
        fi
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
conda_update_base()
{
    (
        log_header "Updating Base Conda Environment..."

        teetty_G "${FULL_LOG}" "${FULL_LOG}" conda activate base
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "'conda activate base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
        fi

        teetty_G "${FULL_LOG}" "${FULL_LOG}" conda update -n base conda
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "'conda update -n base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
        fi

        teetty_G "${FULL_LOG}" "${FULL_LOG}" conda update -n base --all -v -y --prune
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "'conda update -n base' exited with error code: %d" "$ret"
            exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
        fi

        log_footer "Base Conda Environment Updated."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
conda_setup_env()
{
    (
        log_header "Looking for %s Conda Environment..." "${project_base_name}"

        found_env=$(conda env list | awk -v project_base_name="${project_base_name}" '{if ($1 == project_base_name) print $1}')

        if [ "${found_env}" = "" ]; then
            log_footer "%s Conda Environment not found." "${project_base_name}"
        else
            log_footer "%s Conda Environment found." "${project_base_name}"
        fi

        if [ "${found_env}" = "" ]; then
            log_header "Installing %s Conda Environment..." "${project_base_name}"

            teetty_G "${FULL_LOG}" "${FULL_LOG}" conda env create --name "${project_base_name}" --file ./conda-environment.yml -v
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'conda create --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            log_footer "%s Conda Environment Installed." "${project_base_name}"
        else
            log_header "Updating %s Conda Environment..." "${project_base_name}"

            teetty_G "${FULL_LOG}" "${FULL_LOG}" conda env update --name "${project_base_name}" --file ./conda-environment.yml --prune -v
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'conda update --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            log_footer "%s Conda Environment Updated." "${project_base_name}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
conda_env_read_sticky_config() {
    log_header "Loading sticky configuration options..."

    log_superdebug "dev_mode_unsticky=${dev_mode_unsticky}"
    if [ "${dev_mode_unsticky}" != true ]; then
        log_superdebug "doing dev_mode=\"\$\{BFI_DEV_MODE:-\$\{dev_mode\}\}\""
        dev_mode="${BFI_DEV_MODE:-${dev_mode}}"
    else
        log_superdebug "SKIPPING dev_mode=\"\$\{BFI_DEV_MODE:-\$\{dev_mode\}\}\""
    fi
    export dev_mode
    log_debug "dev_mode=%s" "${dev_mode}"

    log_footer "Sticky configuration options loaded."
}

#-------------------------------------------------------------------------------
conda_env_write_sticky_config() {
    log_header "Writing sticky configuration options..."

    ensure_dir "${CONDA_PREFIX}"/etc/conda/activate.d
    ensure_dir "${CONDA_PREFIX}"/etc/conda/deactivate.d
    touch "${CONDA_PREFIX}"/etc/conda/activate.d/env_vars.sh
    touch "${CONDA_PREFIX}"/etc/conda/deactivate.d/env_vars.sh

    activate_env_vars_text="\
        BFI_DEV_MODE=\"${dev_mode}\"
    "
    activate_env_vars_text="$(unident_text "${activate_env_vars_text}")"
    echo "${activate_env_vars_text}" >"${CONDA_PREFIX}"/etc/conda/activate.d/env_vars.sh

    deactivate_env_vars_text="\
        unset BFI_DEV_MODE
    "
    deactivate_env_vars_text="$(unident_text "${deactivate_env_vars_text}")"
    echo "${deactivate_env_vars_text}" >"${CONDA_PREFIX}"/etc/conda/deactivate.d/env_vars.sh

    log_footer "Sticky configuration options written."
}

#-------------------------------------------------------------------------------
poetry_install() {
    (
        log_header "Checking for Poetry Settings..."

        poetry_found="$(grep '\[tool.poetry\]' pyproject.toml)"

        if [ "${poetry_found}" != "" ]; then
            log_footer "Poetry Settings Found."
        else
            log_footer "Poetry Settings Not Found. Skipping."
        fi

        if [ "${poetry_found}" != "" ]; then
            log_header "Running 'poetry install'..."

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
                poetry_no_dev=" --no-dev"
            fi

            poetry_args="${poetry_ansi}${poetry_verbosity}${poetry_no_dev}"

            log_debug "poetry install args: ${poetry_args}"

            # shellcheck disable=SC2086  # we actually want the variable to get split
            teetty_G "${FULL_LOG}" "${FULL_LOG}" poetry install ${poetry_args}
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'poetry install' exited with error code: %d" "$ret"
                exit "${RET_ERROR_POETRY_INSTALL_FAILED}"
            fi

            log_header "'poetry install' Completed."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
pip_uninstall() {
    (
        log_header "Checking for pip-uninstall.txt..."

        if [ -f ./pip-uninstall.txt ]; then
            log_footer "pip-uninstall.txt Found."

            log_header "Checking pip-uninstall.txt size..."

            uninstall_size="$(wc -c <"pip-uninstall.txt")"
            if [ "${uninstall_size}" -ne 0 ]; then
                log_footer "pip-uninstall.txt Not Empty."

                log_header "Running 'pip uninstall'..."

                teetty_G "${FULL_LOG}" "${FULL_LOG}" pip uninstall --yes --no-input --verbose --requirement pip-uninstall.txt
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "'pip uninstall' exited with error code: %d" "$ret"
                    exit "${RET_ERROR_PIP_UNINSTALL_FAILED}"
                fi

                log_footer "'pip uninstall' Completed."
            else
                log_footer "pip-uninstall.txt Empty. Skipping pip uninstall."
            fi
        else
            log_footer "pip-uninstall.txt Not Found. Skipping pip uninstall."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
pip_install() {
    (
        pip_requirements_found=false

        if [ "${dev_mode}" = true ] || [ "${BFI_DEV_MODE:-false}" = true ]; then
            log_header "Running in dev mode, checking for pip-requirements-dev.txt..."
            if [ -f ./pip-requirements-dev.txt ]; then
                log_footer "pip-requirements-dev.txt Found."
                pip_requirements_found=true
            else
                log_footer "pip-requirements-dev.txt Not Found."
            fi
        fi

        if [ "${pip_requirements_found}" = false ]; then
            log_header "Checking for pip-requirements.txt..."
            if [ -f ./pip-requirements-dev.txt ]; then
                log_footer "pip-requirements.txt Found."
            else
                log_footer "pip-requirements.txt Not Found. Skipping pip install."
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
                log_header "Running 'pip install' using 'pip-requirements-dev.txt'..."
                teetty_G "${FULL_LOG}" "${FULL_LOG}" pip install --upgrade --no-input --verbose --requirement pip-requirements-dev.txt
                ret=$?
            elif [ -f ./pip-requirements.txt ]; then
                log_header "Running 'pip install' using 'pip-requirements.txt'..."
                teetty_G "${FULL_LOG}" "${FULL_LOG}" pip install --upgrade --no-input --verbose --requirement pip-requirements.txt
                ret=$?
            fi

            if [ $ret -ne 0 ]; then
                log_fatal "'pip install' exited with error code: %d" "$ret"
                exit "${RET_ERROR_PIP_INSTALL_FAILED}"
            fi

            log_footer "'pip install' Completed."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
run_post_bootstrap_script() {
    log_header "Running 'post-bootstrap.sh'"

    # be sure to run in post-setup in it's own subshell
    # (the default script also does this itself, but we can't trust that
    #   to still exist after user edits)
    (
        ensure_include_GXY "${project_dir}"/post-bootstrap.sh
        post_bootstrap
        ret=$?
        exit $ret
    )
    ret=$?

    if [ $ret -ne 0 ]; then
        log_fatal "'post-bootstrap.sh' exited with error code: %d" "$ret"
    else
        log_footer "'post-bootstrap.sh' Completed."
    fi

    return $ret
}

#-------------------------------------------------------------------------------
ensure_batteries_forking_included() {
    (
        log_header "Ensuring batteries-forking-included exists..."

        check_tools__require_downloadable_X

        log_superdebug "batteries_forking_included_dir_fullpath=${batteries_forking_included_dir_fullpath}"

        if \
            [ ! -d "${batteries_forking_included_dir_fullpath}" ] ||
            [ ! -d "${batteries_forking_included_dir_fullpath}/.git" ] ||
            [ ! -f "${batteries_forking_included_dir_fullpath}/src/batteries_forking_included/template/bfi-update.sh" ]
        then
            # batteries-forking-included missing, let's download it
            ensure_cd "${batteries_forking_included_dir_fullpath}/.."
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            if [ "${git_exists}" = true ]; then
                teetty_G "${FULL_LOG}" "${FULL_LOG}" git clone "https://github.com/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}.git"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "failed to clone https://github.com/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}.git"
                    exit "${RET_ERROR_GIT_CLONE_FAILED}"
                fi

                log_footer "batteries-forking-included cloned."
            elif \
                [ "${curl_exists}" = true ] ||
                [ "${wget_exists}" = true ]
            then
                download_and_extract "https://api.github.com/repos/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}" "${BFI_GITHUB_REPO_NAME}" "${batteries_forking_included_dir_fullpath}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                # create download timestamp
                touch "${batteries_forking_included_dir_fullpath}"/LAST_DOWNLOADED

                log_footer "batteries-forking-included downloaded."
            else # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "no way to download available (no git, no curl, no wget)"
                exit "${RET_ERROR_TOOL_MISSING}"
            fi
        else
            log_footer "batteries-forking-included exists."
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
update_batteries_forking_included_repo() {
    (
        log_header "Updating batteries-forking-included"

        check_tools__require_downloadable_X

        if [ "${git_exists}" = true ]; then
            ensure_cd "${batteries_forking_included_dir_fullpath}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            current_branch="$(git rev-parse --abbrev-ref HEAD)"
            if [ "${current_branch}" != "main" ]; then
                log_warning "batteries-forking-included's current branch is not main"
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
                teetty_G "${FULL_LOG}" "${FULL_LOG}" git fetch
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "git fetch failed"
                    exit "${RET_ERROR_GIT_FETCH_FAILED}"
                fi

                teetty_G "${FULL_LOG}" "${FULL_LOG}" git reset --hard origin/main
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "git reset failed"
                    exit "${RET_ERROR_GIT_RESET_FAILED}"
                fi

                log_footer "batteries-forking-included updated."
            else
                log_warning "batteries-forking-included has local changes"
                # this is fine, so just bail early
                exit "${RET_SUCCESS}"
            fi
        elif \
            [ "${curl_exists}" = true ] ||
            [ "${wget_exists}" = true ]
        then
            # shellcheck disable=SC2012
            is_dirty="$(ls -lt | head -2 | tail -1 | grep -v "LAST_DOWNLOADED")"

            if [ "${is_dirty}" = "" ]; then
                safe_rm "${batteries_forking_included_dir_fullpath}"
                ret=$?
                if [ "$(return_code_is_error $ret)" = true ]; then
                    exit $ret
                fi

                download_and_extract "https://api.github.com/repos/${BFI_GITHUB_REPO_USER}/${BFI_GITHUB_REPO_NAME}" "${BFI_GITHUB_REPO_NAME}" "${batteries_forking_included_dir_fullpath}"
                ret=$?
                if [ "$(return_code_is_error $ret)" = true ]; then
                    exit $ret
                fi

                log_footer "batteries-forking-included updated."
            else
                log_warning "batteries-forking-included has local changes"
                # this is fine, so just bail early
                exit "${RET_SUCCESS}"
            fi
        else # pragma: no branch
            # NOTE: it /shouldn't/ be possible to get here
            log_fatal "no way to download available (no git, no curl, no wget)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
copy_temporary_template_files() {
    (
        log_header "Creating a copy of template files"

        create_dir "${my_tempdir}/template"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        log_debug "Copying files"

        copy_dir "${batteries_forking_included_dir_fullpath}/src/batteries_forking_included/template/" "${my_tempdir}/template/"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            log_fatal "failed to copy files from '%s' to '%s'" "${batteries_forking_included_dir_fullpath}/src/batteries_forking_included/template/" "${my_tempdir}/template/"
            exit "${RET_ERROR_COPY_FAILED}"
        fi

        log_footer "Copy of template files created."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
is_file_same() {
    # exit code 0 == same
    # exit code 1 == different
    # exit code 2 == there was an error
    (
        left_file="$1"
        right_file="$2"

        log_debug "Comparing '%s' and '%s'" "${left_file}" "${right_file}"

        check_tools__require_comparible_X

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
            log_fatal "no way to comapre files (no diff, no md5)"
            exit "${RET_ERROR_TOOL_MISSING}"
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
check_and_update_file() {
    (
        filename="$1"
        make_backup="$2"

        if [ ! -f "${my_tempdir}/template/${filename}" ]; then
            log_warning "Expected a file, but found a directory: %s" "${my_tempdir}/template/${filename}"
            exit "${RET_WARNING_NOT_A_FILE}"
        fi

        needs_copy=false

        if [ ! -f "${project_dir}/${filename}" ]; then
            needs_copy=true
            log_info "${filename} missing from project. Will be copied."
        fi

        if [ "${needs_copy}" = false ]; then
            is_file_same "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
            ret=$?
            if [ $ret -gt 2 ]; then
                exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
            elif [ $ret -eq 1 ]; then
                needs_copy=true
                log_info "${filename} needs to be updated."
            else
                log_success "${filename} did not change. Already up to date."
            fi
        fi

        if [ "${needs_copy}" = true ]; then
            log_info "Copying latest ${filename}..."

            if [ "${make_backup}" = true ]; then
                if [ -f "${project_dir}/${filename}" ]; then
                    backup_filepath="${project_dir}/${filename}.$(get_datetime_stamp_filename_formatted).old"
                    log_info "Creating backup at ${backup_filepath}"
                    copy_file "${project_dir}/${filename}" "${backup_filepath}"
                    ret=$?
                    if [ "$(return_code_is_error $ret)" = true ]; then
                        exit $ret
                    fi
                fi
            fi

            safe_rm "${project_dir}/${filename}"
            ret=$?
            if [ "$(return_code_is_error $ret)" = true ]; then
                exit $ret
            fi

            move_file "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
            if [ "$(return_code_is_error $ret)" = true ]; then
                log_fatal "failed to move '%s' to '%s'" "${my_tempdir}/template/${filename}" "${project_dir}/${filename}"
                exit "${RET_ERROR_MOVE_FAILED}"
            fi

            safe_rm "${my_tempdir}/template/${filename}"

            log_success "${filename} updated successfully."

            exit "${RET_SUCCESS_SPECIAL}"
        else
            safe_rm "${my_tempdir}/template/${filename}"

            exit "${RET_SUCCESS}"
        fi
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
rerun_update_X() {
    log_info_important "Need to re-run bfi-update.sh"
    log_info_important "re-running command as '%s %s'" "$(get_my_real_dir_fullpath)/bfi-update.sh" "$* --no-report"

    # call ourselves again
    invoke "$(get_my_real_dir_fullpath)/bfi-update.sh" "$@" --no-report
    ret=$?
    exit $ret
}

#-------------------------------------------------------------------------------
compare_and_update_files() {
    (
        log_header "Comparing template files to current project's files..."

        check_tools__require_comparible_X

        # special handling for bfi-update.sh b/c we might need to rerun
        check_and_update_file "bfi-update.sh" "false"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            rerun_update_X "$@"
        fi

        # special handling for bfi-base.sh b/c we might need to rerun
        check_and_update_file "bfi-base.sh" "false"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            rerun_update_X "$@"
        fi

        # special handling for bfi-update.sh b/c we might need to rerun
        check_and_update_file "batteries-forking-included.sh" "false"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        elif [ $ret -eq "${RET_SUCCESS_SPECIAL}" ]; then
            rerun_update_X "$@"
        fi

        # special handling for post-boostrap.sh b/c users edit that file

        # split first part of template post-bootstrap.sh (BFI FIRST PART)
        awk '{print; if (match($0,"    \# WARNING: DO NOT EDIT ABOVE THIS LINE")) exit}' "${my_tempdir}"/template/post-bootstrap.sh >"${my_tempdir}"/template/post-bootstrap.sh-part1
        if [ $ret -ne 0 ]; then
            log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh-part1
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # split middle part of project post-bootstrap.sh (USER PART)
        middle_file="${project_dir}"/post-bootstrap.sh
        if [ ! -f "${project_dir}"/post-bootstrap.sh ]; then
            middle_file="${my_tempdir}"/template/post-bootstrap.sh
        fi
        awk -v do_print=0 '{if (match($0,"    \# WARNING: DO NOT EDIT BELOW THIS LINE")) do_print=0; if (do_print==1) print; if (match($0,"    # WARNING: DO NOT EDIT ABOVE THIS LINE")) do_print=1}' "${middle_file}" >"${my_tempdir}"/template/post-bootstrap.sh-part2
        if [ $ret -ne 0 ]; then
            log_fatal "Could not create %s" "${my_tempdir}"template/post-bootstrap.sh-part2
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # split last part of template post-bootstrap.sh (BFI LAST PART)
        awk -v found=0 '{if (match($0,"    \# WARNING: DO NOT EDIT BELOW THIS LINE")) found=1; if (found==1) print}' "${my_tempdir}"/template/post-bootstrap.sh >"${my_tempdir}"/template/post-bootstrap.sh-part3
        if [ $ret -ne 0 ]; then
            log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh-part3
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        # delete original template post-boostrap.sh
        safe_rm "${my_tempdir}"/template/post-bootstrap.sh
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # recombine three parts into new template post-boostrap.sh
        cat "${my_tempdir}"/template/post-bootstrap.sh-part1 \
            "${my_tempdir}"/template/post-bootstrap.sh-part2 \
            "${my_tempdir}"/template/post-bootstrap.sh-part3 \
            >"${my_tempdir}"/template/post-bootstrap.sh
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "Could not create %s" "${my_tempdir}"/template/post-bootstrap.sh
            exit "${RET_ERROR_FILE_COULD_NOT_BE_ACCESSED}"
        fi
        chmod +x "${my_tempdir}"/template/post-bootstrap.sh
        if [ $ret -ne 0 ]; then
            log_fatal "Could not chmod +x %s" "${my_tempdir}/template/post-bootstrap.sh"
            exit "${RET_ERROR_COULD_NOT_CHMOD}"
        fi

        # delete the three parts
        safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part1
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi
        safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part2
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi
        safe_rm "${my_tempdir}"/template/post-bootstrap.sh-part3
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        check_and_update_file "post-bootstrap.sh" "true"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # switch to the template dir so we can loop over all the remaining files
        ensure_cd "${my_tempdir}/template"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # process remaining files
        for filename in *; do
            check_and_update_file "${filename}" "false"
            ret=$?
            if [ "$(return_code_is_error $ret)" = true ]; then
                exit $ret
            fi
        done

        log_footer "Comparison of template files to current project's files completed."

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    return $exit_ret
}

#-------------------------------------------------------------------------------
batteries_forking_included__bootstrap() {
    log_ultradebug "batteries_forking_included__bootstrap called with '%s'" "$*"

    ensure_my_tempdir_G
    ret=$?
    if [ "$(return_code_is_error $ret)" = true ]; then
        exit $ret
    fi

    parse_args__bootstrap "$@"
    ret=$?
    if [ "$(return_code_is_error $ret)" = true ]; then
        return $ret
    fi

    # # bail early before actually doing anything
    # return 0

    (
        require_not_root_user_XY

        check_tools__begin
        check_tools__detect_G
        check_tools__end

        ensure_cd "${project_dir}"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        ensure_conda
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_init_G
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_full_deactivate_G
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_update_base
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        # poetry show | awk '{if ($1 !~ /six|packaging|pyparsing/ ) {print "pypi::" $1}}' >"$CONDA_PREFIX"/conda-meta/pinned

        conda_setup_env
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_activate_env_G "${project_base_name}"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_env_read_sticky_config
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_env_write_sticky_config
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_full_deactivate_G
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        conda_activate_env_G "${project_base_name}"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        poetry_install
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        pip_uninstall
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        pip_install
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        run_post_bootstrap_script
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    report_all $exit_ret "${print_report}" "$(get_my_real_basename)"
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
batteries_forking_included__update() {
    log_ultradebug "batteries_forking_included__update called with '%s'" "$*"

    ensure_my_tempdir_G
    ret=$?
    if [ "$(return_code_is_error $ret)" = true ]; then
        exit $ret
    fi

    parse_args__update "$@"
    ret=$?
    if [ "$(return_code_is_error $ret)" = true ]; then
        return $ret
    fi

    # # bail early before actually doing anything
    # return 0

    (
        require_not_root_user_XY

        check_tools__begin
        check_tools__detect_G
        check_tools__end

        ensure_batteries_forking_included
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        update_batteries_forking_included_repo
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        copy_temporary_template_files
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        compare_and_update_files "$@"
        ret=$?
        if [ "$(return_code_is_error $ret)" = true ]; then
            exit $ret
        fi

        exit "${RET_SUCCESS}"
    )
    exit_ret=$?
    report_all $exit_ret "${print_report}" "$(get_my_real_basename)"
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
        log_ultradebug "%s: OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "%s: SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "$(get_my_real_basename)" "${SET_OMEGA_DEBUG}"
    fi

    #endregion "Globals"
    #===========================================================================

    #===========================================================================
    #region Private Functions

    #---------------------------------------------------------------------------
    __main() {
        log_fatal "$(get_my_real_basename) must be sourced"
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

    if [ "${_IS_UNDER_TEST}" != "true" ]; then
        if [ "$(array_get_last WAS_SOURCED)" = false ]; then
            __main "$@"
            ret=$?
        else
            __sourced_main
            ret=$?
        fi
        exit $ret
    else
        exit "${RET_SUCCESS}"
    fi

    #endregion Immediate
    ############################################################################
)
ret=$?

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
