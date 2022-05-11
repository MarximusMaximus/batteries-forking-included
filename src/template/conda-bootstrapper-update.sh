#!/usr/bin/env sh

################################################################################
#region Preamble

echo "$0"

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

    if [ -d "${CONDA_BOOTSTRAPPER_FULLPATH}" ]; then
        # shellcheck disable=SC1091
        . "${CONDA_BOOTSTRAPPER_FULLPATH}"/src/constants.sh
    fi

    #endregion Includes
    ############################################################################

    ############################################################################
    #region Constants

    OMEGA_DEBUG=false
    export OMEGA_DEBUG

    #endregion Constants
    ############################################################################

    ############################################################################
    #region Return Codes

    RET_ERROR_NO_DOWNLOAD_METHOD=2
    RET_ERROR_NO_EXTRACT_METHOD=3

    #endregion Return Codes
    ############################################################################

    ############################################################################
    #region Public Fucntions

    ensure_conda() {
        (
            if [ ! -d "${CONDA_BOOTSTRAPPER_FULLPATH}" ]; then
            # conda-bootstrapper missing, let's download it
                git_exists=false
                if [ "$(command -v git)" != "" ]; then
                    git_exists=true
                fi
                curl_exists=false
                if [ "$(command -v curl)" != "" ]; then
                    curl_exists=true
                fi
                wget_exists=false
                if [ "$(command -v wget)" != "" ]; then
                    wget_exists=true
                fi
                tar_exists=false
                if [ "$(command -v tar)" != "" ]; then
                    tar_exists=true
                fi
                unzip_exists=false
                if [ "$(command -v unzip)" != "" ]; then
                    unzip_exists=true
                fi

                if \
                    [ "${git_exists}" = false ] &&
                    [ "${curl_exists}" = false ] &&
                    [ "${wget_exists}" = false ]
                then
                    >&2 printf "FATAL: conda-bootstrapper missing and no way to download available"
                    exit "${RET_ERROR_NO_DOWNLOAD_METHOD}"
                fi

                if \
                    [ "${git_exists}" = false ] &&  # we only need to extract if git isn't available
                    [ "${tar_exists}" = false ] &&
                    [ "${unzip_exists}" = false ]
                then
                    >&2 printf "FATAL: conda-bootstrapper missing and no way to extract from compressed file available"
                    exit "${RET_ERROR_NO_EXTRACT_METHOD}"
                fi

                cd "${CONDA_BOOTSTRAPPER_FULLPATH}"/.. || exit 1

                ret=0
                if [ "${git_exists}" = true ]; then
                    git clone https://github.com/MarximusMaximus/conda-bootstrapper.git
                    ret=$?
                elif [ "${curl_exists}" = true ]; then
                    true
                elif [ "${wget_exists}" = true ]; then
                    wget
                fi
            fi
        )
    }

    #endregion
    #############################################################################

    ############################################################################
    #region Private Functions

    #---------------------------------------------------------------------------
    __main() {
        (
            cd "${MY_DIR_FULLPATH}" || exit "${RET_ERROR_DIRECTORY_NOT_FOUND:-1}"

            # TODO: clone conda-bootstrapper if necessary
            ensure_conda

            # re-include this file, in case it was missing earlier
            # shellcheck disable=SC1091
            . "${CONDA_BOOTSTRAPPER_FULLPATH}"/src/constants.sh

            # TODO: update conda-bootstrapper if not dirty
            # TODO: create temp dir
            # TODO: copy template files from conda-bootstrapper to temp dir
            # TODO: modify template files
            # TODO: compare template files to current project's files
            # TODO: prompt to update files


            true

        )
        ret=$?
        return $ret
    }

    #endregion Private Functions
    ############################################################################

    ############################################################################
    #region Immediate

    __main
    ret=$?
    exit $ret

    #endregion Immediate
    ############################################################################

)
ret=$?
exit $ret
