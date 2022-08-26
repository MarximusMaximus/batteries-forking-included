#! false
# pylint: disable=duplicate-code
"""
tests/PytestShellTestHarness/test_PytestShellTestHarness.py (batteries-forking-included)
"""

# NOTE: we cannot use the shell_test_harness fixture in this file, we must
#   create the PytestShellTestHarness object manually

################################################################################
#region Imports

#===============================================================================
#region stdlib

from os.path import (
    join                            as os_path_join,
)
from platform import (
    python_version                  as platform_python_version,
    uname_result                    as platform_uname_result,
)
from shutil import (
    copy2                           as shutil_copy2,
)
from typing import (
    Any,
    Dict,
    List,
    Optional,
    Union,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

from packaging import (
    version                         as packaging_version,
)
import pytest  # required to use pytest.fixture which cannot be aliased via 'as'
from pytest import (
    FixtureRequest                  as pytest_FixtureRequest,
    mark                            as pytest_mark,
    MonkeyPatch                     as pytest_MonkeyPatch,
    param                           as pytest_param,
    raises                          as pytest_raises,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from .. import (
    PytestShellTestHarness          as MODULE_UNDER_TEST,
)
from ..PytestShellTestHarness import (
    PytestShellTestHarness          as PytestShellTestHarness_PytestShellTestHarness,  # noqa: E501,B950
)

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Fixtures

@pytest.fixture
def mock_repo(
    mock_repo: str,  # pylint: disable=redefined-outer-name
    request: pytest_FixtureRequest,
) -> str:
    """
    Create a mock repo to use that looks like a repo that uses
        batteries_forking_include, but named batteries_forking_included so we
        can re-use the already available conda environment.

    Args:
        monkeypatch (pytest_MonkeyPatch): pytest monkeypatch fixture
        request (pytest_FixtureRequest): pytest request fixture

    Returns:
        str: path of mock repo
    """
    example_shell_script_path = os_path_join(
        request.node.fspath.dirname,
        "example_shell_script.sh",
    )

    shutil_copy2(
        example_shell_script_path,
        mock_repo,
    )

    return mock_repo

#endregion Fixtures
################################################################################

################################################################################
#region Helper Functions

def coerceSubprocessCommandToString(
    *args: Any,
    **kwargs: Any,
) -> Union[str, None]:  # pragma: no cover
    """
    Coerce a subprocess's call into a str.

    Returns:
        Union[str, None]: The subprocess's command as a str if exists, or None.
    """
    cmd: Optional[List[str]] = None
    if (
        len(args) > 0 and
        isinstance(args[0], list)
    ):
        cmd = args[0]
    elif (
        len(kwargs) > 0 and
        "cmd" in kwargs
    ):
        if isinstance(kwargs["cmd"], list):
            cmd = kwargs["cmd"]
        else:
            cmd = [kwargs["cmd"]]

    cmd_str = None
    if isinstance(cmd, list):
        cmd_str = " ".join(cmd)

    return cmd_str


#endregion Helper Functions
################################################################################

################################################################################
#region PytestShellTestHarness::init

class Test_PytestShellTestHarness____init__():
    """
    Tests for PytestShellTestHarness::__init__
    """

    def test_PytestShellTestHarness____init__(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test obj construction & initialization for PytestShellTestHarness.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """

        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        assert obj.mock_repo == mock_repo
        assert obj.request == request

#endregion PytestShellTestHarness::init
################################################################################

################################################################################
#region PytestShellTestHarness::run

#===============================================================================
class Test_PytestShellTestHarness__run():
    """
    Tests for PytestShellTestHarness::run
    """

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__success(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        monkeypatch: pytest_MonkeyPatch,
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run python only during a successful test,
            without calling out to shell.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """

        #.......................................................................
        def mock_subprocess_run(*args: Any, **kwargs: Any) -> object:
            cmd_str = args[0]

            assert \
                (
                    "batteries-forking-included/" +
                    "tests/" +
                    "_PytestShellTestHarness/" +
                    "test_PytestShellTestHarness.sh"
                ) in cmd_str
            assert \
                (
                    "Test_PytestShellTestHarness__run" +
                    "__" +
                    "test_PytestShellTestHarness__run__success" +
                    " " +
                    "echo foo"
                ) in cmd_str

            assert "env" in kwargs
            assert len(kwargs["env"]) > 2
            assert "OMEGA_DEBUG" in kwargs["env"]
            assert kwargs["env"]["OMEGA_DEBUG"] == "all"
            assert "NO_COLOR" in kwargs["env"]
            assert kwargs["env"]["NO_COLOR"] == "true"
            assert "capture_output" in kwargs
            assert kwargs["capture_output"] is True
            assert "shell" in kwargs
            assert kwargs["shell"] is True

            class ReturnObject():
                pass
            o = ReturnObject()
            setattr(o, "returncode", 0)  # noqa: B010
            setattr(o, "stdout", b"foo\n")  # noqa: B010
            setattr(o, "stderr", b"")  # noqa: B010

            return o

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "subprocess_run",
            mock_subprocess_run,
        )

        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__assert(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        monkeypatch: pytest_MonkeyPatch,
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run python only during a failed test,
            without calling out to shell.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """

        #.......................................................................
        def mock_subprocess_run(*args: Any, **kwargs: Any) -> object:
            cmd_str = args[0]

            assert \
                (
                    "batteries-forking-included/" +
                    "tests/" +
                    "_PytestShellTestHarness/" +
                    "test_PytestShellTestHarness.sh"
                ) in cmd_str
            assert \
                (
                    "Test_PytestShellTestHarness__run" +
                    "__" +
                    "test_PytestShellTestHarness__run__assert" +
                    " " +
                    "echo foo"
                ) in cmd_str

            assert "env" in kwargs
            assert len(kwargs["env"]) > 2
            assert "OMEGA_DEBUG" in kwargs["env"]
            assert kwargs["env"]["OMEGA_DEBUG"] == "all"
            assert "NO_COLOR" in kwargs["env"]
            assert kwargs["env"]["NO_COLOR"] == "true"
            assert "capture_output" in kwargs
            assert kwargs["capture_output"] is True
            assert "shell" in kwargs
            assert kwargs["shell"] is True

            class ReturnObject():
                pass
            o = ReturnObject()
            setattr(o, "returncode", 255)  # noqa: B010
            setattr(o, "stdout", b"")  # noqa: B010
            setattr(o, "stderr", b"error: foo")  # noqa: B010

            return o

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "subprocess_run",
            mock_subprocess_run,
        )

        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        err = None
        with pytest_raises(AssertionError):
            try:
                _ = obj.run(["echo", "foo"])
            except Exception as e:
                err = e
                raise

        assert isinstance(err, AssertionError)
        assert err.args[0] == b"error: foo"

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_success(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during a successful test.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_assert_pass(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during a successful test,
            using our shell test harness's assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_assert_fail(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during a failed test,
            using our shell test harness's assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        err = None
        with pytest_raises(AssertionError):
            try:
                _ = obj.run(["echo", "foo"])
            except Exception as e:
                err = e
                raise

        assert isinstance(err, AssertionError)
        assert err.args[0] == b"FATAL: expected: asdf is not empty string"

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___main_invoked(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during invoking a script
            with a __main.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 151  # RET_ERROR_SCRIPT_WAS_NOT_SOURCED
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should be sourced\n"
            in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___main(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __main but setting _CALL_MAIN_ANYWAY.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 151  # RET_ERROR_SCRIPT_WAS_NOT_SOURCED
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should be sourced\n"
            in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___main_overridden(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __main but setting _CALL_MAIN_ANYWAY using default
            monkeypatch.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___main_overridden_custom(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __main but setting _CALL_MAIN_ANYWAY.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: manually overridden __main was called\n"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___sourced_main(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __sourced_main.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 149  # RET_ERROR_SCRIPT_WAS_SOURCED
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___sourced_main_overridden(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __sourced_main using default monkeypatch.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell___sourced_main_overridden_custom(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            with a __sourced_main using custom monkeypatch.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: manually overridden __sourced_main was called"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_public_function(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a public function.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            not in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_public_function_overridden(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a public function that is monkeypatched.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: overridden public_function"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_public_function_overridden_assert_pass(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a public function that is monkeypatched and has a passing
            assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: overridden public_function"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_public_function_overridden_assert_fail(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a public function that is monkeypatched and has a failing
            assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        err = None
        with pytest_raises(AssertionError):
            try:
                _ = obj.run(["echo", "foo"])
            except Exception as e:
                err = e
                raise

        assert isinstance(err, AssertionError)
        assert err.args[0] == b"FATAL: expected: asdf is not empty string"

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_private_function(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a private function.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            not in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_private_function_overridden(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a private function that is monkeypatched.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: overridden private_function"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_private_function_overridden_assert_pass(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a private function that is monkeypatched and has a passing
            assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert (
            b"PytestShellTestHarness: 0 echo foo\n"
            in p.stdout
        )
        assert (
            b"PytestShellTestHarness: overridden private_function"
            in p.stdout
        )
        assert (
            b"ULTRADEBUG: example_shell_script.sh called with 'echo foo'\n"
            not in p.stdout
        )
        assert (
            b"FATAL: example_shell_script.sh should not be sourced\n"
            not in p.stderr
        )

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_private_function_overridden_assert_fail(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell during sourcing a script
            calling a private function that is monkeypatched and has a failing
            assert.

        Args:
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        err = None
        with pytest_raises(AssertionError):
            try:
                _ = obj.run(["echo", "foo"])
            except Exception as e:
                err = e
                raise

        assert isinstance(err, AssertionError)
        assert err.args[0] == b"FATAL: expected: asdf is not empty string"

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_add(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell adding an environment
        variable via monkeypatch.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("TEST_ENV_VAR", "ADDED")

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_overwrite(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell overwriting an environment
        variable via monkeypatch.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("_IS_UNDER_TEST", "alt")

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_remove(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell removing an environment
        variable via monkeypatch.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.delenv("_IS_UNDER_TEST")

        p = obj.run(["echo", "foo"])

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_harness_add(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell adding an environment
        variable via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"TEST_ENV_VAR_2": "ADDED"},
        )

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_harness_overwrite(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell overwriting an environment
        variable via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"_IS_UNDER_TEST": "alt"},
        )

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_harness_remove(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell removing an environment
        variable via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"_IS_UNDER_TEST": None},
        )

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_add_harness_add(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell adding an environment
        variable via monkeypatch and a adding second environment variable via
        harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("TEST_ENV_VAR", "ADDED")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"TEST_ENV_VAR_2": "ADDED"},
        )

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_add_harness_overwrite(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell adding an environment
        variable via monkeypatch and overwriting it via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("TEST_ENV_VAR", "ADDED")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"TEST_ENV_VAR": "OVERWRITTEN"},
        )

        assert p.returncode == 0
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_add_harness_remove(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell adding an environment
        variable via monkeypatch and removing it via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("TEST_ENV_VAR", "ADDED")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"TEST_ENV_VAR": None},
        )

        assert p.returncode == 0
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_overwrite_harness_overwrite(  # noqa: E501,B950
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell overwriting an environment
        variable via monkeypatch and overwriting it via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("_IS_UNDER_TEST", "alt")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"_IS_UNDER_TEST": "alt2"},
        )

        assert p.returncode == 0
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_overwrite_harness_remove(  # noqa: E501,B950
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell overwriting an environment
        variable via monkeypatch and removing it via harness.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.setenv("_IS_UNDER_TEST", "alt")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"_IS_UNDER_TEST": None},
        )

        assert p.returncode == 0
        assert b"error: " not in p.stderr

    #---------------------------------------------------------------------------
    def test_PytestShellTestHarness__run__shell_env_monkeypatch_remove_harness_add(
        self,
        mock_repo: str,  # pylint: disable=redefined-outer-name
        request: pytest_FixtureRequest,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::run with shell removing an environment
        variable via monkeypatch.

        Args:
            request (pytest_FixtureRequest): pytest Request fixture
            monkeypatch (pytest_MonkeyPatch): pytest MonkeyPatch fixture
        """
        obj = PytestShellTestHarness_PytestShellTestHarness(
            mock_repo,
            request=request,
        )

        monkeypatch.delenv("_IS_UNDER_TEST")

        p = obj.run(
            ["echo", "foo"],
            additional_env_vars={"_IS_UNDER_TEST": "alt2"},
        )

        assert p.returncode == 0
        assert b"foo\n" in p.stdout
        assert b"error: " not in p.stderr

#endregion PytestShellTestHarness::run
################################################################################

################################################################################
#region PytestShellTestHarness::isActuallyWindowsFileSystem

class Test_PytestShellTestHarness_isActuallyWindowsFileSystem():
    """
    Test PytestShellTestHarness::isActuallyWindowsFileSystem function.
    """

    @pytest_mark.parametrize(
        (
            "mock_uname_dict," +
            "mock_uname_dict_expected_result"
        ),
        [
            # macOS Apple Silicon
            pytest_param(
                {
                    "system": "Darwin",
                    "node": "my-machine",
                    "release": "21.6.0",
                    "version": (
                        "Darwin Kernel Version 21.6.0: " +
                        "Wed Aug 10 14:28:23 PDT 2022; " +
                        "root:xnu-8020.141.5~2/RELEASE_ARM64_T6000"
                    ),
                    "machine": "arm64",
                },
                False,
                id="macOSAppleSilicon",
            ),
            # macOS Intel
            pytest_param(
                {
                    "system": "Darwin",
                    "node": "my-machine",
                    "release": "11.0.0",
                    "version": (
                        "Darwin Kernel Version 11.0.0 " +
                        "Sat Jun 18 12:56:35 PDT 2011; " +
                        "root:xnu-1699.22.73~1/RELEASE_X86_64"
                    ),
                    "machine": "x86_64",
                },
                False,
                id="macOSIntel",
            ),
            # Linux AMD
            pytest_param(
                {
                    "system": "Linux",
                    "node": "my-machine",
                    "release": "2.6.32-21-generic",
                    "version": (
                        "2.6.32-21-generic #32-Ubuntu SMP " +
                        "Fri Apr 16 08:09:38 UTC 2010"
                    ),
                    "machine": "x86_64",
                },
                False,
                id="LinuxAMD",
            ),
            # Linux Intel
            pytest_param(
                {
                    "system": "Linux",
                    "node": "my-machine",
                    "release": "2.6.18-194.e15PAE",
                    "version": (
                        "2.6.18-194.e15PAE #1 SMP " +
                        "Fri Apr 2 15:37:44 EDT 2010 i686"
                    ),
                    "machine": "i686",
                },
                False,
                id="LinuxIntel",
            ),
            # WSL1 Intel
            pytest_param(
                {
                    "system": "Linux",
                    "node": "my-machine",
                    "release": "4.4.0-19041-Microsoft",
                    "version": (
                        "4.4.0-19041-Microsoft #1-Microsoft " +
                        "Sat Sep 11 14:32:00 PST 2021"
                    ),
                    "machine": "x86_64",
                },
                True,
                id="WSL1Intel",
            ),
            # WSL2 Intel
            pytest_param(
                {
                    "system": "Linux",
                    "node": "my-machine",
                    "release": "2.6.32-21-microsoft-standard-WSL2",
                    "version": (
                        "2.6.32-21-microsoft-standard-WSL2 #1-Microsoft " +
                        "Sat Sep 11 14:32:00 PST 2021"
                    ),
                    "machine": "x86_64",
                },
                True,
                id="WSL2Intel",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "mock_subprocess_return_code," +
            "mock_subprocess_return_code_expected_result"
        ),
        [
            pytest_param(
                0,  # mounts of C:\ exist
                True,
                id="mountRet0",
            ),
            pytest_param(
                1,  # mounts of C:\ do NOT exist
                False,
                id="mountRet1",
            ),
            pytest_param(
                -1,  # there was an Exception
                False,
                id="mountRetNeg1",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "mock_real_platform," +
            "mock_real_platform_expected_result"
        ),
        [
            pytest_param(
                "Linux",
                False,
                id="PlatformLinux",
            ),
            pytest_param(
                "Darwin",
                False,
                id="PlatformDarwin",
            ),
            pytest_param(
                "MINGW64NT",  # "Windows
                True,
                id="PlatformMINGW64NT",
            ),
        ],
    )
    @pytest_mark.parametrize(
        (
            "mock_wsl_distro_name," +
            "mock_wsl_distro_name_expected_result"
        ),
        [
            pytest_param(
                "",
                False,
                id="DistroEmpty",
            ),
            pytest_param(
                "NotEmpty",  # e.g. Ubuntu, Debian, CentOS, etc
                True,
                id="DistroNotEmpty",
            ),
        ],
    )
    def test_PytestShellTestHarness_isActuallyWindowsFileSystem(
        self,
        mock_uname_dict: Dict[str, str],
        mock_uname_dict_expected_result: bool,
        mock_subprocess_return_code: int,
        mock_subprocess_return_code_expected_result: bool,
        mock_real_platform: str,
        mock_real_platform_expected_result: bool,
        mock_wsl_distro_name: str,
        mock_wsl_distro_name_expected_result: bool,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test PytestShellTestHarness::isActuallyWindowsFileSystem when
        """
        # if any of the expected results are True,
        # then the final expected result is also True
        expected_result = (
            mock_uname_dict_expected_result or
            mock_subprocess_return_code_expected_result or
            mock_real_platform_expected_result or
            mock_wsl_distro_name_expected_result
        )

        def mock_platform_uname() -> platform_uname_result:
            if (
                packaging_version.parse(platform_python_version()) <
                packaging_version.parse("3.9")
            ):  # pragma: no cover
                mock_uname_dict["processor"] = "cpu"

            return platform_uname_result(**mock_uname_dict)

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "platform_uname",
            mock_platform_uname,
        )

        def mock_subprocess_call(*args: Any, **kwargs: Any) -> int:
            # silence the "variable not used" complaints in function signature
            args = args  # noqa: F841  # pylint: disable=self-assigning-variable
            kwargs = kwargs  # noqa: F841  # pylint: disable=self-assigning-variable

            if mock_subprocess_return_code == -1:
                raise Exception("generic unit test exception")
            return mock_subprocess_return_code

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "subprocess_call",
            mock_subprocess_call,
        )

        monkeypatch.setenv("REAL_PLATFORM", mock_real_platform)
        monkeypatch.setenv("WSL_DISTRO_NAME", mock_wsl_distro_name)

        res = PytestShellTestHarness_PytestShellTestHarness\
            .isActuallyWindowsFileSystem()

        assert res is expected_result

#endregion PytestShellTestHarness::isActuallyWindowsFileSystem
################################################################################
