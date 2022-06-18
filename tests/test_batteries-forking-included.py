"""
tests/test_batteries-forking-included.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

# import sys
from filecmp import (
    cmp                             as filecmp_cmp,
)
from os import (
    listdir                         as os_listdir,
)
from os.path import (
    abspath                         as os_path_abspath,
)
from typing import (
    Any,
)

#endregion stdlib
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Types

PytestFixture = Any

#endregion Types
################################################################################

################################################################################
#region Constants

TEMPLATE_DIR = "src/batteries_forking_included/template"
REPO_ROOT_DIR = "."

#endregion Constants
################################################################################

################################################################################
#region Tests


#-------------------------------------------------------------------------------
def test___main() -> None:
    """
    test___main: simple test to confirm this subpackage of tests loads
    """

    assert True


#-------------------------------------------------------------------------------
def test_files_match() -> None:
    """
    test_files_matches: test if files in repo root and src/bfi/template match
    """

    for file in os_listdir(TEMPLATE_DIR):
        # TODO: split file into sections, compare sections
        if file == "post-bootstrap.sh":
            continue

        template_file = os_path_abspath(f"{TEMPLATE_DIR}/{file}")
        repo_file = os_path_abspath(f"{REPO_ROOT_DIR}/{file}")

        cmp_ret = filecmp_cmp(template_file, repo_file)
        assert cmp_ret, f"files do not match: {template_file} != {repo_file}"


#-------------------------------------------------------------------------------
