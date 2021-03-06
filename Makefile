.PHONY: all
all: dotfiles etc bin tmux vim ## Installs the bin and etc directory files and the dotfiles.

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	./install.sh bash

.PHONY: etc
etc: ## Add aliases for things in etc
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		if [[ -f "$$f" ]]; then sudo mv "$$f" "$$f".bak; fi; \
	 	sudo ln -sf "$$file" "$$f"; \
	done

.PHONY: bin
bin: ## Add aliases for things in bin.
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: tmux
tmux: ## Installs the tmux configuration.
	./install.sh tmux

.PHONY: vim
vim: ## Installs the vim plugins and associated languages.
	./install.sh vim

.PHONY: test_install_fedora_thirty_two
test_install_fedora_thirty_two: shellcheck ## Run all tests and do an full installation within a Fedora 30 container.
	cd test_install/fedora_32 && ./test_dotfiles.sh

.PHONY: test_install_fedora_thirty_one
test_install_fedora_thirty_one: shellcheck ## Run all tests and do an full installation within a Fedora 31 container.
	cd test_install/fedora_31 && ./test_dotfiles.sh

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	./lint.sh

.PHONY: tests
tests: shellcheck ## Run shellcheck and tests
	for file in $(shell find . -type d -name tests); do \
		bats "$$file" || exit 1; \
	done

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
