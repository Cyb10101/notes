package main

import (
  "flag"
  "fmt"
  "time"
  "os"

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

  var timeStart int64
  var timeDiff int64
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

  // Editor [text]
  coordsEditor := coordinates {x: 2771, y: 275}

  // Firefox tab
  coordsFirefoxTab := []coordinates {
    {x: 111, y: 46},
    {x: 338, y: 46},
    {x: 575, y: 46},
    {x: 805, y: 46},
    {x: 1001, y: 46},
    {x: 1238, y: 46},
    {x: 1460, y: 46},
    {x: 1689, y: 46},
  }

  // Firefox address bar
  coordsFirefoxAddressBar := []coordinates {
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
    {x: 900, y: 80},
  }

  // Search console: Remove url field
  coordsSearchConsoleUrl := []coordinates {
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
    {x: 547, y: 533},
  }

  // Search console: Entfernung beantragen
  coordsSearchConsoleButton1 := []coordinates {
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
    {x: 740, y: 533},
  }

  // Search console: Entfernung beantragen (Bestätigung)
  coordsSearchConsoleButton2 := []coordinates {
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
    {x: 775, y: 685},
  }

  // Terminal
  coordsTerminal := coordinates {x: 2066, y: 642}

  for i := 0; i < int(repeat); i++ {
    fmt.Printf("\nRunning query %d of %d:\n", i + 1, repeat)

    // Firefox: Click address bar and run url
    timeStart = getUnixMilliSeconds()
    writeClipboard("https://www.google.com/webmasters/tools/removals")
    for i := 0; i < int(instances); i++ {
      robotgo.MoveMouse(coordsFirefoxTab[i].x, coordsFirefoxTab[i].y)
      robotgo.MouseClick()
      sleepMilliSeconds(200)

      robotgo.MoveMouse(coordsFirefoxAddressBar[i].x, coordsFirefoxAddressBar[i].y)
      robotgo.MouseClick()
      robotgo.KeyTap("a", "ctrl")
      robotgo.KeyTap("v", "ctrl")
      robotgo.KeyTap("enter")
    }

    timeDiff = 3000 - (getUnixMilliSeconds() - timeStart)
    if (timeDiff > 0) {
      fmt.Printf("Wait %d Milliseconds: Page reload\n", timeDiff)
      sleepMilliSeconds(uint(timeDiff))
    }

    timeStart = getUnixMilliSeconds()
    for i := 0; i < int(instances); i++ {
      // Editor: Select text, cut it to clipboard and remove empty line
      robotgo.MoveMouse(coordsEditor.x, coordsEditor.y)
      robotgo.MouseClick()
      sleepMilliSeconds(200)

      robotgo.KeyTap("home")
      sleepMilliSeconds(200)
      robotgo.KeyTap("end", "shift")
      sleepMilliSeconds(100)
      robotgo.KeyTap("x", "ctrl")
      sleepMilliSeconds(100)
      robotgo.KeyTap("delete")
      if (verbose) {
        fmt.Printf("Url %d: %s\n", (i + 1), readClipboard())
      }

      // Search console: Click on remove url field and paste from clipboard
      robotgo.MoveMouse(coordsFirefoxTab[i].x, coordsFirefoxTab[i].y)
      robotgo.MouseClick()
      sleepMilliSeconds(200)

      robotgo.MoveMouse(coordsSearchConsoleUrl[i].x, coordsSearchConsoleUrl[i].y)
      robotgo.MouseClick()
      sleepMilliSeconds(100)
      robotgo.KeyTap("v", "ctrl")
      sleepMilliSeconds(100)

      // Search console: Entfernung beantragen
      robotgo.MoveMouse(coordsSearchConsoleButton1[i].x, coordsSearchConsoleButton1[i].y)
      robotgo.MouseClick()
    }

    timeDiff = 4000 - (getUnixMilliSeconds() - timeStart)
    if (timeDiff > 0) {
      fmt.Printf("Wait %d Milliseconds: Confirm removal\n", timeDiff)
      sleepMilliSeconds(uint(timeDiff))
    }

    timeStart = getUnixMilliSeconds()
    for i := 0; i < int(instances); i++ {
      // Search console: Entfernung beantragen (Bestätigung)
      robotgo.MoveMouse(coordsFirefoxTab[i].x, coordsFirefoxTab[i].y)
      robotgo.MouseClick()
      sleepMilliSeconds(200)

      robotgo.MoveMouse(coordsSearchConsoleButton2[i].x, coordsSearchConsoleButton2[i].y)
      robotgo.MouseClick()
    }

    sleepSeconds(1)
    timeDiff = 1000 - (getUnixMilliSeconds() - timeStart)
    if (timeDiff > 0) {
      fmt.Printf("Wait %d Milliseconds: Removal confirmed\n", timeDiff)
      sleepMilliSeconds(uint(timeDiff))
    }
  }

  // Terminal: Click
  robotgo.MoveMouse(coordsTerminal.x, coordsTerminal.y)
  robotgo.MouseClick()
}
