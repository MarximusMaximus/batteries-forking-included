# pytest-prefer-nested-dup-tests - Contributing

Contributions will be considered via standard Github Pull Requests.

## Development Environment First Time Setup

1. Install `conda` (tested w/ [miniforge])

2. `cd` into repo directory.

3. Setup conda environment:

    ```sh
    $ conda env create --name pytest-prefer-nested-dup-tests --file ./conda-environment.yml -v
    ```

4. Activate conda env:

    ```sh
    $ conda activate pytest-prefer-nested-dup-tests
    ```

5. Install dependencies via poetry:

    ```sh
    $ poetry install
    ```

## Development Environment Updating

1. Update conda env:

    ```sh
    $ conda env update --name pytest-prefer-nested-dup-tests --file ./conda-environment.yml --prune -v
    ```

2. Update additional dependencies via poetry:

    ```sh
    $ poetry install
    ```

## Moving Forward Dependencies' Versions

- Conda:
  - Manually update version pins in `conda-environment.yml`
- Poetry:
  - Option 1: Manually update dependencies in `pyproject.toml`
  - Option 2: Use `poetry update` command.

## Testing

A cross-python version test matrix can be run locally with [tox]:

```sh
    $ tox
```

Current python version only tests can be run locally with [pytest]:

```sh
    $ pytest
```

[miniforge]: <https://github.com/conda-forge/miniforge>
[pytest]: <https://github.com/pytest-dev/pytest>
[tox]: <https://tox.readthedocs.org/en/latest/>
