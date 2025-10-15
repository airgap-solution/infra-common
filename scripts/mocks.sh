#!/bin/bash

set -e

# Ensure we have the right PATH for Go binaries
export PATH="$(go env GOPATH)/bin:$PATH"

if ! command -v mockgen &> /dev/null; then
    echo "Installing mockgen..."
    go install go.uber.org/mock/mockgen@latest
fi

# Clean up existing mocks
rm -rf mocks

echo "Generating mocks..."

# Find all Go files with interfaces, excluding vendor, mocks, and test files
while IFS= read -r -d '' file; do
    # Get the package name
    package=$(grep -m 1 "^package " "$file" | awk '{print $2}')

    # Check if file contains interfaces
    if grep -q "^type .* interface {" "$file"; then
        # Calculate paths
        rel_path="${file#./}"
        dir_path=$(dirname "$rel_path")
        filename=$(basename "$file" .go)
        path_no_slashes="${dir_path//\/}"
        mock_dir="mocks/${path_no_slashes}"
        mock_file="$mock_dir/${path_no_slashes}${filename}.go"

        # Create mock directory
        mkdir -p "$mock_dir"

        # Generate mocks with error checking
        if ! mockgen -source="$file" -destination="$mock_file" -package="${path_no_slashes}mocks" 2>/dev/null; then
            echo "Warning: Failed to generate mock for $file"
        fi
    fi
done < <(find . -name "*.go" -not -path "*/vendor/*" -not -path "*/mocks/*" -not -name "*_test.go" -print0)

# Count generated mock files
mock_count=$(find mocks -name "*.go" -type f 2>/dev/null | wc -l)
echo "Generated $mock_count mock files"

if [ "$mock_count" -eq 0 ]; then
    echo "Warning: No mock files were generated. This might indicate an issue with the script or no interfaces found."
    exit 1
fi

echo "Mocks generated successfully"
