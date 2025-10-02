.PHONY: openapi check-vars

REQUIRED_VARS = SERVICE_NAME

check-vars:
	@$(foreach var,$(REQUIRED_VARS),\
		if [ -z "$$$(var)" ]; then \
			echo "Error: Environment variable $(var) is not set."; \
			exit 1; \
		fi;)

openapi: check-vars
	@scripts/openapi.sh ${SERVICE_NAME}
