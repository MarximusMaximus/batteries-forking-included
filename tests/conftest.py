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
    environ                         as os_environ,
)
from typing import (
    Sequence,
    Union,
)

#endregion stdlib
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Immediate

pytest_plugins: Union[str, Sequence[str]] = [
    "pytester",
    "tests.PytestShellTestHarnessFixture",
]

os_environ["_IS_UNDER_TEST"] = "true"

#endregion Immediate
################################################################################
