USERNAME := tjmaynes

deploy_gaia:
	./scripts/deploy.sh "gaia" "$(USERNAME)"

deploy_aether:
	./scripts/deploy.sh "aether" "$(USERNAME)"

deploy_infinity:
	./scripts/deploy.sh "infinity" "$(USERNAME)"

deploy_demeter:
	./scripts/deploy.sh "demeter" "$(USERNAME)"

reload:
	./scripts/reload.sh
