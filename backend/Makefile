-include .env
export

GOVULNCHECK_VERSION := v1.1.4
GOLANGCI_LINT_VERSION := v1.64.5
GOOSE_VERSION := v3.22.1

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## test: run all tests
.PHONY: test
test:
	go test -v -race -buildvcs ./...

## test/cover: run all tests and display coverage
.PHONY: test/cover
test/cover:
	go test -v -race -buildvcs -coverprofile=/tmp/coverage.out ./...
	go tool cover -html=/tmp/coverage.out

## lint: run golangci-lint
.PHONY: lint
lint:
	golangci-lint run

## vuln: run govulncheck against known vulnerability database
.PHONY: vuln
vuln:
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION) ./...

## audit: tidy + vet + lint + vulncheck
.PHONY: audit
audit: test
	go mod tidy -diff
	go mod verify
	go vet ./...
	golangci-lint run
	go run golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION) ./...

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## tidy: tidy modfiles and format .go files
.PHONY: tidy
tidy:
	go mod tidy -v
	go fmt ./...

## build: build the cmd/api binary
.PHONY: build
build:
	go build -o=./tmp/api ./cmd/api

## run: build and run with air hot-reload
.PHONY: run
run: build
	air

# ==================================================================================== #
# SQL MIGRATIONS
# ==================================================================================== #

## migrations/new name=$1: create a new database migration
.PHONY: migrations/new
migrations/new:
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations create ${name} sql

## migrations/up: apply all up database migrations
.PHONY: migrations/up
migrations/up:
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations postgres "postgres://${DB_DSN}" up

## migrations/down: apply all down database migrations
.PHONY: migrations/down
migrations/down:
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations postgres "postgres://${DB_DSN}" down

## migrations/refresh: reset and re-apply all database migrations
.PHONY: migrations/refresh
migrations/refresh:
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations postgres "postgres://${DB_DSN}" reset
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations postgres "postgres://${DB_DSN}" up

## migrations/version: print the current in-use migration version
.PHONY: migrations/version
migrations/version:
	go run github.com/pressly/goose/v3/cmd/goose@$(GOOSE_VERSION) -dir ./assets/migrations postgres "postgres://${DB_DSN}" version

# ==================================================================================== #
# CODE GENERATION
# ==================================================================================== #

## models/regenerate: regenerate Bob ORM models against the live DB schema
.PHONY: models/regenerate
models/regenerate:
	PSQL_DSN="postgres://${DB_DSN}" go run github.com/stephenafamo/bob/gen/bobgen-psql -c ./bobgen.yaml
