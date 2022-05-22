unit UnitExcel;

interface

Uses
    ClassLinkedList;

Procedure SaveTableInExcel();
Procedure CreateExcelFile();

implementation

Uses
    ComObj, ActiveX, Variants, Windows, Messages, SysUtils, Classes,
    ConstantsTable, ConstantsFile, UnitWorkWithTables;

Var
    XL: variant; // Переменная в которой создаётся обьект EXCEL

Procedure CreateExcelFile();
Begin
    // Обьект EXCEL
    XL := CreateOleObject('Excel.Application');
    // Чтоб не задавал вопрос о сохранении документа
    XL.DisplayAlerts := false;
    // новый документ
    XL.WorkBooks.Add;
End;

Procedure AddSheets(NumOfSheets: Integer);
Var
    I: Integer;
Begin
    For I := 1 to NumOfSheets do
        XL.WorkSheets.Add;
End;

Procedure SetCaptionSheet(NumOfSheet: Integer; Caption: string);
Begin
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Name := Caption;
End;

Procedure MakeEditingRow(MaxIndex, NumOfSheet: Integer);
Var
    I: Integer;
Begin
    For I := 1 to MaxIndex do
    begin
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Rows[I].VerticalAlignment := 2;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Rows[I].HorizontalAlignment := 4;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Rows[I].Font.Name :=
          'Times New Roman';
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Rows[I].Font.Size := 12;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Rows[I].Font.Bold := True;
    end;
End;

Procedure FillSheetExcel(List: TLinkedList; NumOfSheet: Integer);
Var
    I: Integer;
    CurrentElem: PList;
Begin
    I := 2;
    CurrentElem := List.Header;
    While (CurrentElem^.Next <> nil) do
    begin
        CurrentElem := CurrentElem^.Next;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 1] := I - 1;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 2] :=
          CurrentElem^.Watch.Manufactorer;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 3] :=
          CurrentElem^.Watch.Model;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 4] :=
          CurrentElem^.Watch.Price;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 5] :=
          CurrentElem^.Watch.Amount;
        XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[I, 6] :=
          DateToStr(CurrentElem^.Watch.Date);
        Inc(I);
    end;
End;

Procedure SetNameCol(NumOfSheet: Integer);
Begin
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 1] := TITLE_NUMBER;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 2] := TITLE_MANUFACTORER;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 3] := TITLE_MODEL;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 4] := TITLE_PRICE;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 5] := TITLE_AMOUNT;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Cells[1, 6] := TITLE_DATE;
End;

Procedure SetColWidth(NumOfSheet: Integer);
Begin
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[1].ColumnWidth := 4.5;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[2].ColumnWidth := 50;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[3].ColumnWidth := 50;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[4].ColumnWidth := 25;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[5].ColumnWidth := 25;
    XL.WorkBooks[1].WorkSheets[NumOfSheet].Columns[6].ColumnWidth := 25;
End;

Procedure SaveTableInExcel();
Var
    I: Integer;
    List: TLinkedList;
Begin
    CreateExcelFile();
    AddSheets(2);
    For I := 1 to 3 do
    begin
        // prepare and configure table
        SetCaptionSheet(I, ARRAY_LABEL[I - 1]);
        MakeEditingRow(6, I);
        SetNameCol(I);
        SetColWidth(I);

        List := TLinkedList.Create;
        List := TLinkedList.FindList(ARRAY_NAME_FILES[I - 1]); // find next list
        FillSheetExcel(List, I); // fill data
    end;
    XL.Visible := True;
End;

end.
