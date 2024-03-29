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
./run.sh poetry install --only-root
