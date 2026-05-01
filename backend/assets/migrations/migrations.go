// Package migrations exposes the SQL migration files in this directory
// as an embedded filesystem so the running binary can apply them at
// startup without a separate goose CLI invocation.
//
// The same .sql files are still consumed by `make migrations/up` via
// the goose CLI; the embed below is a parallel, in-process pathway.
package migrations

import "embed"

// FS holds every .sql file in this directory at build time.
//
//go:embed *.sql
var FS embed.FS
