package handler

import "net/http"

// Hello is the placeholder endpoint the frontend hits to confirm
// the backend is reachable. Phase 1 will replace this with the
// government-services intent router.
func Hello(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"message": "வெளி — open. clear. civic.",
		"phase":   0,
	})
}
