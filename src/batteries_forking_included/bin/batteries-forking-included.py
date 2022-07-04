#!/usr/bin/env sh
# pylint: disable=C0103
# type: ignore
################################################################################
#region Bootstrap Preamble
# 'multiline shebang' that will run this script in the proper environment
# see: https://rosettacode.org/wiki/Multiline_shebang#Python
#spellchecker: disable
"true" '''\'

#===============================================================================
#region RReadLink

rreadlink() {
    ( # Execute function in subshell to localize variables and effects of 'cd'.
        target=$1
        fname=
        targetDir=
        CDPATH=

        # Try to make the execution environment as predictable as possible:
        # All commands below are invoked via 'command', so we must make sure
        # that 'command' itself is not redefined as an alias or shell function.
        # 'command' bypasses aliases and shell functions and also finds builtins
        # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned
        # on for that to happen.
        { \\unalias command; \\unset -f command; } >/dev/null 2>&1
        # make zsh find *builtins* with 'command' too.
        # shellcheck disable=SC2034
        [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on

        # Resolve potential symlinks until the ultimate target is found.
        while :; do
                [ -L "$target" ] || [ -e "$target" ] || \
                    {
                        command printf '%s\n' "ERROR: '$target' does not exist." >&2
                        return 1
                    }
                # Change to target dir; necessary for correct resolution of
                #   target path.
                # shellcheck disable=SC2164
                command cd "$(command dirname -- "$target")"
                fname=$(command basename -- "$target") # Extract filename.
                # WARNING: curiously, 'basename /' returns '/'
                [ "$fname" = '/' ] && fname=''
                if [ -L "$fname" ]; then
                    # Extract [next] target path, which may be defined
                    # relative to the symlink's own directory.
                    # NOTE: We parse 'ls -l' output to find the symlink target
                    # NOTE:     which is the only POSIX-compliant, albeit
                    #   somewhat fragile, way.
                    target=$(command ls -l "$fname")
                    target=${target#* -> }
                    continue # Resolve [next] symlink target.
                fi
                break # Ultimate target reached.
        done
        targetDir=$(command pwd -P) # Get canonical dir. path
        # Output the ultimate target's canonical path.
        # NOTE: that we manually resolve paths ending in /. and /.. to make
        #   sure we have a normalized path.
        if [ "$fname" = '.' ]; then
            command printf '%s\n' "${targetDir%/}"
        elif    [ "$fname" = '..' ]; then
            # NOTE: something like /var/.. will resolve to /private
            #   (assuming /var@ -> /private/var),
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

run_dir_fullpath="${MY_DIR_FULLPATH}"
found=false
while [ $found = false ]; do
    if [ -f "${run_dir_fullpath}/run.sh" ]; then
        found=true
        break
    fi
    run_dir_fullpath="$(dirname "${run_dir_fullpath}")"
done

BFI_ORIGINAL_EXEC_NAME="$0"
export BFI_ORIGINAL_EXEC_NAME

"${run_dir_fullpath}"/run.sh "$0" "$@"
exit $?
'''  # noqa: D300,W605,E501,B950

#spellchecker: enable

# insert our repo base dir into the sys.path so that we can import our library
# we know that the repo path is ./../../.. b/c we should be in ./src/<project name>/bin/
import sys
import os
import os.path as os_path
MY_DIR_FULLPATH = os_path.dirname(__file__)
MY_REPO_FULLPATH = os_path.dirname(os_path.dirname(MY_DIR_FULLPATH))
sys.path.insert(0, MY_REPO_FULLPATH)
MY_LIB_FULLPATH = os_path.join(MY_REPO_FULLPATH, "src")
sys.path.insert(0, MY_LIB_FULLPATH)

MY_PROGRAM_NAME = os.environ.get("BFI_ORIGINAL_EXEC_NAME", os_path.basename(sys.argv[0]))
if (
    "." not in os_path.basename(MY_PROGRAM_NAME) or
    ".py" in os_path.basename(MY_PROGRAM_NAME)
):
    MY_PROGRAM_NAME = os_path.basename(MY_PROGRAM_NAME)
del os
del os_path
del sys

#endregion Bootstrap Preamble
################################################################################
__doc__ = """\
batteries-forking-included python wrapper
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

import sys
from typing import (
    List,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region Ours

from batteries_forking_included import (
    __main__                        as batteries_forking_included___main__,
)

#endregion Imports
################################################################################

################################################################################
#region Private Functions

#-------------------------------------------------------------------------------
def __main(argv: List[str]) -> int:
    """
    Entry point.

    Args:
        argv (list[str]): command line arguments

    Returns:
        int: return code
    """

    ret: int = int(
        getattr(batteries_forking_included___main__, "__main")(argv),  # noqa: B009
    )

    # exit with useful code
    return ret

#endregion Private Functions
################################################################################

################################################################################
#region Immediate

if __name__ == "__main__":
    __ret = __main(sys.argv[1:])
    sys.exit(__ret)

#endregion Immediate
################################################################################
