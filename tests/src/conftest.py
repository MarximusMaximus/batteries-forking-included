#! false
# pylint: disable=duplicate-code
"""
tests/conftest.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    mkdir                           as os_mkdir,
    symlink                         as os_symlink,
)
from os.path import (
    abspath                         as os_path_abspath,
    dirname                         as os_path_dirname,
    exists                          as os_path_exists,
    join                            as os_path_join,
)
from shutil import (
    copy2                           as shutil_copy2,
    copytree                        as shutil_copytree,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

import pytest
from pytest import (
    FixtureRequest                  as pytest_FixtureRequest,
    MonkeyPatch                     as pytest_MonkeyPatch,
    TempPathFactory                 as pytest_TempPathFactory,
)

#endregion third party
#===============================================================================

#===============================================================================
#region ours

import batteries_forking_included

#endregion ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Fixtures

#---------------------------------------------------------------------------
@pytest.fixture
def mock_repo(
    monkeypatch: pytest_MonkeyPatch,
    request: pytest_FixtureRequest,
    tmp_path_factory: pytest_TempPathFactory,
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
    tempdir = tmp_path_factory.mktemp("test-temp", numbered=True)
    monkeypatch.chdir(tempdir)

    mock_repo_fullpath = "batteries-forking-included"
    mock_repo_fullpath = os_path_abspath(mock_repo_fullpath)

    os_mkdir(mock_repo_fullpath)
    monkeypatch.chdir(mock_repo_fullpath)

    # write a pyproject.toml for the mock repo
    with open("pyproject.toml", "w", encoding="utf-8") as f:
        _ = f.write("""\
                name = "template_project"
                version = "0.0.0"
                description = "A template project."
            """)
        f.flush()

    bfi_src_mod_fullpath = os_path_dirname(batteries_forking_included.__file__)

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

    # copy test_source.sh into mock repo
    shell_harness_path = os_path_join(
        request.node.fspath.dirname,
        f"{request.node.fspath.purebasename}.sh",
    )
    if os_path_exists(shell_harness_path):
        shutil_copy2(
            shell_harness_path,
            mock_repo_fullpath,
        )

    return mock_repo_fullpath

#endregion Fixtures
################################################################################
