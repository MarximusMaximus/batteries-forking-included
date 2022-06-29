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
    environ                         as os_environ,
    listdir                         as os_listdir,
)
from os.path import (
    abspath                         as os_path_abspath,
    join                            as os_path_join,
)
from subprocess import (
    run                             as subprocess_run,
)
from typing import (
    Any,
    Dict,
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
REPO_ROOT_DIR = "."

#endregion Constants
################################################################################

################################################################################
#region Tests


#-------------------------------------------------------------------------------
def test___main() -> None:
    """
    Simple test to confirm this subpackage of tests loads.
    """

    assert True


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
        repo_path = os_path_abspath(f"{REPO_ROOT_DIR}/{file}")

        cmp_ret = filecmp_cmp(template_path, repo_path)
        assert cmp_ret, f"files do not match: {template_path} != {repo_path}"


#-------------------------------------------------------------------------------
def test_files_match__post_bootstrap(tmp_path: PytestFixture) -> None:
    """
    Test if post_bootstrap.sh in repo root and src/bfi/template match.
    """
    template_path = os_path_abspath(f"{TEMPLATE_DIR}/post-bootstrap.sh")
    repo_path = os_path_abspath(f"{REPO_ROOT_DIR}/post-bootstrap.sh")

    combined_template_path = os_path_abspath(os_path_join(tmp_path, "post-bootstrap.sh"))

    part1_data = []
    part2_data = []
    part3_data = []

    f = open(template_path, "r", encoding="utf-8")
    template_data = f.readlines()
    f.close()

    f = open(repo_path, "r", encoding="utf-8")
    repo_data = f.readlines()
    f.close()

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

    f = open(combined_template_path, "w", encoding="utf-8")
    f.writelines(part1_data)
    f.writelines(part2_data)
    f.writelines(part3_data)
    f.flush()
    f.close()

    cmp_ret = filecmp_cmp(combined_template_path, repo_path)
    assert cmp_ret, f"files do not match: {template_path} != {repo_path}"


#-------------------------------------------------------------------------------
def test_call_bfi__no_args() -> None:
    """
    _summary_
    """
    cmd = ["python", "./bin/batteries-forking-included.py"]
    env: Dict[str, Any] = {
        "OMEGA_DEBUG": "true",
    }
    for k, v in os_environ.items():
        env[k] = v
    p = subprocess_run(cmd, capture_output=True, env=env)

    assert p.returncode == 2
    assert b"Error: SUBCOMMAND required." in p.stdout


#-------------------------------------------------------------------------------
def test_call_bfi__help() -> None:
    """
    _summary_
    """
    cmd = ["python", "./bin/batteries-forking-included.py", "--help"]
    env: Dict[str, Any] = {
        "OMEGA_DEBUG": "true",
    }
    for k, v in os_environ.items():
        env[k] = v
    p = subprocess_run(cmd, capture_output=True, env=env)

    assert p.returncode == 0
    assert b"usage:" in p.stdout

#endregion Tests
################################################################################
