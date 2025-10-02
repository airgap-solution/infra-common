#!/bin/bash
set -euo pipefail

SERVICE_NAME=$1
PACKAGE_NAME=${SERVICE_NAME//-/}
BASE_DIR="$(pwd)/openapi"

# Directories
SERVER_OUT="$BASE_DIR/servergen"
CLIENT_OUT="$BASE_DIR/clientgen/go"

# Clean previous output
rm -rf "$SERVER_OUT" "$CLIENT_OUT"
mkdir -p "$SERVER_OUT" "$CLIENT_OUT"

# Generate Go server
openapi-generator-cli generate \
  -i "$BASE_DIR/${SERVICE_NAME}.yaml" \
  -g go-server \
  -o "$SERVER_OUT" \
  --additional-properties=packageName="${PACKAGE_NAME} --skip-validate-spec"

# Generate Go client
openapi-generator-cli generate \
  -i "$BASE_DIR/${SERVICE_NAME}.yaml" \
  -g go \
  -o "$CLIENT_OUT" \
  --additional-properties=packageName="${PACKAGE_NAME} --skip-validate-spec"

echo "OpenAPI generation complete!"
echo "Server code: $SERVER_OUT"
echo "Client code: $CLIENT_OUT"
