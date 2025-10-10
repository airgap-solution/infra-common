#!/bin/bash

if ! [ -x "$(command -v golangci-lint)" ]; then
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../.golangci.yml"

golangci-lint run --config="${CONFIG_FILE}" || exit 1
