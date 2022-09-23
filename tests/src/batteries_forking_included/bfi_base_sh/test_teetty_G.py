#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_teetty_G.py (batteries-forking-included)
"""  # noqa: E501,W505

################################################################################
#region Imports

#===============================================================================
#region stdlib

from glob import (
    glob                            as glob_glob,
)
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
    MonkeyPatch                     as pytest_MonkeyPatch,
)

#endregion third party
#===============================================================================

#===============================================================================
#region ours (external)

from pytest_shell_script_test_harness import PytestShellScriptTestHarness

#endregion ours (external)
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
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
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
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
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
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
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
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="printf_to_stderr",
            ),
        ],
    )
    def test_teetty_G(  # pylint: disable=too-many-locals
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        r"""
        Check that teetty_G runs the specified commands and correctly tees
        output.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")
        full_log_filepath = os_path_abspath("log/log.txt")
        error_and_fatal_log_filepath = os_path_abspath("log/errors_and_fatals_only.txt")

        # check how many fifo files we're ending with
        # (hopefully 0, but might not be true)
        # because we want to make sure we delete any we create
        before_fifo_files = glob_glob(
            "std*.*.*",
            recursive=False,
        )

        p = shell_script_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
                "CONSTANTS_TEMP_DIR": None,
                "FATAL_LOG": None,
                "ERROR_LOG": None,
                "ERROR_AND_FATAL_LOG": None,
                "WARNING_LOG": None,
                "FULL_LOG": None,
            },
        )

        # check how many fifo files we're ending with
        # (hopefully 0, but might not be true, based on starting value)
        # because we want to make sure we deleted any we created
        after_fifo_files = glob_glob(
            "std*.*.*",
            recursive=False,
        )

        assert len(after_fifo_files) == len(before_fifo_files)

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
