package main

import (
    "io/ioutil"
    "encoding/json"
    "log" 
    "net/http"
)

type Response struct {
    Data string `json:"value"`
}

func getDataFromExternalEndpoint() (*Response, error) {
    url := "https://api.chucknorris.io/jokes/random"
    resp, err := http.Get(url)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return nil, err
    }
    var response Response
    err = json.Unmarshal(body, &response)
    if err != nil {
        return nil, err
    }
    return &response, nil
}


func handler(w http.ResponseWriter, r *http.Request) {
    response, err := getDataFromExternalEndpoint()
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    json.NewEncoder(w).Encode(response)
}


func main() {
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}


