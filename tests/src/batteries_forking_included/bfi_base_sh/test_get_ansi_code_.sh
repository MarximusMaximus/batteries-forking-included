#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region Test_get_ansi_code_cursor

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__regular_terminal() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__mono_terminal() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=ansi-mono
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__tput_colors_8() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "8\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__tput_colors_16() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "16\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__tput_colors_256() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__NO_COLOR_empty() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__NO_COLOR_nonempty() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR="NO_COLOR"
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__colorized_output_empty() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=""
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__colorized_output_true() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=true
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__colorized_output_alt() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output="alt"
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor__test_get_ansi_code_cursor__colorized_output_false() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; tput() {
                if [ "$1" = "colors" ]; then
                    command printf "256\n"
                else
                    command tput "$@"
                fi
            }
        }

        TERM=xterm-256color
        export TERM
        NO_COLOR=""
        export NO_COLOR
        colorized_output=false
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_up

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_up__test_get_ansi_code_cursor_up() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" 'A'
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_up "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_up
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_down

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_down__test_get_ansi_code_cursor_down() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_down "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_down
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_right

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_right__test_get_ansi_code_cursor_right() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_right "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_right
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_left

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_left__test_get_ansi_code_cursor_left() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_left "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_left
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_nextline

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_nextline__test_get_ansi_code_cursor_nextline() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_nextline "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_nextline
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_prevline

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_prevline__test_get_ansi_code_cursor_prevline() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_prevline "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_prevline
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_col

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_col__test_get_ansi_code_cursor_col() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_col "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_col
#===============================================================================

#===============================================================================
#region Test_get_ansi_code_cursor_pos

#-------------------------------------------------------------------------------
def; Test_get_ansi_code_cursor_pos__test_get_ansi_code_cursor_pos() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; get_ansi_code_cursor() {
                command echo get_ansi_code_cursor "$1" "$2"
            }
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code_cursor_pos "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code_cursor_pos
#===============================================================================

#endregion Tests
################################################################################
