Option Explicit

Function getColumnLength(ByVal rowPos As Integer, ByVal colPos As Integer) As Integer
    Dim colPosStart As Integer
    colPosStart = colPos

    Do While IsEmpty(Cells(rowPos, colPos)) = False
        colPos = colPos + 1
    Loop
    getColumnLength = colPos - colPosStart
End Function

Function getRowLength(ByVal rowPos As Integer, ByVal colPos As Integer) As Integer
    Dim rowPosStart As Integer
    rowPosStart = rowPos

    Do While IsEmpty(Cells(rowPos, colPos)) = False
        rowPos = rowPos + 1
    Loop
    getRowLength = rowPos - rowPosStart
End Function

Private Sub getDataFromCells(ByRef data() As Double, ByVal rowPos As Integer, ByVal colPos As Integer, ByVal rowLength As Integer, ByVal colLength As Integer)
    Dim iCol, iRow As Integer

    For iRow = 0 To (rowLength - 1)
        For iCol = 0 To (colLength - 1)
            data(iRow, iCol) = Cells(iRow + rowPos, iCol + colPos)
        Next iCol
    Next iRow
End Sub

Private Sub setCellsFromData(ByRef data() As Double, ByVal rowPos As Integer, ByVal colPos As Integer, ByVal rowLength As Integer, ByVal colLength As Integer)
    Dim iCol, iRow As Integer

    For iRow = 0 To (rowLength - 1)
        For iCol = 0 To (colLength - 1)
            Cells(iCol + rowPos, iRow + colPos) = data(iRow, iCol)
        Next iCol
    Next iRow
End Sub

Private Sub Transpose_Click()
    Dim colPos, rowPos, colLength, rowLength As Integer
    Dim data() As Double

    rowPos = 2
    colPos = 1

    colLength = getColumnLength(rowPos, colPos)
    rowLength = getRowLength(rowPos, colPos)
    ReDim data(rowLength, colLength) As Double

    Call getDataFromCells(data, rowPos, colPos, rowLength, colLength)
    Call setCellsFromData(data, ActiveCell.Row, ActiveCell.column, rowLength, colLength)
End Sub
