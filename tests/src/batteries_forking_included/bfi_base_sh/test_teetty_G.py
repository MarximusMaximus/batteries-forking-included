#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_teetty_G.py (batteries-forking-included)
"""  # noqa: E501,W505

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os.path import (
    abspath                         as os_path_abspath,
)
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
            pytest_param(
                [
                    "printf", "\"foo bar\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                    b"foo bar\n",  # cspell:disable-line # noqa: E501,B950
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
                id="printf_single_line",
            ),
            pytest_param(
                [
                    "printf", "\"foo bar\nbaz\nqwerty\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                    b"foo bar\nbaz\nqwerty\n",  # cspell:disable-line # noqa: E501,B950
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
                id="printf_multi_line",
            ),
            pytest_param(
                [
                    "log_fatal", "\"foo bar\nbaz\nqwerty\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                ],
                [
                    b"foo bar\nbaz\nqwerty\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="log_fatal",
            ),
            pytest_param(
                [
                    ">&2", "printf", "\"foo bar\nbaz\nqwerty\n\"",  # cspell:disable-line # noqa: E501,B950
                ],
                0,
                [
                ],
                [
                    b"foo bar\nbaz\nqwerty\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="printf_to_stderr",
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
        Check that teetty_G runs the specified commands and correctly tees
        output.
        """
        if additional_args is None:  # pragma: no cover
            additional_args = []

        tempdir_path = os_path_abspath("")
        full_log_filepath = os_path_abspath("log/log.txt")
        error_and_fatal_log_filepath = os_path_abspath("log/errors_and_fatals_only.txt")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
            },
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

        with open(full_log_filepath, "rb") as f:
            data = f.read()
            for x in expected_stdout:
                assert x in data

        with open(error_and_fatal_log_filepath, "rb") as f:
            data = f.read()
            for x in expected_stderr:
                assert x in data

#endregion teetty_G, cleanup_fifo, create_fifo tests
################################################################################
