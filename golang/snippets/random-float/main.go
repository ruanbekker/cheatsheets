package main

import (
	"fmt"
  "time"
	"math/rand"
)

func floatrandom() float64 {
  rand.Seed(time.Now().UnixNano())
	return rand.Float64()
}

func main() {

	res1 := floatrandom()
	res2 := floatrandom()
	res3 := floatrandom()

	// Displaying results
	fmt.Println("Result 1: ", res1)
	fmt.Println("Result 2: ", res2)
	fmt.Println("Result 3: ", res3)
}
