#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/activate_sh/test_shell.py (batteries-forking-included)
"""  # noqa: E501,W505

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
    MonkeyPatch                     as pytest_MonkeyPatch,
    param                           as pytest_param,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours
from pytest_shell_script_test_harness import PytestShellScriptTestHarness

from batteries_forking_included import (
    getVersionNumber                as batteries_forking_included_getVersionNumber,
)

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Invoke Tests

#===============================================================================
class Test_Invoke():
    """
    Invoke via command line.
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
                None,
                2,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env python",
                    b"usage: ./run.sh",
                ],
                [
                    b"Error: SUBCOMMAND required.\n",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                ],
                id="args_None",
            ),
            pytest_param(
                [],
                2,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env python",
                    b"usage: ./run.sh",
                ],
                [
                    b"Error: SUBCOMMAND required.\n",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: ",
                ],
                id="args_emptyList",
            ),
            pytest_param(
                ["echo", "foo"],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    b"Executing: /usr/bin/env echo foo",
                    b"\nfoo\n",
                ],
                [
                    b"",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_echo_foo",
            ),
            pytest_param(
                ["--version"],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n",
                    b"Conda environment is batteries-forking-included\n",
                    (
                        b"\nbatteries-forking-included " +
                        batteries_forking_included_getVersionNumber().encode("utf8")
                    ),
                ],
                [
                    b"",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                [
                    b" \x1b[1m\x07\xf0\x9f\x94\x94 \xf0\x9f\x92\x80 FATAL: "
                    b" \x1b[0m\x07\xf0\x9f\x94\x94 \xe2\x9d\x8c ERROR: ",
                    b" \x1b[1m\xe2\x9a\xa0\xef\xb8\x8f WARNING: ",
                ],
                id="args_version",
            ),
        ],
    )
    def test_Invoke(
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
        """
        Invoke.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

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

#endregion Invoke Tests
################################################################################

################################################################################
#region Source Tests

#===============================================================================
class Test_Source():
    """
    Invoke via command line.
    """

    #---------------------------------------------------------------------------
    def test_Source(
        self,
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Source.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_script_test_harness.run()

        assert p.returncode == 149
        assert b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n" in p.stdout

#endregion Source Tests
################################################################################
