"""
tests/test_batteries_forking_included.py (batteries-forking-included)
"""
# pylint: disable=R0801
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
    dirname                         as os_path_dirname,
    join                            as os_path_join,
    relpath                         as os_path_relpath,
)
from typing import (
    Any,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region Ours


#endregion Ours
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
MY_DIR = os_path_dirname(__file__)
REPO_ROOT_DIR = os_path_abspath(".")
TESTS_DIR = os_path_join(REPO_ROOT_DIR, "tests")
REL_DIR_TO_TEST = os_path_relpath(MY_DIR, TESTS_DIR)
DIR_TO_TEST = os_path_join(REPO_ROOT_DIR, REL_DIR_TO_TEST)

#endregion Constants
################################################################################

################################################################################
#region Tests

#-------------------------------------------------------------------------------
def test_files_match__general() -> None:
    """
    Test if files in repo root and src/bfi/template match (not post_bootstrap.sh).
    """

    for file in os_listdir(TEMPLATE_DIR):
        # post_bootstrap.sh requires special handling, we do this later
        if file == "post-bootstrap.sh":
            continue

        template_path = os_path_abspath(f"{TEMPLATE_DIR}/{file}")
        repo_path = os_path_abspath(f"{DIR_TO_TEST}/{file}")

        cmp_ret = filecmp_cmp(template_path, repo_path)
        assert cmp_ret, f"files do not match: {template_path} != {repo_path}"


#-------------------------------------------------------------------------------
def test_files_match__post_bootstrap(tmp_path: PytestFixture) -> None:
    """
    Test if post_bootstrap.sh in repo root and src/bfi/template match.
    """
    template_path = os_path_abspath(f"{TEMPLATE_DIR}/post-bootstrap.sh")
    repo_path = os_path_abspath(f"{DIR_TO_TEST}/post-bootstrap.sh")

    combined_template_path = os_path_abspath(os_path_join(tmp_path, "post-bootstrap.sh"))

    part1_data = []
    part2_data = []
    part3_data = []

    with open(template_path, "r", encoding="utf-8") as f:
        template_data = f.readlines()

    with open(repo_path, "r", encoding="utf-8") as f:
        repo_data = f.readlines()

    in_part = "part1"
    for line in template_data:
        if line == "    # WARNING: DO NOT EDIT ABOVE THIS LINE\n":
            in_part = "part2"
        if line == "    # WARNING: DO NOT EDIT BELOW THIS LINE\n":
            in_part = "part3"

        if in_part == "part1":
            part1_data.append(line)
        if in_part == "part3":
            part3_data.append(line)

    in_part = "part1"
    for line in repo_data:
        if line == "    # WARNING: DO NOT EDIT ABOVE THIS LINE\n":
            in_part = "part2"
        if line == "    # WARNING: DO NOT EDIT BELOW THIS LINE\n":
            in_part = "part3"

        if in_part == "part2":
            part2_data.append(line)

    with open(combined_template_path, "w", encoding="utf-8") as f:
        f.writelines(part1_data)
        f.writelines(part2_data)
        f.writelines(part3_data)
        f.flush()

    cmp_ret = filecmp_cmp(combined_template_path, repo_path)
    assert cmp_ret, f"files do not match: {template_path} != {repo_path}"

#endregion Tests
################################################################################
