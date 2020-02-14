package main

import (
  "fmt"
  "time"
  "os"

  "github.com/MarinX/keylogger"
)

func getUnixMilliSeconds() int64 {
  return (time.Now().UnixNano() / 1000 / 1000);
}

func main() {
  // find keyboard device, does not require a root permission
  keyboard := keylogger.FindKeyboardDevice()

  // check if we found a path to keyboard
  if len(keyboard) <= 0 {
    fmt.Println("No keyboard found...you will need to provide manual input path")
    os.Exit(1);
  }

  fmt.Println("Found a keyboard at", keyboard)
  // init keylogger with keyboard
  k, err := keylogger.New(keyboard)
  if err != nil {
    fmt.Println(err)
    os.Exit(1);
  }
  defer k.Close()

  events := k.Read()

  fmt.Println("Logging keyboard...\n")
  // range of events
  start := getUnixMilliSeconds()
  for e := range events {
    switch e.Type {
    // EvKey is used to describe state changes of keyboards, buttons, or other key-like devices.
    // check the input_event.go for more events
    case keylogger.EvKey:

      if e.KeyPress() || e.KeyRelease() {
        now := getUnixMilliSeconds()
        fmt.Printf("sleepMilliSeconds(%d)\n", (now - start))
        start = now
      }

      if e.KeyPress() {
        fmt.Printf("robotgo.KeyToggle(\"%s\", \"down\")\n", e.KeyString())
      } else if e.KeyRelease() {
        fmt.Printf("robotgo.KeyToggle(\"%s\", \"up\")\n", e.KeyString())
      }

      if (e.KeyString() == "ESC") {
        fmt.Println("ESC...\n")
        os.Exit(0);
      }

      break
    }
  }
}
