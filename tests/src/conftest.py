#! false
# pylint: disable=duplicate-code
"""
tests/conftest.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os.path import (
    dirname                         as os_path_dirname,
    join                            as os_path_join,
)
from shutil import (
    copytree                        as shutil_copytree,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

import pytest
# from pytest import (
#     FixtureRequest                  as pytest_FixtureRequest,
#     MonkeyPatch                     as pytest_MonkeyPatch,
#     TempPathFactory                 as pytest_TempPathFactory,
# )

#endregion third party
#===============================================================================

#===============================================================================
#region ours (internal)

import batteries_forking_included

#endregion ours (internal)
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Fixtures

@pytest.fixture(scope="class")
def class_fixture() -> str:
    return "class_fixture"

#-------------------------------------------------------------------------------
@pytest.fixture
def mock_repo(
    mock_repo: str,  # pylint: disable=redefined-outer-name
    # monkeypatch: pytest_MonkeyPatch,
    # request: pytest_FixtureRequest,
    # tmp_path_factory: pytest_TempPathFactory,
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
    mock_repo_fullpath = mock_repo

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

    return mock_repo_fullpath

#endregion Fixtures
################################################################################
