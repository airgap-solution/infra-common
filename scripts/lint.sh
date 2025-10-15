#!/bin/bash

# Set GOPATH if not already set
if [ -z "$GOPATH" ]; then
  GOPATH="$(go env GOPATH)"
fi

GOLANGCI_LINT="${GOPATH}/bin/golangci-lint"

if ! [ -x "$GOLANGCI_LINT" ]; then
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../.golangci.yml"

"$GOLANGCI_LINT" run --config="${CONFIG_FILE}" || exit 1
