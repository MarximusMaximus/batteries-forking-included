#!/usr/bin/env sh

# NOTE: see usage from conda-bootstrapper.sh for command line arguments

################################################################################
#region Preamble

echo "$0"


#===============================================================================
#region Fallbacks

# NOTE: some basic definitions to fallback to if constants.sh failed to load

RET_SUCCESS=0; export RET_SUCCESS
RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN
RET_ERROR_SCRIPT_WAS_SOURCED=149; export RET_ERROR_SCRIPT_WAS_SOURCED
RET_ERROR_USER_IS_ROOT=150; export RET_ERROR_USER_IS_ROOT
RET_ERROR_DIRECTORY_NOT_FOUND=153; export RET_ERROR_DIRECTORY_NOT_FOUND
RET_ERROR_COULD_NOT_SOURCE_FILE=161; export RET_ERROR_COULD_NOT_SOURCE_FILE

#-------------------------------------------------------------------------------
log_fatal() {
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
        command printf "$@"
        command printf "\n"
    fi
}

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
#region Self Referentials

MY_DIR_FULLPATH="$(dirname -- "$(rreadlink "$0")")"
export MY_DIR_FULLPATH
MY_DIR_BASENAME="$(basename -- "${MY_DIR_FULLPATH}")"
export MY_DIR_BASENAME
CONDA_BOOTSTRAPPER_FULLPATH="${MY_DIR_FULLPATH}/../conda-bootstrapper"
export CONDA_BOOTSTRAPPER_FULLPATH

#endregion Self Referentials
#===============================================================================

#endregion Preamble
################################################################################

(
    ############################################################################
    #region Includes

    # shellcheck disable=SC1091
    . "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
    # NOTE: do not check if failed b/c it might not exist yet

    #endregion Includes
    ############################################################################

    ############################################################################
    #region Constants

    SET_OMEGA_DEBUG=false

    #endregion Constants
    ############################################################################

    ############################################################################
    #region "Globals"

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        log_ultradebug "OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "${SET_OMEGA_DEBUG}"
    fi

    #endregion "Globals"
    ############################################################################

    ############################################################################
    #region Private Functions

    __main () {
        (
            (
                # shellcheck disable=SC2164
                cd "${MY_DIR_FULLPATH}/.."
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "Could not cd into '%s'" "${MY_DIR_FULLPATH}/.."
                    exit "${RET_ERROR_DIRECTORY_NOT_FOUND}"
                fi

                # TODO: clone conda-bootstrapper
                true
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                # TODO: update conda-bootstrapper
                true
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            )
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            # re-include constants.sh if the fence value is missing
            if [ "${CONDA_BOOTSTRAPPER_CONSTANTS_LOADED:-}" = "" ]; then
                # shellcheck disable=SC1091
                . "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "Failed to source '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
                    exit "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
                fi
            fi

            (
                # shellcheck disable=SC2164
                cd "${MY_DIR_FULLPATH}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "Could not cd into '%s'" "${MY_DIR_FULLPATH}"
                    exit "${RET_ERROR_DIRECTORY_NOT_FOUND}"
                fi

                "${CONDA_BOOTSTRAPPER_FULLPATH}"/src/conda-bootstrapper.sh --project-dir="${MY_DIR_FULLPATH}" "$@"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            )
            ret=$?
            exit $ret
        )
        ret=$?
        return $ret
    }

    #endregion Functions
    ############################################################################

    ############################################################################
    #region Immediate

    #===============================================================================
    #region anti-sourceing

    sourced=0
    if [ -n "$ZSH_EVAL_CONTEXT" ]; then
        case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
    elif [ -n "$KSH_VERSION" ]; then
        # shellcheck disable=SC2296
        [ "$(cd "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] && sourced=1
    elif [ -n "$BASH_VERSION" ]; then
        (return 0 2>/dev/null) && sourced=1
    else # All other shells: examine $0 for known shell binary filenames
        # Detects `sh` and `dash`; add additional shell filenames as needed.
        case ${0##*/} in sh|dash) sourced=1;; esac
    fi
    if [ $sourced -eq 1 ]; then
        log_fatal "bootstrap.sh should not be sourced"
        # NOTE: we have to return here otherwise we kill the shell
        return "${RET_ERROR_SCRIPT_WAS_SOURCED}"
    fi

    #endregion anti-sourceing
    #===========================================================================

    #===========================================================================
    #region anti-root

    # shellcheck disable=SC3028
    if [ $UID -eq 0 ] || [ $EUID -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
        log_fatal "bootstrap.sh should not be run as root nor with sudo"
        exit "${RET_ERROR_USER_IS_ROOT}"
    fi

    #endregion anti-root
    #===========================================================================

    log_ultradebug "bootstrap.sh called with '%s'" "$*"

    __main "$@"
    ret=$?
    log_info "bootstrap.sh exiting with return code: %d\n" "${ret}"
    exit $ret

    #endregion Immediate
    ############################################################################
)
ret=$?
# NOTE: we have to return here if we were sourced otherwise we kill the shell
if [ $ret -ne "${RET_ERROR_SCRIPT_WAS_SOURCED}" ]; then
    exit $ret
else
    return $ret
fi
