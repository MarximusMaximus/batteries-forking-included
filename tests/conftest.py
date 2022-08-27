#! false
# pylint: disable=duplicate-code
"""
tests/conftest.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from math import (
    floor                           as math_floor,
)
from os import (
    environ                         as os_environ,
)
from typing import (
    Sequence,
    Union,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region Third Party

from psutil import (  # type: ignore[import]
    cpu_count                       as psutil_cpu_count,
)

#endregion Third Party
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Hooks

def pytest_xdist_auto_num_workers() -> int:
    """
    Limit number of auto cores to use, so that we don't overload the system.

    Returns:
        int: Number of cores to use.
    """
    physical_cores = psutil_cpu_count(logical=False)
    usable_cores = math_floor(physical_cores * 0.6)
    return usable_cores


#endregion Hooks
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
