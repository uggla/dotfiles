.PHONY: all
# all: bin dotfiles etc ## Installs the bin and etc directory files and the dotfiles.
all: dotfiles etc bin tmux vim## Installs the bin and etc directory files and the dotfiles.

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	./install.sh bash

.PHONY: etc
etc: ## Installs the etc directory files.
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		if [[ -f "$$f" ]]; then sudo mv "$$f" "$$f".bak; fi; \
	 	sudo ln -sf "$$file" "$$f"; \
	done

.PHONY: bin
bin: ## Installs the bin directory files.
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: tmux
tmux: ## Installs the vim plugins
	./install.sh tmux

.PHONY: vim
vim: ## Installs the vim plugins
	./install.sh vim

.PHONY: test_install
test_install: shellcheck test_docker ## Runs all the tests on the files in the repository.

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	./lint.sh

.PHONY: test_docker
test_docker:
	cd tests && ./dotfiles.sh

.PHONY: tests
tests: shellcheck
	bats bash/tests

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
