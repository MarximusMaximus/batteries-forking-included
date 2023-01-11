# batteries-forking-included

<https://github.com/MarximusMaximus/batteries-forking-included>

by Marximus Maximus (<https://marximus.com>)

A single command cross-platform all-in-one installer for users and developers for git repos/projects. Completely sets up either a user environment or development environment from scratch. No longer deal with pages of steps of setup nor dependency hell!

**NOTE: Currently in Alpha Phase**

## Features

- `bootstrap.sh` - Automatically downloads and installs/updates to latest miniforge, sets up/updates project's conda environment.
- `activate.sh` - Activates conda environment for project.
- `run.sh` - Runs specified command within project's conda environment. (Will try default command if first arg is not a path to an executable file nor script.)
- Python File Preamble - Automatically activates project's conda environment when attempting to run python script directly. (Optional)
- `bfi-update.sh` - Updates batteries-forking-included files within your project to latest versions
- `post-bootstrap.sh` - Any additional commands to run after environment setup provided by supported package managers (currently: conda, poetry, & pip).

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
  - git
  - python<3.11
```

2. If you plan to use poetry (recommended), add this line to the end of `conda-environment.yml`:

```yaml
  - poetry
```

3. Copy latest `bfi-update.sh` to your project root.
4. Run `bfi-update.sh` from within your project root.
   1. `cd YOUR_PROJECT_ROOT_FOLDER`
   2. `./bfi-update.sh`
6. (Optional) Modify `conda-environment.yml` and `pip-*.txt` directly and/or `pyproject.toml` (via `poetry` commands) as desired.
7. Remove the line `# TODO: do additional setup/update things here; if nothing to do, just delete this line` from `post-bootstrap.sh`.
8. (Optional) Modify `post-bootstrap.sh` with any additional commands you wish to run during bootstrapping an environment (such as creating additional conda envs or running npm commands.)
9. Run `bootstrap.sh --dev` to create development environment.

### Initial Setup for New Developer

1. Developer clones or otherwise acquires project repo.
2. Run `bootstrap.sh --dev` to create development environment.

### Update batteries-forking-included Stubs

1. Run `bfi-update.sh` from within your project root.
2. Run `bootstrap.sh --dev` to update environment.
    - (`--dev` here is optional if you already have a development environment)

### Update Project Environment

1. (Optional) Modify `conda-environment.yaml` and `pip-*` directly and/or `pyproject.toml` (via `poetry` commands) as desired.
   1. NOTE: If using `poetry`, remember to run `poetry update` if you want your dependencies' pinned versions updated!
2. Run `bootstrap.sh --dev` to update environment.
    - (`--dev` here is optional if you already have a development environment)

### Raw Deployments (i.e. Direct To Metal)

**NOT YET IMPLEMENTED**

1. Clone or otherwise acquire your project to its destination.
2. Run `bootstrap.sh --deploy` to create environment.
3. Setup your favorite supervisor software to run `run.sh` with a current working directory of your project root.

### Docker Deployments

**TBD**

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
