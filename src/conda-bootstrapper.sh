#!/usr/bin/env sh
usage_text=$(cat<<EOF
Usage:
    conda-bootstrapper.sh [flags|options]

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
    -d, --dev, --developer
                        install as developer (include development dependencies)
    +d, --no-dev, --no-develeoper
                        do not install as developer
    -D, --deploy, --deployment
                        install as a deployment
    +D, --no-deploy, --no-deployment
                        do not install as a deployment

Global Options:
    -p PROJECT_DIR, --project-dir PROJECT_DIR
                        override to use specified project dir
                        default: current working directory of invocation
    -P PROJECT_BASE_NAME, --project-base-name PROJECT_BASE_NAME
                        override to use specified project base name
                        default: basename of PROJECT_DIR

Positional Arguments:
    NONE

Subcommands:
    NONE
EOF
)
export usage_text


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
#region Includes

ensure_include "${MY_DIR_FULLPATH}"/constants.sh

#endregion Includes
#===============================================================================

#===============================================================================
#region Return Codes



#endregion Return Codes
#===============================================================================

#===============================================================================
#region Public Globals

print_usage=false; export print_usage
colorized_output=true; export colorized_output
verbosity=1; export verbosity
quiet=false; export quiet

project_dir=""; export project_dir
project_base_name=""; export project_base_name
dev_mode=false; export dev_mode
deploy_mode=false; export deploy_mode

#endregion Public Globals
#===============================================================================

#===============================================================================
#region Public Functions

#-------------------------------------------------------------------------------
usage() {
    command printf "%s\n" "${usage_text}"
}

#-------------------------------------------------------------------------------
parse_args() {
    log_ultradebug "conda-bootstrapper.sh::parse_args called with '%s'" "$*"

    # temporarily just assign these
    project_dir="$(pwd)"
    project_base_name="$(basename -- "${project_dir}")"

    positional_arg_index=0

    alt_color=false

    project_base_name_temp=""

    while true; do
        log_ultradebug "conda-bootstrapper.sh::parse_args::while; \$1='%s'; \$*='%s'" "$1" "$*"

        if [ $# -le 0 ]; then
            break
        fi

        case "$1" in
            -h|-\?|--help|--usage)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found usage arg"
                print_usage=true
                ;;

            -q|--quiet)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found quiet arg"
                quiet=true
                ;;
            +q|--no-quiet)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-quiet arg"
                quiet=false
                ;;

            -v|--verbose)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found verbose arg"
                verbosity=$((verbosity + 1))
                ;;
            +v|--no-verbose)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-verbose arg"
                verbosity=$((verbosity - 1))
                ;;

            --)     # stop processing args
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found -- arg"
                shift
                break
                ;;

            -c|--color)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found color arg"
                colorized_output=true
                ;;
            +c|--no-color)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-color arg"
                colorized_output=false
                ;;

            -C|--alt-color)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found alt-color arg"
                alt_color=true
                ;;
            +C|--no-alt-color)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-alt-color arg"
                alt_color=false
                ;;

            -d|--dev|--developer)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found dev arg"
                dev_mode=true
                ;;
            +d|--no-dev|--no-developer)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-dev arg"
                dev_mode=false
                ;;

            -D|--deploy|--deployment)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found deploy arg"
                deploy_mode=true
                ;;
            +D|--no-deploy|--no-deployment)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found no-deploy arg"
                deploy_mode=false
                ;;

            -p|--project-dir)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-dir arg"
                if [ -n "$2" ]; then
                    project_dir="$2"
                    log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_dir=%s" "${project_dir}"
                    shift
                else
                    usage
                    log_error "\"--project-dir\" requires a non-empty option argument."
                    exit "${RET_ERROR_INVALID_ARGUMENT}"
                fi
                ;;
            --project-dir=?*)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-dir=* arg"
                project_dir="$1"
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_dir=%s" "${project_dir}"
                project_dir="$(echo "${project_dir}" | cut -c 15-)"
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_dir=%s" "${project_dir}"
                ;;
            --project-dir=)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-dir= arg"
                usage
                log_error "\"--project-dir\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
                ;;

            -P|--project-base-name)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-base-name arg"
                if [ -n "$2" ]; then
                    project_base_name_temp="$2"
                    log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                    shift
                else
                    usage
                    log_error "\"--project-base-name\" requires a non-empty option argument."
                    exit "${RET_ERROR_INVALID_ARGUMENT}"
                fi
                ;;
            --project-base-name=?*)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-base-name=* arg"
                project_base_name_temp="$1"
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                project_base_name_temp="$(echo "${project_base_name_temp}" | cut -c 21-)"
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t\t project_base_name_temp=%s" "${project_base_name_temp}"
                ;;
            --project-base-name=)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found project-base-name= arg"
                usage
                log_error "\"--project-base-name\" requires a non-empty option argument."
                exit "${RET_ERROR_INVALID_ARGUMENT}"
                ;;


            --?*)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found unknown arg"
                log_warning " Unknown option (ignored): %s" "$1" >&2
                ;;

            -?*)    # positive flags
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found positive flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        h|\?)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found usage flag"
                            print_usage=true
                            ;;
                        # p is not a valid flag b/c it takes a value
                        q)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found quiet flag"
                            quiet=true
                            ;;
                        v)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found verbose flag"
                            verbosity=$((verbosity + 1)) # Each -v argument adds 1 to verbosity.
                            ;;

                        c)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found color flag"
                            colorized_output=true
                            ;;

                        d)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found dev flag"
                            dev_mode=true;
                            ;;

                        D)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found deploy flag"
                            deploy_mode=true;
                            ;;

                        *)
                            log_warning "Unknown flag (ignored): %s" "${arg_char}"
                            ;;
                    esac

                done
                ;;

            +?*)    # negative flags
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found negative flags arg"
                arg_remain="$1"

                while true; do
                    arg_remain="$(command echo "${arg_remain}" | cut -c 2-)"
                    arg_char="$(command echo "${arg_remain}" | cut -c 1-1)"

                    log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-); arg_char='%s' arg_remain='%s'" "${arg_char}" "${arg_remain}"

                    if [ "${arg_char}" = "" ]; then
                        break
                    fi

                    case "${arg_char}" in
                        h|\?)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(+);\t found usage flag"
                            print_usage=true
                            ;;
                        # p is not a valid flag b/c it takes a value
                        q)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(+);\t found no-quiet flag"
                            quiet=false
                            ;;
                        v)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(-);\t found verbose flag"
                            verbosity=$((verbosity - 1))
                            ;;

                        c)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(+);\t found no-color flag"
                            colorized_output=false;
                            ;;

                        d)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(+);\t found no-dev flag"
                            dev_mode=false;
                            ;;

                        D)
                            log_ultradebug "conda-bootstrapper.sh::parse_args::while::while(+);\t found no-deploy flag"
                            deploy_mode=false;
                            ;;

                        *)
                            log_warning "Unknown flag (ignored): %s" "${arg_char}"
                            ;;
                    esac

                done
                ;;

            *)
                log_ultradebug "conda-bootstrapper.sh::parse_args::while;\t found positional arg #%d '%s'" "${positional_arg_index}" "$1"

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

    if [ "${alt_color}" = true ]; then
        colorized_output=alt
    fi


    export colorized_output
    export verbosity
    export quiet
    export print_usage

    export project_dir
    if [ "${project_base_name_temp}" = "" ]; then
        project_base_name="$(basename -- "${project_dir}")"
    else
        project_base_name="${project_base_name_temp}"
    fi
    export project_base_name
    export dev_mode
    export deploy_mode

    # recalculate "constant" values
    set_calculated_constants
    set_ansi_code_constants

    log_superdebug "colorized_output=%s" "${colorized_output}"
    log_superdebug "verbosity=%d" "${verbosity}"
    log_superdebug "quiet=%s" "${quiet}"
    log_superdebug "print_usage=%s" "${print_usage}"
    log_superdebug "project_dir=%s" "${project_dir}"
    log_superdebug "project_base_name=%s" "${project_base_name}"
    log_superdebug "dev_mode=%s" "${dev_mode}"
    log_superdebug "deploy_mode=%s" "${deploy_mode}"

    if [ "${print_usage}" = true ]; then
        usage
        exit "${RET_ERROR_USAGE_PRINTED}"
    fi
}

#-------------------------------------------------------------------------------
conda_init () {
    # intentionally no local scope so it modify globals

    log_header "Initializing Conda..."

    include "${CONDA_BASE_DIR_FULLPATH}/etc/profile.d/conda.sh"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'. conda.sh' failed with error code: %d" "$ret"
        return "${RET_ERROR_CONDA_INIT_FAILED}"
    fi
    PATH="${CONDA_BASE_DIR_FULLPATH}/bin:$PATH"
    export PATH

    log_footer "Conda Initialized."

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
conda_full_deactivate () {
    # intentionally no local scope so it modify globals

    log_header "Deactivating Current Conda Environments..."

    while [ "${CONDA_SHLVL}" -gt 0 ]; do
        conda deactivate
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "'conda deactivate' exited with error code: %d" "$ret"
            return "${RET_ERROR_CONDA_DEACTIVATE_FAILED}"
        fi
    done

    log_footer "Conda Environments Deactivated."

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
conda_update_base()
{
    log_header "Updating Base Conda Environment..."

    conda activate base
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'conda activate base' exited with error code: %d" "$ret"
        return "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
    fi

    conda update -n base --all -v -y --prune
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'conda update -n base' exited with error code: %d" "$ret"
        return "${RET_ERROR_CONDA_INSTALL_FAILED}"
    fi

    log_footer "Base Conda Environment Updated."

    return "${RET_SUCCESS}"
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

            conda env create --name "${project_base_name}" --file ./conda-environment.yml -v
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'conda create --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            log_header "%s Conda Environment Installed." "${project_base_name}"
        else
            log_header "Updating %s Conda Environment..." "${project_base_name}"

            conda env update --name "${project_base_name}" --file ./conda-environment.yml --prune -v
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'conda update --name \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
                exit "${RET_ERROR_CONDA_INSTALL_FAILED}"
            fi

            log_header "%s Conda Environment Updated." "${project_base_name}"
        fi

        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
conda_activate_env() {
    log_header "Activating %s Conda Environment..." "${project_base_name}"

    conda activate "${project_base_name}"
    ret=$?
    if [ $ret -ne 0 ]; then
        log_fatal "'conda activate \"${project_base_name}\"' exited with error code: %d" "${project_base_name}" "$ret"
        return "${RET_ERROR_CONDA_ACTIVATE_FAILED}"
    fi

    log_header "%s Conda Environment Activated." "${project_base_name}"

    return "${RET_SUCCESS}"
}

#-------------------------------------------------------------------------------
poetry_install() {
    (
        log_header "Checking for Poetry Settings..."

        poetry_found="$(grep '\[tool.poetry\]' pyproject.toml)"

        if [ "${poetry_found}" != "" ]; then
            log_footer "Poetry Settings Not Found."
        else
            log_footer "Poetry Settings Found. Skipping."
        fi

        if [ "${poetry_found}" != "" ]; then
            log_header "Running 'poetry install'..."

            poetry_verbosity=""
            if [ "${verbosity}" -ge 1 ]; then
                poetry_verbosity="-"
                for _i in $(seq 1 "${verbosity}"); do
                    poetry_verbosity="${poetry_verbosity}v"
                done
            fi

            poetry_quiet=""
            if [ "${quiet}" = true ]; then
                poetry_quiet="--quiet"
            fi

            poetry_ansi="--ansi"
            if [ "${colorized_output}" = false ]; then
                poetry_ansi="--no-ansi"
            fi

            poetry_no_dev=""
            if [ "${dev_mode}" = false ]; then
                poetry_no_dev="--no-dev"
            fi

            poetry_args="${poetry_ansi} ${poetry_verbosity} ${poetry_quiet} ${poetry_no_dev}"

            log_debug "poetry install args: ${poetry_args}"

            poetry install "${poetry_args}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "'poetry install' exited with error code: %d" "$ret"
                exit "${RET_ERROR_POETRY_INSTALL_FAILED}"
            fi

            log_header "'poetry install' Completed."
        fi

        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
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

                pip uninstall --yes --no-input --verbose --requirement pip-uninstall.txt
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "'pip uninstall' exited with error code: %d" "$ret"
                    exit "${RET_ERROR_PIP_UNINSTALL_FAILED}"
                fi

                log_footer "'pip uninstall' Completed."
            else
                log_footer "pip-uninstall.txt Empty. Skipping."
            fi
        else
            log_footer "pip-uninstall.txt Not Found. Skipping."
        fi

        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
}

#-------------------------------------------------------------------------------
pip_install() {
    (
        pip_requirements_found=false

        if [ "${dev_mode}" = "true" ]; then
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
                log_footer "pip-requirements-dev.txt Not Found. Skipping pip install."
            fi
        fi

        if [ "${pip_requirements_found}" = true ]; then
            ret="${RET_ERROR_UNKNOWN}"

            if \
                [ "${dev_mode}" = "true" ] &&
                [ -f ./pip-requirements-dev.txt ]
            then
                log_header "Running 'pip install' using 'pip-requirements-dev.txt'..."
                pip install --upgrade --no-input --verbose --requirement pip-requirements-dev.txt
                ret=$?
            elif [ -f ./pip-requirements.txt ]; then
                log_header "Running 'pip install' using 'pip-requirements.txt'..."
                pip install --upgrade --no-input --verbose --requirement pip-requirements.txt
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
    ret=$?
    return $?
}

#-------------------------------------------------------------------------------
run_post_setup_script() {
    log_header "Running 'post-setup.sh'"

    # be sure to run in post-setup in it's own subshell
    # (the default script also does this itself, but we can't trust that
    #   to still exist after user edits)
    (
        "${project_dir}"/post-setup.sh
    )
    ret=$?

    if [ $ret -ne 0 ]; then
        log_fatal "'post-setup.sh' exited with error code: %d" "$ret"
    else
        log_footer "'post-setup.sh' Completed."
    fi

    return $ret
}

#-------------------------------------------------------------------------------
conda_bootstrapper () {
    log_ultradebug "conda-bootstrapper.sh::conda_bootstrapper called with '%s'" "$*"

    parse_args "$@"

    return 0

    (
        ensure_cd "${project_dir}"
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        conda_init
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        conda_full_deactivate
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        conda_update_base
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        # poetry show | awk '{if ($1 !~ /six|packaging|pyparsing/ ) {print "pypi::" $1}}' >"$CONDA_PREFIX"/conda-meta/pinned

        conda_setup_env
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        conda_activate_env
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        poetry_install
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        pip_uninstall
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        pip_install
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        run_post_setup_script
        ret=$?
        if [ $ret -ne 0 ]; then
            exit $ret
        fi

        exit "${RET_SUCCESS}"
    )
    ret=$?
    return $ret
}

#endregion Public Functions
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
    #region Return Codes



    #endregion Return Codes
    #===========================================================================

    #===========================================================================
    #region Private Globals

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        log_ultradebug "OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "${SET_OMEGA_DEBUG}"
    fi

    #endregion Private Globals
    #===========================================================================

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
