#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region Test_get_ansi_code

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__terminal_regular() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__terminal_mono() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__terminal_mono__colorized_output_alt() {
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
        colorized_output="alt"
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__tput_colors_8() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__tput_colors_8__colorized_output_alt() {
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
        colorized_output="alt"
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__tput_colors_16() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__tput_colors_256() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__NO_COLOR_empty() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__NO_COLOR_nonempty() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__NO_COLOR_nonempty__colorized_output_alt() {
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
        colorized_output="alt"
        export colorized_output

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__colorized_output_empty() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__colorized_output_true() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__colorized_output_alt() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#-------------------------------------------------------------------------------
def; Test_get_ansi_code__test_get_ansi_code__colorized_output_false() {
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

        output="$(get_ansi_code "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_get_ansi_code
#===============================================================================

#endregion Tests
################################################################################
