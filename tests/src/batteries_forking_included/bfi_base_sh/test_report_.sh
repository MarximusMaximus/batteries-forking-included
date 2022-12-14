#!/usr/bin/env sh

################################################################################
#region Helper Functions

def; set_report_files() { true; }

def; do_basic_count_report_test() {
    (
        log_type=$1
        should_print=$2
        shift 2

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

        include_G ./bfi-base.sh
        script_ret=$?
        if [ "${script_ret}" -ne 0 ]; then
            exit $script_ret
        fi

        set_report_files "$@"

        report_"${log_type}" "${should_print}"
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
#region report_errors Tests

#-------------------------------------------------------------------------------
def; Test_report_errors__test_report_errors() {
    def; set_report_files() {
        message=""
        message_count=$1

        i=0
        while [ $i -lt "${message_count}" ]; do
            i=$(( i + 1 ))
            message="${message}YYYY-mm-dd HH:MM:SS ${ANSI_ERROR}error $i${ANSI_RESET}\n"
        done

        command printf -- "$message" >>"${FULL_LOG}"  # must append to this one
        command printf -- "$message" >"${ERROR_AND_FATAL_LOG}"
        command printf -- "$message" >"${ERROR_LOG}"
    }

    do_basic_count_report_test errors "$@"
    return $?
}

#endregion report_errors Tests
#===============================================================================

#===============================================================================
#region report_warnings Tests

#-------------------------------------------------------------------------------
def; Test_report_warnings__test_report_warnings() {
    def; set_report_files() {
        message=""
        message_count=$1

        i=0
        while [ $i -lt "${message_count}" ]; do
            i=$(( i + 1 ))
            message="${message}YYYY-mm-dd HH:MM:SS ${ANSI_WARNING}warning $i${ANSI_RESET}\n"
        done

        command printf -- "$message" >>"${FULL_LOG}"  # must append to this one
        command printf -- "$message" >"${WARNING_LOG}"
    }

    do_basic_count_report_test warnings "$@"
    return $?
}

#endregion report_warnings Tests
#===============================================================================

#===============================================================================
#region report_final_status Tests

#-------------------------------------------------------------------------------
def; Test_report_final_status__test_report_final_status() {
    should_print=$1
    fatal_count=$2
    error_count=$3
    warning_count=$4
    ret_code_pass_through=$5

    def; set_report_files() {
        fatal_count=$1
        error_count=$2
        warning_count=$3

        message=""
        i=0
        while [ $i -lt "${fatal_count}" ]; do
            i=$(( i + 1 ))
            message="${message}YYYY-mm-dd HH:MM:SS ${ANSI_FATAL}fatal $i${ANSI_RESET}\n"
        done
        command printf -- "$message" >>"${FULL_LOG}"  # must append to this one
        command printf -- "$message" >"${ERROR_AND_FATAL_LOG}"
        command printf -- "$message" >"${FATAL_LOG}"

        message=""
        i=0
        while [ $i -lt "${error_count}" ]; do
            i=$(( i + 1 ))
            message="${message}YYYY-mm-dd HH:MM:SS ${ANSI_ERROR}error $i${ANSI_RESET}\n"
        done
        command printf -- "$message" >>"${FULL_LOG}"  # must append to this one
        command printf -- "$message" >>"${ERROR_AND_FATAL_LOG}"  # must append to this one
        command printf -- "$message" >"${ERROR_LOG}"

        message=""
        i=0
        while [ $i -lt "${warning_count}" ]; do
            i=$(( i + 1 ))
            message="${message}YYYY-mm-dd HH:MM:SS ${ANSI_WARNING}warning $i${ANSI_RESET}\n"
        done
        command printf -- "$message" >>"${FULL_LOG}"  # must append to this one
        command printf -- "$message" >"${WARNING_LOG}"
    }

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

    include_G ./bfi-base.sh
    script_ret=$?
    if [ "${script_ret}" -ne 0 ]; then
        exit $script_ret
    fi

    set_report_files "${fatal_count}" "${error_count}" "${warning_count}"

    report_final_status "${ret_code_pass_through}" "${should_print}" "SOME_PROGRAM"
    return $?
}

#endregion report_final_status Tests
#===============================================================================

#===============================================================================
#region report_all Tests

#-------------------------------------------------------------------------------
def; Test_report_all__test_report_all() {
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

        def; report_warnings() { return 0; }
        def; report_errors() { return 0; }
        def; report_final_status() { return "$1"; }
    }

    TERM=xterm-256color
    export TERM
    NO_COLOR=""
    export NO_COLOR
    colorized_output=true
    export colorized_output

    include_G ./bfi-base.sh
    script_ret=$?
    if [ "${script_ret}" -ne 0 ]; then
        exit $script_ret
    fi

    report_all "$@"
    return $?
}

#endregion report_all Tests
#===============================================================================


#endregion Tests
################################################################################
