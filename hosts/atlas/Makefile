ENVIRONMENT := development

include .env.$(ENVIRONMENT)
export $(shell sed 's/=.*//' .env.$(ENVIRONMENT))

start:
	./scripts/$@.sh

stop:
	./scripts/$@.sh

backup:
	./scripts/$@.sh

restore:
	./scripts/$@.sh

destroy: stop
	./scripts/$@.sh

dev:
	vagrant up --provision
