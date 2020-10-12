// https://golang.cafe/blog/golang-random-number-generator.html
// https://golang.org/pkg/math/rand/
// Top-level functions, such as Float64 and Int, use a default shared Source that produces a deterministic sequence of values each time a program is run. Use the Seed function to initialize the default Source if different behavior is required for each run

package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    min := 1
    max := 30
    fmt.Println(rand.Intn(rand.Intn(max - min + 1) + min))
}
