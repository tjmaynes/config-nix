USERNAME := tjmaynes

install_gaia:
	./scripts/install.sh "gaia" "$(USERNAME)"

install_demeter:
	./scripts/install.sh "demeter" "$(USERNAME)"

install_glaucus:
	./scripts/install.sh "glaucus" "$(USERNAME)"

install_atlas:
	./scripts/install-atlas.sh

stop_atlas:
	./scripts/stop-atlas.sh

backup_atlas:
	./scripts/backup-atlas.sh

reload:
	./scripts/reload.sh

.PHONY: install_* reload
