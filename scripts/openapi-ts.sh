SERVICE_NAME=$1
VERSION=$(cat VERSION)

rm -rf openapi/clientgen/ts
# Generate TypeScript Axios client
openapi-generator-cli generate \
  -i openapi/${SERVICE_NAME}.yaml \
  -g typescript-axios \
  -o /tmp/oapi \
  --additional-properties=npmName=@airgap-solution/${SERVICE_NAME},supportsES6=true,withInterfaces=true

# Ensure target directory exists
mkdir -p openapi/clientgen/ts/src

# Copy everything (including subdirs and dotfiles)
cp -r /tmp/oapi/. openapi/clientgen/ts/src/
rm -rf /tmp/oapi

# Create package.json if missing
if [ ! -f "openapi/clientgen/ts/package.json" ]; then
    echo "Creating package.json..."
    cat > openapi/clientgen/ts/package.json <<EOF
{
  "name": "@airgap-solution/${SERVICE_NAME}",
  "version": "${VERSION}",
  "description": "TypeScript client",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "files": [
    "dist/",
    "src/"
  ],
  "scripts": {
    "build": "tsc --declaration",
    "clean": "rm -rf dist/",
    "prepare": "yarn run build"
  },
  "devDependencies": {
    "@openapitools/openapi-generator-cli": "^2.7.0",
    "typescript": "^5.0.0"
  },
  "publishConfig": {
    "registry": "https://registry.npmjs.org"
  }
}
EOF
fi

# Create tsconfig.json if missing
if [ ! -f "openapi/clientgen/ts/tsconfig.json" ]; then
    echo "Creating tsconfig.json..."
    cat > openapi/clientgen/ts/tsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["ES2020", "DOM"],
    "declaration": true,
    "declarationMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
fi

# Create .npmrc if missing
if [ ! -f "openapi/clientgen/ts/.npmrc" ]; then
    echo "Creating .npmrc..."
    cat > openapi/clientgen/ts/.npmrc <<EOF
registry=https://registry.npmjs.org/
@airgap-solution:registry=https://registry.npmjs.org/
@airgap-solution:access=public
EOF
fi

# Build client
echo "Installing TypeScript client dependencies and building..."
cd openapi/clientgen/ts
yarn install --silent
yarn build

if [ ! -f "dist/index.d.ts" ]; then
    echo "⚠️ No top-level index.d.ts found, generating a shim..."
    echo "export * from './';" > dist/index.d.ts
fi

cd - > /dev/null
echo "✅ OpenAPI generation complete! TypeScript client built into dist/ with typings."
