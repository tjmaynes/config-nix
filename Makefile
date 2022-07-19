USERNAME := tjmaynes

install_submodules:
	git submodule update --init --recursive

install_gaia: install_submodules
	./scripts/install.sh "gaia" "$(USERNAME)"

install_demeter: install_submodules
	./scripts/install.sh "demeter" "$(USERNAME)"

install_glaucus: install_submodules
	./scripts/install.sh "glaucus" "$(USERNAME)"

install_hera: install_submodules
	./scripts/install.sh "hera" "$(USERNAME)"

reload:
	./scripts/reload.sh

.PHONY: install_* reload
