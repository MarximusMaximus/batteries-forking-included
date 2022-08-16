#! false
# pylint: disable=duplicate-code
"""
tests/src/batteries_forking_included/bfi_base_sh/test_get_ansi_code_.py (batteries-forking-included)
"""  # noqa: E501,W505,B950

################################################################################
#region Imports

#===============================================================================
#region stdlib

from typing import (
    List,
    Union,
)

#endregion stdlib
#===============================================================================

#===============================================================================
#region third party

from pytest import (
    mark                            as pytest_mark,
    param                           as pytest_param,
)

#endregion third party
#===============================================================================

#===============================================================================
#region Ours

from ....PytestShellTestHarness import PytestShellTestHarness

#endregion Ours
#===============================================================================

#endregion Imports
################################################################################

################################################################################
#region get_ansi_code_cursor Tests

#===============================================================================
class Test_get_ansi_code_cursor():
    """
    Test get_ansi_code_cursor.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__regular_terminal(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__mono_terminal(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__tput_colors_8(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__tput_colors_16(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__tput_colors_256(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__NO_COLOR_empty(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__NO_COLOR_nonempty(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__colorized_output_empty(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__colorized_output_true(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__colorized_output_alt(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "A",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A",
            ),
            pytest_param(
                [
                    "foo", "A", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: \033[fooA\n",  # cspell:disable-line
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_A_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor__colorized_output_false(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_up Tests

#===============================================================================
class Test_get_ansi_code_cursor_up():
    """
    Test get_ansi_code_cursor_up.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo A\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo A\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_up(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_up Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_down Tests

#===============================================================================
class Test_get_ansi_code_cursor_down():
    """
    Test get_ansi_code_cursor_down.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo B\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo B\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_down(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_down Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_right Tests

#===============================================================================
class Test_get_ansi_code_cursor_right():
    """
    Test get_ansi_code_cursor_right.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo C\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo C\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_right(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_right Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_left Tests

#===============================================================================
class Test_get_ansi_code_cursor_left():
    """
    Test get_ansi_code_cursor_left.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo D\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo D\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_left(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_left Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_nextline Tests

#===============================================================================
class Test_get_ansi_code_cursor_nextline():
    """
    Test get_ansi_code_cursor_nextline.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo E\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo E\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_nextline(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_nextline Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_prevline Tests

#===============================================================================
class Test_get_ansi_code_cursor_prevline():
    """
    Test get_ansi_code_cursor_prevline.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo F\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo F\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_prevline(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_prevline Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_col Tests

#===============================================================================
class Test_get_ansi_code_cursor_col():
    """
    Test get_ansi_code_cursor_col.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo G\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo",
            ),
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo G\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_col(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_col Tests
################################################################################

################################################################################
#region get_ansi_code_cursor_pos Tests

#===============================================================================
class Test_get_ansi_code_cursor_pos():
    """
    Test get_ansi_code_cursor_pos.
    """

    #---------------------------------------------------------------------------
    @pytest_mark.parametrize(
        (
            "additional_args," +
            "expected_ret," +
            "expected_stdout," +
            "expected_stderr," +
            "expected_not_stdout," +
            "expected_not_stderr"
        ),
        [
            pytest_param(
                [
                    "foo", "bar",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo;bar H\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
            pytest_param(
                [
                    "foo", "bar", "baz",
                ],
                0,
                [
                    b"ULTRADEBUG: WAS_SOURCED: false\ttrue\n",
                    b"PytestShellTestHarness: get_ansi_code_cursor foo;bar H\n",  # cspell:disable-line # noqa: E501,B950
                ],
                [
                    b"",
                ],
                [
                    b"Error:",
                ],
                [
                    b"Error:",
                ],
                id="args_foo_bar",
            ),
        ],
    )
    def test_get_ansi_code_cursor_pos(
        self,
        additional_args: Union[List[str], None],
        expected_ret: int,
        expected_stdout: List[bytes],
        expected_stderr: List[bytes],
        expected_not_stdout: List[bytes],
        expected_not_stderr: List[bytes],
        shell_test_harness: PytestShellTestHarness,
    ) -> None:
        r"""
        Check that get_ansi_code returns properly based on args and environment
            vars.
        """
        p = shell_test_harness.run(
            additional_args=additional_args,
        )

        assert p.returncode == expected_ret
        for x in expected_stdout:
            assert x in p.stdout
        for x in expected_stderr:
            assert x in p.stderr
        for x in expected_not_stdout:
            assert x not in p.stdout
        for x in expected_not_stderr:
            assert x not in p.stderr

#endregion get_ansi_code_cursor_pos Tests
################################################################################
