Function fSaveFile() as String
  Dim oDoc
  oDoc = ThisComponent
  oSheet = oDoc.sheets(0)  ' The first sheet object
  'FileName = GetFileNameWithoutExtension(oDoc.url,"/") + " TEST.xls"

  oCell = oSheet.getCellRangeByName("d4")
  FileName = oCell.string + "W "

  'datum = Date("2012-09-17") + ((oCell.string - 1) * 7)
  oCell = oSheet.getCellRangeByName("i7")
  oCell.Numberformat = 84
  FileName = FileName + oCell.string
  oCell.Numberformat = 36

  ' Sets the settings of the file selection box to certain default values
  sFilePickerArgs = Array(com.sun.star.ui.dialogs.TemplateDescription.FILESAVE_AUTOEXTENSION)

  ' Registers the service for the file selection box
  oFilePicker = CreateUnoService("com.sun.star.ui.dialogs.FilePicker")

  ' Passes some specific settings
  With oFilePicker
    .Initialize(sFilePickerArgs())
    '.setDisplayDirectory("C:/Documents")
    .SetDefaultName(FileName)
    .appendFilter("Microsoft Excel 97/2000/XP/2013 (.xls)", "*.xls" )
    .SetValue(com.sun.star.ui.dialogs.ExtendedFilePickerElementIds.CHECKBOX_AUTOEXTENSION, 0, true)
    .setTitle("Save as (.xls)")
  End With

  If oFilePicker.execute() Then
    sFiles = oFilePicker.getFiles()
    sFileURL = sFiles(0)
    'oDoc.storeAsURL(sFileURL, Array())
  End If

  'oFilePicker.Dispose()
End Function

'sText = oCell.string            ' Get cell text
'nWert = oCell.value             ' Get cell number
'sFormel = oCell.formula         ' Get cell formula
'oCell.string = "Hello"          ' Set cell text
'oCell.value = 123               ' Set cell number
'oCell.formula = "=sum(a1:a14)"  ' Set cell formula
