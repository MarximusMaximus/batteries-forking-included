#!/usr/bin/env sh

################################################################################
#region Tests

#===============================================================================
#region Test_Invoke

#-------------------------------------------------------------------------------
def; Test_Invoke__test_Invoke() {
    (
        def; inject_monkeypatch() { true; }

        if [ "${CONDA_EXE}" != "" ]; then
            # shellcheck disable=SC1091
            . "$( dirname "${CONDA_EXE}" )"/../etc/profile.d/conda.sh
            conda activate .
        fi

        assert [ "${CONDA_DEFAULT_ENV}" != "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV != 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        chmod +x ./bfi-base.sh
        invoke ./bfi-base.sh "$@"
        script_ret=$?
        chmod -x ./bfi-base.sh

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

        include_G ./bfi-base.sh
        script_ret=$?

        exit $script_ret
    )
    return $?
}

#endregion Test_Source
#===============================================================================

#===============================================================================
#region Test_Fence

#-------------------------------------------------------------------------------
def; Test_Fence__test_Fence() {
    (
        type BATTERIES_FORKING_INCLUDED_BASE_FENCE >/dev/null 2>&1
        ret=$?
        if [ $ret -eq 0 ]; then
            exit 2
        fi

        include_G ./bfi-base.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        type BATTERIES_FORKING_INCLUDED_BASE_FENCE >/dev/null 2>&1
        ret=$?
        if [ $ret -ne 0 ]; then
            exit 3
        fi

        exit 0
    )
    return $?
}

#endregion Test_post_bootstrap
#===============================================================================

#endregion Tests
################################################################################
