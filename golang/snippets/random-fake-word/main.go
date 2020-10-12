package main

import (
    "fmt"
    "github.com/bxcodec/faker"
)

func main() {
    randomDay := faker.DayOfWeek()
    fmt.Println("Hi:", randomDay)
}
