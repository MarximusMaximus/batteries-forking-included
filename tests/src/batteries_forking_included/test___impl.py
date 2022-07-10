"""
tests/src/batteries_forking_included/test___impl.py (batteries-forking-included)
"""

################################################################################
#region Imports

#===============================================================================
#region stdlib

from io import (
    TextIOWrapper                   as io_TextIOWrapper,
)
from os.path import (
    join                            as os_path_join,
)
from subprocess import (
    run                             as subprocess_run,
)
from typing import (
    Any,
    Callable,
    Dict,
    List,
    Optional,
    Union,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

from pytest import (
    mark                            as pytest_mark,
    MonkeyPatch                     as pytest_MonkeyPatch,
    Pytester                        as pytest_Pytester,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from batteries_forking_included import (
    __impl                          as MODULE_UNDER_TEST,
)

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region Helper Functions

def coerceSubprocessCommandToString(
    *args: List[Any],
    **kwargs: Dict[str, Any],
) -> Union[str, None]:  # pragma: no cover
    """
    Coerce a subprocess's call into a str.

    Returns:
        Union[str, None]: The subprocess's command as a str if exists, or None.
    """
    cmd = None
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
    elif cmd is not None:
        cmd_str = str(cmd)

    return cmd_str


#endregion Helper Functions
################################################################################

################################################################################
#region __main Tests

class Test___main():
    """
    Tests loading the test suite.
    """

    #-------------------------------------------------------------------------------
    def test___main(self) -> None:
        """
        Tests that the library cannot be invoked directly.
        """
        ret = getattr(MODULE_UNDER_TEST, "__main")([])  # noqa: B009
        assert ret != 0

    #-------------------------------------------------------------------------------
    def test___main__shell_invocation(self) -> None:
        """
        Tests that the library cannot be invoked directly.
        """
        cmd = [
            "python",
            "./src/batteries_forking_included/__impl.py",
        ]

        p = subprocess_run(cmd, capture_output=True)

        assert p.returncode == 1
        assert b"This module should not be run directly." in p.stderr

#endregion Tests
################################################################################

################################################################################
#region bfiSubcommand Tests

#===============================================================================
class Test_bfiSubcommand:
    """
    Test bfi subcommand functions.
    """

    '''
    def bfi*(
        extras: Optional[List[str]],
    ) -> int:
    '''

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize("expected_ret", [0, 1])
    @pytest_mark.parametrize(
        "input_args",
        [
            None,
            [],
            ["oneArg"],
            ["oneArg", "twoArg"],
        ],
    )
    @pytest_mark.parametrize(
        "script_name,func",
        [
            ("bootstrap.sh", MODULE_UNDER_TEST.bfiBootstrap),
            ("bfi-update.sh", MODULE_UNDER_TEST.bfiInit),
            ("run.sh", MODULE_UNDER_TEST.bfiRun),
            ("bfi-update.sh", MODULE_UNDER_TEST.bfiUpdate),
        ],
    )
    def test_bfiSubcommand(
        self,
        monkeypatch: pytest_MonkeyPatch,
        script_name: str,
        func: Callable[[Optional[List[str]]], int],
        input_args: Union[List[str], None],
        expected_ret: int,
    ) -> None:
        """
        _summary_
        """
        def mock_subprocess_call(
            *args: List[Any],
            **kwargs: Dict[str, Any],
        ) -> int:
            expected_cmd = [script_name]
            if input_args:
                expected_cmd = expected_cmd + input_args
            expected_cmd_str = " ".join(expected_cmd)

            cmd_str = coerceSubprocessCommandToString(*args, **kwargs)

            assert cmd_str is not None
            assert expected_cmd_str in cmd_str

            if func == MODULE_UNDER_TEST.bfiInit:  # pylint: disable=comparison-with-callable  # noqa: E501,B950
                assert "--project-dir" in cmd_str

            return expected_ret

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "subprocess_call",
            mock_subprocess_call,
        )

        ret = None
        if input_args is None:
            ret = func()  # type: ignore[call-arg]
        else:
            ret = func(input_args)

        assert ret == expected_ret


#endregion bfiSubcommand
################################################################################

################################################################################
#region get_version_number

#===============================================================================
class Test_getVersionNumber():
    """
    Test getVersionNumber function.
    """

    '''
    def getVersionNumber() -> str:
    '''

    #---------------------------------------------------------------------------
    def test_getVersionNumber_importlib(
        self,
        monkeypatch: pytest_MonkeyPatch,
    ) -> None:
        """
        Test getVersionNumber via importlib.
        """

        monkeypatch.delenv("BFI_VERSION", raising=False)

        ret = MODULE_UNDER_TEST.getVersionNumber()

        assert ret != ""
        assert ret != "UNKNOWN"

    #---------------------------------------------------------------------------
    def test_getVersionNumber_pyproject_toml(
        self,
        monkeypatch: pytest_MonkeyPatch,
        pytester: pytest_Pytester,
    ) -> None:
        """
        Test getVersionNumber via pyproject.toml.
        """
        import importlib.metadata  # pylint: disable=import-outside-toplevel

        mock_repo_path = pytester.copy_example(
            os_path_join(
                MODULE_UNDER_TEST.MY_DIR_FULLPATH,
                "template",
            ),
        )
        pytester.makepyprojecttoml("""\
            name = "template"
            version = "0.0.0"
            description = "A template project."
        """)
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "MY_REPO_FULLPATH",
            mock_repo_path,
        )

        def mock_importlib_metadata_version(_: str) -> str:
            raise importlib.metadata.PackageNotFoundError
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "importlib_metadata_version",
            mock_importlib_metadata_version,
        )

        monkeypatch.delenv("BFI_VERSION", raising=False)

        ret = MODULE_UNDER_TEST.getVersionNumber()

        assert ret != ""
        assert ret != "UNKNOWN"
        assert ret == "0.0.0"

    #---------------------------------------------------------------------------
    def test_getVersionNumber_UNKNOWN(
        self,
        monkeypatch: pytest_MonkeyPatch,
        pytester: pytest_Pytester,
    ) -> None:
        """
        Test getVersionNumber via pyproject.toml.
        """
        import importlib.metadata  # pylint: disable=import-outside-toplevel

        mock_repo_path = pytester.copy_example(
            os_path_join(
                MODULE_UNDER_TEST.MY_DIR_FULLPATH,
                "template",
            ),
        )
        pytester.makepyprojecttoml("""\
            name = "template"
            version = "0.0.0"
            description = "A template project."
        """)
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "MY_REPO_FULLPATH",
            mock_repo_path,
        )

        def mock_importlib_metadata_version(_: str) -> str:
            raise importlib.metadata.PackageNotFoundError
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "importlib_metadata_version",
            mock_importlib_metadata_version,
        )

        def mock_open(f: str, mode: str) -> io_TextIOWrapper:  # pragma: no cover
            raise Exception
        # create something that monkeypatch can override
        MODULE_UNDER_TEST.open = lambda f, m: __builtins__.open(f, m)  # type: ignore[attr-defined]  # pragma: no cover  # noqa: E501,B950
        monkeypatch.setattr(MODULE_UNDER_TEST, "open", mock_open)

        monkeypatch.delenv("BFI_VERSION", raising=False)

        ret = MODULE_UNDER_TEST.getVersionNumber()

        assert ret != ""
        assert ret == "UNKNOWN"

    #---------------------------------------------------------------------------
    def test_getVersionNumber_BFI_VERSION(
        self,
        monkeypatch: pytest_MonkeyPatch,
        pytester: pytest_Pytester,
    ) -> None:
        """
        Test getVersionNumber via pyproject.toml.
        """
        import importlib.metadata  # pylint: disable=import-outside-toplevel

        mock_repo_path = pytester.copy_example(
            os_path_join(
                MODULE_UNDER_TEST.MY_DIR_FULLPATH,
                "template",
            ),
        )
        pytester.makepyprojecttoml("""\
            name = "template"
            version = "0.0.0"
            description = "A template project."
        """)
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "MY_REPO_FULLPATH",
            mock_repo_path,
        )

        def mock_importlib_metadata_version(_: str) -> str:
            raise importlib.metadata.PackageNotFoundError
        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "importlib_metadata_version",
            mock_importlib_metadata_version,
        )

        def mock_open(f: str, mode: str) -> io_TextIOWrapper:  # pragma: no cover
            raise Exception
        # create something that monkeypatch can override
        MODULE_UNDER_TEST.open = lambda f, mode: __builtins__.open(f, mode)  # type: ignore[attr-defined]  # pragma: no cover  # noqa: E501,B950
        monkeypatch.setattr(MODULE_UNDER_TEST, "open", mock_open)

        monkeypatch.setenv("BFI_VERSION", "x.y.z")

        ret = MODULE_UNDER_TEST.getVersionNumber()

        assert ret != ""
        assert ret == "x.y.z"

#endregion get_version_number
################################################################################

################################################################################
#region _bfiExecute

class Test__bfiExecute:
    """
    Test _bfiExecute function.
    """

    '''
    def _bfiExecute(
        script: str,
        extras: Union[List[str], None] = None,
    ) -> int:
    '''

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize("expected_ret", [0, 1])
    @pytest_mark.parametrize(
        "input_args",
        [
            None,
            [],
            ["oneArg"],
            ["oneArg", "twoArg"],
        ],
    )
    def test__bfiExecute(
        self,
        monkeypatch: pytest_MonkeyPatch,
        input_args: Union[List[str], None],
        expected_ret: int,
    ) -> None:
        """
        Test _bfiExecute with no args that returns 0.
        """
        def mock_subprocess_call(
            *args: List[Any],
            **kwargs: Dict[str, Any],
        ) -> int:
            expected_cmd = ["script.sh"]
            if input_args:
                expected_cmd = expected_cmd + input_args
            expected_cmd_str = " ".join(expected_cmd)

            cmd_str = coerceSubprocessCommandToString(*args, **kwargs)

            assert cmd_str is not None
            assert expected_cmd_str in cmd_str
            return expected_ret

        monkeypatch.setattr(
            MODULE_UNDER_TEST,
            "subprocess_call",
            mock_subprocess_call,
        )

        ret = None
        if input_args is None:
            ret = MODULE_UNDER_TEST._bfiExecute(script="script.sh")  # pylint: disable=protected-access  # noqa: E501,B950
        else:
            ret = MODULE_UNDER_TEST._bfiExecute(script="script.sh", extras=input_args)  # pylint: disable=protected-access  # noqa: E501,B950

        assert ret == expected_ret

#endregion _bfiExecute
################################################################################
