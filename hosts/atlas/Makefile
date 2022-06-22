ENVIRONMENT := development

include .env.$(ENVIRONMENT)
export $(shell sed 's/=.*//' .env.$(ENVIRONMENT))

install:
	./scripts/install.sh

stop:
	./scripts/stop.sh

backup:
	./scripts/backup.sh
