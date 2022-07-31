USERNAME := tjmaynes

install_gaia:
	./scripts/install.sh "gaia" "darwin" "$(USERNAME)"

install_demeter:
	./scripts/install.sh "demeter" "darwin" "$(USERNAME)"

install_glaucus:
	./scripts/install.sh "glaucus" "nixos" "$(USERNAME)"

reload:
	./scripts/reload.sh

.PHONY: install_* reload
