.PHONY: openapi tests mocks lint check-vars

REQUIRED_VARS = SERVICE_NAME

check-vars:
	$(foreach var,$(REQUIRED_VARS),$(if $($(var)),,$(error Error: Makefile variable $(var) is not set.)))

COMMON_MK_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
openapi: check-vars
	@${COMMON_MK_DIR}scripts/openapi-go.sh $(SERVICE_NAME)
tests:
	@${COMMON_MK_DIR}scripts/tests.sh
mocks:
	@${COMMON_MK_DIR}scripts/mocks.sh
lint:
	@${COMMON_MK_DIR}scripts/lint.sh
