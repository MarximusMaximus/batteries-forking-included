"""\
batteries-forking-included python wrapper
"""

################################################################################
#region __main__.py Preamble

# insert our repo base dir into the sys.path so that we can import our library
# we know that the repo path is ./../.. b/c we should be in ./src/<project name>/
import sys
import os
import os.path as os_path
MY_DIR_FULLPATH = os_path.dirname(__file__)
MY_REPO_FULLPATH = os_path.dirname(os_path.dirname(MY_DIR_FULLPATH))
sys.path.insert(0, MY_REPO_FULLPATH)
MY_LIB_FULLPATH = os_path.join(MY_REPO_FULLPATH, "src")
sys.path.insert(0, MY_LIB_FULLPATH)

MY_PROGRAM_NAME = os.environ.get("BFI_ORIGINAL_EXEC_NAME", os_path.basename(sys.argv[0]))
if (  # pragma: no branch
    "." not in os_path.basename(MY_PROGRAM_NAME) or
    ".py" in os_path.basename(MY_PROGRAM_NAME)
):
    MY_PROGRAM_NAME = os_path.basename(MY_PROGRAM_NAME)
del os
del os_path

#endregion __main__.py Preamble
################################################################################


################################################################################
#region Imports

#===============================================================================
#region stdlib

import argparse
from typing import (
    Any,
    Dict,
    List,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region Ours

from batteries_forking_included import (
    bfiBootstrap                    as batteries_forking_included_bfiBootstrap,
    bfiInit                         as batteries_forking_included_bfiInit,
    bfiUpdate                       as batteries_forking_included_bfiUpdate,
    bfiRun                          as batteries_forking_included_bfiRun,
    getVersionNumber                as batteries_forking_included_getVersionNumber,
)

#endregion Imports
################################################################################

################################################################################
#region Constants


#endregion Constants
################################################################################

################################################################################
#region Subcommands

#-------------------------------------------------------------------------------
def subcommandBootstrap(
    extras: List[str],
    *args: List[Any],
    **kwargs: Dict[str, Any],
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

    return batteries_forking_included_bfiBootstrap(extras=extras)

#-------------------------------------------------------------------------------
def subcommandInit(
    extras: List[str],
    *args: List[Any],
    **kwargs: Dict[str, Any],
) -> int:
    """
    Call BFI/src/batteries_forking_included/template/bfi-update.sh with current
        dir as project dir to copy ALL missing files (and update others) to
        current dir.

    Args:
        extras (list[str]): command line args to bfi-update.sh

    Returns:
        int: return code from bfi-update.sh
    """
    # silence the "variable not used" complaints in function signature
    args = args  # noqa: F841
    kwargs = kwargs  # noqa: F841

    return batteries_forking_included_bfiInit(extras=extras)

#-------------------------------------------------------------------------------
def subcommandRun(
    extras: List[str],
    *args: List[Any],
    **kwargs: Dict[str, Any],
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

    return batteries_forking_included_bfiRun(extras=extras)

#-------------------------------------------------------------------------------
def subcommandUpdate(
    extras: List[str],
    *args: List[Any],
    **kwargs: Dict[str, Any],
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

    return batteries_forking_included_bfiUpdate(extras=extras)

#endregion Subcommands
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
    # do argparse stuff
    bfi_version = batteries_forking_included_getVersionNumber()

    parser = argparse.ArgumentParser(
        prog=MY_PROGRAM_NAME,
        description=f"batteries-forking-included {bfi_version}",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"batteries-forking-included {bfi_version}",
    )
    subparsers = parser.add_subparsers(
        dest="subcommand",
        metavar="SUBCOMMAND",
    )

    subparsers.add_parser(
        name="bootstrap",
        help="bootstrap current directory's project's environment",
    )

    subparsers.add_parser(
        name="init",
        help="initialize current directory with template",
    )

    subparsers.add_parser(
        name="run",
        help="run command in current directory's project's environment",
    )

    subparsers.add_parser(
        name="update",
        help="update current directory from template",
    )

    options, extras = parser.parse_known_args(argv)

    subcommands = {
        "bootstrap":    subcommandBootstrap,
        "init":         subcommandInit,
        "run":          subcommandRun,
        "update":       subcommandUpdate,
    }

    if (
        options.subcommand is None or
        options.subcommand not in subcommands
    ):  # pragma: no cover
        parser.print_help()
        print("\nError: SUBCOMMAND required.", file=sys.stderr)
        parser.exit(2)

    ret = subcommands[options.subcommand](extras=extras, **vars(options))

    # exit with useful code
    return ret

#endregion Private Functions
################################################################################

################################################################################
#region Script Entry Point

def scriptEntryPoint() -> int:  # pragma: no cover
    """
    Script entry point. Used by tool.poetry.scripts.

    Returns:
        int: return code
    """
    ret = __main(sys.argv[1:])
    sys.exit(ret)

#endregion Script Entry Point
################################################################################

################################################################################
#region Immediate

if __name__ == "__main__":  # pragma: no cover
    scriptEntryPoint()

#endregion Immediate
################################################################################
