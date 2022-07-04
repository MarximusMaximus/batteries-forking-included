"""
batteries-forking-included python wrapper
"""
################################################################################
#region Python Library Preamble

# we know that the repo path is ./../../ b/c we should be in ./src/<project name>/
import os.path as os_path
MY_DIR_FULLPATH = os_path.dirname(__file__)
MY_REPO_FULLPATH = os_path.dirname(os_path.dirname(MY_DIR_FULLPATH))
del os_path

from logging import (  # noqa: F401
    DEBUG                           as logging_DEBUG,
    ERROR                           as logging_ERROR,
    FATAL                           as logging_FATAL,
    getLogger                       as logging_getLogger,
    INFO                            as logging_INFO,
    WARNING                         as logging_WARNING,
)
logger = logging_getLogger(__name__)
logger_log = logger.log

#endregion Python Library Preamble
################################################################################

###############################################################################
#region Imports

#===============================================================================
#region stdlib

from importlib.metadata import (
    version                         as importlib_metadata_version,
    PackageNotFoundError            as importlib_metadata_PackageNotFoundError,
)

from os import (
    environ                         as os_environ,
)
from os.path import (
    abspath                         as os_path_abspath,
    curdir                          as os_path_curdir,
    join                            as os_path_join,
)
from subprocess import (  # nosec
    call                            as subprocess_call,
)
import sys
from typing import (
    List,
    Optional,
)

#endregion stdlib
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Public Functions

#-------------------------------------------------------------------------------
def bfiBootstrap(
    extras: Optional[List[str]] = None,
) -> int:
    """
    Call bootstrap.sh to begin bootstrap process.

    Args:
        extras (list[str]): command line args to bootstrap.sh

    Returns:
        int: return code from bootstrap.sh
    """
    cwd = os_path_abspath(os_path_curdir)
    script = os_path_join(cwd, "bootstrap.sh")

    ret = _bfiExecute(script=script, extras=extras)
    return ret

#-------------------------------------------------------------------------------
def bfiInit(
    extras: Optional[List[str]] = None,
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
    if extras is None:
        extras = []

    cwd = os_path_abspath(os_path_curdir)
    extras.insert(0, f"--project-dir={cwd}")

    script = os_path_join(
        MY_REPO_FULLPATH, "src", "batteries_forking_included", "template",
        "bfi-update.sh",
    )

    ret = _bfiExecute(script=script, extras=extras)
    return ret

#-------------------------------------------------------------------------------
def bfiUpdate(
    extras: Optional[List[str]] = None,
) -> int:
    """
    Call bfi-update.sh to update project's BFI files from BFI's template.

    Args:
        extras (list[str]): command line args to bfi-update.sh

    Returns:
        int: return code from bfi-update.sh
    """
    cwd = os_path_abspath(os_path_curdir)
    script = os_path_join(cwd, "bfi-update.sh")

    ret = _bfiExecute(script=script, extras=extras)
    return ret

#-------------------------------------------------------------------------------
def bfiRun(
    extras: Optional[List[str]] = None,
) -> int:
    """
    Call run.sh to run a command (denoted in 'extras') in the project's conda
        environment.

    Args:
        extras (Union[List[str], None], optional): command line args to run.sh

    Returns:
        int: return code from run.sh
    """
    cwd = os_path_abspath(os_path_curdir)
    script = os_path_join(cwd, "run.sh")

    ret = _bfiExecute(script=script, extras=extras)
    return ret

#-------------------------------------------------------------------------------
def getVersionNumber() -> str:
    """
    Get version number of library.

    Returns:
        _type_: version number as str
    """
    try:
        bfi_version = importlib_metadata_version("batteries_forking_included")
    except importlib_metadata_PackageNotFoundError:
        try:
            with open(os_path_join(MY_REPO_FULLPATH, "pyproject.toml")) as f:
                f_data = []
                for _ in range(10):
                    f_data.append(f.readline())
                f_data = [x for x in f_data if "version = " in x]
                bfi_version = f_data[0][len("version = "):]
                bfi_version = bfi_version[1:-2]
        except Exception:
            bfi_version = "UNKNOWN"

    bfi_version = os_environ.get("BFI_VERSION", bfi_version)

    return bfi_version

#endregion Public Functions
################################################################################

################################################################################
#region Protected Functions

def _bfiExecute(
    script: str,
    extras: Optional[List[str]] = None,
) -> int:
    """
    Call shell script with args (denoted in 'extras') in the project's conda
        environment.

    Args:
        extras (Union[List[str], None], optional): command line args

    Returns:
        int: return code from shell script
    """
    if extras is None:
        extras = []

    cmd = [script]

    cmd = cmd + extras
    print("Executing: " + " ".join(cmd))
    ret = subprocess_call(cmd)  # nosec
    return ret

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

    logger_log(logging_FATAL, "This module should not be run directly.")

    return 1

#endregion Private Functions
################################################################################

################################################################################
#region Immediate

if __name__ == "__main__":
    __ret = __main(sys.argv[1:])
    sys.exit(__ret)

#endregion Immediate
################################################################################
