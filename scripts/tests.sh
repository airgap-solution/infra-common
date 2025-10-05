#!/bin/bash
mkdir -p coverage
go test -coverprofile coverage/cover.out -v ./...
grep -v -E -f .covignore coverage/cover.out > coverage/coverage.filtered.out
mv coverage/coverage.filtered.out coverage/cover.out

echo ""
echo "Coverage by file:"
go tool cover -func=coverage/cover.out | awk '
    !/total:/ {
        split($1, parts, ":")
        file = parts[1]
        gsub(/%/, "", $NF)
        coverage[file] += $NF
        count[file]++
    }
    END {
        for (f in coverage) {
            printf "%s: %.1f%%\n", f, coverage[f]/count[f]
        }
    }
' | sort

COVERAGE="$(go tool cover -func=coverage/cover.out | grep "total" | tail -n 1 | grep -Eo '[0-9]+\.[0-9]+')"
echo ""
echo "Total coverage: $COVERAGE%"

if [[ $COVERAGE != "100.0" ]]; then
    echo "coverage threshold of 100% not met"
    exit 1
fi
