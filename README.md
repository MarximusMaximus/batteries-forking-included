# batteries-forking-included

<https://github.com/MarximusMaximus/batteries-forking-included>

by Marximus Maximus (<https://marximus.com>)

Single command installer for users and developers for git repos/projects. Sets up either a user environment or development environment for running or contributing to a project. There is no longer a need for a whole readme file with many steps of setup.

## Features

- `bootstrap.sh` - Automatically downloads and installs/updates to latest miniforge, sets up/updates project env.
- `activate.sh` - Activates conda environment for project.
- `run.sh` - Runs command within conda environment for project. (Will try default command if first arg is not a path to an executable file.)
- Python File Preamble - Automatically activates conda env when attempting to run python script directly. (Optional)
- `bfi-update.sh` - Updates stub files within your project to latest versions
- `post-bootstrap.sh` - Any additional commands to run after main environment setup provided by conda, pip, or poetry. (Optional)

Additional Files:

- `conda-environment.yml` - (required) the conda environment definition for your project, default starting file is included
- `pip-requirements.txt` (optional) - pip requirements to install (example provided)
- `pip-constraints.txt` (optional) - pip constraints to be used with pip-requirements.txt (example provided)
- `pip-uninstall.txt` (optional) - pip packages to uninstall list (explicitly remove old packages you no longer use) (example provided)
- `pyproject.toml` w/ `[tool.poetry]` line (optional) - poetry data & requirements that will be installed (takes precedence over pip) (example provided)

## Usage (user of your project)

1. User clones or otherwise acquires your project.
2. User runs `bootstrap.sh` from within your project.
3. User runs either `run.sh` or your custom entry points to your project.

## Usage (developer of your project)

### Initial Addition To Project

1. Create a `conda-environment.yml` file in the root of your project with these contents:

```yaml
channels:
  - nodefaults
  - conda-forge
dependencies:
  - python<3.11
```

2. If you plan to use poetry (recommended), add this line to the end of `conda-environment.yml`:

```yaml
  - poetry
```

2. Copy latest `bfi-update.sh` to your project root.
3. Run `bfi-update.sh` from within your project root.
   1. `cd YOUR_PROJECT_ROOT_FOLDER`
   2. `./bfi-update.sh`
5. (Optional) Modify `conda-environment.yml` and `pip-*.txt` directly and/or `pyproject.toml` (via `poetry` commands) as desired.
6. (Optional) Modify `post-bootstrap.sh` with any additional commands you wish to run during bootstrapping an environment (such as creating additional conda envs or running npm commands.)
7. Run `bootstrap.sh --dev` to create environment.

### Initial Setup for New Developer

1. Run `bootstrap.sh --dev` to create environment.

### Update batteries-forking-included Stubs

1. Run `bfi-update.sh` from within your project root.
2. Run `bootstrap.sh --dev` to update environment.

### Update Project Environment

1. (Optional) Modify `conda-environment.yaml` and `pip-*` directly and/or `pyproject.toml` (via `poetry` commands) as desired.
   1. NOTE: If using `poetry`, remember to run `poetry update` if you want your dependencies' pinned versions updated!
2. Run `bootstrap.sh --dev` to create environment.

### Raw Deployments (i.e. Direct To Metal)

1. Clone or otherwise acquire your project to its destination.
2. Run `bootstrap.sh --deploy` to create environment.
3. Setup your favorite supervisor software to run `run.sh` with a current working directory of your project root.

## Bug Reports / Feature Requests

Please submit bug reports and feature requests to:
<https://github.com/MarximusMaximus/batteries-forking-included/issues>

## Development & Contribution

Pull Requests will be reviewed at:
<https://github.com/MarximusMaximus/batteries-forking-included/pulls>

## Like My Work & Want To Support It?

- Main Website: <https://marximus.com>
- Patreon (On Going Support): <https://www.patreon.com/marximus>
- Ko-fi (One Time Tip): <https://ko-fi.com/marximusmaximus>
