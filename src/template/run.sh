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

(
    RUN_EXEC="python"
    RUN_ARGS="${MY_DIR_FULLPATH}"/bin/"${MY_DIR_BASENAME}".py

    ############################################################################
    #region Immediate

    # shellcheck disable=SC1091 # shellcheck source=../constants.sh
    . "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"

    # shellcheck disable=SC1091 # shellcheck source=./activate.sh
    . "${MY_DIR_FULLPATH}/activate.sh"

    if [ -f "$1" ] && [ -x "$1" ]; then
        # arg 1 is an executable, run that instead
        if [ "$(file "$1" | grep 'script' )" != "" ]; then
            # arg 1 is a script
            RUN_ARGS="$1"
            shebang=$(head -n 1 "$1")
            if [ "$(echo "$1" | grep ".py" )" != "" ]; then
                # python script
                RUN_EXEC=python
                TEMP_RUN_EXEC=
                if [ "$(echo "${shebang}" | grep "#!")" = "" ]; then
                    # no shebang, wtf?!
                    true    # no op
                elif [ "$(echo "${shebang}" | awk '{print $1}')" = "#!/usr/bin/env" ]; then
                    # shebang is asking /usr/bin/env to find the executable
                    # awk removes the '#!/usr/bin/env' part
                    TEMP_RUN_EXEC="$(echo "${shebang}" | awk '{$1=""; print $0}' )"
                else
                    # shebang is the executable, remove '#!' from string
                    # cut removes '#!'
                    TEMP_RUN_EXEC="$(echo "${shebang}" | cut -c 3- )"
                fi
                if [ "$(echo "${TEMP_RUN_EXEC}" | grep "python")" != "" ]; then
                    RUN_EXEC="${TEMP_RUN_EXEC}"
                fi
            else
                # .sh or other
                if [ "$(echo "${shebang}" | grep "#!")" = "" ]; then
                    # no shebang, wtf?!
                    >&2 printf "First arg is an executable script, but does not have a shebang.\n"
                    exit "${RET_ERROR_COULD_NOT_EXECUTE}"
                elif [ "$(echo "${shebang}" | awk '{print $1}')" = "#!/usr/bin/env" ]; then
                    # shebang is asking /usr/bin/env to find the executable
                    # awk removes the '#!/usr/bin/env' part
                    RUN_EXEC="$(echo "${shebang}" | awk '{$1=""; print $0}' )"
                else
                    # shebang is the executable, remove '#!' from string
                    # cut removes '#!'
                    RUN_EXEC="$(echo "${shebang}" | cut -c 3- )"
                fi
            fi
        else
            # arg 1 is directly an exec
            RUN_EXEC="$1"
            RUN_ARGS=""
        fi
        shift
    fi

    # remove the "stop processing args" delimiter
    # (allows first real arg to what we're running to be an executable file)
    if [ "$1" = "--" ]; then
        shift
    fi

    # cleanup RUN_EXEC
    # sed (1st) removes leading spaces
    # sed (2nd) removes trailing spaces
    # if your executable has leading or trailing spaces in its name...
    #          ...STOP THAT MALARKY!
    RUN_EXEC="$(echo "${RUN_EXEC}" | sed -r 's/^ *//' | sed -r 's/ *$//' )"

    which "${RUN_EXEC}"
    if [ "$(echo "${RUN_EXEC}" | grep "python")" != "" ]; then
        "${RUN_EXEC}" --version
    fi

    if [ "${RUN_ARGS}" = "" ]; then
        echo /usr/bin/env "${RUN_EXEC}" "$@"
        /usr/bin/env "${RUN_EXEC}" "$@"
    else
        echo /usr/bin/env "${RUN_EXEC}" "${RUN_ARGS}" "$@"
        /usr/bin/env "${RUN_EXEC}" "${RUN_ARGS}" "$@"
    fi

    ret=$?
    exit $ret

    #endregion Immediate
    ################################################################################
)
ret=$?
exit $ret
