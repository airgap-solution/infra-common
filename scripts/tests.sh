mkdir -p coverage

go test -coverprofile coverage/cover.out -v ./...
grep -v -E -f .covignore coverage/cover.out > coverage/coverage.filtered.out
mv coverage/coverage.filtered.out coverage/cover.out

COVERAGE="$(go tool cover -func=coverage/cover.out | grep "total" | tail -n 1 | grep -Eo '[0-9]+\.[0-9]+')"

if [[ $COVERAGE != "100.0" ]] then
    echo "coverage threshold of 100% not met"
fi
