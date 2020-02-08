package main

import (
  "flag"
  "fmt"
  "strconv"
  "os"
  "./packages"
)

func isFile(fileName string) bool {
  fileInfo, error := os.Stat(fileName)

  if os.IsNotExist(error) {
    return false
  }

  if fileInfo.Mode().IsRegular() {
    return true
  }

  return false
}

func isDir(dirName string) bool {
  fileInfo, error := os.Stat(dirName)

  if os.IsNotExist(error) {
    return false
  }

  if fileInfo.Mode().IsDir() {
    return true
  }

  return false
}

func fsCreateDirectory(dirName string) bool {
  if isDir(dirName) {
    return true;
  }

  error := os.MkdirAll(dirName, 0755)
  if error != nil {
    panic(error)
  }
  return true
}

func fsRename(oldLocation string, newLocation string) {
  error := os.Rename(oldLocation, newLocation)
  if error != nil {
    panic(error)
  }
}

func fsRemoveDirectory(dirName string) {
  error := os.RemoveAll(dirName)
  if error != nil {
    panic(error)
  }
}

func fsRotateDirectoryOrFile(max int, dirName string) {
  maxString := strconv.Itoa(max)
  if isDir(dirName + "." + maxString) || isFile(dirName + "." + maxString) {
    fsRemoveDirectory(dirName + "." + maxString)
  }

  for i := max; i > 1; i-- {
    previousId := (i - 1)
    previousIdString := strconv.Itoa(previousId)
    idString := strconv.Itoa(i)
    if isDir(dirName + "." + previousIdString) || isFile(dirName + "." + previousIdString) {
      fsRename(dirName + "." + previousIdString, dirName + "." + idString)
    }
  }

  fsRename(dirName, dirName + ".1")
}

func checkArguments(args []string) {
  var error bool;
  error = false;
  for _, filePath := range args {
    if !(isDir(filePath) || isFile(filePath)) {
      error = true;
      fmt.Println("ERROR: '" + filePath + "' not found!")
    }
  }
  if error {
    os.Exit(1)
  }
}

func executeArguments(max int, args []string) {
  for _, filePath := range args {
    if filePath == "" {
      continue
    }
    fsRotateDirectoryOrFile(max, filePath)
  }
}

func main() {
  // Parse arguments
  var max int
  flag.IntVar(&max, "max", 9, "Rotation file or folder maximum")
  flag.Parse()

  // Execute script
  if len(flag.Args()) > 0 {
    checkArguments(flag.Args())
    executeArguments(max, flag.Args())
  } else {
    fmt.Println(colors.Cyan("Rotate file or directory."))
    fmt.Println("")
    fmt.Println(colors.Green("Usage:"))
    fmt.Println("  rotate [OPTION]... fileOrDirectory...\n")
    fmt.Println(colors.Yellow("Options:"))
    flag.PrintDefaults()
  }
}
