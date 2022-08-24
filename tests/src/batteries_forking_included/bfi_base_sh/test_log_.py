#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_get_ansi_code.py (batteries-forking-included)
"""  # noqa: E501,W505,B950

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

from pytest import (
    mark                            as pytest_mark,
    param                           as pytest_param,
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
#region log_console Tests

#===============================================================================
class Test_log_console():
    """
    Test log_console.
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
            pytest_param(
                [
                    "asdf", "qwerty", 42,
                ],
                0,
                [
                    b"PytestShellTestHarness: YYYY-mm-dd HH:MM:SS \033[1;37masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"PytestShellTestHarness: YYYY-mm-dd HH:MM:SS \033[1;37mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="args_empty",
            ),
        ],
    )
    def test_log_console(
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
        Check that log_console returns properly based on args and environment
            vars.
        """
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

#endregion log_console Tests
################################################################################
