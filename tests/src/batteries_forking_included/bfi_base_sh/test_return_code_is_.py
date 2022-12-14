#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_shell__return_code.py (batteries-forking-included)
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
#region ours (external)

from pytest_shell_script_test_harness import PytestShellScriptTestHarness

#endregion ours (external)
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region return_code_is_error Tests

#===============================================================================
class Test_return_code_is_error():
    """
    Test return_code_is_error.
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
                    0,  # RET_SUCCESS
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="0_RET_SUCCESS",
            ),
            pytest_param(
                [
                    1,  # RET_ERROR_UNKNOWN
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="1_RET_ERROR_UNKNOWN",
            ),
            pytest_param(
                [
                    2,  # first local error code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="2_first_local_error_code",
            ),
            pytest_param(
                [
                    10,  # a middle local error code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="10_middle_local_error_code",
            ),
            pytest_param(
                [
                    63,  # last local error code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="63_last_local_error_code",
            ),
            pytest_param(
                [
                    64,  # first local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="64_first_local_warning_code",
            ),
            pytest_param(
                [
                    100,  # middle local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="100_middle_local_warning_code",
            ),
            pytest_param(
                [
                    125,  # last local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="125_last_local_warning_code",
            ),
            pytest_param(
                [
                    126,  # RET_ERROR_SHELL_PERMISSION_DENIED
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="126_RET_ERROR_SHELL_PERMISSION_DENIED",
            ),
            pytest_param(
                [
                    127,  # RET_ERROR_SHELL_FILE_NOT_FOUND
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="127_RET_ERROR_SHELL_FILE_NOT_FOUND",
            ),
            pytest_param(
                [
                    128,  # RET_ERROR_UNKNOWN_128 (first global error code)
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="128_RET_ERROR_UNKNOWN_128_first_global_error_code",
            ),
            pytest_param(
                [
                    129,  # RET_ERROR_SIGHUP
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="129_RET_ERROR_SIGHUP_middle_global_error_code",
            ),
            pytest_param(
                [
                    143,  # RET_ERROR_SIGTERM
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="143_RET_ERROR_SIGTERM_middle_global_error_code",
            ),
            pytest_param(
                [
                    144,  # RET_ERROR_CONDA_ACTIVATE_FAILED
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="144_RET_ERROR_CONDA_ACTIVATE_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    160,  # RET_ERROR_POETRY_INSTALL_FAILED
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="160_RET_ERROR_POETRY_INSTALL_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    191,  # last global error code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="191_last_global_error_code",
            ),
            pytest_param(
                [
                    192,  # RET_WARNING_UNKNOWN (first global warning code)
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="192_RET_WARNING_UNKNOWN_first_global_warning_code",
            ),
            pytest_param(
                [
                    225,  # middle global warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="225_middle_global_warning_code",
            ),
            pytest_param(
                [
                    251,  # last global warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="251_last_global_warning_code",
            ),
            pytest_param(
                [
                    253,  # RET_SUCCESS_SPECIAL
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="253_RET_SUCCESS_SPECIAL",
            ),
            pytest_param(
                [
                    254,  # RET_TOMBSTONE
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="254_RET_TOMBSTONE",
            ),
            pytest_param(
                [
                    255,  # RET_ERROR_UNKNOWN_255
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="255_RET_ERROR_UNKNOWN_255",
            ),
            pytest_param(
                [
                    -1,  # RET_ERROR_UNKNOWN_NEG1
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="neg1_RET_ERROR_UNKNOWN_NEG1",
            ),
            pytest_param(
                [
                    -127,  # middle negative return code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="neg127_middle_negative_return_code",
            ),
            pytest_param(
                [
                    -255,  # high negative return code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="neg255_high_negative_return_code",
            ),
        ],
    )
    def test_return_code_is_error(
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_script_test_harness: PytestShellScriptTestHarness,
    ) -> None:
        r"""
        Check that return_code_is_error returns properly based on args.
        """
        p = shell_script_test_harness.run(
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

#endregion return_code_is_error Tests
################################################################################

################################################################################
#region return_code_is_warning Tests

#===============================================================================
class Test_return_code_is_warning():
    """
    Test return_code_is_warning.
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
                    0,  # RET_SUCCESS
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="0_RET_SUCCESS",
            ),
            pytest_param(
                [
                    1,  # RET_ERROR_UNKNOWN
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="1_RET_ERROR_UNKNOWN",
            ),
            pytest_param(
                [
                    2,  # first local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="2_first_local_error_code",
            ),
            pytest_param(
                [
                    10,  # a middle local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="10_middle_local_error_code",
            ),
            pytest_param(
                [
                    63,  # last local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="63_last_local_error_code",
            ),
            pytest_param(
                [
                    64,  # first local warning code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="64_first_local_warning_code",
            ),
            pytest_param(
                [
                    100,  # middle local warning code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="100_middle_local_warning_code",
            ),
            pytest_param(
                [
                    125,  # last local warning code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="125_last_local_warning_code",
            ),
            pytest_param(
                [
                    126,  # RET_ERROR_SHELL_PERMISSION_DENIED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="126_RET_ERROR_SHELL_PERMISSION_DENIED",
            ),
            pytest_param(
                [
                    127,  # RET_ERROR_SHELL_FILE_NOT_FOUND
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="127_RET_ERROR_SHELL_FILE_NOT_FOUND",
            ),
            pytest_param(
                [
                    128,  # RET_ERROR_UNKNOWN_128 (first global error code)
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="128_RET_ERROR_UNKNOWN_128_first_global_error_code",
            ),
            pytest_param(
                [
                    129,  # RET_ERROR_SIGHUP
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="129_RET_ERROR_SIGHUP_middle_global_error_code",
            ),
            pytest_param(
                [
                    143,  # RET_ERROR_SIGTERM
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="143_RET_ERROR_SIGTERM_middle_global_error_code",
            ),
            pytest_param(
                [
                    144,  # RET_ERROR_CONDA_ACTIVATE_FAILED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="144_RET_ERROR_CONDA_ACTIVATE_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    160,  # RET_ERROR_POETRY_INSTALL_FAILED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="160_RET_ERROR_POETRY_INSTALL_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    191,  # last global error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="191_last_global_error_code",
            ),
            pytest_param(
                [
                    192,  # RET_WARNING_UNKNOWN (first global warning code)
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="192_RET_WARNING_UNKNOWN_first_global_warning_code",
            ),
            pytest_param(
                [
                    225,  # middle global warning code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="225_middle_global_warning_code",
            ),
            pytest_param(
                [
                    251,  # last global warning code
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="251_last_global_warning_code",
            ),
            pytest_param(
                [
                    253,  # RET_SUCCESS_SPECIAL
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="253_RET_SUCCESS_SPECIAL",
            ),
            pytest_param(
                [
                    254,  # RET_TOMBSTONE
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="254_RET_TOMBSTONE",
            ),
            pytest_param(
                [
                    255,  # RET_ERROR_UNKNOWN_255
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="255_RET_ERROR_UNKNOWN_255",
            ),
            pytest_param(
                [
                    -1,  # RET_ERROR_UNKNOWN_NEG1
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg1_RET_ERROR_UNKNOWN_NEG1",
            ),
            pytest_param(
                [
                    -127,  # middle negative return code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg127_middle_negative_return_code",
            ),
            pytest_param(
                [
                    -255,  # high negative return code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg255_high_negative_return_code",
            ),
        ],
    )
    def test_return_code_is_warning(
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_script_test_harness: PytestShellScriptTestHarness,
    ) -> None:
        r"""
        Check that return_code_is_error returns properly based on args.
        """
        p = shell_script_test_harness.run(
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

#endregion return_code_is_warning Tests
################################################################################

################################################################################
#region return_code_is_success Tests

#===============================================================================
class Test_return_code_is_success():
    """
    Test return_code_is_success.
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
                    0,  # RET_SUCCESS
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="0_RET_SUCCESS",
            ),
            pytest_param(
                [
                    1,  # RET_ERROR_UNKNOWN
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="1_RET_ERROR_UNKNOWN",
            ),
            pytest_param(
                [
                    2,  # first local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="2_first_local_error_code",
            ),
            pytest_param(
                [
                    10,  # a middle local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="10_middle_local_error_code",
            ),
            pytest_param(
                [
                    63,  # last local error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="63_last_local_error_code",
            ),
            pytest_param(
                [
                    64,  # first local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="64_first_local_warning_code",
            ),
            pytest_param(
                [
                    100,  # middle local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="100_middle_local_warning_code",
            ),
            pytest_param(
                [
                    125,  # last local warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="125_last_local_warning_code",
            ),
            pytest_param(
                [
                    126,  # RET_ERROR_SHELL_PERMISSION_DENIED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="126_RET_ERROR_SHELL_PERMISSION_DENIED",
            ),
            pytest_param(
                [
                    127,  # RET_ERROR_SHELL_FILE_NOT_FOUND
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="127_RET_ERROR_SHELL_FILE_NOT_FOUND",
            ),
            pytest_param(
                [
                    128,  # RET_ERROR_UNKNOWN_128 (first global error code)
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="128_RET_ERROR_UNKNOWN_128_first_global_error_code",
            ),
            pytest_param(
                [
                    129,  # RET_ERROR_SIGHUP
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="129_RET_ERROR_SIGHUP_middle_global_error_code",
            ),
            pytest_param(
                [
                    143,  # RET_ERROR_SIGTERM
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="143_RET_ERROR_SIGTERM_middle_global_error_code",
            ),
            pytest_param(
                [
                    144,  # RET_ERROR_CONDA_ACTIVATE_FAILED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="144_RET_ERROR_CONDA_ACTIVATE_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    160,  # RET_ERROR_POETRY_INSTALL_FAILED
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="160_RET_ERROR_POETRY_INSTALL_FAILED_middle_global_error_code",
            ),
            pytest_param(
                [
                    191,  # last global error code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="191_last_global_error_code",
            ),
            pytest_param(
                [
                    192,  # RET_WARNING_UNKNOWN (first global warning code)
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="192_RET_WARNING_UNKNOWN_first_global_warning_code",
            ),
            pytest_param(
                [
                    225,  # middle global warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="225_middle_global_warning_code",
            ),
            pytest_param(
                [
                    251,  # last global warning code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="251_last_global_warning_code",
            ),
            pytest_param(
                [
                    253,  # RET_SUCCESS_SPECIAL
                ],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: true\n",
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
                id="253_RET_SUCCESS_SPECIAL",
            ),
            pytest_param(
                [
                    254,  # RET_TOMBSTONE
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="254_RET_TOMBSTONE",
            ),
            pytest_param(
                [
                    255,  # RET_ERROR_UNKNOWN_255
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="255_RET_ERROR_UNKNOWN_255",
            ),
            pytest_param(
                [
                    -1,  # RET_ERROR_UNKNOWN_NEG1
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg1_RET_ERROR_UNKNOWN_NEG1",
            ),
            pytest_param(
                [
                    -127,  # middle negative return code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg127_middle_negative_return_code",
            ),
            pytest_param(
                [
                    -255,  # high negative return code
                ],
                1,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                    b"PytestShellScriptTestHarness: false\n",
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
                id="neg255_high_negative_return_code",
            ),
        ],
    )
    def test_return_code_is_success(
        self,
        additional_args: List[Union[str, int]],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_script_test_harness: PytestShellScriptTestHarness,
    ) -> None:
        r"""
        Check that return_code_is_error returns properly based on args.
        """
        p = shell_script_test_harness.run(
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

#endregion return_code_is_success Tests
################################################################################
