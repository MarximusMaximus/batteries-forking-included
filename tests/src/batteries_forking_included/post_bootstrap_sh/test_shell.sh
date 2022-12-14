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

        invoke ./post-bootstrap.sh "$@"
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

        include_G ./post-bootstrap.sh "$@"
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
#region Test_post_bootstrap

#-------------------------------------------------------------------------------
def; Test_post_bootstrap__test_post_bootstrap() {
    (
        include_G ./post-bootstrap.sh "$@"
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        post_bootstrap
        func_ret=$?

        exit $func_ret
    )
    return $?
}

#endregion Test_post_bootstrap
#===============================================================================

#endregion Tests
################################################################################
