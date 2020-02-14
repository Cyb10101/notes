package main

import (
  "flag"
  "fmt"
  "time"
  "os"
  "os/exec"
  "strings"

  "github.com/go-vgo/robotgo"
)

func sleepSeconds(second uint) {
  time.Sleep(time.Duration(second) * time.Second)
}

func getMouseCoordinates() {
  x, y := robotgo.GetMousePos()
  // @todo GetTitle not working
  // fmt.Printf("\n// %s\n", robotgo.GetTitle(robotgo.GetPID()), robotgo.GetPID())
  // fmt.Printf("\n// %s (PID: %d)\n", getProcessByPid(robotgo.GetPID()), robotgo.GetPID())
  fmt.Printf("robotgo.MoveMouse(%d, %d)\n", x, y)
}

func ifTenaryUint(condition bool, ifTrue uint, ifFalse uint) uint {
  if condition {
    return ifTrue
  }
  return ifFalse
}

func getProcessByPid(pid int32) string {
  out, err := exec.Command("ps", "-h", "-o", "command", "-p", fmt.Sprint(pid)).Output()
  if err != nil {
      fmt.Printf("%s", err)
  }
  output := string(out[:])
  output = strings.TrimSpace(output)
  output = output[(strings.LastIndex(output, "/") + 1):len(output)]
  return output
}

func main() {
  // Fix: Invalid MIT-MAGIC-COOKIE-1 key
  robotgo.SetXDisplayName(os.Getenv("DISPLAY"))

  var seconds uint
  var max uint

  flag.UintVar(&max, "max", 10, "Maximum number of queries")
  flag.UintVar(&seconds, "seconds", 3, "Pause in seconds before the query")
  flag.Parse()

  max = ifTenaryUint(max > 0 && max <= 1000, max, 10)
  seconds = ifTenaryUint(seconds > 0 && seconds <= 60, seconds, 3)
  fmt.Printf("Get mouse coordinates in %d queries with %d seconds pause:\n", max, seconds)

  for i := 0; i < int(max); i++ {
    sleepSeconds(seconds)
    getMouseCoordinates()
  }
}
