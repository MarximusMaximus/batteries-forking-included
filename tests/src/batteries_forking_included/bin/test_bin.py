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
from pytest import (
    mark                            as pytest_mark,
)
from subprocess import (  # nosec
    run                             as subprocess_run,
)
from typing import (
    Any,
    Dict,
    List,
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
#region Command Line

#===============================================================================
class Test_CommandLine():
    """
    Invoke via command line.
    """

    #----------------------------------bfi-----------------------------------------
    @pytest_mark.parametrize(
        "extra_args,expected_ret,expected_stdout,not_expected_stdout",
        [
            (
                [],
                2,
                [
                    b"usage:",
                    b"batteries-forking-included",
                    b"Error: SUBCOMMAND required.",
                ],
                [],
            ),
            (
                ["--help"],
                0,
                [b"usage:", b"batteries-forking-included"],
                [b"Error: SUBCOMMAND required."],
            ),
            (
                ["--version"],
                0,
                [b"batteries-forking-included"],
                [b"usage:", b"Error: SUBCOMMAND required."],
            ),
            (
                ["run", "echo", "foo"],
                0,
                [b"Executing:", b"run.sh echo foo", b"Executing: /usr/bin/env echo foo"],
                [b"usage:", b"Error: SUBCOMMAND required."],
            ),
        ],
    )
    def test_commandLine_noArgs(
        self,
        extra_args: List[str],
        expected_ret: int,
        expected_stdout: List[bytes],
        not_expected_stdout: List[bytes],
    ) -> None:
        """
        Invoke command line with no args.
        """
        cmd = ["python", "./bin/batteries-forking-included.py"]
        cmd = cmd + extra_args
        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v
        p = subprocess_run(cmd, capture_output=True, env=env)  # nosec

        assert p.returncode == expected_ret
        assert all(x in p.stdout for x in expected_stdout)
        assert all(x not in p.stdout for x in not_expected_stdout)

#endregion Command Line
################################################################################
