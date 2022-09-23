USERNAME := tjmaynes

install_gaia:
	./scripts/install.sh "gaia" "darwin" "$(USERNAME)"

install_demeter:
	./scripts/install.sh "demeter" "darwin" "$(USERNAME)"

install_glaucus:
	./scripts/install.sh "glaucus" "nixos" "$(USERNAME)" "80"

install_apollo:
	./scripts/install.sh "apollo" "linux" "$(USERNAME)"

install_kratos:
	./scripts/install.sh "kratos" "docker" "$(USERNAME)"

reload:
	./scripts/reload.sh

.PHONY: install_* reload
