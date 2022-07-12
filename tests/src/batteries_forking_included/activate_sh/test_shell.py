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
#region Ours

from ....PytestShellTestHarness import PytestShellTestHarness

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
    def test_Invoke(
        self,
        shell_test_harness: PytestShellTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Invoke.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_test_harness.run()

        assert p.returncode == 151
        assert b"ULTRADEBUG: WAS_SOURCED: false\tfalse\n" in p.stdout
        assert b"FATAL: activate.sh should not be invoked, only sourced" in p.stderr

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
        shell_test_harness: PytestShellTestHarness,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Source.
        """
        monkeypatch.delenv("_IS_UNDER_TEST", raising=False)

        p = shell_test_harness.run()

        assert p.returncode == 0
        assert b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n" in p.stdout

#endregion Source Tests
################################################################################
