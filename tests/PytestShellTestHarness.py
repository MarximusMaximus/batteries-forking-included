#! false
# pylint: disable=duplicate-code
"""
tests/PytestShellTestHarness.py (batteries-forking-included)
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
from platform import (
    uname                           as platform_uname,
)
from subprocess import (  # noqa: F401
    call                            as subprocess_call,
    CompletedProcess                as subprocess_CompletedProcess,
    run                             as subprocess_run,
)
from shlex import (
    join                            as shlex_join,
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
        mock_repo: str,
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Initialize.
        """
        super().__init__()
        self.mock_repo = mock_repo
        self.request = request

    #---------------------------------------------------------------------------
    def run(
        self,
        additional_args: Optional[List[str]] = None,
        additional_env_vars: Optional[Dict[str, Optional[str]]] = None,
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
        if additional_env_vars is None:
            additional_env_vars = {}

        mock_repo_fullpath = self.mock_repo

        # path to script file to run
        script_path = os_path_join(
            self.request.node.fspath.dirname,
            f"{self.request.node.fspath.purebasename}.sh",
        )

        # final command line to run
        cmd = [
            script_path,
            f"{self.request.cls.__name__}__{self.request.function.__name__}",  # type: ignore[reportUnknownMemberType]  # noqa: E501,B950
        ]
        cmd.extend(additional_args)
        cmd = [str(x) for x in cmd]

        cmd_str = shlex_join(cmd)

        # pass along our entire environment + OMEGA_DEBUG=all
        env: Dict[str, Any] = {}
        k: str
        v: Optional[str]
        for k, v in os_environ.items():
            env[k] = v
        env["OMEGA_DEBUG"] = "all"
        env["NO_COLOR"] = "true"
        for k, v in additional_env_vars.items():
            if v is not None:
                env[k] = v
            else:
                if k in env:
                    del env[k]

        print(f"Running Command:\n{cmd_str}\n")

        p = subprocess_run(
            cmd_str,
            capture_output=True,
            cwd=mock_repo_fullpath,
            env=env,
            shell=True,  # nosec
        )

        print(f"\nRaw stdout bytes:\n{repr(p.stdout)}\n")
        print(f"\nRaw stderr bytes:\n{repr(p.stderr)}\n")
        print(f"\nstdout:\n{str(p.stdout)}\n")
        print(f"\nstderr:\n{str(p.stderr)}\n")
        print(f"\nReturn Code: {p.returncode}\n")

        if p.returncode == 255:
            raise AssertionError(p.stderr.strip().split(b"\n")[-1])

        return p

    @staticmethod
    def isActuallyWindowsFileSystem() -> bool:
        """
        Check if we are probably actually on Windows.

        Returns:
            bool: true if Windowsy, false if not Windowsy
        """
        if (
            any(
                x in " ".join(platform_uname()).casefold()
                for x in ["microsoft", "wsl"]
            ) or
            os_environ.get("REAL_PLATFORM", "") == "MINGW64NT" or
            os_environ.get("WSL_DISTRO_NAME", "") != ""
        ):
            return True

        # we don't care if this fails b/c if it does,
        # we've got many other problems
        windows_fs = 1  # 1 is False
        try:
            windows_fs = subprocess_call(  # nosec
                "mount | grep -e '[A-Z]:\\\\'",
                shell=True,
            )
        except Exception:  # pylint: disable=broad-except # noqa: E722 # nosec
            pass
        if windows_fs == 0:
            return True

        return False

#endregion Public Classes
################################################################################
