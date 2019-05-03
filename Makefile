.PHONY: all
# all: bin dotfiles etc ## Installs the bin and etc directory files and the dotfiles.
all: dotfiles etc bin tmux vim## Installs the bin and etc directory files and the dotfiles.

.PHONY: bin
bin: ## Installs the bin directory files.
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	./install.sh bash

.PHONY: vim
vim: ## Installs the vim plugins
	./install.sh vim

.PHONY: tmux
tmux: ## Installs the vim plugins
	./install.sh tmux

.PHONY: etc
etc: ## Installs the etc directory files.
	# sudo mkdir -p /etc/docker/seccomp
	# for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
	# 	f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
	# 	sudo mkdir -p $$(dirname $$f); \
	# 	sudo ln -f $$file $$f; \
	# done
	# systemctl --user daemon-reload || true
	# sudo systemctl daemon-reload
	# sudo systemctl enable systemd-networkd systemd-resolved
	# sudo systemctl start systemd-networkd systemd-resolved
	# sudo ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

.PHONY: tests
tests: shellcheck docker_test ## Runs all the tests on the files in the repository.

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	./lint.sh

.PHONY: docker_test
docker_test:
	cd tests && ./dotfiles.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
