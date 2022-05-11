#!/usr/bin/env sh

################################################################################
#region Preamble

echo "$0"

#===============================================================================
#region RReadLink

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

################################################################################
#region Includes

# shellcheck disable=SC1091
. "${CONDA_BOOTSTRAPPER_FULLPATH}"/src/constants.sh

#endregion Includes
################################################################################

################################################################################
#region Functions

conda_init () {
    # shellcheck disable=SC1091
    . "${CONDA_BASE_DIR_FULLPATH}/etc/profile.d/conda.sh"
    export PATH="${CONDA_BASE_DIR_FULLPATH}/bin:$PATH"
}

conda_deep_deactivate () {
    while [ "${CONDA_SHLVL}" -gt 0 ]; do
        conda deactivate || exit "${RET_ERROR_CONDA_DEACTIVATE_FAILED}"
    done
}

#endregion Functions
################################################################################

################################################################################
#region Immediate

conda_init
conda_deep_deactivate

type conda | head -n 1
conda --version
echo "Activating conda env '${MY_DIR_BASENAME}'."

conda activate "${MY_DIR_BASENAME}" || exit "${RET_ERROR_CONDA_ACTIVATE_FAILED}"

#endregion Immediate
################################################################################
