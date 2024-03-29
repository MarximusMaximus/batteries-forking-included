#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/activate_sh/test_shell.py (batteries-forking-included)
"""  # noqa: E501,W505

################################################################################
#region Imports

#===============================================================================
#region third party

from pytest import (
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
#region Invoke Tests

#===============================================================================
class Test_Invoke():
    """
    Invoke via command line.
    """

    #---------------------------------------------------------------------------
    def test_Invoke(
        self,
        shell_script_test_harness: PytestShellScriptTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Invoke.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_script_test_harness.run()

        assert p.returncode == 151
        assert (
            b"ULTRADEBUG: WAS_SOURCED:\n" +
            b"__array__WAS_SOURCED__index__0=false\n" +
            b"__array__WAS_SOURCED__index__1=false\n" +
            b"__array__WAS_SOURCED__length=2\n"
        ) in p.stdout
        assert b"FATAL: activate.sh should not be invoked, only sourced" in p.stderr

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

        assert p.returncode == 0
        assert (
            b"ULTRADEBUG: WAS_SOURCED:\n" +
            b"__array__WAS_SOURCED__index__0=false\n" +
            b"__array__WAS_SOURCED__index__1=true\n" +
            b"__array__WAS_SOURCED__length=2\n"
        ) in p.stdout

#endregion Source Tests
################################################################################
