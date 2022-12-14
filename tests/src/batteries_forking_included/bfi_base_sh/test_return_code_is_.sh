#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region Test_return_code_is_error

#-------------------------------------------------------------------------------
def; Test_return_code_is_error__test_return_code_is_error() {
    (
        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(return_code_is_error "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_return_code_is_error
#===============================================================================

#===============================================================================
#region Test_return_code_is_warning

#-------------------------------------------------------------------------------
def; Test_return_code_is_warning__test_return_code_is_warning() {
    (
        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(return_code_is_warning "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_return_code_is_warning
#===============================================================================

#===============================================================================
#region Test_return_code_is_success

#-------------------------------------------------------------------------------
def; Test_return_code_is_success__test_return_code_is_success() {
    (
        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        output="$(return_code_is_success "$@")"
        func_ret=$?

        test_harness_output "${output}"

        exit $func_ret
    )
    return $?
}

#endregion Test_return_code_is_success
#===============================================================================

#endregion Tests
################################################################################
