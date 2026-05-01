//go:build tools

// Package tools pins development tool dependencies so their versions
// are tracked in go.mod instead of floating @latest. Install via
// `go install <tool>`; this file itself is excluded from normal builds.
package tools

import (
	_ "github.com/pressly/goose/v3/cmd/goose"
	_ "github.com/stephenafamo/bob/gen/bobgen-psql"
	_ "golang.org/x/vuln/cmd/govulncheck"
	_ "honnef.co/go/tools/cmd/staticcheck"
)
