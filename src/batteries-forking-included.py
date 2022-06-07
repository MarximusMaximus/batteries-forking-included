#!/usr/bin/env sh
################################################################################
#region Bootstrap Preamble
# 'multiline shebang' that will run this script in the proper environment
# see: https://rosettacode.org/wiki/Multiline_shebang#Python
#spellchecker: disable
"true" '''\'

#===============================================================================
#region RReadLink

rreadlink() {
    ( # Execute the function in a *subshell* to localize variables and the effect of 'cd'.

        target=$1
        fname=
        targetDir=
        CDPATH=

        # Try to make the execution environment as predictable as possible:
        # All commands below are invoked via 'command', so we must make sure that 'command'
        # itself is not redefined as an alias or shell function.
        # \(NOTE: that command is too inconsistent across shells, so we don't use it.\)
        # 'command' is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
        # an external utility version of it \(e.g, Ubuntu\).
        # 'command' bypasses aliases and shell functions and also finds builtins
        # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
        # to happen.
        { \\unalias command; \\unset -f command; } >/dev/null 2>&1
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
#region Self Referentials

MY_DIR_FULLPATH=$(dirname -- "$(rreadlink "$0")")
export MY_DIR_FULLPATH
MY_DIR_BASENAME=$(basename -- "${MY_DIR_FULLPATH}")
export MY_DIR_BASENAME

#endregion Self Referentials
#===============================================================================

"${MY_DIR_FULLPATH}"/../../run.sh "$@"
exit $?
'''
#spellchecker: enable

# insert our repo base dir into the sys.path so that we can import our library
import sys
import os.path as os_path
MY_DIR_FULLPATH=os_path.dirname(__file__)
MY_REPO_FULLPATH=os_path.dirname(MY_DIR_FULLPATH)
sys.path.insert(0, MY_REPO_FULLPATH)

#endregion Bootstrap Preamble
################################################################################
__doc__ = """\

"""

import argparse
import time

def __main(argv):
    # do argparse stuff
    parser = argparse.ArgumentParser(

    )

    parser.parse_known_args(argv)

    print("running")
    time.sleep(60)

    # exit with useful code
    sys.exit(0)


if __name__ == "__main__":
    __main(sys.argv)
