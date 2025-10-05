#!/bin/bash

set -e

if ! command -v mockgen &> /dev/null; then
    echo "Installing mockgen..."
    go install go.uber.org/mock/mockgen@latest
fi

rm -rf mocks

echo "Generating mocks..."

while IFS= read -r file; do
    package=$(grep -m 1 "^package " "$file" | awk '{print $2}')

    if grep -q "^type .* interface {" "$file"; then
        rel_path="${file#./}"
        dir_path=$(dirname "$rel_path")
        filename=$(basename "$file" .go)
        path_no_slashes="${dir_path//\/}"
        mock_dir="mocks/${path_no_slashes}"
        mkdir -p "$mock_dir"
        mock_file="$mock_dir/${path_no_slashes}${filename}.go"

        mockgen -source="$file" -destination="$mock_file" -package="${path_no_slashes}mocks" 2>/dev/null || true
    fi
done < <(find . -name "*.go" -not -path "*/vendor/*" -not -path "*/mocks/*" -not -path "*_test.go")

echo "Mocks generated successfully"
