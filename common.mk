.PHONY: openapi check-vars

REQUIRED_VARS = SERVICE_NAME

check-vars:
	$(foreach var,$(REQUIRED_VARS),$(if $($(var)),,$(error Error: Makefile variable $(var) is not set.)))

openapi: check-vars
	@scripts/openapi.sh $(SERVICE_NAME)
