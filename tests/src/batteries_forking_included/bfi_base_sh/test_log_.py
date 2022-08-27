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
#region Ours

from ....PytestShellTestHarness import PytestShellTestHarness

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Helper Functions

#-------------------------------------------------------------------------------
def get_data_for_log(log_filepath: str) -> bytes:
    """
    Get data for log file.

    Args:
        log_filepath (str): fullpath to log file

    Returns:
        bytes: data of log file
    """
    log_file = None
    try:
        log_file = open(log_filepath, "rb")  # pylint: disable=consider-using-with  # noqa: E501,B950
        log_data = log_file.read()
    finally:
        if log_file:
            log_file.close()

    return log_data

#-------------------------------------------------------------------------------
def check_log_data(  # pylint: disable=too-many-locals  # noqa: C901
    expected_stdout: List[bytes],
    expected_stderr: List[bytes],
    expected_not_stdout: List[bytes],
    expected_not_stderr: List[bytes],
    stdout: bytes,
    stderr: bytes,
    is_fatal: bool = False,
    is_error: bool = False,
    is_warning: bool = False,
    is_console_only: bool = False,
    is_file_only: bool = False,
) -> None:
    """
    Check logs for expected and not expected bytes.

    Args:
        expected_stdout (List[bytes]): list of bytes expected in stdout (and
            full log)
        expected_stderr (List[bytes]): list of bytes expected in stderr (and
            appropriate fatal/error/warning logs)
        expected_not_stdout (List[bytes]): list of bytes expected NOT in stdout
        expected_not_stderr (List[bytes]): list of bytes expected NOT in stderr
            (and NOT in inappropriate fatal/error/warning logs)
        stdout (bytes): stdout bytes from process
        stderr (bytes): stderr bytes from process
        is_fatal (bool, optional): is a fatal log; defaults to False.
        is_error (bool, optional): is an error log; defaults to False.
        is_warning (bool, optional): is a warning log; defaults to False.
        is_console_only (bool, optional): is a console only log; defaults to False.
        is_file_only (bool, optional): is a file only log; defaults to False.
    """
    full_log_filepath = os_path_abspath("log/log.txt")
    error_and_fatal_log_filepath = os_path_abspath("log/errors_and_fatals_only.txt")
    fatal_log_filepath = os_path_abspath("log/fatal_only.txt")
    error_log_filepath = os_path_abspath("log/errors_only.txt")
    warning_log_filepath = os_path_abspath("log/warnings_only.txt")

    full_log_data = get_data_for_log(full_log_filepath)
    error_and_fatal_log_data = get_data_for_log(error_and_fatal_log_filepath)
    fatal_log_data = get_data_for_log(fatal_log_filepath)
    error_log_data = get_data_for_log(error_log_filepath)
    warning_log_data = get_data_for_log(warning_log_filepath)

    for x in expected_stdout:
        if not is_file_only:
            assert x in stdout
        if not is_console_only:
            assert x in full_log_data

        if x:  # pragma: no branch
            if not is_file_only:
                assert x not in stderr
            if not is_console_only:
                assert x not in error_and_fatal_log_data
                assert x not in fatal_log_data
                assert x not in error_log_data
                assert x not in warning_log_data
    for x in expected_stderr:
        if not is_file_only:
            assert x in stderr
        if not is_console_only:
            assert x in full_log_data
            if is_fatal or is_error:
                assert x in error_and_fatal_log_data
            if is_fatal:
                assert x in fatal_log_data
            if is_error:
                assert x in error_log_data
            if is_warning:
                assert x in warning_log_data
        if x:  # pragma: no branch
            if not is_file_only:
                assert x not in stdout
            if not is_console_only:
                if not is_fatal and not is_error:
                    assert x not in error_and_fatal_log_data
                if not is_fatal:
                    assert x not in fatal_log_data
                if not is_error:
                    assert x not in error_log_data
                if not is_warning:
                    assert x not in warning_log_data
    for x in expected_not_stdout:
        if not is_file_only:
            assert x not in stdout
        # cannot ensure these strings wouldn't be in stderr
        # cannot assert against full log (b/c it is both stdout and stderr)
        # cannot ensure that these strings wouldn't be in error logs
    for x in expected_not_stderr:
        # cannot ensure these strings wouldn't be in stdout
        if not is_file_only:
            assert x not in stderr
        # cannot assert against full log (b/c it is both stdout and stderr)
        if not is_console_only:
            assert x not in error_and_fatal_log_data
            assert x not in fatal_log_data
            assert x not in error_log_data
            assert x not in warning_log_data

#endregion Helper Functions
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_console(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_console returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;32mSUCCESS: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_success(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_success returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;32m\007\xf0\x9f\x94\x94 \xe2\x9c\x85 SUCCESS: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_success_final(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_success_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_fatal(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_fatal returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_fatal=True,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;31m\007\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_fatal_final(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_fatal_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_fatal=True,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_error(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_error returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_error=True,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[0;31m\007\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_error_final(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_error_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_error=True,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\xe2\x9a\xa0\xef\xb8\x8f WARNING: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_warning(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_warning returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_warning=True,
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
                    b"",
                ],
                [
                    b"YYYY-mm-dd HH:MM:SS \033[1;33m\007\xf0\x9f\x94\x94 \xe2\x9a\xa0\xef\xb8\x8f WARNING: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_warning_final(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_warning_final returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
            is_warning=True,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;4;36mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_header(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_header returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;36mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_footer(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_footer returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;33mINFO: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_info_important(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_info_important returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mINFO: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_info(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_info returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;37mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_info_no_prefix(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_info_no_prefix returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;37mDEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_debug(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_debug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[1;30mSUPERDEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_superdebug(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_superdebug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;35mULTRADEBUG: qwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_ultradebug(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_ultradebug returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
                    b"YYYY-mm-dd HH:MM:SS \033[0;35mqwerty42\033[0m\n",  # cspell:disable-line  # noqa: E501,B950
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
    def test_log_file(  # pylint: disable=too-many-locals
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
        r"""
        Check that log_file returns properly based on args and environment
            vars.
        """
        monkeypatch.delenv("CI", raising=False)

        tempdir_path = os_path_abspath("")

        p = shell_test_harness.run(
            additional_args=additional_args,
            additional_env_vars={
                "my_tempdir": tempdir_path,
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
