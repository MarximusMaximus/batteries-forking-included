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
#region get_ansi_code Tests

#===============================================================================
class Test_get_ansi_code():
    """
    Test get_ansi_code.
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__terminal_regular(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__terminal_mono(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__terminal_mono__colorized_output_alt(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__tput_colors_8(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__tput_colors_8__colorized_output_alt(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__tput_colors_16(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__tput_colors_256(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__NO_COLOR_empty(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__NO_COLOR_nonempty(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__NO_COLOR_nonempty__colorized_output_alt(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__colorized_output_empty(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__colorized_output_true(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[foom\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[barm\n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[barm\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;foom\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;barm\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;barm\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__colorized_output_alt(
        self,
        additional_args: List[Union[str, int]],
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
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="no_args",
            ),
            pytest_param(
                [
                    "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty",
            ),
            pytest_param(
                [
                    "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_empty_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo",
            ),
            pytest_param(
                [
                    "", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty",
            ),
            pytest_param(
                [
                    "", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_empty_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \n",  # cspell:disable-line
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
                id="args_empty_foo_bar_empty",
            ),
            pytest_param(
                [
                    "", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_bar_A",
            ),
            pytest_param(
                [
                    "", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
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
                id="args_empty_foo_empty_A",
            ),
            pytest_param(
                [
                    "0",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0",
            ),
            pytest_param(
                [
                    "0", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty",
            ),
            pytest_param(
                [
                    "0", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty",
            ),
            pytest_param(
                [
                    "0", "", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_empty_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo",
            ),
            pytest_param(
                [
                    "0", "foo", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_empty_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0m\n",  # cspell:disable-line
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
                id="args_0_foo_bar_empty",
            ),
            pytest_param(
                [
                    "0", "foo", "bar", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_bar_A",
            ),
            pytest_param(
                [
                    "0", "foo", "", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[0;fooA\n",  # cspell:disable-line
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
                id="args_0_foo_empty_A",
            ),
        ],
    )
    def test_get_ansi_code__colorized_output_false(
        self,
        additional_args: List[Union[str, int]],
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

#endregion get_ansi_code Tests
################################################################################
