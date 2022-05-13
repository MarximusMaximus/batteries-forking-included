#!/usr/bin/env sh

################################################################################
#region Preamble

echo "$0"

#===============================================================================
#region RReadLink

#-------------------------------------------------------------------------------
rreadlink() {
    ( # Execute the function in a *subshell* to localize variables and the effect of `cd`.

        target=$1
        fname=
        targetDir=
        CDPATH=

        # Try to make the execution environment as predictable as possible:
        # All commands below are invoked via `command`, so we must make sure that `command`
        # itself is not redefined as an alias or shell function.
        # (NOTE: that command is too inconsistent across shells, so we don't use it.)
        # `command` is a *builtin* in bash, dash, ksh, zsh, and some platforms do not even have
        # an external utility version of it (e.g, Ubuntu).
        # `command` bypasses aliases and shell functions and also finds builtins
        # in bash, dash, and ksh. In zsh, option POSIX_BUILTINS must be turned on for that
        # to happen.
        { \unalias command; \unset -f command; } >/dev/null 2>&1
        # shellcheck disable=SC2034
        [ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on # make zsh find *builtins* with `command` too.

        while :; do # Resolve potential symlinks until the ultimate target is found.
                [ -L "$target" ] || [ -e "$target" ] || { command printf '%s\n' "ERROR: '$target' does not exist." >&2; return 1; }
                # shellcheck disable=SC2164
                command cd "$(command dirname -- "$target")" # Change to target dir; necessary for correct resolution of target path.
                fname=$(command basename -- "$target") # Extract filename.
                [ "$fname" = '/' ] && fname='' # WARNING: curiously, `basename /` returns '/'
                if [ -L "$fname" ]; then
                    # Extract [next] target path, which may be defined
                    # relative to the symlink's own directory.
                    # NOTE: We parse `ls -l` output to find the symlink target
                    # NOTE:     which is the only POSIX-compliant, albeit somewhat fragile, way.
                    target=$(command ls -l "$fname")
                    target=${target#* -> }
                    continue # Resolve [next] symlink target.
                fi
                break # Ultimate target reached.
        done
        targetDir=$(command pwd -P) # Get canonical dir. path
        # Output the ultimate target's canonical path.
        # NOTE: that we manually resolve paths ending in /. and /.. to make sure we have a normalized path.
        if [ "$fname" = '.' ]; then
            command printf '%s\n' "${targetDir%/}"
        elif    [ "$fname" = '..' ]; then
            # NOTE: something like /var/.. will resolve to /private (assuming /var@ -> /private/var),
            # NOTE:     i.e. the '..' is applied AFTER canonicalization.
            command printf '%s\n' "$(command dirname -- "${targetDir}")"
        else
            command printf '%s\n' "${targetDir%/}/$fname"
        fi
    )
}

#endregion RReadLink
#===============================================================================

#===============================================================================
#region Self Referentials

MY_DIR_FULLPATH="$(dirname -- "$(rreadlink "$0")")"
export MY_DIR_FULLPATH
MY_DIR_BASENAME="$(basename -- "${MY_DIR_FULLPATH}")"
export MY_DIR_BASENAME
CONDA_BOOTSTRAPPER_FULLPATH="${MY_DIR_FULLPATH}/../conda-bootstrapper"
export CONDA_BOOTSTRAPPER_FULLPATH

#endregion Self Referentials
#===============================================================================


#===============================================================================
#region Fallbacks

# NOTE: some basic definitions to fallback to if constants.sh failed to load

RET_SUCCESS=0; export RET_SUCCESS
RET_ERROR_UNKNOWN=1; export RET_ERROR_UNKNOWN
RET_ERROR_SCRIPT_WAS_SOURCED=149; export RET_ERROR_SCRIPT_WAS_SOURCED
RET_ERROR_USER_IS_ROOT=150; export RET_ERROR_USER_IS_ROOT
RET_ERROR_DIRECTORY_NOT_FOUND=153; export RET_ERROR_DIRECTORY_NOT_FOUND
RET_ERROR_COULD_NOT_SOURCE_FILE=161; export RET_ERROR_COULD_NOT_SOURCE_FILE

#-------------------------------------------------------------------------------
log_fatal() {
    >&2 command printf "FATAL: "
    >&2 command printf "$@"
    >&2 command printf "\n"
}

#-------------------------------------------------------------------------------
log_error() {
    >&2 command printf "ERROR: "
    >&2 command printf "$@"
    >&2 command printf "\n"
}

#-------------------------------------------------------------------------------
log_warning() {
    >&2 command printf "WARNING: "
    >&2 command printf "$@"
    >&2 command printf "\n"
}

#-------------------------------------------------------------------------------
log_info() {
    if \
        { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 1 ] ;} ||
        [ "${OMEGA_DEBUG:-}" = true ] ||
        [ "${OMEGA_DEBUG:-}" = "all" ]
    then
        command printf "INFO: "
        command printf "$@"
        command printf "\n"
    fi
}

#-------------------------------------------------------------------------------
log_ultradebug() {
    if \
        { [ "${quiet:-}" != true ] && [ "${verbosity:-0}" -ge 4 ] ;} ||
        [ "${OMEGA_DEBUG:-}" = true ] ||
        [ "${OMEGA_DEBUG:-}" = "all" ]
    then
        command printf "ULTRADEBUG: "
        command printf "$@"
        command printf "\n"
    fi
}

#endregion Fallbacks
#===============================================================================

#endregion Preamble
################################################################################

(

    ############################################################################
    #region Includes

    if [ -f "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh" ]; then
        # shellcheck disable=SC1091
        . "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
    fi

    #endregion Includes
    ############################################################################

    ############################################################################
    #region Constants

    SET_OMEGA_DEBUG=false
    GITHUB_REPO_USER=MarximusMaximus
    GITHUB_REPO_NAME=conda-bootstrapper

    #endregion Constants
    ############################################################################

    ############################################################################
    #region Return Codes

    RET_ERROR_NO_DOWNLOAD_METHOD=2
    RET_ERROR_NO_EXTRACT_METHOD=3
    RET_ERROR_FAILED_TO_CLONE=4
    RET_ERROR_FAILED_TO_DOWNLOAD=5
    RET_ERROR_FAILED_TO_CREATE_DIRECTORY=6
    RET_ERROR_FAILED_TO_EXTRACT=7
    RET_ERROR_FAILED_TO_GET_my_tempdir=8
    RET_ERROR_FAILED_TO_MOVE_FILES=9
    RET_ERROR_FAILED_TO_CD=10
    RET_ERROR_GIT_FETCH_FAILED=11
    RET_ERROR_GIT_RESET_FAILED=12
    RET_ERROR_UNSAFE_RM_PATH=13
    RET_ERROR_RM_FAILED=14
    RET_ERROR_COPY_FAILED=15
    RET_ERROR_NO_DIFF_METHOD=16

    #endregion Return Codes
    ############################################################################

    ############################################################################
    #region Globals

    if [ "${OMEGA_DEBUG}" = "all" ]; then
        log_ultradebug "OMEGA_DEBUG was already 'all', ignoring value of SET_OMEGA_DEBUG ('%s')" "${SET_OMEGA_DEBUG}"
    else
        OMEGA_DEBUG="${SET_OMEGA_DEBUG}"
        export OMEGA_DEBUG
        log_ultradebug "SET_OMEGA_DEBUG was '%s', setting OMEGA_DEBUG to same and exporting it." "${SET_OMEGA_DEBUG}"
    fi

    verbosity=99

    git_exists=false; export git_exists
    curl_exists=false; export curl_exists
    wget_exists=false; export wget_exists
    tar_exists=false; export tar_exists
    unzip_exists=false; export unzip_exists
    diff_exists=false; export diff_exists
    md5_exists=false; export md5_exists

    my_tempdir=""; export my_tempdir

    #endregion Globals
    ############################################################################

    ############################################################################
    #region Public Functions

    ensure_cd() {
        # intentionally no local scope so that the cd command takes effect

        path_to_cd="$1"

        log_info "Changing current directory to '%s'" "${path_to_cd}"

        # shellcheck disable=SC2164
        cd "${path_to_cd}"
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "Could not cd into '%s'" "${path_to_cd}"
            return "${RET_ERROR_DIRECTORY_NOT_FOUND}"
        fi
    }

    safe_rm() {
        (
            path_to_remove="$1"
            print_rm_error_message="$2"

            log_info "Safely removing '%s'" "${path_to_remove}"

            if \
                [ "${path_to_remove}" != "/" ] &&
                [ "${path_to_remove}" != "${HOME}" ] &&
                [ "${path_to_remove}" != "${TMPDIR}" ] &&
                [ "${path_to_remove}" != "/Applications" ] &&
                [ "${path_to_remove}" != "/bin" ] &&
                [ "${path_to_remove}" != "/boot" ] &&
                [ "${path_to_remove}" != "/cores" ] &&
                [ "${path_to_remove}" != "/dev" ] &&
                [ "${path_to_remove}" != "/etc" ] &&
                [ "${path_to_remove}" != "/home" ] &&
                [ "${path_to_remove}" != "/lib" ] &&
                [ "${path_to_remove}" != "/Library" ] &&
                [ "${path_to_remove}" != "/local" ] &&
                [ "${path_to_remove}" != "/media" ] &&
                [ "${path_to_remove}" != "/mnt" ] &&
                [ "${path_to_remove}" != "/opt" ] &&
                [ "${path_to_remove}" != "/private" ] &&
                [ "${path_to_remove}" != "/proc" ] &&
                [ "${path_to_remove}" != "/sbin" ] &&
                [ "${path_to_remove}" != "/srv" ] &&
                [ "${path_to_remove}" != "/System" ] &&
                [ "${path_to_remove}" != "/Users" ] &&
                [ "${path_to_remove}" != "/usr" ] &&
                [ "${path_to_remove}" != "/var" ] &&
                [ "${path_to_remove}" != "/Volumes" ] &&
                [ "${path_to_remove}" != "" ]
            then
                rm -rf "${path_to_remove}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    if \
                        [ "${print_rm_error_message}" = "" ] ||
                        [ "${print_rm_error_message}" = true ]
                    then
                        log_error "failed to rm '%s'" "${path_to_remove}"
                    fi
                    exit "${RET_ERROR_RM_FAILED}"
                fi
            else
                log_fatal "unsafe rm path '%s'" "${path_to_remove}"
                exit "${RET_ERROR_UNSAFE_RM_PATH}"
            fi
        )
    }

    ensure_does_not_exist() {
        (
            path_to_remove="$1"

            log_info "Ensuring does not exist: '%s'" "${path_to_remove}"

            if \
                [ -f "${path_to_remove}" ] ||
                [ -d "${path_to_remove}" ]
            then
                safe_rm "${path_to_remove}"
                ret=$?
                exit $ret
            fi
        )
    }

    check_tools() {
        # intentionally no local scope because modifying globals

        log_info "Checking tools"

        if [ "$(command -v git)" != "" ]; then
            git_exists=true
        fi
        export git_exists

        if [ "$(command -v curl)" != "" ]; then
            curl_exists=true
        fi
        export curl_exists

        if [ "$(command -v wget)" != "" ]; then
            wget_exists=true
        fi
        export wget_exists

        if [ "$(command -v tar)" != "" ]; then
            tar_exists=true
        fi
        export tar_exists

        if [ "$(command -v unzip)" != "" ]; then
            unzip_exists=true
        fi
        export unzip_exists

        if [ "$(command -v diff)" != "" ]; then
            diff_exists=true
        fi
        export diff_exists

        if [ "$(command -v md5)" != "" ]; then
            md5_exists=true
        fi
        export md5_exists

        if \
            [ "${git_exists}" = false ] &&
            [ "${curl_exists}" = false ] &&
            [ "${wget_exists}" = false ]
        then
            log_fatal "conda-bootstrapper missing and no way to download available (no git, no curl, no wget)"
            return "${RET_ERROR_NO_DOWNLOAD_METHOD}"
        fi

        if \
            [ "${git_exists}" = false ] &&  # we only need to extract if git isn't available
            [ "${tar_exists}" = false ] &&
            [ "${unzip_exists}" = false ]
        then
            log_fatal "conda-bootstrapper missing and no way to extract from compressed file available (no tar, no unzip)"
            return "${RET_ERROR_NO_EXTRACT_METHOD}"
        fi

        if \
            [ "${diff_exists}" = false ] &&
            [ "${md5_exists}" = false ]
        then
            log_fatal "no way to comapre files (no diff, no md5)"
            return "${RET_ERROR_NO_DIFF_METHOD}"
        fi
    }

    create_dir() {
        (
            destdir="$1"

            log_info "Creating directory '%s'" "${destdir}"

            ensure_does_not_exist "${destdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to remove path '%s'" "${destdir}"
                exit $ret
            fi

            mkdir -p "${destdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to create directory '%s'" "${destdir}"
                exit "${RET_ERROR_FAILED_TO_CREATE_DIRECTORY}"
            fi
        )
    }

    ensure_dir() {
        (
            destdir="$1"

            log_info "Ensuring directory exists: '%s'" "${destdir}"

            if [ ! -d "${destdir}" ]; then
                create_dir "${destdir}"
                ret=$?
                exit $ret
            fi
        )
    }

    create_my_tempdir() {
        # intentionally no local scope b/c modifying a global

        log_info "Creating temporary directory"

        my_tempdir=$(mktemp -d -t conda-bootstrapper-update.XXXXXXXX)
        ret=$?
        if [ $ret -ne 0 ]; then
            log_fatal "failed to get temporary directory"
            return "${RET_ERROR_FAILED_TO_GET_my_tempdir}"
        fi

        ensure_dir "${my_tempdir}"
        if [ $ret -ne 0 ]; then
            return $ret
        fi

        export my_tempdir
    }

    download_via_curl() {
        (
            repo_url=$1
            file_basename=$2
            directory="$3"

            if [ "${tar_exists}" = true ]; then
                log_info "Downloading as tarball via curl: '%s'" "${repo_url}"
                curl -L "${repo_url}/tarball" --output "${directory}/${file_basename}.tar.gz"
                ret=$?
            elif [ "${unzip_exists}" = true ]; then
                log_info "Downloading as zipball via curl: '%s'" "${repo_url}"
                curl -L "${repo_url}/zipball" --output "${directory}/${file_basename}.zip"
                ret=$?
            else  # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "No way to extract from compressed file available (no tar, no unzip)"
                exit "${RET_ERROR_NO_EXTRACT_METHOD}"
            fi
            if [ $ret -ne 0 ]; then
                log_fatal "failed to download ${file_basename} compressed file (curl)"
                exit "${RET_ERROR_FAILED_TO_DOWNLOAD}"
            fi
        )
    }

    download_via_wget() {
        (
            repo_url=$1
            file_basename=$2
            directory="$3"

            if [ "${tar_exists}" = true ]; then
                log_info "Downloading as tarball via wget: '%s'" "${repo_url}"
                wget "${repo_url}/tarball" -O "${directory}/${file_basename}.tar.gz"
                ret=$?
            elif [ "${unzip_exists}" = true ]; then
                log_info "Downloading as zipball via wget: '%s'" "${repo_url}"
                wget "${repo_url}/zipball" -O "${directory}/${file_basename}.zip"
                ret=$?
            else  # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "No way to extract from compressed file available (no tar, no unzip)"
                exit "${RET_ERROR_NO_EXTRACT_METHOD}"
            fi
            if [ $ret -ne 0 ]; then
                log_fatal "failed to download ${file_basename} compressed file (wget)"
                exit "${RET_ERROR_FAILED_TO_DOWNLOAD}"
            fi
        )
    }

    extract_tarball() {
        (
            file=$1
            dest=$2

            log_info "Extracting tarball '%s' to '%s'" "${file}" "${dest}"

            _dest=""
            if [ "${dest}" != "" ]; then
                _dest=" -C "
            fi

            tar -xzf "${file}" --strip=1"${_dest}""${dest}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to extract ${file} compressed file (tar)"
                exit "${RET_ERROR_FAILED_TO_EXTRACT}"
            fi
        )
    }

    extract_zipball() {
        (
            file=$1
            dest=$2

            log_info "Extracting zipball '%s' to '%s'" "${file}" "${dest}"

            create_dir "${my_tempdir}/extracted"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            unzip -d "${my_tempdir}/extracted" "${file}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to extract  ${file} compressed file (unzip)"
                exit "${RET_ERROR_FAILED_TO_EXTRACT}"
            fi

            mv "${my_tempdir}/extracted/*/*" "${dest}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to move extracted files into place from temporary directory"
                exit "${RET_ERROR_FAILED_TO_MOVE_FILES}"
            fi

            mv "${my_tempdir}/extracted/*/.*" "${dest}"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to move extracted files dotfiles into place from temporary directory"
                exit "${RET_ERROR_FAILED_TO_MOVE_FILES}"
            fi
        )
    }

    download_and_extract() {
        (
            repo_url=$1
            file_basename=$2
            destdir="$3"

            if [ "${curl_exists}" = true ]; then
                download_via_curl "${repo_url}" "${file_basename}" "${my_tempdir}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            elif [ "${wget_exists}" = true ]; then
                download_via_wget "${repo_url}" "${file_basename}" "${my_tempdir}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            fi

            create_dir "${destdir}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            if [ "${tar_exists}" = true ]; then
                extract_tarball "${my_tempdir}/${file_basename}.tar.gz" "${destdir}"
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            elif [ "${unzip_exists}" = true ]; then
                extract_zipball "${my_tempdir}/${file_basename}.tar.gz" "${destdir}"
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi
            else  # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "No way to extract from compressed file available (no tar, no unzip)"
                exit "${RET_ERROR_NO_EXTRACT_METHOD}"
            fi
        )
    }

    ensure_conda_bootstrapper() {
        (
            log_info "Ensuring conda-bootstrapper exists"

            if [ ! -d "${CONDA_BOOTSTRAPPER_FULLPATH}" ]; then
                # conda-bootstrapper missing, let's download it
                # shellcheck disable=SC2164
                cd "${CONDA_BOOTSTRAPPER_FULLPATH}/.."
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "failed to cd into '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/.."
                    exit "${RET_ERROR_FAILED_TO_CD}"
                fi

                if [ "${git_exists}" = true ]; then
                    git clone "https://github.com/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}.git"
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        log_fatal "failed to clone https://github.com/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}.git"
                        exit "${RET_ERROR_FAILED_TO_CLONE}"
                    fi
                elif \
                    [ "${curl_exists}" = true ] ||
                    [ "${wget_exists}" = true ]
                then
                    download_and_extract "https://api.github.com/repos/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}" "${GITHUB_REPO_NAME}" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        exit $ret
                    fi

                    # create download timestamp
                    touch "${CONDA_BOOTSTRAPPER_FULLPATH}"/LAST_DOWNLOADED
                else # pragma: no branch
                    # NOTE: it /shouldn't/ be possible to get here
                    log_fatal "no way to download available (no git, no curl, no wget)"
                    exit "${RET_ERROR_NO_DOWNLOAD_METHOD}"
                fi
            fi
        )
    }

    update_condabootstrapper() {
        (
            log_info "Updating conda-bootstrapper"

            if [ "${git_exists}" = true ]; then
                # shellcheck disable=SC2164
                cd "${CONDA_BOOTSTRAPPER_FULLPATH}"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "failed to cd into '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                    exit "${RET_ERROR_FAILED_TO_CD}"
                fi

                current_branch="$(git rev-parse --abbrev-ref HEAD)"
                if [ "${current_branch}" != "main" ]; then
                    log_warning "conda-bootstrapper's current branch is not main"
                    # this is fine, so just bail early
                    exit 0
                fi

                ahead_by="$(git rev-list --left-right --count origin/main...main | awk '{print $2}')"
                is_dirty="$(git status --porcelain --untracked-files=all)"
                if \
                    [ "${is_dirty}" = "" ] &&
                    [ "${ahead_by}" -eq 0 ]
                then
                    # not dirty
                    git fetch
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        log_fatal "git fetch failed"
                        exit "${RET_ERROR_GIT_FETCH_FAILED}"
                    fi

                    git reset --hard origin/main
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        log_fatal "git reset failed"
                        exit "${RET_ERROR_GIT_RESET_FAILED}"
                    fi
                else
                    log_warning "conda-bootstrapper has local changes"
                    # this is fine, so just bail early
                    exit 0
                fi
            elif \
                [ "${curl_exists}" = true ] ||
                [ "${wget_exists}" = true ]
            then
                # shellcheck disable=SC2012
                is_dirty="$(ls -lt | head -2 | tail -1 | grep -v "LAST_DOWNLOADED")"

                if [ "${is_dirty}" = "" ]; then
                    safe_rm "${CONDA_BOOTSTRAPPER_FULLPATH}"
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        exit $ret
                    fi

                    download_and_extract "https://api.github.com/repos/${GITHUB_REPO_USER}/${GITHUB_REPO_NAME}" "${GITHUB_REPO_NAME}" "${CONDA_BOOTSTRAPPER_FULLPATH}"
                    ret=$?
                    if [ $ret -ne 0 ]; then
                        exit $ret
                    fi
                else
                    log_warning "conda-bootstrapper has local changes"
                    # this is fine, so just bail early
                    exit 0
                fi
            else # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "no way to download available (no git, no curl, no wget)"
                exit "${RET_ERROR_NO_DOWNLOAD_METHOD}"
            fi
        )
    }

    copy_temporary_template_files() {
        (
            log_info "Creating a copy of template files"

            create_dir "${my_tempdir}/template"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            cp "${CONDA_BOOTSTRAPPER_FULLPATH}/src/template"/* "${my_tempdir}/template/"
            ret=$?
            if [ $ret -ne 0 ]; then
                log_fatal "failed to copy files from '%s' to '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/src/template/*" "${my_tempdir}/template/"
                exit "${RET_ERROR_COPY_FAILED}"
            fi
        )
    }

    is_file_same() {
        # exit code 0 == same
        # exit code 1 == different
        # exit code 2 == there was an error
        (
            left_file="$1"
            right_file="$2"

            log_info "Comparing '%s' and '%s'" "${left_file}" "${right_file}"

            if [ "${diff_exists}" = true ]; then
                diff "${left_file}" "${right_file}"
                ret=$?
                if [ $ret -gt 2 ]; then
                    exit 2
                fi
                exit $ret
            elif [ "${md5_exists}" = true ]; then
                left_md5="$(md5 -q "${left_file}")"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit 2
                fi

                right_md5="$(md5 -q "${right_file}")"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit 2
                fi

                if [ "${left_md5}" = "${right_md5}" ]; then
                    exit 0
                else
                    exit 1
                fi
            else  # pragma: no branch
                # NOTE: it /shouldn't/ be possible to get here
                log_fatal "no way to comapre files (no diff, no md5)"
                exit "${RET_ERROR_NO_DIFF_METHOD}"
            fi
        )
    }

    compare_and_update_files() {
        (
            # this file gets edited by users, we don't want it to get tested
            safe_rm "${my_tempdir}/template/post-boostrap.sh"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            is_file_same "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
            ret=$?
            if [ $ret -gt 2 ]; then
                exit $ret
            elif [ $ret -eq 1 ]; then
                log_info "conda-bootstrapper-update.sh changed, copying and re-running"

                # we need to update ourself, and then call ourself again
                safe_rm "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                mv "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
                if [ $ret -ne 0 ]; then
                    log_fatal "failed to copy '%s' to '%s'" "${my_tempdir}/template/conda-bootstrapper-update.sh" "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh"
                    exit "${RET_ERROR_COPY_FAILED}"
                fi

                # call ourselves again
                "${MY_DIR_FULLPATH}/conda-bootstrapper-update.sh" "$@"
                ret=$?
                exit $ret
            else
                # we need to remove the temporary template version of ourself,
                # so that we can just iterate the rest of the files
                safe_rm "${my_tempdir}/template/conda-bootstrapper-update.sh"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                ensure_cd "${my_tempdir}/template"
                ret=$?
                if [ $ret -ne 0 ]; then
                    exit $ret
                fi

                for filename in *; do
                    if [ ! -f "${filename}" ]; then
                        continue
                    fi

                    needs_copy=false

                    if [ ! -f "${MY_DIR_FULLPATH}/${filename}" ]; then
                        needs_copy=true
                    fi

                    if [ "${needs_copy}" = false ]; then
                        is_file_same "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                        ret=$?
                        if [ $ret -gt 2 ]; then
                            exit $ret
                        elif [ $ret -eq 1 ]; then
                            needs_copy=true
                        fi
                    fi

                    if [ "${needs_copy}" = true ]; then
                        # file is different, needs to be updated
                        log_info "${filename} needs to be copied, copying"

                        safe_rm "${MY_DIR_FULLPATH}/${filename}"
                        ret=$?
                        if [ $ret -ne 0 ]; then
                            exit $ret
                        fi

                        mv "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                        if [ $ret -ne 0 ]; then
                            log_fatal "failed to copy '%s' to '%s'" "${my_tempdir}/template/${filename}" "${MY_DIR_FULLPATH}/${filename}"
                            exit "${RET_ERROR_COPY_FAILED}"
                        fi
                    fi
                done
            fi
        )
    }

    #endregion Public Functions
    #############################################################################

    ############################################################################
    #region Private Functions

    #---------------------------------------------------------------------------
    __main() {
        check_tools
        ret=$?
        if [ $ret -ne 0 ];then
            return $ret
        fi

        (
            ensure_cd "${MY_DIR_FULLPATH}"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            create_my_tempdir
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            ensure_conda_bootstrapper
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            # re-include constants.sh if the fence value is missing,
            # in case file didn't exist earlier
            if [ "${CONDA_BOOTSTRAPPER_CONSTANTS_LOADED:-}" = "" ]; then
                # shellcheck disable=SC1091
                . "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
                ret=$?
                if [ $ret -ne 0 ]; then
                    log_fatal "Failed to source '%s'" "${CONDA_BOOTSTRAPPER_FULLPATH}/src/constants.sh"
                    exit "${RET_ERROR_COULD_NOT_SOURCE_FILE}"
                fi
            fi

            update_condabootstrapper
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            copy_temporary_template_files
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi

            compare_and_update_files "$@"
            ret=$?
            if [ $ret -ne 0 ]; then
                exit $ret
            fi
        )
        ret=$?
        return $ret
    }

    #endregion Private Functions
    ############################################################################

    ############################################################################
    #region Immediate

    __main "$@"
    ret=$?
    exit $ret

    #endregion Immediate
    ############################################################################

)
ret=$?
exit $ret
