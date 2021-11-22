
' isheet find
' return 1..n space occuped in the array or -1 in case of error
Function isheetFind(isheetObj)
    Dim low
    low = 0
    Dim high
    high = isheetObj.Count
    Dim i
    i = 0
    Dim result

    Dim current
    current = "start"

    Do While True
        i = (low + high) / 2
	IF i>isheetObj.Count THEN
		Exit DO
	END IF
	i = Round(i)

	Set current = isheetObj.Item(i)
	Set previous = isheetObj.Item(i-1)

       If current.Value="" And (i=1 Or (previous.Value="")=False) Then
            isheetFind = Round(i)
            Exit Function
        ElseIf previous.Value="" Then
            ' target is lower
            high = (i - 1)
        Else
	    ' target is sup
            low = (i + 1)
        End If

    Loop    
    isheetFind = -1
End Function

' get number of rows used in sheet
Function usedRows(sheet, col)
	if positions("cpu")=col then
	else
		MsgBox("definition violation")
	end if
	usedRows = isheetFind(sheet.Range(positions("cpu")&"1:"&positions("cpu")&sheet.Rows.Count).Rows)-1
END FUNCTION

' get number of columns used in sheet
' WARNING : this don't work when the specified line contains merged cells
Function usedCols(sheet, line)
	MsgBox("not implemented")
END FUNCTION

' Create a row in the given by getPositionsIndex
Function sheetCreateRowFromArray(sheet, line, data) 
	Dim keys, cell, cellv
        keys = positions.Keys()
       for i=0 to UBound(data)
	    cell = positions(keys(i)) & line
	    cellv = data(i)
	    sheet.Range(cell).Value = cellv
       next
End Function

' create a sheet row for the provided in a hashmap
Function sheetCreateRowFromHashMap(sheet, line, map)
	FOR EACH k IN map.Keys
		sheet.Range(k&line).Value = map(k)
	NEXT
End Function

' Open an existing sheet 
' WARNING : absolute path are not allowed
Function openExisting(fname)
	Set props = CreateObject("Scripting.Dictionary")
        Set pm = CreateObject("PlanMaker.Application")
	pm.Application.Options.CreateBackup = False
        pm.Visible = False
	props.Add "pm", pm
	Set w = pm.Workbooks.Open(fname)
	props.Add "w", w
	props.Add "sheet", w.ActiveSheet
        props.Add "mustWrite", False
	Set openExisting = props
End Function

Dim smoColorIndexAuto, smoColorIndexTransparent, smoColorIndexBlack, smoColorIndexBlue, smoColorIndexCyan, smoColorIndexGreen
Dim smoColorIndexMagenta, smoColorIndexRed, smoColorIndexYellow, smoColorIndexWhite, smoColorIndexDarkBlue, smoColorIndexDarkCyan
Dim smoColorIndexDarkGreen, smoColorIndexDarkMagenta, smoColorIndexDarkRed, smoColorIndexBrown, smoColorIndexDarkGray, smoColorIndexLightGray
smoColorIndexAuto = -1 ' Automatic (see below)
smoColorIndexTransparent = -1 ' Transparent (see below)
smoColorIndexBlack = 0 ' Black
smoColorIndexBlue = 1 ' Blue
smoColorIndexCyan = 2 ' Cyan
smoColorIndexGreen = 3 ' Green
smoColorIndexMagenta = 4 ' Magenta
smoColorIndexRed = 5 ' Red
smoColorIndexYellow = 6 ' Yellow
smoColorIndexWhite = 7 ' White
smoColorIndexDarkBlue = 8 ' Dark blue
smoColorIndexDarkCyan = 9 ' Dark cyan
smoColorIndexDarkGreen = 10 ' Dark green
smoColorIndexDarkMagenta = 11 ' Dark magenta
smoColorIndexDarkRed = 12 ' Dark red
smoColorIndexBrown = 13 ' Brown
smoColorIndexDarkGray = 14 ' Dark gray
smoColorIndexLightGray = 15 ' Light gray

' Create initial sheet of reports
' http://www.softmaker.net/down/bm2010manual_en.pdf
Function sheetCreateInital()
    Set props = CreateObject("Scripting.Dictionary")
    Set pm = CreateObject("PlanMaker.Application")
    pm.Visible = False
    pm.Application.Options.CreateBackup = False
    Set w = pm.Workbooks.Add
    w.Activate

    With w
     .BuiltInDocumentProperties("Title") = "Tous les reconditionnements"
     .BuiltInDocumentProperties("Subject") = "Reconditionnements"
     .BuiltInDocumentProperties("Author") = "Emmaüs"
    End With

    Set sheet = w.ActiveSheet
    Set r = sheet.Range("A1:D1")
    r.MergeCells = True
    r.Value = "SUIVI"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexDarkGray
    r.Shading.ForegroundPatternColorIndex = smoColorIndexDarkGray
    r.Font.ColorIndex = smoColorIndexWhite
    Set r = sheet.Range("E1:I1")
    r.MergeCells = True
    r.Value = "MATERIEL"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexBlue
    r.Shading.ForegroundPatternColorIndex = smoColorIndexBlue
    r.Shading.Texture = 13
    r.Font.ColorIndex = smoColorIndexWhite
    Set r = sheet.Range("J1:O1")
    r.MergeCells = True
    r.Value = "DON"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexDarkGreen
    r.Shading.ForegroundPatternColorIndex = smoColorIndexDarkGreen
    r.Font.ColorIndex = smoColorIndexWhite
    Set r = sheet.Range("P1:AA1")
    r.MergeCells = True
    r.Value = "CATEGORISATION ET CALCUL DU PRIX DE VENTE"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexBrown
    r.Shading.ForegroundPatternColorIndex = smoColorIndexBrown
    r.Font.ColorIndex = smoColorIndexWhite
    Set r = sheet.Range("AB1:AH1")
    r.MergeCells = True
    r.Value = "SUIVI DU RECONDITIONNEMENT"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexDarkBlue
    r.Shading.ForegroundPatternColorIndex = smoColorIndexDarkBlue
    r.Font.ColorIndex = smoColorIndexWhite
    Set r = sheet.Range("AI1:AK1")
    r.MergeCells = True
    r.Value = "VENTE"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexGreen
    r.Shading.ForegroundPatternColorIndex = smoColorIndexGreen
    r.Font.ColorIndex = smoColorIndexBlack
    Set r = sheet.Range("AL1:AV1")
    r.MergeCells = True
    r.Value = "FICHE TECHNIQUE"
    r.Shading.BackgroundPatternColorIndex = smoColorIndexBrown
    r.Shading.ForegroundPatternColorIndex = smoColorIndexBrown
    r.Font.ColorIndex = smoColorIndexBlack

    sheetCreateRow sheet, 2, getTitlesMap()

    Set r = sheet.Range("A1:AV2")
    r.Font.Bold = True

    props.Add "pm", pm
    props.Add "w", w
    props.Add "sheet", sheet
    props.Add "mustWrite", True
    Set sheetCreateInital = props
End Function

' Write the sheet to the storage
Function sheetWrite(o, f)
	f = getAbsoluteFilenameFromRelative(f)
	o("pm").ActiveWorkbook.SaveAs f
End Function

' Close the current instance of excel
Function sheetClose(o)
	o("pm").Quit
End Function


' Get filename with extension compatible with this lib
Function getOutputFile(fname)
	getOutputFile = getCompatOutputFmt(fname, ".pmdx")
End Function


' Get preferred extension for this lib
Function getPreferredExtension()
	getPreferredExtension = ".pmdx"
End Function

' Get avaliable extension type
Function getAvaliableExtensions() 
	Dim exts(0)
	exts(0) = ".pmdx"
	getAvaliableExtensions = exts
End Function




Dim pmHAlignGeneral, pmHAlignLeft, pmHAlignRight, pmHAlignCenter, pmHAlignJustify, pmHAlignCenterAcrossSelection
pmHAlignGeneral = 0 ' Default
pmHAlignLeft = 1 ' Left
pmHAlignRight = 2 ' Right
pmHAlignCenter = 3 ' Centered
pmHAlignJustify = 4 ' Justified
pmHAlignCenterAcrossSelection = 5 ' Centered across columns
Dim pmVAlignTop, pmVAlignCenter, pmVAlignBottom, pmVAlignJustify
pmVAlignTop = 0 ' Top
pmVAlignCenter = 1 ' Centered
pmVAlignBottom = 2 ' Bottom
pmVAlignJustify = 3 ' Justified

' Autofit all cols in the sheet
Function sheetAutoFit(sheet)
    sheet.Cells.HorizontalAlignment = pmHAlignCenter
    sheet.Cells.VerticalAlignment = pmVAlignCenter
    sheet.Cells.AutoFit
End Function
		
' Returns -1 if this pc is not in the sheet else 1..n line where the entry has been found
Function sheetThisPCinSheet(sheet)
        dim serialNumber
        strComputer = "."
        Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
        Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)
        For Each objItem in colItems
            serialNumber = objItem.SerialNumber
	Next
	Dim res
	res = -1
	Set rows = sheet.Rows
	For i = 1 To usedRows(sheet,positions("cpu"))
		Set range = sheet.Range(positions("no_serie") & i)
		Set c = range.Item(1)
		if c.Value=serialNumber then
			res = i	
			Exit For
		end if
	next
	sheetThisPCinSheet = res
End Function
