package handler

import "net/http"

// Health is a liveness probe — returns 200 as long as the process is up.
func Health(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

// Ready is a readiness probe — should fail when downstream dependencies
// (DB, etc.) are not yet usable. Currently a stub: returns 200 because
// the scaffold has no dependencies wired yet.
func Ready(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ready"})
}
