"""
tests/src/batteries_forking_included/activate_sh/test_shell.py (batteries-forking-included)
"""  # noqa: E501,W505

################################################################################
#region Imports

#===============================================================================
#region stdlib

from typing import (
    List,
    Union,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

import pytest
from pytest import (
    mark                            as pytest_mark,
    MonkeyPatch                     as pytest_MonkeyPatch,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from batteries_forking_included import (
    getVersionNumber                as batteries_forking_included_getVersionNumber,
)
from ....PytestShellTestHarness import PytestShellTestHarness

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Invoke Tests

#===============================================================================
class Test_Invoke():
    """
    Invoke via command line.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest.param(
                None,
                2,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env python",
                    b"usage: ./run.sh",
                ],
                [
                    b"Error: SUBCOMMAND required.\n",
                ],
                [
                    b"Error:",
                ],
                [
                    b"FATAL:",
                ],
                id="args_None",
            ),
            pytest.param(
                [],
                2,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env python",
                    b"usage: ./run.sh",
                ],
                [
                    b"Error: SUBCOMMAND required.\n",
                ],
                [
                    b"Error:",
                ],
                [
                    b"FATAL:",
                ],
                id="args_emptyList",
            ),
            pytest.param(
                ["echo", "foo"],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env echo foo",
                    b"\nfoo\n",
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_echo_foo",
            ),
            pytest.param(
                ["--version"],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    (
                        b"\nbatteries-forking-included " +
                        batteries_forking_included_getVersionNumber().encode("utf8")
                    ),
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_version",
            ),
        ],
    )
    def test_Invoke(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Invoke.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion Invoke Tests
################################################################################

################################################################################
#region Source Tests

#===============================================================================
class Test_Source():
    """
    Invoke via command line.
    """

    #---------------------------------------------------------------------------
    def test_Source(
        self,
        shell_test_harness: PytestShellTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Source.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_test_harness.run()

        assert p.returncode == 149
        assert b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n" in p.stdout

#endregion Source Tests
################################################################################
