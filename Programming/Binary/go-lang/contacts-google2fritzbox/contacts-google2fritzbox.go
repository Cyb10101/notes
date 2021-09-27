package main

import (
  "fmt"
  "log"
  "strings"
  "flag"
  "encoding/json"
  "encoding/xml"
  "path/filepath"
  "reflect"
  "os"
  "io/ioutil"
  "cyb10101/contacts-google2fritzbox/packages"
)

const (
  XmlHeader = `<?xml version="1.0" encoding="UTF-8"?>` + "\n"
)

type googleContact struct {
  Name string `json:"Name"`
  GivenName string `json:"Given Name"`
  FamilyName string `json:"Family Name"`
  PhoneType1 string `json:"Phone 1 - Type"`
  PhoneNumber1 string `json:"Phone 1 - Value"`
  PhoneType2 string `json:"Phone 2 - Type"`
  PhoneNumber2 string `json:"Phone 2 - Value"`
  PhoneType3 string `json:"Phone 3 - Type"`
  PhoneNumber3 string `json:"Phone 3 - Value"`
  PhoneType4 string `json:"Phone 4 - Type"`
  PhoneNumber4 string `json:"Phone 4 - Value"`
  PhoneType5 string `json:"Phone 5 - Type"`
  PhoneNumber5 string `json:"Phone 5 - Value"`
  PhoneType6 string `json:"Phone 6 - Type"`
  PhoneNumber6 string `json:"Phone 6 - Value"`
  PhoneType7 string `json:"Phone 7 - Type"`
  PhoneNumber7 string `json:"Phone 7 - Value"`
}

type jsonRows struct {
  Id string `json:"id"`
  Rows []googleContact `json:"rows"`
}


type fritzTelephonyNumber struct {
  Type string `xml:"type,attr"`
  Prio int `xml:"prio,attr"`
  Id int `xml:"id,attr"`
  Number string `xml:",innerxml"`
}

type fritzTelephony struct {
  Nid int `xml:"nid,attr"`
  Number []fritzTelephonyNumber `xml:"number"`
}

type fritzContactPerson struct {
  RealName string `xml:"realName"`
}

type fritzContact struct {
  Person fritzContactPerson `xml:"person"`
  Telephony []fritzTelephony `xml:"telephony"`
}

type fritzPhonebook struct {
  Contact []fritzContact `xml:"contact"`
}

type fritzPhonebooks struct {
  XMLName xml.Name `xml:"phonebooks"`
  Phonebook []fritzPhonebook `xml:"phonebook"`
}

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

func getContentByJsonFile(inputFile string) []byte {
  jsonFile, err := os.Open(inputFile)
  if err != nil {
    log.Fatal("The file is not found!")
  }
  defer jsonFile.Close()
  
  byteContent, _ := ioutil.ReadAll(jsonFile)
  return byteContent
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

func inArray(val interface{}, array interface{}) (index int) {
    values := reflect.ValueOf(array)
    if reflect.TypeOf(array).Kind() == reflect.Slice || values.Len() > 0 {
        for i := 0; i < values.Len(); i++ {
            if reflect.DeepEqual(val, values.Index(i).Interface()) {
                return i
            }
        }
    }
    return -1
}

func getContactName(GivenName string, FamilyName string, Name string) string {
  var value string
  value = ""
  if (GivenName != "") {
    value += GivenName
  }
  if (FamilyName != "") {
    value += " " + FamilyName
  }
  value = strings.TrimSpace(value)

  if (Name != "" && value != "" && Name != value) {
    value += " (" + Name + ")"
  } else if (Name != "" && value == "") {
    value += Name
  }
  value = strings.TrimSpace(value)
  return value
}

func telephonyAdd(telephony fritzTelephony, phoneNumber string, phoneType string, name string) fritzTelephony {
  numbers := strings.Split(phoneNumber, " ::: ")
  for _, number := range numbers {
    number = strings.TrimSpace(number)
    if (number != "") {
      var telephonyNumber fritzTelephonyNumber
      telephonyNumber.Prio = 0
      telephonyNumber.Number = number
      
      phoneType = strings.ToLower(phoneType)
      home := []string{"home"}
      mobile := []string{"mobile"}
      work := []string{"work"}
      faxWork := []string{"fax_work", "workfax", "homefax"}
      
      if (phoneType == "main") {
        telephonyNumber.Type = "home"
        telephonyNumber.Prio = 1
      } else if (inArray(phoneType, home) >= 0) {
        telephonyNumber.Type = "home"
      } else if (inArray(phoneType, mobile) >= 0) {
        telephonyNumber.Type = "mobile"
      } else if (inArray(phoneType, work) >= 0) {
        telephonyNumber.Type = "work"
      } else if (inArray(phoneType, faxWork) >= 0) {
        telephonyNumber.Type = "fax_work"
      } else {
        if (phoneType != "") {
          fmt.Println("Unkown phone type: " + phoneType + " [" + name + "]")
        }
        telephonyNumber.Type = "home"
      }

      telephonyNumber.Id = len(telephony.Number)
      telephony.Number = append(telephony.Number, telephonyNumber)
    }
  }
  return telephony
}

func isPrioSet(numbers []fritzTelephonyNumber) bool {
  for _, number := range numbers {
    if (number.Prio == 1) {
      return true
    }
  }
  return false
}

func convert(jsonContent []byte) []byte {
  var rows jsonRows
  json.Unmarshal([]byte(jsonContent), &rows)

  var phonebooks fritzPhonebooks
  var phonebook fritzPhonebook

  for _, row := range rows.Rows {
    var contact fritzContact

    name := getContactName(row.GivenName, row.FamilyName, row.Name)
    contact.Person.RealName = name

    var telephony fritzTelephony
    telephony = telephonyAdd(telephony, row.PhoneNumber1, row.PhoneType1, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber2, row.PhoneType2, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber3, row.PhoneType3, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber4, row.PhoneType4, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber5, row.PhoneType5, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber6, row.PhoneType6, name)
    telephony = telephonyAdd(telephony, row.PhoneNumber7, row.PhoneType7, name)

    telephony.Nid = len(telephony.Number)
    if (telephony.Nid > 0) {
      if (!isPrioSet(telephony.Number)) {
        telephony.Number[0].Prio = 1
      }
  
      contact.Telephony = append(contact.Telephony, telephony)
      phonebook.Contact = append(phonebook.Contact, contact)
    }
  }
  phonebooks.Phonebook = append(phonebooks.Phonebook, phonebook)

  xmlContent, _ := xml.MarshalIndent(phonebooks, "", "  ")
  xmlContent = []byte(XmlHeader + string(xmlContent))
  return xmlContent
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
    contentJson := getContentByJsonFile(inputFile)
    bytesJson := convert(contentJson)
    if outputFile == "" {
      outputFile = convertInputToOutputPath(inputFile, "xml")
    }
    saveFile(outputFile, bytesJson)
  } else {
    fmt.Println(colors.Cyan("Convert Google Contacts to FritzBox contacts."))
    fmt.Println("")
    fmt.Println(colors.Green("Usage:"))
    fmt.Println("  contacts-google2fritzbox [OPTION]... input.json [output.xml]\n")
    fmt.Println(colors.Yellow("Options:"))
    flag.PrintDefaults()
  }
}
