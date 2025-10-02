
#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME=$1
PACKAGE_NAME=${SERVICE_NAME//-/}
BASE_DIR="$(pwd)/openapi"
TMP_OUT="/tmp/oapi"

SERVER_OUT="$BASE_DIR/servergen"
CLIENT_OUT="$BASE_DIR/clientgen/go"

rm -rf "$TMP_OUT"
mkdir -p "$TMP_OUT"

openapi-generator-cli generate \
  -i "$BASE_DIR/${SERVICE_NAME}.yaml" \
  -g go-server \
  -o "$TMP_OUT" \
  --skip-validate-spec \
  --additional-properties=packageName="${PACKAGE_NAME}"

rm -rf "$SERVER_OUT"
mkdir -p "$SERVER_OUT"
mv "$TMP_OUT/go" "$SERVER_OUT"

rm -rf "$TMP_OUT"
mkdir -p "$TMP_OUT"

openapi-generator-cli generate \
  -i "$BASE_DIR/${SERVICE_NAME}.yaml" \
  -g go \
  -o "$TMP_OUT" \
  --skip-validate-spec \
  --additional-properties=packageName="${PACKAGE_NAME}"

rm -rf "$CLIENT_OUT"
mkdir -p "$CLIENT_OUT"
mv "$TMP_OUT/"*.go "$CLIENT_OUT/"

rm -rf "$TMP_OUT"

cd "$BASE_DIR" || exit
go mod tidy
cd - > /dev/null

echo "OpenAPI generation complete!"
echo "Server code: $SERVER_OUT"
echo "Client code: $CLIENT_OUT"
