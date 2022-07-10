#!/usr/bin/env sh
./bfi-update.sh
(
    cd examples || exit 1

    for x in *; do
        if [ "$x" != "batteries-forking-included" ]; then
            ../bfi-update.sh --project-dir "${x}"
        fi
    done
)
(
    cd src/batteries_forking_included || exit 1
    cp ./template/* .
)
poetry install
