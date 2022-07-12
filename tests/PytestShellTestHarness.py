"""
tests/PytestShellTestHarness (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    environ                         as os_environ,
)
from os.path import (
    join                            as os_path_join,
)
from subprocess import (  # pylint: disable=unused-import  # noqa: F401
    CompletedProcess                as subprocess_CompletedProcess,
    run                             as subprocess_run,
)
from typing import (
    Any,
    List,
    Dict,
    Optional,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

from pytest import (
    FixtureRequest                  as pytest_FixtureRequest,
    MonkeyPatch                     as pytest_MonkeyPatch,
    TempPathFactory                 as pytest_TempPathFactory,
)

#endregion third party
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Public Classes

#===============================================================================
class PytestShellTestHarness:
    """
    Test Harness for running unit tests against shell scripts.
    """

    #---------------------------------------------------------------------------
    def __init__(
        self,
        make_mock_repo: str,
        monkeypatch: pytest_MonkeyPatch,
        request: pytest_FixtureRequest,
        tmp_path_factory: pytest_TempPathFactory,
    ) -> None:
        """
        Initialize.
        """
        self.make_mock_repo = make_mock_repo
        self.monkeypatch = monkeypatch
        self.request = request
        self.tmp_path_factory = tmp_path_factory

    #---------------------------------------------------------------------------
    def run(
        self,
        additional_args: Optional[List[str]] = None,
    ) -> "subprocess_CompletedProcess[bytes]":
        """
        Call the matching shell func in .sh file with same name as this .py file.

        Args:
            additional_args (Optional[List[str]], optional): list of args for shell
                function. Defaults to None.

        Returns:
            subprocess_CompletedProcess[bytes]: process object from subprocess
        """
        if additional_args is None:
            additional_args = []

        # mock_repo_fullpath = self.makeMockRepo()
        mock_repo_fullpath = self.make_mock_repo

        # path to script file to run
        script_path = os_path_join(
            self.request.node.fspath.dirname,
            f"{self.request.node.fspath.purebasename}.sh",
        )

        # final command line to run
        cmd = [
            # "sh",
            script_path,
            f"{self.request.cls.__name__}__{self.request.function.__name__}",
        ]
        cmd.extend(additional_args)

        # pass along our entire environment + OMEGA_DEBUG=all
        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=mock_repo_fullpath, env=env)

        if p.returncode == 255:
            raise AssertionError(p.stdout.strip().split(b"\n")[-1])

        return p

#endregion Public Classes
################################################################################
