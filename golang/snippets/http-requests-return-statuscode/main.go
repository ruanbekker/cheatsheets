package main

import (
    "fmt"
    "net/http"
)

func main() {
    url := "https://ruan.dev"
    resp, err := http.Get(url)
    if err != nil {
        fmt.Println("Error while fetching the URL:", err)
        return
    }
    defer resp.Body.Close()
    fmt.Println(resp.StatusCode)
}
