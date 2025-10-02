#!/bin/bash

SERVICE_NAME=$1
PACKAGE_NAME=${SERVICE_NAME//-/}

openapi-generator-cli generate \
  -i openapi/${SERVICE_NAME}.yaml \
  -g go-server \
  -o /tmp/oapi \
  --additional-properties=packageName=${PACKAGE_NAME}

rm -rf openapi/servergen
mkdir -p openapi/servergen
mv /tmp/oapi/go/ openapi/servergen
rm -rf /tmp/oapi

openapi-generator-cli generate \
  -i openapi/${SERVICE_NAME}.yaml \
  -g go \
  -o /tmp/oapi \
  --additional-properties=packageName=${PACKAGE_NAME}

rm -rf openapi/clientgen
mkdir -p openapi/clientgen/go
mv /tmp/oapi/*.go openapi/clientgen/go
rm -rf /tmp/oapi
