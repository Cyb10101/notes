package main

import (
  "encoding/csv"
  "encoding/json"
  "flag"
  "fmt"
  "io/ioutil"
  "log"
  "os"
  "path/filepath"
  "strconv"
  "cyb10101/csv2json/packages"
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

func checkArguments(inputFile string) {
  var error bool;
  error = false;

  if !(isFile(inputFile)) {
    error = true;
    fmt.Println("ERROR: '" + inputFile + "' not found!")
  }

  if error {
    os.Exit(1)
  }
}

func getContentByCsvFile(inputFile string) [][]string {
  csvFile, err := os.Open(inputFile)
  if err != nil {
    log.Fatal("The file is not found!")
  }
  defer csvFile.Close()

  reader := csv.NewReader(csvFile)
  content, _ := reader.ReadAll()
  if len(content) < 1 {
    log.Fatal("Something wrong, the file maybe empty or length of the lines are not greater than two!")
  }

  return content
}

func splitCsvHeaderAndContent(content [][]string) ([]string, [][]string) {
  headers := make([]string, 0)
  for _, item := range content[0] {
    headers = append(headers, item)
  }
  content = content[1:] // Remove the header row
  return headers, content
}

func convertCsvPartsToJson(headers []string, content [][]string) []byte {
  objRows := make(map[string][]map[string]interface{})
  for _, row := range content {
    item := make(map[string]interface{})
    for id, column := range row {
      floatValue, floatErr := strconv.ParseFloat(column, 64)
      intValue, intErr := strconv.ParseInt(column, 10, 64)
      boolValue, boolErr := strconv.ParseBool(column)
      if floatErr == nil {
        item[headers[id]] = floatValue
      } else if intErr == nil {
        item[headers[id]] = intValue
      } else if boolErr == nil {
        item[headers[id]] = boolValue
      } else {
        item[headers[id]] = column
      }
    }
    objRows["rows"] = append(objRows["rows"], item)
  }

  bytesJson, _ := json.MarshalIndent(objRows, "", "  ")
  // fmt.Println(string(bytesJson))
  return bytesJson
}

func convertInputToOutputPath(path string, extension string) string {
  newFileName := filepath.Base(path)
  newFileName = newFileName[0:len(newFileName)-len(filepath.Ext(newFileName))] + "." + extension
  r := filepath.Dir(path)
  return filepath.Join(r, newFileName)
}

func saveFile(path string, content []byte) {
  err := ioutil.WriteFile(path, content, os.FileMode(0644))
  if err != nil {
    panic(err)
  }
}

func main() {
  // Parse arguments
  var inputFile string
  var outputFile string
  flag.Parse()

  arguments := flag.Args()
  if len(arguments) > 0 {
    inputFile = arguments[0]
  }
  if len(arguments) > 1 {
    outputFile = arguments[1]
  }

  if len(flag.Args()) > 0 {
    checkArguments(inputFile)
    contentCsv := getContentByCsvFile(inputFile)
    headers, content := splitCsvHeaderAndContent(contentCsv)
  
    bytesJson := convertCsvPartsToJson(headers, content)
    if outputFile == "" {
      outputFile = convertInputToOutputPath(inputFile, "json")
    }
    saveFile(outputFile, bytesJson)
  } else {
    fmt.Println(colors.Cyan("Convert CSV to JSON."))
    fmt.Println("")
    fmt.Println(colors.Green("Usage:"))
    fmt.Println("  csv2json [OPTION]... input.csv [output.csv]\n")
    fmt.Println(colors.Yellow("Options:"))
    flag.PrintDefaults()
  }
}
