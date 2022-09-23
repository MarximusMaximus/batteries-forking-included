#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_get_ansi_code.py (batteries-forking-included)
"""  # noqa: E501,W505,B950

# TODO: verbosity checks

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
#region ours (external)

from pytest_shell_script_test_harness import PytestShellScriptTestHarness

#endregion ours (external)
#===============================================================================

#===============================================================================
#region ours (internal)

from ...helper_functions import check_log_data

#endregion ours (internal)
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_console(  # pylint: disable=too-many-locals
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
        Check that log_console returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
            is_console_only=True,
        )

#endregion log_console Tests
################################################################################

################################################################################
#region log_success Tests

#===============================================================================
class Test_log_success():
    """
    Test log_success.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;32mSUCCESS: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;32mSUCCESS: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_success(  # pylint: disable=too-many-locals
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
        Check that log_success returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_success Tests
################################################################################

################################################################################
#region log_success_final Tests

#===============================================================================
class Test_log_success_final():
    """
    Test log_success_final.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;32m\007\xf0\x9f\x94\x94 \xe2\x9c\x85 SUCCESS: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;32m\007\xf0\x9f\x94\x94 \xe2\x9c\x85 SUCCESS: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_success_final(  # pylint: disable=too-many-locals
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
        Check that log_success_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_success_final Tests
################################################################################

################################################################################
#region log_fatal Tests

#===============================================================================
class Test_log_fatal():
    """
    Test log_fatal.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_fatal(  # pylint: disable=too-many-locals
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
        Check that log_fatal returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_fatal Tests
################################################################################

################################################################################
#region log_fatal_final Tests

#===============================================================================
class Test_log_fatal_final():
    """
    Test log_fatal_final.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_fatal_final(  # pylint: disable=too-many-locals
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
        Check that log_fatal_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_fatal_final Tests
################################################################################

################################################################################
#region log_error Tests

#===============================================================================
class Test_log_error():
    """
    Test log_error.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="args_empty",
            ),
        ],
    )
    def test_log_error(  # pylint: disable=too-many-locals
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
        Check that log_error returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_error Tests
################################################################################

################################################################################
#region log_error_final Tests

#===============================================================================
class Test_log_error_final():
    """
    Test log_error_final.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="args_empty",
            ),
        ],
    )
    def test_log_error_final(  # pylint: disable=too-many-locals
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
        Check that log_error_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_error_final Tests
################################################################################

################################################################################
#region log_warning Tests

#===============================================================================
class Test_log_warning():
    """
    Test log_warning.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
                id="args_empty",
            ),
        ],
    )
    def test_log_warning(  # pylint: disable=too-many-locals
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
        Check that log_warning returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_warning Tests
################################################################################

################################################################################
#region log_warning_final Tests

#===============================================================================
class Test_log_warning_final():
    """
    Test log_warning_final.
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\007\xf0\x9f\x94\x94 \xe2\x9a\xa0\xef\xb8\x8f WARNING: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\007\xf0\x9f\x94\x94 \xe2\x9a\xa0\xef\xb8\x8f WARNING: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1;31m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                    b" \x1b[0;31m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_warning_final(  # pylint: disable=too-many-locals
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
        Check that log_warning_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_warning_final Tests
################################################################################

################################################################################
#region log_header Tests

#===============================================================================
class Test_log_header():
    """
    Test log_header.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;4;36masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;4;36mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_header(  # pylint: disable=too-many-locals
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
        Check that log_header returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_header Tests
################################################################################

################################################################################
#region log_footer Tests

#===============================================================================
class Test_log_footer():
    """
    Test log_footer.
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;36masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;36mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_footer(  # pylint: disable=too-many-locals
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
        Check that log_footer returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_footer Tests
################################################################################

################################################################################
#region log_info_important Tests

#===============================================================================
class Test_log_info_important():
    """
    Test log_info_important.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;33mINFO: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33mINFO: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_info_important(  # pylint: disable=too-many-locals
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
        Check that log_info_important returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_info_important Tests
################################################################################

################################################################################
#region log_info Tests

#===============================================================================
class Test_log_info():
    """
    Test log_info.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mINFO: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mINFO: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_info(  # pylint: disable=too-many-locals
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
        Check that log_info returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_info Tests
################################################################################

################################################################################
#region log_info_no_prefix Tests

#===============================================================================
class Test_log_info_no_prefix():
    """
    Test log_info_no_prefix.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_info_no_prefix(  # pylint: disable=too-many-locals
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
        Check that log_info_no_prefix returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_info_no_prefix Tests
################################################################################

################################################################################
#region log_debug Tests

#===============================================================================
class Test_log_debug():
    """
    Test log_debug.
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;37mDEBUG: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;37mDEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_debug(  # pylint: disable=too-many-locals
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
        Check that log_debug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_debug Tests
################################################################################

################################################################################
#region log_superdebug Tests

#===============================================================================
class Test_log_superdebug():
    """
    Test log_superdebug.
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;30mSUPERDEBUG: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;30mSUPERDEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_superdebug(  # pylint: disable=too-many-locals
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
        Check that log_superdebug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_superdebug Tests
################################################################################

################################################################################
#region log_ultradebug Tests

#===============================================================================
class Test_log_ultradebug():
    """
    Test log_ultradebug.
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;35mULTRADEBUG: asdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;35mULTRADEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_ultradebug(  # pylint: disable=too-many-locals
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
        Check that log_ultradebug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
        )

#endregion log_ultradebug Tests
################################################################################

################################################################################
#region log_file Tests

#===============================================================================
class Test_log_file():
    """
    Test log_file.
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;35masdf\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="no_format_directives",
            ),
            pytest_param(
                [
                    "%s%d", "qwerty", 42,
                ],
                0,
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;35mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
                ],
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
                    b" \x1b[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_empty",
            ),
        ],
    )
    def test_log_file(  # pylint: disable=too-many-locals
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
        Check that log_file returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

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

        assert p.returncode == expected_ret

        check_log_data(
            expected_stdout=expected_stdout,
            expected_stderr=expected_stderr,
            expected_not_stdout=expected_not_stdout,
            expected_not_stderr=expected_not_stderr,
            stdout=p.stdout,
            stderr=p.stderr,
            is_file_only=True,
        )

#endregion log_file Tests
################################################################################
