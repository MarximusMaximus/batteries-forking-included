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
    cpu_count                       as os_cpu_count,
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
    physical_cores = os_cpu_count()
    if physical_cores is None:  # pragma: no cover
        physical_cores = 1
    usable_cores = math_floor(physical_cores * 0.5)
    usable_cores = max(1, usable_cores)
    return usable_cores


#endregion Hooks
################################################################################

################################################################################
#region Immediate

pytest_plugins: Union[str, Sequence[str]] = [
    "pytester",
]

os_environ["_IS_UNDER_TEST"] = "true"

#endregion Immediate
################################################################################
