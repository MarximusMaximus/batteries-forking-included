#!/usr/bin/env sh

################################################################################
#region Helper Functions

def; do_log_test() {
    (
        log_type=$1
        shift

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

        log_"${log_type}" "$@"
        func_ret=$?

        exit $func_ret
    )
    return $?
}

#endregion Helper Functions
################################################################################

################################################################################
#region Tests

#===============================================================================
#region log_console Tests

#-------------------------------------------------------------------------------
def; Test_log_console__test_log_console() {
    do_log_test console "$@"
    return $?
}

#endregion log_console Tests
#===============================================================================


#===============================================================================
#region log_success Tests

#-------------------------------------------------------------------------------
def; Test_log_success__test_log_success() {
    do_log_test success "$@"
    return $?
}

#endregion log_success Tests
#===============================================================================

#===============================================================================
#region log_success_final Tests

#-------------------------------------------------------------------------------
def; Test_log_success_final__test_log_success_final() {
    do_log_test success_final "$@"
    return $?
}

#endregion log_success_final Tests
#===============================================================================

#===============================================================================
#region log_fatal Tests

#-------------------------------------------------------------------------------
def; Test_log_fatal__test_log_fatal() {
    do_log_test fatal "$@"
    return $?
}

#endregion log_fatal Tests
#===============================================================================

#===============================================================================
#region log_fatal_final Tests

#-------------------------------------------------------------------------------
def; Test_log_fatal_final__test_log_fatal_final() {
    do_log_test fatal_final "$@"
    return $?
}

#endregion log_fatal_final Tests
#===============================================================================

#===============================================================================
#region log_error Tests

#-------------------------------------------------------------------------------
def; Test_log_error__test_log_error() {
    do_log_test error "$@"
    return $?
}

#endregion log_error Tests
#===============================================================================

#===============================================================================
#region log_error_final Tests

#-------------------------------------------------------------------------------
def; Test_log_error_final__test_log_error_final() {
    do_log_test error_final "$@"
    return $?
}

#endregion log_error_final Tests
#===============================================================================

#===============================================================================
#region log_warning Tests

#-------------------------------------------------------------------------------
def; Test_log_warning__test_log_warning() {
    do_log_test warning "$@"
    return $?
}

#endregion log_warning Tests
#===============================================================================

#===============================================================================
#region log_warning_final Tests

#-------------------------------------------------------------------------------
def; Test_log_warning_final__test_log_warning_final() {
    do_log_test warning_final "$@"
    return $?
}

#endregion log_warning_final Tests
#===============================================================================

#===============================================================================
#region log_header Tests

#-------------------------------------------------------------------------------
def; Test_log_header__test_log_header() {
    do_log_test header "$@"
    return $?
}

#endregion log_header Tests
#===============================================================================

#===============================================================================
#region log_footer Tests

#-------------------------------------------------------------------------------
def; Test_log_footer__test_log_footer() {
    do_log_test footer "$@"
    return $?
}

#endregion log_footer Tests
#===============================================================================

#===============================================================================
#region log_info_important Tests

#-------------------------------------------------------------------------------
def; Test_log_info_important__test_log_info_important() {
    do_log_test info_important "$@"
    return $?
}

#endregion log_info_important Tests
#===============================================================================

#===============================================================================
#region log_info Tests

#-------------------------------------------------------------------------------
def; Test_log_info__test_log_info() {
    do_log_test info "$@"
    return $?
}

#endregion log_info Tests
#===============================================================================

#===============================================================================
#region log_info_no_prefix Tests

#-------------------------------------------------------------------------------
def; Test_log_info_no_prefix__test_log_info_no_prefix() {
    do_log_test info_no_prefix "$@"
    return $?
}

#endregion log_info_no_prefix Tests
#===============================================================================

#===============================================================================
#region log_debug Tests

#-------------------------------------------------------------------------------
def; Test_log_debug__test_log_debug() {
    do_log_test debug "$@"
    return $?
}

#endregion log_debug Tests
#===============================================================================

#===============================================================================
#region log_superdebug Tests

#-------------------------------------------------------------------------------
def; Test_log_superdebug__test_log_superdebug() {
    do_log_test superdebug "$@"
    return $?
}

#endregion log_superdebug Tests
#===============================================================================

#===============================================================================
#region log_ultradebug Tests

#-------------------------------------------------------------------------------
def; Test_log_ultradebug__test_log_ultradebug() {
    do_log_test ultradebug "$@"
    return $?
}

#endregion log_ultradebug Tests
#===============================================================================

#===============================================================================
#region log_file Tests

#-------------------------------------------------------------------------------
def; Test_log_file__test_log_file() {
    do_log_test file "$@"
    return $?
}

#endregion log_file Tests
#===============================================================================

#endregion Tests
################################################################################
