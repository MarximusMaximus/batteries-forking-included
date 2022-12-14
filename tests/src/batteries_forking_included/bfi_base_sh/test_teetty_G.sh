#!/usr/bin/env sh

################################################################################
#region Tests

#-------------------------------------------------------------------------------
def; Test_teetty_G__test_teetty_G() {
    (
        def; inject_monkeypatch() {
            default_inject_monkeypatch
        }

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        teetty_G "$@"
        func_ret=$?

        exit $func_ret
    )
    return $?
}

#endregion Tests
################################################################################
