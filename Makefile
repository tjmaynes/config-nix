USERNAME := tjmaynes

deploy_gaia:
	./scripts/deploy.sh "gaia" "$(USERNAME)"

deploy_aether:
	./scripts/deploy.sh "aether" "$(USERNAME)"

deploy_infinity:
	./scripts/deploy.sh "infinity" "$(USERNAME)"

reload:
	./scripts/reload.sh
