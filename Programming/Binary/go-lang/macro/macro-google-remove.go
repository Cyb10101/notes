package main

import (
  "fmt"
  "time"
  "os"

  "github.com/go-vgo/robotgo"
  "github.com/go-vgo/robotgo/clipboard"
)

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

func main() {
  // Fix: Invalid MIT-MAGIC-COOKIE-1 key
	robotgo.SetXDisplayName(os.Getenv("DISPLAY"))

  robotgo.SetKeyDelay(100)
  robotgo.SetMouseDelay(100)

  // Firefox: Click address bar and run url
  robotgo.MoveMouse(1018, 98)
  robotgo.MouseClick()
  writeClipboard("https://www.google.com/webmasters/tools/removals")
  robotgo.KeyTap("a", "ctrl")
  robotgo.KeyTap("v", "ctrl")
  robotgo.KeyTap("enter")
  fmt.Println("Wait 3 seconds for page reload...")
  sleepSeconds(3)

  // Editor: Select text, cut it to clipboard and remove empty line
  robotgo.MoveMouse(2367, 310)
  robotgo.MouseClick()
  robotgo.KeyTap("home")
  robotgo.KeyTap("end", "shift")
  robotgo.KeyTap("x", "ctrl")
  robotgo.KeyTap("delete")

  // Search console: Click on remove url field and paste from clipboard
  robotgo.MoveMouse(631, 547)
  robotgo.MouseClick()
  robotgo.KeyTap("v", "ctrl")

  // Search console: Entfernung beantragen
  robotgo.MoveMouse(775, 553)
  robotgo.MouseClick()
  fmt.Println("Wait 2 seconds for page reload...")
  sleepSeconds(2)

  // Search console: Entfernung beantragen (Bestätigung)
  robotgo.MoveMouse(701, 690)
  robotgo.MouseClick()

  // Terminal: Click
  robotgo.MoveMouse(3616, 761)
  robotgo.MouseClick()
}
