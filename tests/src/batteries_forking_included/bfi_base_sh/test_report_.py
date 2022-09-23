#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_get_ansi_code.py (batteries-forking-included)
"""  # noqa: E501,W505,B950

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
    MonkeyPatch                     as pytest_MonkeyPatch,
    param                           as pytest_param,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours
from pytest_shell_script_test_harness import PytestShellScriptTestHarness

from ...helper_functions import check_log_data

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region report_errors Tests

#===============================================================================
class Test_report_errors():
    """
    Test report_errors.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "expected_stderr," +
            "expected_report_header," +
            "additional_args_2"
        ),
        [
            pytest_param(
                [
                    b"",
                ],
                [
                    b"",
                ],
                [
                    0,
                ],
                id="zero",
            ),
            pytest_param(
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: error 1\x1b[0m\n"
                    ),
                ],
                [
                    b"\x1b[0;31mThe following Error(s) occurred:\x1b[0m\n",
                ],
                [
                    1,
                ],
                id="one",
            ),
            pytest_param(
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: error 1\x1b[0m\n"
                    ),
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: error 2\x1b[0m\n"
                    ),
                ],
                [
                    b"\x1b[0;31mThe following Error(s) occurred:\x1b[0m\n",
                ],
                [
                    2,
                ],
                id="two",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "true",
                ],
                0,
                [
                    b"",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="should_print_true",
            ),
            pytest_param(
                [
                    "false",
                ],
                0,
                [
                    (
                        b" \x1b[0;35mULTRADEBUG: " +
                        b"Skipping Error Report b/c should_print is 'false'.\x1b[0m\n"
                    ),
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="should_print_false",
            ),
        ],
    )
    def test_report_errors(  # pylint: disable=too-many-locals
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        expected_report_header: List[bytes],
        additional_args_2: List[Union[str, int]],
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        r"""
        Check that report_errors returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        # if we're not supposed to print, only check files
        is_file_only = (
            len(additional_args) >= 1 and
            additional_args[0] == "false"
        )

        final_additional_args: List[Union[str, int]] = []
        final_additional_args.extend(additional_args)
        final_additional_args.extend(additional_args_2)

        p = shell_script_test_harness.run(
            additional_args=final_additional_args,
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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
            # if we're not supposed to print, only check files
            is_file_only=is_file_only,
        )

        # if we were going to print and not skip,
        # we need to check for the report header:
        if not is_file_only:
            # in the full log:
            check_log_data(
                # lie about being in stdout, so we look in the full log only
                expected_stdout=expected_report_header,
                expected_stderr=[],
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                # lie about is_file_only, so we look in the full log only
                is_file_only=True,
                only_check_full_log=True,
            )

            # in stderr:
            check_log_data(
                expected_stdout=[],
                expected_stderr=expected_report_header,
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                is_console_only=True,
            )

#endregion report_errors Tests
################################################################################

################################################################################
#region report_warnings Tests

#===============================================================================
class Test_report_warnings():
    """
    Test report_warnings.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "expected_stderr," +
            "expected_report_header," +
            "additional_args_2"
        ),
        [
            pytest_param(
                [
                    b"",
                ],
                [
                    b"",
                ],
                [
                    0,
                ],
                id="zero",
            ),
            pytest_param(
                [
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: warning 1\x1b[0m\n",
                ],
                [
                    b"\x1b[1;33mThe following Warning(s) occurred:\x1b[0m\n",
                ],
                [
                    1,
                ],
                id="one",
            ),
            pytest_param(
                [
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: warning 1\x1b[0m\n",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: warning 2\x1b[0m\n",
                ],
                [
                    b"\x1b[1;33mThe following Warning(s) occurred:\x1b[0m\n",
                ],
                [
                    2,
                ],
                id="two",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "true",
                ],
                0,
                [
                    b"",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                ],
                id="should_print_true",
            ),
            pytest_param(
                [
                    "false",
                ],
                0,
                [
                    (
                        b" \x1b[0;35mULTRADEBUG: " +
                        b"Skipping Warning Report b/c should_print is 'false'."
                    ),
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                ],
                id="should_print_false",
            ),
        ],
    )
    def test_report_warnings(  # pylint: disable=too-many-locals
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        expected_report_header: List[bytes],
        additional_args_2: List[Union[str, int]],
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        r"""
        Check that report_warnings returns properly based on args and environment
            vars.
        """

        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        # if we're not supposed to print, only check files
        is_file_only = (
            len(additional_args) >= 1 and
            additional_args[0] == "false"
        )

        final_additional_args: List[Union[str, int]] = []
        final_additional_args.extend(additional_args)
        final_additional_args.extend(additional_args_2)

        p = shell_script_test_harness.run(
            additional_args=final_additional_args,
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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
            # if we're not supposed to print, only check files
            is_file_only=is_file_only,
        )

        # if we were going to print and not skip,
        # we need to check for the report header:
        if not is_file_only:
            # in the full log:
            check_log_data(
                # lie about being in stdout, so we look in the full log only
                expected_stdout=expected_report_header,
                expected_stderr=[],
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                # lie about is_file_only, so we look in the full log only
                is_file_only=True,
                only_check_full_log=True,
            )

            # in stderr:
            check_log_data(
                expected_stdout=[],
                expected_stderr=expected_report_header,
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                is_console_only=True,
            )

#endregion report_warnings Tests
################################################################################

################################################################################
#region report_final_status Tests

#===============================================================================
class Test_report_final_status():
    """
    Test report_final_status.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        "additional_args_3",
        [
            pytest_param(
                [
                    0,  # RET_SUCCESS
                ],
                id="pass0",
            ),
            pytest_param(
                [
                    1,  # RET_ERROR_UNKNOWN
                ],
                id="pass1",
            ),
            pytest_param(
                [
                    2,  # an error
                ],
                id="pass2",
            ),
            pytest_param(
                [
                    192,  # RET_WARNING_UNKNOWN
                ],
                id="pass192",
            ),
            pytest_param(
                [
                    193,  # RET_WARNING_MULTIPLE
                ],
                id="pass193",
            ),
            pytest_param(
                [
                    194,  # a warning
                ],
                id="pass194",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "expected_ret," +
            "expected_stderr," +
            "expected_report_header," +
            "additional_args_2," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                0,
                [
                    b"",
                ],
                [
                    b"",
                ],
                [
                    0,
                    0,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_zeroE_zeroW_ret0",
            ),
            pytest_param(
                192,  # RET_WARNING_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: " +
                        b"SOME_PROGRAM Had 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    0,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                ],
                id="zeroF_zeroE_oneW_ret192",
            ),
            pytest_param(
                193,  # RET_WARNING_MULTIPLE
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: " +
                        b"SOME_PROGRAM Had 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    0,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                ],
                id="zeroF_zeroE_twoW_ret193",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 1 Error.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    1,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_oneE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 1 Error " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    1,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_oneE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 1 Error " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    1,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_oneE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 2 Errors.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    2,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_twoE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 2 Errors " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    2,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_twoE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: " +
                        b"SOME_PROGRAM Had 2 Errors " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    0,
                    2,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="zeroF_twoE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    0,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_zeroE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    0,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_zeroE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    0,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_zeroE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error " +
                        b"and 1 Error.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    1,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_oneE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error, 1 Error, " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    1,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_oneE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error, 1 Error, " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    1,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_oneE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error " +
                        b"and 2 Errors.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    2,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_twoE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error, 2 Errors, " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    2,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_twoE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 1 Fatal Error, 2 Errors, " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    1,
                    2,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="oneF_twoE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    0,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_zeroE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    0,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_zeroE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    0,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_zeroE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors " +
                        b"and 1 Error.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    1,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_oneE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors, 1 Error, " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    1,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_oneE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors, 1 Error, " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    1,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_oneE_twoW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors " +
                        b"and 2 Errors.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    2,
                    0,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_twoE_zeroW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors, 2 Errors, " +
                        b"and 1 Warning.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    2,
                    1,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_twoE_oneW_ret1",
            ),
            pytest_param(
                1,  # RET_ERROR_UNKNOWN
                [
                    b"",
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xf0\x9f\x92\x80 FATAL: " +
                        b"SOME_PROGRAM Had 2 Fatal Errors, 2 Errors, " +
                        b"and 2 Warnings.\x1b[0m\n"
                    ),
                ],
                [
                    2,
                    2,
                    2,
                ],
                [
                    (
                        b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                        b"\xe2\x9d\x8c ERROR: "
                    ),
                    (
                        b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                        b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
                    ),
                ],
                id="twoF_twoE_twoW_ret1",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_stdout"
        ),
        [
            pytest_param(
                [
                    "true",
                ],
                [
                    b"",
                ],
                id="should_print_true",
            ),
            pytest_param(
                [
                    "false",
                ],
                [
                    (
                        b" \x1b[0;35mULTRADEBUG: " +
                        b"Skipping Final Report b/c should_print is 'false'."
                    ),
                ],
                id="should_print_false",
            ),
        ],
    )
    def test_report_final_status(  # pylint: disable=too-many-locals
        self,
        additional_args_3: List[Union[str, int]],
        expected_ret: int,
        expected_stderr: List[bytes],
        expected_report_header: List[bytes],
        additional_args_2: List[Union[str, int]],
        expected_not_stderr: List[bytes],
        additional_args: List[Union[str, int]],
        expected_stdout: List[bytes],
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        r"""
        Check that report_final_status returns properly based on args and environment
            vars.
        """
        expected_not_stdout = [
            (
                b" \x1b[1;31m\x07\xf0\x9f\x94\x94 " +
                b"\xf0\x9f\x92\x80 FATAL: "
            ),
            (
                b" \x1b[0;31m\x07\xf0\x9f\x94\x94 " +
                b"\xe2\x9d\x8c ERROR: "
            ),
            (
                b" \x1b[1;33m\x07\xf0\x9f\x94\x94 "
                b"\xe2\x9a\xa0\xef\xb8\x8f WARNING: "
            ),
        ]

        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        # if we're not supposed to print, only check files
        is_file_only = (
            len(additional_args) >= 1 and
            additional_args[0] == "false"
        )

        final_additional_args: List[Union[str, int]] = []
        final_additional_args.extend(additional_args)
        final_additional_args.extend(additional_args_2)
        final_additional_args.extend(additional_args_3)

        if (
            len(additional_args_3) >= 1 and
            isinstance(additional_args_3[0], int) and
            additional_args_3[0] != 0
        ):
            expected_ret = additional_args_3[0]

        final_expected_stdout: List[bytes] = []
        final_expected_stdout.extend(expected_stdout)
        if expected_ret == 0 and not is_file_only:
            final_expected_stdout.extend([
                (
                    b" \x1b[1;32m\007\xf0\x9f\x94\x94 " +
                    b"\xe2\x9c\x85 SUCCESS: " +
                    b"SOME_PROGRAM Completed Successfully.\x1b[0m\n"
                ),
            ])

        p = shell_script_test_harness.run(
            additional_args=final_additional_args,
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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=final_expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
            # if we're not supposed to print, only check files
            is_file_only=is_file_only,
        )

        # if we were going to print and not skip,
        # we need to check for the report header:
        if not is_file_only:
            # in the full log:
            check_log_data(
                # lie about being in stdout, so we look in the full log only
                expected_stdout=expected_report_header,
                expected_stderr=[],
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                # lie about is_file_only, so we look in the full log only
                is_file_only=True,
                only_check_full_log=True,
            )

            # in stderr:
            check_log_data(
                expected_stdout=[],
                expected_stderr=expected_report_header,
                expected_not_stdout=[],
                expected_not_stderr=[],
                stdout=p.stdout,
                stderr=p.stderr,
                is_console_only=True,
            )

#endregion report_final_status Tests
################################################################################
