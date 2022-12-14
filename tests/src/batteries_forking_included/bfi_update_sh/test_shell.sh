#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region Test_Invoke

#-------------------------------------------------------------------------------
def; Test_Invoke__test_Invoke() {
    (
        if [ "${CONDA_EXE}" != "" ]; then
            # shellcheck disable=SC1091
            . "$( dirname "${CONDA_EXE}" )"/../etc/profile.d/conda.sh
            conda activate .
        fi

        assert [ "${CONDA_DEFAULT_ENV}" != "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV != 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        def; inject_monkeypatch() { true; }

        invoke ./bfi-update.sh "$@"
        script_ret=$?

        assert [ "${CONDA_DEFAULT_ENV}" != "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV != 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        exit $script_ret
    )
    return $?
}

#endregion Test_Invoke
#===============================================================================

#===============================================================================
#region Test_Source

#-------------------------------------------------------------------------------
def; Test_Source__test_Source() {
    (
        def; inject_monkeypatch() { true; }

        if [ "${CONDA_EXE}" != "" ]; then
            # shellcheck disable=SC1091
            . "$( dirname "${CONDA_EXE}" )"/../etc/profile.d/conda.sh
            conda activate .
        fi

        assert [ "${CONDA_DEFAULT_ENV}" != "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV != 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        include_G ./bfi-update.sh "$@"
        script_ret=$?

        assert [ "${CONDA_DEFAULT_ENV}" != "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV != 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        exit $script_ret
    )
    return $?
}

#endregion Test_Source
#===============================================================================

#===============================================================================
#region Test___main

#-------------------------------------------------------------------------------
def; Test___main__test___main_monkeyPatched() {
    (
        def; inject_monkeypatch() {
            echo monkeypatch
            def; batteries_forking_included__update() {
                printf "batteries_forking_included__update called %s\n" "$*"
                exit 0
            }
        }

        _CALL_MAIN_ANYWAY=true
        export _CALL_MAIN_ANYWAY

        include_G ./bfi-update.sh "$@"
        script_ret=$?

        exit $script_ret
    )
    return $?
}

#endregion Test___main
#===============================================================================

#endregion Tests
################################################################################
