.DEFAULT_GOAL := help

all: build

.PHONY:
install:  ## setup user environment
	./bootstrap.sh

setup: install

.PHONY:
install-dev:  ## setup development environment
	./bootstrap.sh --dev

setup-dev: install-dev

.PHONY:
build: ## build wheels and sdists
	./run.sh poetry build

.PHONY:
extract-build: build ## extract built archives into folders
	cd dist; for x in *; do mkdir "$$x-extracted"; tar -xzf "$$x" -C "$$x-extracted"; done

.PHONY:
clean: ## clean all temp, cache, and build files
	rm -rf .mypy_cache
	rm -rf .pytest_cache
	rm -rf .reports
	rm -rf dist
	rm -rf htmlcov
	rm -f .coverage
	rm -f .coverage.*
	rm -f cov.xml
	rm -f coverage.cobertura.xml
	rm -f coverage.json
	rm -f coverage.html
	rm -f coverage.xml
	rm -f jacoco.xml
	rm -f lcov.info
	rm -f lcov.xml
	find . \( -name '__pycache__' -or -name '*.pyc' -or -name '*.pyo' -or -name '*.pyd' \) -print0 | xargs -r0 rm -rf

.PHONY:
clean-old: ## remove all *.old files
	find . -name '*.old' -print0 | xargs -r0 rm -f

.PHONY:
clean-tox: ## remove tox environments
	rm -rf .tox

.PHONY:
sterile: clean clean-old clean-tox ## clean EVERYTHING

superclean: sterile

.PHONY:
run: ## run software
	./run.sh

.PHONY:
update-bfi: ## update batteries-forking-included files
	./bfi-update.sh

.PHONY:
quicktest: ## run tests for latest python version
	./run.sh tox -e py310 -- --verbose

.PHONY:
legacytest: ## run tests for oldest supported python version
	./run.sh tox -e py38 -- --verbose

.PHONY:
coverage: ## gather coverage data
	./run.sh tox -e coverage -- --verbose

.PHONY:
lint: ## run all linters
	./run.sh tox -e lint -- --verbose

.PHONY:
test: ## run all tests for all python versions, linters, and gather coverage
	./run.sh tox

check: test

.PHONY:
help: ## show this help message
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%s\n\n" "Usage: make [task]"; \
	printf "%-20s %s\n" "task" "help" ; \
	printf "%-20s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-20s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
	done
