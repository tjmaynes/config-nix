USERNAME := tjmaynes

install_submodules:
	git submodule update --init --recursive

install_gaia: install_submodules
	./scripts/install.sh "gaia" "darwin" "$(USERNAME)"

install_demeter: install_submodules
	./scripts/install.sh "demeter" "darwin" "$(USERNAME)"

install_glaucus: install_submodules
	./scripts/install.sh "glaucus" "nixos" "$(USERNAME)"

reload:
	./scripts/reload.sh

.PHONY: install_* reload
