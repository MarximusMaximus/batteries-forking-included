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
#region ours (external)

from pytest_shell_script_test_harness import PytestShellScriptTestHarness

#endregion ours (external)
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
                [],
                151,  # RET_ERROR_SCRIPT_WAS_NOT_SOURCED
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=false\n" +
                        b"__array__WAS_SOURCED__length=2\n"
                    ),
                ],
                [
                    b"FATAL: post-bootstrap.sh must be sourced\n",
                ],
                [
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

        assert p.returncode == 0
        assert (
            b"ULTRADEBUG: WAS_SOURCED:\n" +
            b"__array__WAS_SOURCED__index__0=false\n" +
            b"__array__WAS_SOURCED__index__1=true\n" +
            b"__array__WAS_SOURCED__length=2\n"
        ) in p.stdout

#endregion Source Tests
################################################################################

################################################################################
#region post_bootstrap Tests

#===============================================================================
class Test_post_bootstrap():
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
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
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
                id="args_None",
            ),
            pytest_param(
                [],
                0,
                [
                    (
                        b"ULTRADEBUG: WAS_SOURCED:\n" +
                        b"__array__WAS_SOURCED__index__0=false\n" +
                        b"__array__WAS_SOURCED__index__1=true\n" +
                        b"__array__WAS_SOURCED__length=2\n"
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
                id="args_empty_list",
            ),
        ],
    )
    def test_post_bootstrap(
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
        Call __main, with batteries_forking_included__update monkeypatched
        to just print 'batteries_forking_included__update called (args)\n'.
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

#endregion post_bootstrap Tests
################################################################################
