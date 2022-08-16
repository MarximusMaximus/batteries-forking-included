#! false
# pylint: disable=duplicate-code
"""
tests/PytestShellTestHarness (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os import (
    mkdir                           as os_mkdir,
)
from os.path import (
    abspath                         as os_path_abspath,
)

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

from .PytestShellTestHarness import PytestShellTestHarness

#endregion ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Fixtures

#-------------------------------------------------------------------------------
@pytest.fixture(name="shell_test_harness")
def shell_test_harness(
    mock_repo: str,  # pylint: disable=redefined-outer-name
    request: pytest_FixtureRequest,
) -> "PytestShellTestHarness":
    """
    Fixture wrapper for PytestShellTestHarness.

    Returns:
        PytestShellTestHarness: PytestShellTestHarness instance.
    """
    return PytestShellTestHarness(
        mock_repo=mock_repo,
        request=request,
    )

#---------------------------------------------------------------------------
@pytest.fixture
def mock_repo(
    monkeypatch: pytest_MonkeyPatch,
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

    mock_repo_fullpath = "template_project"
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

    return mock_repo_fullpath


#endregion Fixtures
################################################################################
