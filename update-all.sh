#!/usr/bin/env sh
bfi_dir="$(pwd)"
export bfi_dir

./bfi-update.sh
(
    cd examples || exit 1

    for x in *; do
        if [ "$x" != "batteries-forking-included" ]; then
            ../bfi-update.sh --project-dir="${x}" --bfi-dir="${bfi_dir}"
        fi
    done
)
(
    cd src/batteries_forking_included || exit 1
    ../../bfi-update.sh --project-dir="$(pwd)" --bfi-dir="${bfi_dir}"
)
./run.sh poetry install

# HACK: fix poetry removing important shit
# shellcheck disable=SC1091
. "$(dirname "$(dirname "$CONDA_EXE")")"/etc/profile.d/conda.sh
conda activate base
CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda install --force-reinstall -y -v pip wheel setuptools
conda activate batteries-forking-included
CONDA_PATH_CONFLICT=clobber CONDA_ALWAYS_COPY=true conda install --force-reinstall -y -v pip wheel setuptools
