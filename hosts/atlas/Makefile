ENVIRONMENT := development

include .env.$(ENVIRONMENT)
export $(shell sed 's/=.*//' .env.$(ENVIRONMENT))

install:
	./scripts/$@.sh

stop:
	./scripts/$@.sh

backup:
	./scripts/$@.sh

restore:
	./scripts/$@.sh
