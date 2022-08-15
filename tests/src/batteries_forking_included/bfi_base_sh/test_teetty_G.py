"""
tests/src/batteries_forking_included/bfi_base_sh/test_teetty_G.py (batteries-forking-included)
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
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from ....PytestShellTestHarness import PytestShellTestHarness

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region teetty_G, cleanup_fifo, create_fifo tests

#===============================================================================
class Test_teetty_G():
    """
    Test teetty_G.
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
                [
                    "printf", "\"foo bar\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                ],
                [
                    b"PytestShellTestHarness: foo bar\n",  # cspell:disable-line # noqa: E501,B950
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
            pytest.param(
                [
                    "printf", "\"foo bar\nbaz\nqwerty\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: foo bar\nbaz\nqwerty\n",  # cspell:disable-line # noqa: E501,B950
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
                id="args_foo_bar",
            ),
            pytest.param(
                [
                    ">&2", "printf", "\"foo bar\nbaz\nqwerty\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: foo bar\nbaz\nqwerty\n",  # cspell:disable-line # noqa: E501,B950
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
                id="args_foo_bar",
            ),
        ],
    )
    def test_teetty_G(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        if additional_args is None:
            additional_args = []

        stdout_filepath = "stdout.txt"
        stderr_filepath = "stderr.txt"
        final_args = [
            stdout_filepath,
            stderr_filepath,
        ] + additional_args

        p = shell_test_harness.run(
            additional_args=final_args,
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

        with open(stdout_filepath, "rb") as f:
            data = f.read()
            for x in expected_stdout:
                if x.startswith(b"PytestShellTestHarness: "):
                    assert x[len(b"PytestShellTestHarness: "):-1] in data

        with open(stderr_filepath, "rb") as f:
            data = f.read()
            for x in expected_stderr:
                if x.startswith(b"PytestShellTestHarness: "):
                    assert x[len(b"PytestShellTestHarness: "):-1] in data

#endregion teetty_G, cleanup_fifo, create_fifo tests
################################################################################
