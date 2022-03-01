USERNAME := tjmaynes

install_gaia:
	./scripts/install.sh "gaia" "$(USERNAME)"

install_aether:
	./scripts/install.sh "aether" "$(USERNAME)"

install_demeter:
	./scripts/install.sh "demeter" "$(USERNAME)"

install_glaucus:
	./scripts/install.sh "glaucus" "$(USERNAME)" "vmware-fusion"

install_atlas:
	./scripts/install.sh "atlas" "$(USERNAME)" "vmware-fusion"

reload:
	./scripts/reload.sh

.PHONY: install_* reload
