package main

import (
  "flag"
  "fmt"
  "os"
  "time"

  "github.com/go-vgo/robotgo"
  "github.com/go-vgo/robotgo/clipboard"
)

func getUnixMilliSeconds() int64 {
  return (time.Now().UnixNano() / 1000 / 1000);
}

type coordinates struct {
  x int
  y int
}

func readClipboard() string {
  text, err := clipboard.ReadAll()
  if err != nil {
    panic(err)
  }
  return text
}

func writeClipboard(text string) {
  if err := clipboard.WriteAll(text); err != nil {
    panic(err)
  }
}

func sleepSeconds(second uint) {
  time.Sleep(time.Duration(second) * time.Second)
}

func sleepMilliSeconds(milliSecond uint) {
  time.Sleep(time.Duration(milliSecond) * time.Millisecond)
}

func ifTenaryUint(condition bool, ifTrue uint, ifFalse uint) uint {
  if condition {
    return ifTrue
  }
  return ifFalse
}

func main() {
  // Fix: Invalid MIT-MAGIC-COOKIE-1 key
  robotgo.SetXDisplayName(os.Getenv("DISPLAY"))

  var verbose bool
  var repeat uint
  flag.BoolVar(&verbose, "v", false, "Verbose")
  flag.UintVar(&repeat, "r", 1, "Number of repeats")
  flag.Parse()

  repeat = ifTenaryUint(repeat > 0 && repeat <= 1000, repeat, 1)

  robotgo.SetKeyDelay(100)
  robotgo.SetMouseDelay(100)

  for i := 0; i < int(repeat); i++ {
    fmt.Printf("\nRunning query %d of %d:\n", i + 1, repeat)

    robotgo.MoveMouse(1016, 573)
    robotgo.MouseClick()
    sleepMilliSeconds(200)

    sleepMilliSeconds(1000)
    robotgo.MouseClick("right")
    sleepMilliSeconds(200)
    robotgo.KeyTap("u")
    sleepMilliSeconds(200)
    robotgo.KeyTap("enter")
    sleepMilliSeconds(1000)
    robotgo.KeyTap("w", "ctrl")
    sleepMilliSeconds(200)
  }

  // Terminal: Click
  robotgo.MoveMouse(2259, 573)
  robotgo.MouseClick()
}
