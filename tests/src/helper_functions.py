#! false
# pylint: disable=duplicate-code
"""
tests/helper_functions.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os.path import (
    abspath                         as os_path_abspath,
)
from typing import (
    List,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party


#endregion third party
#===============================================================================

#===============================================================================
#region ours (internal)


#endregion ours (internal)
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
    is_console_only: bool = False,
    is_file_only: bool = False,
    only_check_full_log: bool = False,
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
        is_console_only (bool, optional): is a console only log; defaults to False.
        is_file_only (bool, optional): is a file only log; defaults to False.
        only_check_full_log (bool, optional): if we should only check against the
            full log and not others; defaults to False
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
            if not is_console_only and not only_check_full_log:
                assert x not in error_and_fatal_log_data
                assert x not in fatal_log_data
                assert x not in error_log_data
                assert x not in warning_log_data

    for x in expected_stderr:
        if not is_file_only:
            assert x in stderr
        if not is_console_only:
            assert x in full_log_data
            if not only_check_full_log:  # pragma: no branch
                if b"FATAL:" in x or b"ERROR:" in x:
                    assert x in error_and_fatal_log_data
                if b"FATAL:" in x:
                    assert x in fatal_log_data
                if b"ERROR:" in x:
                    assert x in error_log_data
                if b"WARNING: " in x:
                    assert x in warning_log_data
        if x:  # pragma: no branch
            if not is_file_only:
                assert x not in stdout
            # not checking is_console_only b/c
            # fatal/error/warning can never be console only
            if not only_check_full_log:  # pragma: no branch
                if b"FATAL:" not in x and b"ERROR:" not in x:
                    assert x not in error_and_fatal_log_data
                if b"FATAL:" not in x:
                    assert x not in fatal_log_data
                if b"ERROR:" not in x:
                    assert x not in error_log_data
                if b"WARNING: " not in x:
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
        if not is_console_only and not only_check_full_log:
            assert x not in error_and_fatal_log_data
            assert x not in fatal_log_data
            assert x not in error_log_data
            assert x not in warning_log_data

#endregion Helper Functions
################################################################################
