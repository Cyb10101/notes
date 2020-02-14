package main

import (
  "flag"
  "fmt"
  "time"
  "os"

  "github.com/go-vgo/robotgo"
)

func getUnixMilliSeconds() int64 {
  return (time.Now().UnixNano() / 1000 / 1000);
}

func sleepMilliSeconds(milliSecond uint) {
	time.Sleep(time.Duration(milliSecond) * time.Millisecond)
}

func keyReset() {
  robotgo.KeyToggle("w", "up")
  robotgo.KeyToggle("a", "up")
  robotgo.KeyToggle("s", "up")
  robotgo.KeyToggle("d", "up")
  robotgo.KeyToggle("i", "up")
  robotgo.KeyToggle("j", "up")
  robotgo.KeyToggle("k", "up")
  robotgo.KeyToggle("l", "up")
}

func main() {
  // Fix: Invalid MIT-MAGIC-COOKIE-1 key
	robotgo.SetXDisplayName(os.Getenv("DISPLAY"))

  var verbose bool
  flag.BoolVar(&verbose, "v", false, "Verbose")
  flag.Parse()

  robotgo.SetKeyDelay(0)
  robotgo.SetMouseDelay(0)

  fmt.Println("Run")

  // Click window
  robotgo.MoveMouse(953, 499)
  robotgo.MouseClick()
  sleepMilliSeconds(1000);

  // Record with record-keyboard.go, copy & paste here.
  // go run replay-keyboard.go; sudo /usr/local/go/bin/go run record-keyboard.go > /tmp/logger.txt

  // Safety first
  keyReset();
}
