"""
tests/conftest.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

import os
from typing import (
    Sequence,
    Union,
)

#endregion stdlib
#===============================================================================

#endregion Imports
################################################################################

pytest_plugins: Union[str, Sequence[str]] = ["pytester"]

os.environ["PY_IGNORE_IMPORTMISMATCH"] = "1"
