#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region format_log_message Tests

#-------------------------------------------------------------------------------
def; Test_format_log_message__test_format_log_message() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch

            def; date() {
                printf "YYYY-mm-dd HH:MM:SS"
            }

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

        output="$(format_log_message "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion format_log_message Tests
#===============================================================================

#endregion Tests
################################################################################

################################################################################
#region PytestShellScriptTestHarness Postamble

func_to_call="$1"
shift
(
    "${func_to_call}" "$@"
    ret=$?
    exit $ret
)
ret=$?
exit $ret

#endregion PytestShellScriptTestHarness Postamble
################################################################################
