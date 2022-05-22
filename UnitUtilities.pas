unit UnitUtilities;

interface

Uses
    Vcl.Forms, Vcl.Grids, UnitTable, UnitMainMenu, UnitAddOrDeleteElement,
    ClassLinkedList, ClassWatch;

Function IsNum(Str: String; IsInteger: Boolean): Boolean;
Procedure ClearSG(SG: TStringGrid);
Procedure FillSG(SG: TStringGrid; List: TLinkedList);
Procedure DeleteElementFromSG(ARow: Integer; SG: TStringGrid);
Procedure ShowElementInSG(SG: TStringGrid; Watch: TWatch);
Procedure ChangeElementInSG(SG: TStringGrid; Watch: TWatch; Index: Integer);
Function IsValidPriceAndAmount(PriceStr, AmountStr: string): Boolean;
Procedure KeyForPrice(var Key: Char; Str: string);
Procedure KeyForAmount(var Key: Char; Str: string);

implementation

Uses
    System.SysUtils, ConstantsAddOrDelete;

Function IsNum(Str: String; IsInteger: Boolean): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    If IsInteger then
        try
            StrToInt(Str);
        except
            on E: EConvertError do
                IsCorrect := False;
        end
    else
        try
            StrToFloat(Str);
        except
            on E: EConvertError do
                IsCorrect := False;
        end;
    IsNum := IsCorrect;
End;

Procedure DeleteElementFromSG(ARow: Integer; SG: TStringGrid);
Var
    I, J: Integer;
Begin
    for I := ARow + 1 to SG.RowCount - 1 do
        for J := 0 to SG.ColCount - 1 do
            SG.Cells[J, I - 1] := SG.Cells[J, I];
    for I := 0 to SG.ColCount - 1 do
        SG.Cells[I, SG.RowCount - 1] := '';
    SG.RowCount := SG.RowCount - 1;
    For I := 1 to SG.RowCount - 2 do
        SG.Cells[0, I] := IntToStr(I);
end;

Function IsValidPriceAndAmount(PriceStr, AmountStr: string): Boolean;
Begin
    Result := (IsNum(PriceStr, False)) and (IsNum(AmountStr, True)) and
      (StrToFloat(PriceStr) > 0) and (StrToInt(AmountStr) > 0)

End;

Procedure ClearSG(SG: TStringGrid);
Var
    I, J, Col, Row: Integer;
Begin
    Col := SG.ColCount - 1;
    Row := SG.RowCount - 1;
    For I := 1 to Row do
        For J := 0 to Col do
            SG.Cells[J, I] := '';
    SG.RowCount := 2;
End;

Procedure ChangeElementInSG(SG: TStringGrid; Watch: TWatch; Index: Integer);
Var
    CurrentRow: Integer;
Begin
    CurrentRow := Index;
    SG.Cells[1, CurrentRow] := Watch.Manufactorer;
    SG.Cells[2, CurrentRow] := Watch.Model;
    SG.Cells[3, CurrentRow] := FloatToStr(Watch.Price);
    SG.Cells[4, CurrentRow] := FloatToStr(Watch.Amount);
End;

Procedure FillSG(SG: TStringGrid; List: TLinkedList);
Var
    CurrentElem: ClassLinkedList.PList;
Begin
    CurrentElem := List.Header;
    while (CurrentElem^.Next <> nil) do
    begin
        CurrentElem := CurrentElem^.Next;
        ShowElementInSG(SG, CurrentElem^.Watch);
    end;
End;

Procedure ShowElementInSG(SG: TStringGrid; Watch: TWatch);
Var
    CurrentRow: Integer;
Begin
    CurrentRow := SG.RowCount - 1;
    SG.Cells[0, CurrentRow] := IntToStr(CurrentRow);
    SG.Cells[1, CurrentRow] := Watch.Manufactorer;
    SG.Cells[2, CurrentRow] := Watch.Model;
    SG.Cells[3, CurrentRow] := FloatToStr(Watch.Price);
    SG.Cells[4, CurrentRow] := FloatToStr(Watch.Amount);
    SG.Cells[5, CurrentRow] := DateToStr(Watch.Date);
    SG.RowCount := SG.RowCount + 1;
End;

Procedure OpenAddOrDeleteUnit(FormAddOrDelete: TFormAddOrDeleteElement;
  SG: TStringGrid; CurrentRow: Integer);
Begin
    if (SG.Cells[0, CurrentRow] <> '') and
      (FormTable.Caption <> 'Результаты Поиска') then
        With FormAddOrDelete do
        Begin
            Caption := LABEL_DELETE_CHANGE;
            BtnChange.Visible := True;
            BtnDelete.Visible := True;
            BtnAdd.Visible := False;
            EditManufactorer.Text := SG.Cells[1, CurrentRow];
            EditModel.Text := SG.Cells[2, CurrentRow];
            EditPrice.Text := SG.Cells[3, CurrentRow];
            EditAmount.Text := SG.Cells[4, CurrentRow];
            CalendarPicker.Date := StrToDate(SG.Cells[5, CurrentRow]);
        End
    else
        With FormAddOrDelete do
        begin
            Caption := LABEL_ADD;
            BtnAdd.Visible := True;
            BtnChange.Visible := False;
            BtnDelete.Visible := False;
        end;
    FormAddOrDelete.Show;
End;

Procedure ChangeCurrency(List: PList; SG: TStringGrid; Currency: Double);
Var
    I, Len: Integer;
    TempList: PList;
Begin
    TempList := List;
    Len := SG.RowCount - 2;
    For I := 1 to Len do
    begin
        TempList := TempList^.Next;
        SG.Cells[3, I] := Format('%.2f', [TempList^.Watch.Price / Currency]);
    end;
End;

Function IsNumberValid(Str: String): Boolean;
Var
    Len: Integer;
    IsValid: Boolean;
Begin
    IsValid := True;
    Len := Length(Str);
    if Len > 0 then
        if Str[1] = '0' then
            IsValid := False;
    IsNumberValid := IsValid;
End;

Function CheckHasSymbol(Str: String; Symbol: Char): Boolean;
Var
    I, Len: Integer;
    HasSymbol: Boolean;
Begin
    HasSymbol := False;
    Len := Length(Str) + 1;
    I := 1; // на первой позиции(проверить на 00000)
    while Not(HasSymbol) and (I < Len) do // For I := 1 to Len do
    Begin
        If (Str[I] = ',') then
            HasSymbol := True;
        Inc(I)
    End;
    Result := HasSymbol;
End;

Function IsValidComma(Str: string): Boolean;
Var
    IsValid: Boolean;
Begin
    IsValid := False;
    If (Length(Str) > 1) then
        IsValid := True;
    if (Length(Str) = 1) then
        IsValid := Str[Length(Str)] <> '0';
    Result := IsValid;
End;

Procedure KeyForAmount(var Key: Char; Str: string);
Begin
    if not CharInSet(Key, ['0' .. '9', #8]) then
        Key := #0;
    if (CharInSet(Key, ['0' .. '9'])) and ((not IsNumberValid(Str))) then
        Key := #0;
    If (Key = '0') then
        if CheckHasSymbol(Str, '0') then
            Key := #0;

End;

Procedure KeyForPrice(var Key: Char; Str: string);
Begin
    if not(CharInSet(Key, ['0' .. '9', #8, ','])) then
        Key := #0;
    if (CharInSet(Key, ['0' .. '9'])) and ((not IsNumberValid(Str))) then
        Key := #0;
    If (Key = ',') then
    Begin
        if CheckHasSymbol(Str, ',') then
            Key := #0;
        if not(IsValidComma(Str)) then
            Key := #0;
    End;
    If (Key = '0') then
        if CheckHasSymbol(Str, '0') then
            Key := #0;

End;

end.
