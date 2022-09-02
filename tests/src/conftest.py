#! false
# pylint: disable=duplicate-code
"""
tests/conftest.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    mkdir                           as os_mkdir,
    symlink                         as os_symlink,
)
from os.path import (
    abspath                         as os_path_abspath,
    dirname                         as os_path_dirname,
    exists                          as os_path_exists,
    join                            as os_path_join,
)
from shutil import (
    copy2                           as shutil_copy2,
    copytree                        as shutil_copytree,
)
from typing import (
    List,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

import pytest
from pytest import (
    FixtureRequest                  as pytest_FixtureRequest,
    MonkeyPatch                     as pytest_MonkeyPatch,
    TempPathFactory                 as pytest_TempPathFactory,
)

#endregion third party
#===============================================================================

#===============================================================================
#region ours

import batteries_forking_included

#endregion ours
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
        if log_file:  # pragma: no branch
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
            if not is_console_only:  # pragma: no branch
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
#region Fixtures

#-------------------------------------------------------------------------------
@pytest.fixture
def mock_repo(
    monkeypatch: pytest_MonkeyPatch,
    request: pytest_FixtureRequest,
    tmp_path_factory: pytest_TempPathFactory,
) -> str:
    """
    Create a mock repo to use that looks like a repo that uses
        batteries_forking_include, but named batteries_forking_included so we
        can re-use the already available conda environment.

    Args:
        monkeypatch (pytest_MonkeyPatch): pytest monkeypatch fixture
        tmp_path_factory (pytest_TempPathFactory): pytest tmp_path_factory fixture

    Returns:
        str: path of mock repo
    """
    tempdir = tmp_path_factory.mktemp("test-temp", numbered=True)
    monkeypatch.chdir(tempdir)

    mock_repo_fullpath = "batteries-forking-included"
    mock_repo_fullpath = os_path_abspath(mock_repo_fullpath)

    os_mkdir(mock_repo_fullpath)
    monkeypatch.chdir(mock_repo_fullpath)

    # write a pyproject.toml for the mock repo
    with open("pyproject.toml", "w", encoding="utf-8") as f:
        _ = f.write("""\
                name = "template_project"
                version = "0.0.0"
                description = "A template project."
            """)
        f.flush()

    bfi_src_mod_fullpath = os_path_dirname(batteries_forking_included.__file__)

    # copy template (.sh files) into root of mock repo
    bfi_template_fullpath = os_path_join(
        bfi_src_mod_fullpath,
        "template",
    )
    shutil_copytree(
        bfi_template_fullpath,
        mock_repo_fullpath,
        dirs_exist_ok=True,
    )

    # copy src/** from bfi into mock repo
    mock_src_mod_fullpath = os_path_join(
        mock_repo_fullpath,
        "src",
        "batteries_forking_included",
    )
    shutil_copytree(
        bfi_src_mod_fullpath,
        mock_src_mod_fullpath,
        dirs_exist_ok=True,
    )

    # copy bin/** from bfi into mock repo
    mock_bin_fullpath = os_path_join(
        mock_repo_fullpath,
        "bin",
    )
    os_mkdir(mock_bin_fullpath)
    os_symlink(
        os_path_join(
            mock_src_mod_fullpath,
            "bin",
            "batteries-forking-included.py",
        ),
        os_path_join(
            mock_bin_fullpath,
            "batteries-forking-included.py",
        ),
    )

    # copy test_source.sh into mock repo
    shell_harness_path = os_path_join(
        request.node.fspath.dirname,
        f"{request.node.fspath.purebasename}.sh",
    )
    if os_path_exists(shell_harness_path):
        shutil_copy2(
            shell_harness_path,
            mock_repo_fullpath,
        )

    return mock_repo_fullpath

#endregion Fixtures
################################################################################
