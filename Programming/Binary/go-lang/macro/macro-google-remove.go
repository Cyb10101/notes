package main

import (
  "flag"
  "fmt"
  "time"
  "os"

  "github.com/go-vgo/robotgo"
  "github.com/go-vgo/robotgo/clipboard"
)

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
  var instances uint
  flag.BoolVar(&verbose, "v", false, "Verbose")
  flag.UintVar(&repeat, "r", 1, "Number of repeats")
  flag.UintVar(&instances, "i", 1, "Number of instances")
  flag.Parse()

  repeat = ifTenaryUint(repeat > 0 && repeat <= 1000, repeat, 1)
  instances = ifTenaryUint(instances > 0 && instances <= 10, instances, 1)

  robotgo.SetKeyDelay(100)
  robotgo.SetMouseDelay(100)

  // Firefox address bar
  firefoxAddressBar := []coordinates {
    {x: 303, y: 80},
    {x: 1258, y: 83},
  }

  // Search console: Remove url field
  searchConsoleUrl := []coordinates {
    {x: 587, y: 533},
    {x: 1542, y: 533},
  }

  // Search console: Entfernung beantragen
  searchConsoleButton1 := []coordinates {
    {x: 742, y: 533},
    {x: 1697, y: 533},
  }

  // Search console: Entfernung beantragen (Bestätigung)
  searchConsoleButton2 := []coordinates {
    {x: 294, y: 687},
    {x: 1251, y: 681},
  }

  for i := 0; i < int(repeat); i++ {
    fmt.Printf("\nRunning query %d of %d:\n", i + 1, repeat)

    // Firefox: Click address bar and run url
    writeClipboard("https://www.google.com/webmasters/tools/removals")
    for i := 0; i < int(instances); i++ {
      robotgo.MoveMouse(firefoxAddressBar[i].x, firefoxAddressBar[i].y)
      robotgo.MouseClick()
      robotgo.KeyTap("a", "ctrl")
      robotgo.KeyTap("v", "ctrl")
      robotgo.KeyTap("enter")
    }
    fmt.Println("Wait 3 seconds: Page reload")
    sleepSeconds(3)

    for i := 0; i < int(instances); i++ {
      // Editor: Select text, cut it to clipboard and remove empty line
      robotgo.MoveMouse(2404, 278)
      robotgo.MouseClick()
      robotgo.KeyTap("home")
      sleepMilliSeconds(100)
      robotgo.KeyTap("end", "shift")
      sleepMilliSeconds(100)
      robotgo.KeyTap("x", "ctrl")
      robotgo.KeyTap("delete")
      if (verbose) {
        fmt.Printf("Url: %s\n", readClipboard())
      }

      // Search console: Click on remove url field and paste from clipboard
      robotgo.MoveMouse(searchConsoleUrl[i].x, searchConsoleUrl[i].y)
      robotgo.MouseClick()
      robotgo.KeyTap("v", "ctrl")

      // Search console: Entfernung beantragen
      robotgo.MoveMouse(searchConsoleButton1[i].x, searchConsoleButton1[i].y)
      robotgo.MouseClick()
    }
    fmt.Println("Wait 3 seconds: Confirm removal")
    sleepSeconds(3)

    for i := 0; i < int(instances); i++ {
      // Search console: Entfernung beantragen (Bestätigung)
      robotgo.MoveMouse(searchConsoleButton2[i].x, searchConsoleButton2[i].y)
      robotgo.MouseClick()
    }
    fmt.Println("Wait 1 seconds: Removal confirmed")
    sleepSeconds(1)
  }

  // Terminal: Click
  robotgo.MoveMouse(3793, 999)
  robotgo.MouseClick()
}
