#!/bin/bash

if ! [ -x "$(command -v golangci-lint)" ]; then
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.2
fi

golangci-lint run --enable-all \
--disable depguard \
--disable wsl \
--disable exhaustruct \
--disable gochecknoglobals \
--disable gofumpt \
--disable varnamelen \
--disable nlreturn \
|| exit 1
