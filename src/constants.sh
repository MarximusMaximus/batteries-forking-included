#!/usr/bin/env sh
# shellcheck disable=SC2034

################################################################################
#region Fence Value

CONDA_BOOTSTRAPPER_CONSTANTS_LOADED=true

#endregion Fence Value
################################################################################

################################################################################
#region Return Codes

RET_SUCCESS=0; export RET_SUCCESS

RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN

# Local Errors 2-63 (61)
# define these in individual scripts

# Local Warnings 64-127 (63)
# define these in individual scripts

# Global Errors 128-191 (63, but 16 are pre-reserved, so really 47)
RET_ERROR_UNKNOWN_128=128; export RET_ERROR_UNKNOWN_128
RET_ERROR_SIGHUP=129 ; export RET_ERROR_SIGHUP  #  SIGHUP  1
RET_ERROR_SIGINT=130 ; export RET_ERROR_SIGINT  #  SIGINT  2
RET_ERROR_SIGQUIT=131; export RET_ERROR_SIGQUIT #  SIGQUIT 3
RET_ERROR_SIGILL=132 ; export RET_ERROR_SIGILL  #  SIGILL  4
RET_ERROR_SIGTRAP=133; export RET_ERROR_SIGTRAP #  SIGTRAP 5
RET_ERROR_SIGABRT=134; export RET_ERROR_SIGABRT #  SIGABRT 6
RET_ERROR_SIG135=135 ; export RET_ERROR_SIG135  #  Uncommon, might be SIGBUS (linux) or SIGEMT (macOS)
RET_ERROR_SIGFPE=136 ; export RET_ERROR_SIGFPE  #  SIGFPE  8
RET_ERROR_SIGKILL=137; export RET_ERROR_SIGKILL #  SIGKILL 9
RET_ERROR_SIG138=138 ; export RET_ERROR_SIG138  #  Uncommon, might be SIGUSR1 (linux) or SIGBUS (macOS)
RET_ERROR_SIGSEGV=139; export RET_ERROR_SIGSEGV #  SIGSEGV 11
RET_ERROR_SIG140=140 ; export RET_ERROR_SIG140  #  Uncommon, might be SIGUSR2 (linux) or SIGSYS (macOS)
RET_ERROR_SIGPIPE=141; export RET_ERROR_SIGPIPE #  SIGPIPE 13
RET_ERROR_SIGALRM=142; export RET_ERROR_SIGALRM #  SIGALRM 14
RET_ERROR_SIGTERM=143; export RET_ERROR_SIGTERM #  SIGTERM 15
# Signals above 16 are less commonly seen,
# listed here for informational purposes:
# Linux:            macOS:
# SIGCHLD   17      SIGURG    16
# SIGCONT   18      SIGSTOP   17
# SIGSTOP   19      SIGTSTP   18
# SIGTSTP   20      SIGCONT   19
# SIGTTIN   21      SIGCHLD   20
# SIGTTOU   22      SIGTTIN   21
# SIGURG    23      SIGTTOU   22
# SIGXCPU   24      SIGIO     23
# SIGXFSZ   25      SIGXCPU   24
# SIGVTALRM 26      SIGXFSZ   25
# SIGPROF   27      SIGVTALRM 26
# SIGWINCH  28      SIGPROF   27
# SIGIO     29      SIGWINCH  28
# SIGPWR    30      SIGINFO   29
# SIGSYS    31      SIGUSR1   30
# SIGRTMIN  34      SIGUSR2   31
RET_ERROR_CONDA_ACTIVATE_FAILED=144; export RET_ERROR_CONDA_ACTIVATE_FAILED
RET_ERROR_CONDA_INSTALL_FAILED=145; export RET_ERROR_CONDA_INSTALL_FAILED
RET_ERROR_PIP_INSTALL_FAILED=146; export RET_ERROR_PIP_INSTALL_FAILED
RET_ERROR_CONDA_DEACTIVATE_FAILED=147; export RET_ERROR_CONDA_DEACTIVATE_FAILED
RET_ERROR_PIP_UNINSTALL_FAILED=148; export RET_ERROR_PIP_UNINSTALL_FAILED
RET_ERROR_SCRIPT_WAS_SOURCED=149; export RET_ERROR_SCRIPT_WAS_SOURCED
RET_ERROR_USER_IS_ROOT=150; export RET_ERROR_USER_IS_ROOT
RET_ERROR_SCRIPT_WAS_NOT_SOURCED=151; export RET_ERROR_SCRIPT_WAS_NOT_SOURCED
RET_ERROR_USER_IS_NOT_ROOT=152; export RET_ERROR_USER_IS_NOT_ROOT
RET_ERROR_DIRECTORY_NOT_FOUND=153; export RET_ERROR_DIRECTORY_NOT_FOUND
RET_ERROR_FILE_NOT_FOUND=154; export RET_ERROR_FILE_NOT_FOUND
RET_ERROR_FILE_COULD_NOT_BE_ACCESSED=155; export RET_ERROR_FILE_COULD_NOT_BE_ACCESSED
RET_ERROR_INVALID_INVOCATION=156; export RET_ERROR_INVALID_INVOCATION
RET_ERROR_COULD_NOT_EXECUTE=157; export RET_ERROR_COULD_NOT_EXECUTE
RET_ERROR_INVALID_ARGUMENT=158; export RET_ERROR_INVALID_ARGUMENT
RET_ERROR_CONDA_INIT_FAILED=159; export RET_ERROR_CONDA_INIT_FAILED
RET_ERROR_POETRY_INSTALL_FAILED=160; export RET_ERROR_POETRY_INSTALL_FAILED
RET_ERROR_COULD_NOT_SOURCE_FILE=161; export RET_ERROR_COULD_NOT_SOURCE_FILE

# Global Warnings 192-253 (61, but 2 reserved, so really 59)
RET_WARNING_UNKNOWN=192; export RET_WARNING_UNKNOWN
RET_WARNING_MULTIPLE=193; export RET_WARNING_MULTIPLE


# Special code for when Usage gets printed out
RET_ERROR_USAGE_PRINTED=254; export RET_ERROR_USAGE_PRINTED

# Reserved b/c shell weirdness
RET_ERROR_UNKNOWN_255=255; export RET_ERROR_UNKNOWN_255
RET_ERROR_UNKNOWN_NEG1=-1; export RET_ERROR_UNKNOWN_NEG1

#endregion Return Codes
################################################################################

################################################################################
#region Constants

CONDA_INSTALL_PATH="/opt/conda/miniforge"
DATETIME_STAMP_FORMAT="+%Y-%m-%d %H:%M:%S"

#endregion Constants
################################################################################

################################################################################
#region Platform Constants

PLATFORM=$(uname)
export PLATFORM
REAL_PLATFORM=${REAL_PLATFORM:-${PLATFORM}}
export REAL_PLATFORM

if [ "${REAL_PLATFORM}" = "Darwin" ]; then
    date() {
        command date -j "$@"
    }
elif [ "${REAL_PLATFORM}" = "Linux" ]; then
    date() {
        command date "$@"
    }
fi

PLATFORM_IS_WSL=false
if [ "$(uname -a | grep '\(microsoft\|Microsoft\|WSL\)')" != "" ]; then
    PLATFORM_IS_WSL=true
fi

#endregion Platform Constants
################################################################################

################################################################################
#region Calculated "Constants"

set_calculated_constants() {
    CONDA_BASE_DIR_FULLPATH="$(dirname "$(dirname "${CONDA_EXE}")")"; export CONDA_BASE_DIR_FULLPATH
}
set_calculated_constants

#endregion Calculated "Constants"
################################################################################

################################################################################
#region Colorized Output Constants & Helper Functions

ANSI_CODE_START="\033["
ANSI_CODE_END="m"

#-------------------------------------------------------------------------------
get_ansi_code()
{
    (
        ending="$3"
        if [ "${ending}" = "" ]; then
            ending="${ANSI_CODE_END}"
        fi
        # shellcheck disable=SC2154 # because "colorize_output" may or may not exist
        if [ "$(command echo "${TERM}" | grep 'mono')" != "" ] ||
            [ "$(tput colors)" -lt 16 ] ||
            [ "${NO_COLOR}" != "" ] ||
            [ "${colorized_output}" = false ];
        then
            command printf ""
        elif [ "${colorized_output}" = "alt" ] && [ "$2" != "" ]; then
            # shellcheck disable=SC2059
            command printf "${ANSI_CODE_START}$2${ending}"
        else
            # shellcheck disable=SC2059
            command printf "${ANSI_CODE_START}$1${ending}"
        fi
    )
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_up() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'A')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_down() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'B')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_right() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'C')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_left() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'D')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_nextline() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'E')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_prevline() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'F')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_col() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1" '' 'G')"
}

#-------------------------------------------------------------------------------
get_ansi_code_cursor_pos() {
    # shellcheck disable=SC2059
    command printf "$(get_ansi_code "$1;$2" '' 'H')"
}

#-------------------------------------------------------------------------------
set_ansi_code_constants() {
    ANSI_FG_BLACK="$(get_ansi_code '0;30')"; export ANSI_FG_BLACK
    ANSI_FG_RED="$(get_ansi_code '0;31')"; export ANSI_FG_RED
    ANSI_FG_GREEN="$(get_ansi_code '0;32')"; export ANSI_FG_GREEN
    ANSI_FG_YELLOW="$(get_ansi_code '0;33')"; export ANSI_FG_YELLOW
    ANSI_FG_BLUE="$(get_ansi_code '0;34')"; export ANSI_FG_BLUE
    ANSI_FG_MAGENTA="$(get_ansi_code '0;35')"; export ANSI_FG_MAGENTA
    ANSI_FG_CYAN="$(get_ansi_code '0;36')"; export ANSI_FG_CYAN
    ANSI_FG_WHITE="$(get_ansi_code '0;37')"; export ANSI_FG_WHITE

    ANSI_BLACK="${ANSI_FG_BLACK}"; export ANSI_BLACK
    ANSI_RED="${ANSI_FG_RED}"; export ANSI_RED
    ANSI_GREEN="${ANSI_FG_GREEN}"; export ANSI_GREEN
    ANSI_YELLOW="${ANSI_FG_YELLOW}"; export ANSI_YELLOW
    ANSI_BLUE="${ANSI_FG_BLUE}"; export ANSI_BLUE
    ANSI_MAGENTA="${ANSI_FG_MAGENTA}"; export ANSI_MAGENTA
    ANSI_CYAN="${ANSI_FG_CYAN}"; export ANSI_CYAN
    ANSI_WHITE="${ANSI_FG_WHITE}"; export ANSI_WHITE

    ANSI_FG_BOLD_BLACK="$(get_ansi_code '1;30')"; export ANSI_FG_BOLD_BLACK
    ANSI_FG_BOLD_RED="$(get_ansi_code '1;31')"; export ANSI_FG_BOLD_RED
    ANSI_FG_BOLD_GREEN="$(get_ansi_code '1;32')"; export ANSI_FG_BOLD_GREEN
    ANSI_FG_BOLD_YELLOW="$(get_ansi_code '1;33')"; export ANSI_FG_BOLD_YELLOW
    ANSI_FG_BOLD_BLUE="$(get_ansi_code '1;34')"; export ANSI_FG_BOLD_BLUE
    ANSI_FG_BOLD_MAGENTA="$(get_ansi_code '1;35')"; export ANSI_FG_BOLD_MAGENTA
    ANSI_FG_BOLD_CYAN="$(get_ansi_code '1;36')"; export ANSI_FG_BOLD_CYAN
    ANSI_FG_BOLD_WHITE="$(get_ansi_code '1;37')"; export ANSI_FG_BOLD_WHITE

    ANSI_BOLD_BLACK="${ANSI_FG_BOLD_BLACK}"; export ANSI_BOLD_BLACK
    ANSI_BOLD_RED="${ANSI_FG_BOLD_RED}"; export ANSI_BOLD_RED
    ANSI_BOLD_GREEN="${ANSI_FG_BOLD_GREEN}"; export ANSI_BOLD_GREEN
    ANSI_BOLD_YELLOW="${ANSI_FG_BOLD_YELLOW}"; export ANSI_BOLD_YELLOW
    ANSI_BOLD_BLUE="${ANSI_FG_BOLD_BLUE}"; export ANSI_BOLD_BLUE
    ANSI_BOLD_MAGENTA="${ANSI_FG_BOLD_MAGENTA}"; export ANSI_BOLD_MAGENTA
    ANSI_BOLD_CYAN="${ANSI_FG_BOLD_CYAN}"; export ANSI_BOLD_CYAN
    ANSI_BOLD_WHITE="${ANSI_FG_BOLD_WHITE}"; export ANSI_BOLD_WHITE

    ANSI_BG_BLACK="$(get_ansi_code '0;40')"; export ANSI_BG_BLACK
    ANSI_BG_RED="$(get_ansi_code '0;41')"; export ANSI_BG_RED
    ANSI_BG_GREEN="$(get_ansi_code '0;42')"; export ANSI_BG_GREEN
    ANSI_BG_YELLOW="$(get_ansi_code '0;43')"; export ANSI_BG_YELLOW
    ANSI_BG_BLUE="$(get_ansi_code '0;44')"; export ANSI_BG_BLUE
    ANSI_BG_MAGENTA="$(get_ansi_code '0;45')"; export ANSI_BG_MAGENTA
    ANSI_BG_CYAN="$(get_ansi_code '0;46')"; export ANSI_BG_CYAN
    ANSI_BG_WHITE="$(get_ansi_code '0;47')"; export ANSI_BG_WHITE

    ANSI_BG_BOLD_BLACK="$(get_ansi_code '1;40')"; export ANSI_BG_BOLD_BLACK
    ANSI_BG_BOLD_RED="$(get_ansi_code '1;41')"; export ANSI_BG_BOLD_RED
    ANSI_BG_BOLD_GREEN="$(get_ansi_code '1;42')"; export ANSI_BG_BOLD_GREEN
    ANSI_BG_BOLD_YELLOW="$(get_ansi_code '1;43')"; export ANSI_BG_BOLD_YELLOW
    ANSI_BG_BOLD_BLUE="$(get_ansi_code '1;44')"; export ANSI_BG_BOLD_BLUE
    ANSI_BG_BOLD_MAGENTA="$(get_ansi_code '1;45')"; export ANSI_BG_BOLD_MAGENTA
    ANSI_BG_BOLD_CYAN="$(get_ansi_code '1;46')"; export ANSI_BG_BOLD_CYAN
    ANSI_BG_BOLD_WHITE="$(get_ansi_code '1;47')"; export ANSI_BG_BOLD_WHITE

    ANSI_UNDERLINE="$(get_ansi_code '4')"; export ANSI_UNDERLINE
    ANSI_UNDERLINE_OFF="$(get_ansi_code '24')"; export ANSI_UNDERLINE_OFF

    ANSI_FG_UNDERLINE_BLACK="$(get_ansi_code '0;4;30')"; export ANSI_FG_UNDERLINE_BLACK
    ANSI_FG_UNDERLINE_RED="$(get_ansi_code '0;4;31')"; export ANSI_FG_UNDERLINE_RED
    ANSI_FG_UNDERLINE_GREEN="$(get_ansi_code '0;4;32')"; export ANSI_FG_UNDERLINE_GREEN
    ANSI_FG_UNDERLINE_YELLOW="$(get_ansi_code '0;4;33')"; export ANSI_FG_UNDERLINE_YELLOW
    ANSI_FG_UNDERLINE_BLUE="$(get_ansi_code '0;4;34')"; export ANSI_FG_UNDERLINE_BLUE
    ANSI_FG_UNDERLINE_MAGENTA="$(get_ansi_code '0;4;35')"; export ANSI_FG_UNDERLINE_MAGENTA
    ANSI_FG_UNDERLINE_CYAN="$(get_ansi_code '0;4;36')"; export ANSI_FG_UNDERLINE_CYAN
    ANSI_FG_UNDERLINE_WHITE="$(get_ansi_code '0;4;37')"; export ANSI_FG_UNDERLINE_WHITE

    ANSI_FG_BOLD_UNDERLINE_BLACK="$(get_ansi_code '1;4;30')"; export ANSI_FG_BOLD_UNDERLINE_BLACK
    ANSI_FG_BOLD_UNDERLINE_RED="$(get_ansi_code '1;4;31')"; export ANSI_FG_BOLD_UNDERLINE_RED
    ANSI_FG_BOLD_UNDERLINE_GREEN="$(get_ansi_code '1;4;32')"; export ANSI_FG_BOLD_UNDERLINE_GREEN
    ANSI_FG_BOLD_UNDERLINE_YELLOW="$(get_ansi_code '1;4;33')"; export ANSI_FG_BOLD_UNDERLINE_YELLOW
    ANSI_FG_BOLD_UNDERLINE_BLUE="$(get_ansi_code '1;4;34')"; export ANSI_FG_BOLD_UNDERLINE_BLUE
    ANSI_FG_BOLD_UNDERLINE_MAGENTA="$(get_ansi_code '1;4;35')"; export ANSI_FG_BOLD_UNDERLINE_MAGENTA
    ANSI_FG_BOLD_UNDERLINE_CYAN="$(get_ansi_code '1;4;36')"; export ANSI_FG_BOLD_UNDERLINE_CYAN
    ANSI_FG_BOLD_UNDERLINE_WHITE="$(get_ansi_code '1;4;37')"; export ANSI_FG_BOLD_UNDERLINE_WHITE

    ANSI_CLEAR_LINE="$(get_ansi_code '2' '' 'K')"; export ANSI_CLEAR_LINE
    ANSI_RESET_LINE="$(get_ansi_code '2' '' 'K')$(get_ansi_code '1' '' 'G')"; export ANSI_RESET_LINE

    ANSI_CLEAR_SCREEN="$(get_ansi_code '2' '' 'J')"; export ANSI_CLEAR_SCREEN
    ANSI_RESET_SCREEN="$(get_ansi_code '2' '' 'J')$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_SCREEN

    ANSI_CLEAR_HISTORY="$(get_ansi_code '3' '' 'J')"; export ANSI_CLEAR_HISTORY
    ANSI_RESET_HISTORY="$(get_ansi_code '3' '' 'J')$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_HISTORY

    ANSI_RESET_CURSOR_LINE="$(get_ansi_code '1' '' 'G')"; export ANSI_RESET_CURSOR_LINE
    ANSI_RESET_CURSOR_SCREEN="$(get_ansi_code '1;1' '' 'H')"; export ANSI_RESET_CURSOR_SCREEN

    ANSI_CURSOR_UP="$(get_ansi_code '1' '' 'A')"; export ANSI_CURSOR_UP
    ANSI_CURSOR_DOWN="$(get_ansi_code '1' '' 'B')"; export ANSI_CURSOR_DOWN
    ANSI_CURSOR_RIGHT="$(get_ansi_code '1' '' 'C')"; export ANSI_CURSOR_RIGHT
    ANSI_CURSOR_LEFT="$(get_ansi_code '1' '' 'D')"; export ANSI_CURSOR_LEFT
    ANSI_CURSOR_NEXTLINE="$(get_ansi_code '1' '' 'E')"; export ANSI_CURSOR_NEXTLINE
    ANSI_CURSOR_PREVLINE="$(get_ansi_code '1' '' 'F')"; export ANSI_CURSOR_PREVLINE

    ANSI_BELL="\007🔔 "; export ANSI_BELL
    ANSI_RESET="$(get_ansi_code '0')"; export ANSI_RESET

    ANSI_COLOR_SUCCESS="$(get_ansi_code '1;32' '1;34')"; export ANSI_COLOR_SUCCESS          # bright green/blue
    ANSI_COLOR_FATAL="$(get_ansi_code '1;31')"; export ANSI_COLOR_FATAL                     # bright red
    ANSI_COLOR_ERROR="$(get_ansi_code '0;31')"; export ANSI_COLOR_ERROR                     # darkred
    ANSI_COLOR_WARNING="$(get_ansi_code '1;33')"; export ANSI_COLOR_WARNING                 # bright yellow
    ANSI_COLOR_HEADER="$(get_ansi_code '1;4;36')"; export ANSI_COLOR_HEADER                 # bright cyan, underlined
    ANSI_COLOR_FOOTER="$(get_ansi_code '0;24;36')"; export ANSI_COLOR_FOOTER                # bright darkcyan, not underlined
    ANSI_COLOR_INFO="$(get_ansi_code '1;37')"; export ANSI_COLOR_INFO                       # bright white
    ANSI_COLOR_DEBUG="$(get_ansi_code '0;37')"; export ANSI_COLOR_DEBUG                     # lightgrey
    ANSI_COLOR_SUPERDEBUG="$(get_ansi_code '1;30')"; export ANSI_COLOR_SUPERDEBUG           # grey
    ANSI_COLOR_ULTRADEBUG="$(get_ansi_code '0;35' '0;33')"; export ANSI_COLOR_ULTRADEBUG    # darkmagenta/darkyellow

    ANSI_SUCCESS_FINAL="${ANSI_COLOR_SUCCESS}${ANSI_BELL}✅ "; export ANSI_SUCCESS_FINAL
    ANSI_SUCCESS="${ANSI_COLOR_SUCCESS}"; export ANSI_SUCCESS
    ANSI_FATAL="${ANSI_COLOR_FATAL}${ANSI_BELL}💀 "; export ANSI_FATAL
    ANSI_ERROR="${ANSI_COLOR_ERROR}${ANSI_BELL}❌ "; export ANSI_ERROR
    ANSI_WARNING="${ANSI_COLOR_WARNING}⚠️ "; export ANSI_WARNING
    ANSI_HEADER="${ANSI_COLOR_HEADER}"; export ANSI_HEADER
    ANSI_FOOTER="${ANSI_COLOR_FOOTER}"; export ANSI_FOOTER
    ANSI_INFO="${ANSI_COLOR_INFO}"; export ANSI_INFO
    ANSI_DEBUG="${ANSI_COLOR_DEBUG}"; export ANSI_DEBUG
    ANSI_SUPERDEBUG="${ANSI_COLOR_SUPERDEBUG}"; export ANSI_SUPERDEBUG
    ANSI_ULTRADEBUG="${ANSI_COLOR_ULTRADEBUG}"; export ANSI_ULTRADEBUG
}
set_ansi_code_constants

#endregion Colorized Output Constants
################################################################################

################################################################################
#region Logging Helpers

#-------------------------------------------------------------------------------
get_datetime_stamp()
{
    date "${DATETIME_STAMP_FORMAT}"
}

#-------------------------------------------------------------------------------
format_log_message()
{
    (
        prefix="$1"
        suffix="$2"
        shift 2

        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        inner_text="$(command printf -- "$@"; command echo EOL)"
        command printf -- "%s %s%s%s\n" "$(get_datetime_stamp)" "${prefix}" "${inner_text%EOL}" "${suffix}"
    )
}

#-------------------------------------------------------------------------------
log_console()
{
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message="$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)"
        command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_success_final() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUCCESS_FINAL}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            [ "${quiet:-}" != true ]||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_success() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUCCESS}SUCCESS: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            [ "${quiet:-}" != true ]||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_fatal() {
    # NOTE: outside the local scope to modify global var
    LOG_FATAL_COUNT=$((LOG_FATAL_COUNT + 1)); export LOG_FATAL_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_FATAL}FATAL: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${ERROR_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_error() {
    # NOTE: outside the local scope to modify global var
    LOG_ERROR_COUNT=$((LOG_ERROR_COUNT + 1)); export LOG_ERROR_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_ERROR}ERROR: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${ERROR_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_warning() {
    # NOTE: outside the local scope to modify global var
    LOG_WARNING_COUNT=$((LOG_WARNING_COUNT + 1)); export LOG_WARNING_COUNT
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_WARNING}WARNING: " "${ANSI_RESET}" "$@"; command echo EOL)
        >&2 command printf -- "${message%EOL}"
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
        >>"${WARNING_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_header() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_HEADER}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge -1 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_footer() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_FOOTER}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 0 ]  ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_info() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}INFO: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_info_noprefix() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_debug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_DEBUG}DEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 2 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_superdebug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_SUPERDEBUG}SUPERDEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 3 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_ultradebug() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_ULTRADEBUG}ULTRADEBUG: " "${ANSI_RESET}" "$@"; command echo EOL)
        if \
            { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
            [ "${OMEGA_DEBUG:-}" = true ] ||
            [ "${OMEGA_DEBUG:-}" = "all" ]
        then
            command printf -- "${message%EOL}"
        fi
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
log_file() {
    (
        # NOTE: we echo 'EOL' and then remove it during printf in order to keep trailing newlines
        message=$(format_log_message "${ANSI_INFO}" "${ANSI_RESET}" "$@"; command echo EOL)
        >>"${FULL_LOG}" command printf -- "${message%EOL}"
    )
}

#-------------------------------------------------------------------------------
printf() {
    log_file "$@"
    command printf -- "$@"
}

#-------------------------------------------------------------------------------
echo() {
    log_file "$@"
    command echo "$@"
}

#-------------------------------------------------------------------------------
report_errors() {
    (
        if [ "$(wc -c <"${ERROR_LOG}")" -gt 0 ]; then
            message="${ANSI_COLOR_ERROR}The following errors occurred:${ANSI_RESET}\n"
            >&2 command printf -- "${message}"
            >>"${FULL_LOG}" command printf -- "${message}"

            >&2 command sed 's/^/\t/' "${ERROR_LOG}"
            >>"${FULL_LOG}" command sed 's/^/\t/' "${ERROR_LOG}"
        fi
    )
}

#-------------------------------------------------------------------------------
report_warnings() {
    (
        if [ "$(wc -c <"${WARNING_LOG}")" -gt 0 ]; then
            message="${ANSI_COLOR_WARNING}The following warnings occurred:${ANSI_RESET}\n"
            >&2 command printf -- "${message}"
            >>"${FULL_LOG}" command printf "${message}"

            >&2 sed 's/^/\t/' "${WARNING_LOG}"
            >>"${FULL_LOG}" sed 's/^/\t/' "${WARNING_LOG}"
        fi
    )
}

#-------------------------------------------------------------------------------
report_final_status() {
    (
        ret=$1
        shift
        message="$(command printf -- "$@"; command echo EOL)"

        # fixup return code in case it is wrong
        if [ "$ret" -eq 0 ]; then
            if [ ${LOG_FATAL_COUNT} -gt 0 ]; then
                ret=${RET_ERROR_UNKNOWN}
            elif [ ${LOG_ERROR_COUNT} -gt 0 ]; then
                ret=${RET_ERROR_UNKNOWN}
            elif [ ${LOG_WARNING_COUNT} -gt 0 ]; then
                if [ ${LOG_WARNING_COUNT} -gt 1 ]; then
                    ret=${RET_WARNING_MULTIPLE}
                elif [ "${LAST_WARNING_CODE}" -ne 0 ]; then
                    ret="${LAST_WARNING_CODE}"
                else
                    ret=${RET_WARNING_UNKNOWN}
                fi
            fi
        fi

        fatal_text=""
        plural=""
        if [ ${LOG_FATAL_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_FATAL_COUNT} -gt 0 ]; then
            fatal_text="$(command printf "%d Fatal Error%s" "${LOG_FATAL_COUNT}" "${plural}")"
        fi

        error_text=""
        plural=""
        if [ ${LOG_ERROR_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_ERROR_COUNT} -gt 0 ]; then
            error_text="$(command printf "%d Error%s" "${LOG_ERROR_COUNT}" "${plural}")"
        fi

        warning_text=""
        plural=""
        if [ ${LOG_WARNING_COUNT} -gt 1 ]; then
            plural="s"
        fi
        if [ ${LOG_WARNING_COUNT} -gt 0 ]; then
            warning_text="$(command printf "%d Warning%s" "${LOG_WARNING_COUNT}" "${plural}")"
        fi

        before_error_text=""
        before_warning_text=""
        if \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_ERROR_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_error_text=", "
            before_warning_text=", and "
        elif \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_warning_text=" and "
        elif \
            [ ${LOG_FATAL_COUNT} -gt 0 ] &&
            [ ${LOG_ERROR_COUNT} -gt 0 ]
        then
            before_error_text=" and "
        elif \
            [ ${LOG_ERROR_COUNT} -gt 0 ] &&
            [ ${LOG_WARNING_COUNT} -gt 0 ]
        then
            before_warning_text=" and "
        fi

        log_info "%s exiting with return code: %d" "${message%EOL}"  "$ret"
        if [ "$ret" -eq 0 ]; then
            log_success_final "%s Completed Successfully." "${message%EOL}"
        elif [ ${LOG_FATAL_COUNT} -gt 0 ]; then
            log_fatal "%s Had %s%s%s%s%s." "${message%EOL}" "${fatal_text}" "${before_error_text}" "${error_text}" "${before_warning_text}" "${warning_text}"
        elif [ ${LOG_ERROR_COUNT} -gt 0 ]; then
            log_error "%s Had %s%s%s." "${message%EOL}" "${error_text}" "${before_warning_text}" "${warning_text}"
        elif [ ${LOG_WARNING_COUNT} -gt 0 ]; then
            log_warning "%s Had %s." "${message%EOL}" "${warning_text}"
        fi

        return "$ret"
    )
}

#-------------------------------------------------------------------------------
report_all() {
    (
        report_warnings
        report_errors
        >&2 command printf "Fully detailed log is available at '%s'\n" "${FULL_LOG}"
        report_final_status "$@"
    )
}

#-------------------------------------------------------------------------------
set_warning_code() {
    LAST_WARNING_CODE="$1"
}

if [ "${CONSTANTS_TEMP_DIR}" = "" ]; then
    CONSTANTS_TEMP_DIR=$(mktemp -d -t constants.sh-XXXXXXXX)
    export CONSTANTS_TEMP_DIR
    mkdir -p "${CONSTANTS_TEMP_DIR}"
fi
if [ "${ERROR_LOG}" = "" ]; then
    ERROR_LOG="${CONSTANTS_TEMP_DIR}"/errors_only.txt
    export ERROR_LOG
    command printf '' >"${ERROR_LOG}"
fi
if [ "${WARNING_LOG}" = "" ]; then
    WARNING_LOG="${CONSTANTS_TEMP_DIR}"/warnings_only.txt
    export WARNING_LOG
    command printf '' >"${WARNING_LOG}"
fi
if [ "${FULL_LOG}" = "" ]; then
    FULL_LOG="${CONSTANTS_TEMP_DIR}"/log.txt
    export FULL_LOG
    command printf '' >"${FULL_LOG}"
fi

if [ "${LOG_FATAL_COUNT}" = "" ]; then
    LOG_FATAL_COUNT=0; export LOG_FATAL_COUNT
fi
if [ "${LOG_ERROR_COUNT}" = "" ]; then
    LOG_ERROR_COUNT=0; export LOG_ERROR_COUNT
fi
if [ "${LOG_WARNING_COUNT}" = "" ]; then
    LOG_WARNING_COUNT=0; export LOG_WARNING_COUNT
fi

if [ "${LAST_WARNING_CODE}" = "" ]; then
    LAST_WARNING_CODE="${RET_SUCCESS}"
fi

#endregion Logging Helpers
################################################################################
