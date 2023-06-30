package main

import (
  "flag"
  "fmt"
  "io/ioutil"
  "os"
  "path"
  "strconv"
  "strings"
  "cyb10101/split-files/packages"
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

func splitFiles(max int, addFolder string, dirName string) {
  var currentIndex int = 1
  basePath := path.Dir(strings.TrimRight(dirName, "/")) + "/"
  baseName := path.Base(dirName)

  for {
    splitFolderName := baseName + "_" + strconv.Itoa(currentIndex)
    splitFolder := basePath + splitFolderName
    if (isDir(splitFolder) || isFile(splitFolder)) {
      currentIndex++
      continue
    }

    if !(isDir(splitFolder)) {
      fsCreateDirectory(splitFolder)
    }

    // Read directory
    files, err := ioutil.ReadDir(basePath + baseName)
    if err != nil {
       panic(err)
    }
    if len(files) == 0 {
      break;
    }

    fmt.Println("[ID: " + strconv.Itoa(currentIndex) + "] Remaining files: " + strconv.Itoa(len(files)))

    // Move files
    var filesCurrent int = 0
    for _, file := range files {
      fsRename(basePath + baseName + "/" + file.Name(), splitFolder + "/" + file.Name())
      filesCurrent++;

      if (filesCurrent >= max) {
        break;
      }
    }

    // Add a extra folder in directory
    if (addFolder != "" && !isDir(splitFolder + "/" + addFolder)) {
      fsCreateDirectory(splitFolder + "/" + addFolder)
    }

    if (len(files) - filesCurrent) <= 0 {
      break;
    }
  }
}

func checkArguments(args []string) {
  var error bool;
  error = false;
  for _, filePath := range args {
    if isFile(filePath) {
      error = true;
      fmt.Println("ERROR: '" + filePath + "' is a file!")
    }
    if !(isDir(filePath)) {
      error = true;
      fmt.Println("ERROR: Folder '" + filePath + "' not found!")
    }
  }
  if error {
    os.Exit(1)
  }
}

func executeArguments(max int, addFolder string, args []string) {
  for _, filePath := range args {
    if filePath == "" {
      continue
    }
    splitFiles(max, addFolder, filePath)
  }
}

func main() {
  // Parse arguments
  var max int
  var addFolder string
  flag.StringVar(&addFolder, "addfolder", "", "Add folder in each new directory, for example '0-viewed'")
  flag.IntVar(&max, "max", 5000, "Maximum count for each new directory")
  flag.Parse()

  // Execute script
  if len(flag.Args()) > 0 {
    checkArguments(flag.Args())
    executeArguments(max, addFolder, flag.Args())
  } else {
    fmt.Println(colors.Cyan("Split a directory to seperate folders."))
    fmt.Println("")
    fmt.Println(colors.Green("Usage:"))
    fmt.Println("  split-files [OPTION]... directory...\n")
    fmt.Println(colors.Yellow("Options:"))
    flag.PrintDefaults()
  }
}
