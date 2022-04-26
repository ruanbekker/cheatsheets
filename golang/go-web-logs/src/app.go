package main

import (
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	log.SetFormatter(&log.JSONFormatter{})
	log.Info("starting server")
	http.HandleFunc("/", hostnameHandler)
	http.ListenAndServe("0.0.0.0:8080", nil)
}

func hostnameHandler(w http.ResponseWriter, r *http.Request) {
	log.SetFormatter(&log.JSONFormatter{})
	log.WithFields(log.Fields{"health": "ok"}).Info("service is healthy")
}
