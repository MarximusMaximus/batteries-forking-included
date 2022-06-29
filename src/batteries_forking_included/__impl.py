"""
batteries-forking-included python wrapper
"""
################################################################################
#region Python Library Preamble

import os.path as os_path
MY_DIR_FULLPATH = os_path.dirname(__file__)
MY_REPO_FULLPATH = os_path.dirname(MY_DIR_FULLPATH)
del os_path

#endregion Python Library Preamble
################################################################################

###############################################################################
#region Imports

#===============================================================================
#region stdlib

from importlib.metadata import (
    version                         as importlib_metadata_version,
)
from os import (
    environ                         as os_environ,
)
from os.path import (
    abspath                         as os_path_abspath,
    curdir                          as os_path_curdir,
)
from subprocess import (
    call                            as subprocess_call,
)

#endregion stdlib
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Constants

BFI_VERSION = os_environ.get(
    "BFI_VERSION",
    importlib_metadata_version("batteries_forking_included"),
)

#endregion Constants
################################################################################

#-------------------------------------------------------------------------------
def bfi_bootstrap(
    extras: list[str],
) -> int:
    """
    Call bootstrap.sh to begin bootstrap process.

    Args:
        extras (list[str]): command line args to bootstrap.sh

    Returns:
        int: return code from bootstrap.sh
    """
    cmd = [
        f"{MY_REPO_FULLPATH}/src/batteries_forking_included/template/bootstrap.sh",
    ]
    cmd = cmd + extras
    print("Executing: " + " ".join(cmd))
    ret = subprocess_call(cmd)
    return ret

#-------------------------------------------------------------------------------
def bfi_init(
    extras: list[str],
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
    cwd = os_path_abspath(os_path_curdir)
    cmd = [
        f"{MY_REPO_FULLPATH}/src/batteries_forking_included/template/bfi-update.sh",
        f"--project-dir={cwd}",
    ]
    cmd = cmd + extras
    print("Executing: " + " ".join(cmd))
    ret = subprocess_call(cmd)
    return ret

#-------------------------------------------------------------------------------
def bfi_update(
    extras: list[str],
) -> int:
    """
    Call bfi-update.sh to update project's BFI files from BFI's template.

    Args:
        extras (list[str]): command line args to bfi-update.sh

    Returns:
        int: return code from bfi-update.sh
    """
    cmd = [
        f"{MY_REPO_FULLPATH}/src/batteries_forking_included/template/bfi-update.sh",
    ]
    cmd = cmd + extras
    print("Executing: " + " ".join(cmd))
    ret = subprocess_call(cmd)
    return ret

#-------------------------------------------------------------------------------
def bfi_run(
    extras: list[str],
) -> int:
    """
    Call run.sh to run a command (denoted in 'extras') in the project's conda
        environment.

    Args:
        extras (list[str]): command line args to run.sh

    Returns:
        int: return code from run.sh
    """
    cmd = [
        f"{MY_REPO_FULLPATH}/src/batteries_forking_included/template/bfi-run.sh",
    ]
    cmd = cmd + extras
    print("Executing: " + " ".join(cmd))
    ret = subprocess_call(extras)
    return ret
