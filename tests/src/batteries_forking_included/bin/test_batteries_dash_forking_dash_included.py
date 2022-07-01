"""
tests/bin/test_batteries_dash_forking_dash_included.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

# import sys
from os import (
    environ                         as os_environ,
)
from subprocess import (  # nosec
    run                             as subprocess_run,
)
from typing import (
    Any,
    Dict,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region Ours


#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Types

PytestFixture = Any

#endregion Types
################################################################################

################################################################################
#region Constants


#endregion Constants
################################################################################

################################################################################
#region Tests

#-------------------------------------------------------------------------------
def test___loads() -> None:
    """
    Simple test to confirm this subpackage of tests loads.
    """

    assert True

#-------------------------------------------------------------------------------
def test_call_bfi__no_args() -> None:
    """
    _summary_
    """
    cmd = ["python", "./bin/batteries-forking-included.py"]
    env: Dict[str, Any] = {
        "OMEGA_DEBUG": "true",
    }
    for k, v in os_environ.items():
        env[k] = v
    p = subprocess_run(cmd, capture_output=True, env=env)  # nosec

    assert p.returncode == 2
    assert b"Error: SUBCOMMAND required." in p.stdout

#-------------------------------------------------------------------------------
def test_call_bfi__help() -> None:
    """
    _summary_
    """
    cmd = ["python", "./bin/batteries-forking-included.py", "--help"]
    env: Dict[str, Any] = {
        "OMEGA_DEBUG": "true",
    }
    for k, v in os_environ.items():
        env[k] = v
    p = subprocess_run(cmd, capture_output=True, env=env)  # nosec

    assert p.returncode == 0
    assert b"usage:" in p.stdout

#endregion Tests
################################################################################
