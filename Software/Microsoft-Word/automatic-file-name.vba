Sub FileSave()
	msgbox("save");
	Call AutomaticFilenameAtSave
End Sub

Sub FileSaveAS()
	msgbox("save-as");
	Call AutomaticFilenameAtSave
End Sub

Private Sub AutomaticFilenameAtSave()
	Dim PathAndFileName As String
	PathAndFileName = "C:\Documents\"

	'Datum anfügen
	PathAndFileName = PathAndFileName & Format(Now, "yyyy-mm-dd ")
	'Textmarke auswerten
'	PathAndFileName = PathAndFileName & ActiveDocument.Bookmarks("Subject").Range.Text

	'Set document properties
'	With ActiveDocument
'		.BuiltInDocumentProperties("Title") = .Bookmarks("Subject").Range.Text
'		.BuiltInDocumentProperties("Subject") = "Letter - " & Format(Date, "YYYY-MM-DD")
'		.BuiltInDocumentProperties("Author") = VBA.Environ("Username")
'		.BuiltInDocumentProperties("Manager") = "My Boss"
'		.BuiltInDocumentProperties("Keywords") = "Brief, ABC"
'		.BuiltInDocumentProperties("Company") = "My little Factory"
'		.BuiltInDocumentProperties("Category") = "Brief"
'		.BuiltInDocumentProperties("Comments") = "Test"
'	End With

	With Application.Dialogs(wdDialogFileSaveAs)
		.Name = PathAndFileName & ".docx"
		.Show
	End With
'	ActiveDocument.Fields(2).Update 'Field with save date - adjust index number 2 if necessary
	ActiveDocument.Save
End Sub
