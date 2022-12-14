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

        invoke ./activate.sh "$@"
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

        ensure_include_GXY ./activate.sh "$@"
        script_ret=$?

        assert [ "${CONDA_SHLVL}" -ge 1 ] \
            "CONDA_SHLVL >= 1 (was {$CONDA_SHLVL})"
        assert [ "${CONDA_DEFAULT_ENV}" = "batteries-forking-included" ] \
            "CONDA_DEFAULT_ENV = 'batteries-forking-included' (was '${CONDA_DEFAULT_ENV}')"

        exit $script_ret
    )
    return $?
}

#endregion Test_Source
#===============================================================================

#endregion Tests
################################################################################
