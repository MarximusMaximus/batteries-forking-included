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
# we know that the repo path is ./.. b/c we should be in ./bin/
import sys
import os
import os.path as os_path
MY_DIR_FULLPATH = os_path.dirname(__file__)
MY_REPO_FULLPATH = os_path.dirname(MY_DIR_FULLPATH)
sys.path.insert(0, MY_REPO_FULLPATH)

MY_PROGRAM_NAME = os.environ.get("BFI_ORIGINAL_EXEC_NAME", os_path.basename(sys.argv[0]))
if (
    "." not in os_path.basename(MY_PROGRAM_NAME) or
    ".py" in os_path.basename(MY_PROGRAM_NAME)
):
    MY_PROGRAM_NAME = os_path.basename(MY_PROGRAM_NAME)

#endregion Bootstrap Preamble
################################################################################
__doc__ = """\
batteries-forking-included python wrapper
"""

import argparse
import subprocess
from typing import Any

BFI_VERSION = os.environ.get("BFI_VERSION", "Unknown")


#-------------------------------------------------------------------------------
def subcommand_init(
    extras: list[str],
    *args: list[Any],
    **kwargs: dict[str, Any],
) -> int:
    """
    Call BFI/src/template/bfi-update.sh with current dir as project dir to copy
        ALL missing files (and update others) to current dir.

    Args:
        extras (list[str]): command line args to bfi-update.sh

    Returns:
        int: return code from bfi-update.sh
    """
    # silence the "variable not used" complaints in function signature
    args = args  # noqa: F841
    kwargs = kwargs  # noqa: F841

    cwd = os.path.abspath(os.path.curdir)
    cmd = [
        f"{MY_REPO_FULLPATH}/src/template/bfi-update.sh",
        f"--project-dir={cwd}",
    ]
    cmd = cmd + extras
    ret = subprocess.call(cmd)
    return ret


#-------------------------------------------------------------------------------
def subcommand_update(
    extras: list[str],
    *args: list[Any],
    **kwargs: dict[str, Any],
) -> int:
    """
    Call bfi-update.sh to update project's BFI files from BFI's template.

    Args:
        extras (list[str]): command line args to bfi-update.sh

    Returns:
        int: return code from bfi-update.sh
    """
    # silence the "variable not used" complaints in function signature
    args = args  # noqa: F841
    kwargs = kwargs  # noqa: F841

    cmd = [
        f"{MY_REPO_FULLPATH}/src/template/bfi-update.sh",
    ]
    cmd = cmd + extras
    ret = subprocess.call(cmd)
    return ret


#-------------------------------------------------------------------------------
def subcommand_run(
    extras: list[str],
    *args: list[Any],
    **kwargs: dict[str, Any],
) -> int:
    """
    Call run.sh to run a command (denoted in 'extras') in the project's conda
        environment.

    Args:
        extras (list[str]): command line args to run.sh

    Returns:
        int: return code from run.sh
    """
    # silence the "variable not used" complaints in function signature
    args = args  # noqa: F841
    kwargs = kwargs  # noqa: F841

    cmd = [
        f"{MY_REPO_FULLPATH}/src/template/bfi-run.sh",
    ]
    cmd = cmd + extras
    ret = subprocess.call(extras)
    return ret


#-------------------------------------------------------------------------------
def subcommand_bootstrap(
    extras: list[str],
    *args: list[Any],
    **kwargs: dict[str, Any],
) -> int:
    """
    Call bootstrap.sh to begin bootstrap process.

    Args:
        extras (list[str]): command line args to bootstrap.sh

    Returns:
        int: return code from bootstrap.sh
    """
    # silence the "variable not used" complaints in function signature
    args = args  # noqa: F841
    kwargs = kwargs  # noqa: F841

    cmd = [
        f"{MY_REPO_FULLPATH}/src/template/bootstrap.sh",
    ]
    cmd = cmd + extras
    ret = subprocess.call(cmd)
    return ret


#-------------------------------------------------------------------------------
def __main(argv: list[str]) -> int:
    """
    Entry point.

    Args:
        argv (list[str]): command line arguments

    Returns:
        int: return code
    """
    # do argparse stuff
    parser = argparse.ArgumentParser(
        prog=MY_PROGRAM_NAME,
        description=f"batteries-forking-included {BFI_VERSION}\n{__doc__}",
    )
    parser.add_argument(
        '--version',
        action='version',
        version=f"batteries-forking-included {BFI_VERSION}",
    )
    subparsers = parser.add_subparsers(
        dest="subcommand",
        metavar="SUBCOMMAND",
    )

    subparsers.add_parser(
        name="init",
        help="initialize current directory with template",
    )

    subparsers.add_parser(
        name="update",
        help="update current directory from template",
    )

    subparsers.add_parser(
        name="run",
        help="run command in current directory's project's environment",
    )

    subparsers.add_parser(
        name="bootstrap",
        help="bootstrap current directory's project's environment",
    )

    options, extras = parser.parse_known_args(argv)

    subcommands = {
        "init": subcommand_init,
        "update": subcommand_update,
        "run":  subcommand_run,
        "bootstrap": subcommand_bootstrap,
    }

    if (
        options.subcommand is None or
        options.subcommand not in subcommands
    ):
        parser.print_help()
        print("\nError: SUBCOMMAND required.")
        parser.exit(2)

    ret = subcommands[options.subcommand](extras=extras, **vars(options))

    # exit with useful code
    return ret


if __name__ == "__main__":
    ret = __main(sys.argv[1:])
    sys.exit(ret)
