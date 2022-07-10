"""
tests/src/batteries_forking_included/activate_sh/test_shell.py (batteries-forking-included)
"""  # noqa: E501,W505


################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    environ                         as os_environ,
    mkdir                           as os_mkdir,
    symlink                         as os_symlink,
)
from os.path import (
    abspath                         as os_path_abspath,
    basename                        as os_path_basename,
    dirname                         as os_path_dirname,
    join                            as os_path_join,
)
from shutil import (
    copy2                           as shutil_copy2,
    copytree                        as shutil_copytree,
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
#region Helper Functions

def makeMockRepo(
    monkeypatch: Optional[pytest_MonkeyPatch] = None,
    tmp_path_factory: Optional[pytest_TempPathFactory] = None,
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
    # silence complaints about potential None values
    assert monkeypatch is not None
    assert tmp_path_factory is not None

    tempdir = tmp_path_factory.mktemp("test-temp", numbered=True)
    monkeypatch.chdir(tempdir)

    mock_repo_fullpath = "batteries-forking-included"
    mock_repo_fullpath = os_path_abspath(mock_repo_fullpath)

    bfi_src_mod_fullpath = MODULE_UNDER_TEST.MY_DIR_FULLPATH

    os_mkdir(mock_repo_fullpath)
    monkeypatch.chdir(mock_repo_fullpath)

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

    # write a pyproject.toml for the mock repo
    with open("pyproject.toml", "w", encoding="utf-8") as f:
        f.write("""\
                name = "template_project"
                version = "0.0.0"
                description = "A template project."
            """)
        f.flush()

    # copy test_source.sh into mock repo
    shutil_copy2(
        os_path_join(
            os_path_dirname(__file__),
            os_path_basename(__file__).replace(".py", ".sh"),
        ),
        mock_repo_fullpath,
    )

    return mock_repo_fullpath

def callMyShellFunc(
    additional_args: Optional[List[str]] = None,
    monkeypatch: Optional[pytest_MonkeyPatch] = None,  # Optional is a lie
    request: Optional[pytest_FixtureRequest] = None,  # Optional is a lie
    tmp_path_factory: Optional[pytest_TempPathFactory] = None,  # Optional is a lie
) -> "subprocess_CompletedProcess[bytes]":
    """
    Call the matching shell func in .sh file with same name as this .py file.

    Args:
        additional_args (Optional[List[str]], optional): list of args for shell
            function. Defaults to None.
        monkeypatch (pytest_MonkeyPatch): pytest monkeypatch fixture
        request (pytest_FixtureRequest): pytest request fixture
        tmp_path_factory (pytest_TempPathFactory): pytest tmp_path_factory fixture

    Returns:
        subprocess_CompletedProcess[bytes]: process object from subprocess
    """
    # silence complaints about potential None values
    assert monkeypatch is not None
    assert request is not None
    assert tmp_path_factory is not None

    if additional_args is None:
        additional_args = []

    mock_repo_fullpath = makeMockRepo(
        monkeypatch=monkeypatch,
        tmp_path_factory=tmp_path_factory,
    )

    # path to script file to run
    script_path = os_path_join(
        ".",
        os_path_basename(__file__).replace(".py", ".sh"),
    )

    # final command line to run
    cmd = [
        # "sh",
        script_path,
        f"{request.cls.__name__}__{request.function.__name__}",
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

#endregion Helper Functions
################################################################################

################################################################################
#region Invoke Tests

class Test_Invoke():
    """
    Invoke via command line.
    """

    #---------------------------------------------------------------------------
    def test_Invoke(
        self,
        monkeypatch: pytest_MonkeyPatch,
        request: pytest_FixtureRequest,
        tmp_path_factory: pytest_TempPathFactory,
    ) -> None:
        """
        Invoke.
        """
        p = callMyShellFunc(
            monkeypatch=monkeypatch,
            request=request,
            tmp_path_factory=tmp_path_factory,
        )

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
        monkeypatch: pytest_MonkeyPatch,
        request: pytest_FixtureRequest,
        tmp_path_factory: pytest_TempPathFactory,
    ) -> None:
        """
        Source.
        """
        p = callMyShellFunc(
            monkeypatch=monkeypatch,
            request=request,
            tmp_path_factory=tmp_path_factory,
        )

        assert p.returncode == 0
        assert b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n" in p.stdout

#endregion Source Tests
################################################################################
