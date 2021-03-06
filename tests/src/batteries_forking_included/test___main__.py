"""
tests/src/batteries_forking_included/test___main__.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    environ                         as os_environ,
)
from os.path import (
    abspath                         as os_path_abspath,
    expanduser                      as os_path_expanduser,
    join                            as os_path_join,
    relpath                         as os_path_relpath,
)
from subprocess import (
    run                             as subprocess_run,
)
from typing import (
    Any,
    List,
    Dict,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

from pytest import (
    mark                            as pytest_mark,
    MonkeyPatch                     as pytest_MonkeyPatch,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from batteries_forking_included import (
    __main__                          as MODULE_UNDER_TEST,
)

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Command Line Tests

class Test_CommandLine():
    """
    Invoke via command line.
    """

    #-------------------------------------------------------------------------------
    def test_CommandLine_Version_FromRepoRoot(self) -> None:
        """
        Invoke from repo root.
        """
        cwd = MODULE_UNDER_TEST.MY_REPO_FULLPATH

        script_path = os_path_join(
            ".",
            os_path_relpath(MODULE_UNDER_TEST.MY_DIR_FULLPATH, cwd),
            "__main__.py",
        )

        cmd = [
            "python",
            script_path,
            "--version",
        ]

        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=cwd, env=env)

        assert p.returncode == 0

    #-------------------------------------------------------------------------------
    def test_CommandLine_Version_FromSrc(self) -> None:
        """
        Invoked from src dir.
        """
        cwd = os_path_abspath(os_path_join(MODULE_UNDER_TEST.MY_DIR_FULLPATH, ".."))
        script_path = os_path_join(
            ".",
            os_path_relpath(MODULE_UNDER_TEST.MY_DIR_FULLPATH, cwd),
            "__main__.py",
        )

        cmd = [
            "python",
            script_path,
            "--version",
        ]

        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=cwd, env=env)

        assert p.returncode == 0

    #-------------------------------------------------------------------------------
    def test_CommandLine_Version_FromSrcMod(self) -> None:
        """
        Invoked from it's own dir.
        """
        cwd = MODULE_UNDER_TEST.MY_DIR_FULLPATH

        cmd = [
            "python",
            "./__main__.py",
            "--version",
        ]

        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=cwd, env=env)

        assert p.returncode == 0

    #-------------------------------------------------------------------------------
    def test_CommandLine_Version_FromHome(self) -> None:
        """
        Invoked from home dir.
        """
        cwd = os_path_expanduser("~")

        script_path = os_path_join(
            MODULE_UNDER_TEST.MY_DIR_FULLPATH,
            "__main__.py",
        )

        cmd = [
            "python",
            script_path,
            "--version",
        ]

        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=cwd, env=env)

        assert p.returncode == 0

    #-------------------------------------------------------------------------------
    def test_CommandLine_RunEchoFoo_FromRepoRoot(
        self,
        make_mock_repo: str,
    ) -> None:  # pylint: disable: R0801
        """
        Invoke from repo root.
        """
        script_path = os_path_join(
            ".",
            "src",
            "batteries_forking_included",
            "__main__.py",
        )

        cmd = [
            "python",
            script_path,
            "run",
            "echo",
            "foo",
        ]

        env: Dict[str, Any] = {
            "OMEGA_DEBUG": "true",
        }
        for k, v in os_environ.items():
            env[k] = v

        p = subprocess_run(cmd, capture_output=True, cwd=make_mock_repo, env=env)

        assert p.returncode == 0

#endregion Tests
################################################################################

################################################################################
#region __main Tests

#===============================================================================
class Test___main():
    """
    _summary_
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        "extra_args,expected_ret,func_to_mock",
        [
            [
                ["bootstrap"],
                0,
                "batteries_forking_included_bfiBootstrap",
            ],
            [
                ["bootstrap", "--project-dir=/some/fake/dir"],
                0,
                "batteries_forking_included_bfiBootstrap",
            ],
            [
                ["init"],
                0,
                "batteries_forking_included_bfiInit",
            ],
            [
                ["init", "--project-dir=/some/fake/dir"],
                0,
                "batteries_forking_included_bfiInit",
            ],
            [
                ["update"],
                0,
                "batteries_forking_included_bfiUpdate",
            ],
            [
                ["update", "--project-dir=/some/fake/dir"],
                0,
                "batteries_forking_included_bfiUpdate",
            ],
            [
                ["run"],
                0,
                "batteries_forking_included_bfiRun",
            ],
            [
                ["run",  "--project-dir=/some/fake/dir"],
                0,
                "batteries_forking_included_bfiRun",
            ],
            [
                ["run", "echo", "foo"],
                0,
                "batteries_forking_included_bfiRun",
            ],
        ],
    )
    def test___main(
        self,
        monkeypatch: pytest_MonkeyPatch,
        extra_args: List[str],
        expected_ret: int,
        func_to_mock: str,
    ) -> None:
        """
        _summary_
        """
        def mock_func(
            extras: List[str],
            *args: List[Any],
            **kwargs: Dict[str, Any],
        ) -> int:
            # ignore unused vars in function signature
            args = args
            kwargs = kwargs

            expected_extras = extra_args[1:]
            assert extras == expected_extras

            return expected_ret

        monkeypatch.setattr(MODULE_UNDER_TEST, func_to_mock, mock_func)

        __main = getattr(MODULE_UNDER_TEST, "__main")  # noqa: B009
        try:
            ret = __main(extra_args)
        except SystemExit as e:  # pragma: no cover
            ret = e.code
            pass

        assert ret == expected_ret

#endregion __main Tests
################################################################################
