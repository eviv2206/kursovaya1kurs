unit UnitWorkWithTables;

interface

Uses
    SysUtils, UnitUtilities, ClassLinkedList, ClassWatch, Vcl.Grids, UnitTable,
    UnitMainMenu,
    ConstantsTable, ConstantsAddOrDelete, UnitTransfer, UnitAddOrDeleteElement;

Function SaveTableAs(Form: TFormTable; List: TLinkedList): Boolean;
Procedure ChangeEnableRadioButton(Form: TFormTable;
  FormTransfer: TFormTransfer);
Procedure AddElementToList(Watch: TWatch; List: TLinkedList);
Procedure DeleteElementFromList(TempWatch: TWatch; List: TLinkedList);
Procedure OpenAddOrDeleteForm(FormAddOrDelete: TFormAddOrDeleteElement;
  SG: TStringGrid; CurrentRow: Integer);

Procedure NewFile(List: TLinkedList; FileName: string);
procedure OpenTable(FormLabel: string; FormTable: TFormTable;
  FormMainMenu: TFormMainMenu; FileName: String);
Procedure AddElementToFile(Watch: TWatch; FileName: string);
Procedure ActionEnableChange(Form: TFormTable; ActionState: Boolean);
Procedure ResetFixedSG(SG: TStringGrid);

implementation

procedure OpenTable(FormLabel: string; FormTable: TFormTable;
  FormMainMenu: TFormMainMenu; FileName: String);
Begin
    if (FormTable.Caption <> FormLabel) then
    begin
        ClearSG(FormTable.SG);
        FormTable.Caption := FormLabel;
        UnitTable.Caption := FormLabel;
        UnitTable.FileName := FileName;
        UnitTable.List := TLinkedList.FindList(FileName);
        UnitTable.CurrentRow := 1;
        FillSG(FormTable.SG, UnitTable.List);
    end;
    ActionEnableChange(FormTable, True);
    FormMainMenu.Close;
    FormTable.SG.SetFocus;
End;

Procedure OpenAddOrDeleteForm(FormAddOrDelete: TFormAddOrDeleteElement;
  SG: TStringGrid; CurrentRow: Integer);
Begin
    if (SG.Cells[0, CurrentRow] <> '') then
        // checking whether the selected item is empty
        With FormAddOrDelete do
        Begin
            // configuring buttons and caption in the necessary conditions
            Caption := LABEL_DELETE_CHANGE;
            BtnChange.Visible := True;
            BtnDelete.Visible := True;
            BtnAdd.Visible := False;
            // set edits with selected element
            EditManufactorer.Text := SG.Cells[1, CurrentRow];
            EditModel.Text := SG.Cells[2, CurrentRow];
            EditPrice.Text := SG.Cells[3, CurrentRow];
            EditAmount.Text := SG.Cells[4, CurrentRow];
            CalendarPicker.Date := StrToDate(SG.Cells[5, CurrentRow]);
        End
    else
        With FormAddOrDelete do
        begin
            // configuring buttons and caption in the necessary conditions
            Caption := LABEL_ADD;
            BtnAdd.Visible := True;
            BtnChange.Visible := False;
            BtnDelete.Visible := False;
        end;
    FormAddOrDelete.ShowModal;
End;

Procedure NewFile(List: TLinkedList; FileName: string);
Var
    F: File of TRecordWatch;
Begin
    List.Destroy; // destroy an instance of class TLinkedList
    List := TLinkedList.Create; // create a new instance
    AssignFile(F, FileName);
    Rewrite(F); // clear old file
    CloseFile(F);
End;

Procedure AddElementToFile(Watch: TWatch; FileName: string);
Var
    F: File of TRecordWatch;
    TempWatch: TRecordWatch;
Begin
    AssignFile(F, FileName);
    If (Not(FileExists(FileName))) then
        Rewrite(F)
    else
    begin
        Reset(F);
        Seek(F, FileSize(F));
    end;
    TempWatch := Watch.ConvertToRecord();
    Write(F, TempWatch);
    CloseFile(F);
End;

Function FindList(FileName: string): TLinkedList;
Var
    F: File of TRecordWatch;
    TempRecord: TRecordWatch;
    TempWatch: TWatch;
    List: TLinkedList;
Begin
    List := TLinkedList.Create;
    AssignFile(F, FileName);
    If (Not(FileExists(FileName))) then
    begin
        Rewrite(F);
    end
    else
    begin
        Reset(F);
        if FileSize(F) <> 0 then
            while (not Eof(F)) do
            Begin
                Read(F, TempRecord);
                TempWatch := TempWatch.ConvertToTWatch(TempRecord);
                List.AddElementAtEnd(TempWatch);
            End;
    end;
    CloseFile(F);
    Result := List;
End;

Procedure AddElementToList(Watch: TWatch; List: TLinkedList);
Begin
    List.AddElementAtEnd(Watch);
End;

Procedure DeleteElementFromList(TempWatch: TWatch; List: TLinkedList);
Begin
    List.DeleteElement(TempWatch);
End;

Function SaveTableAs(Form: TFormTable; List: TLinkedList): Boolean;
Begin
    if (Form.SaveDialog.Execute) then
    begin
        List.SaveList(Form.SaveDialog.FileName);
        Result := True;
    end
    Else
        Result := False;
End;

Procedure ChangeEnableRadioButton(Form: TFormTable;
  FormTransfer: TFormTransfer);
Begin
    if UnitTable.Caption = LABEL_IN_STOCK then
    begin
        With FormTransfer do
        begin
            RadioButtonInStock.Enabled := False;
            RadioButtonForSale.Enabled := True;
            RadioButtonSold.Enabled := True;
        end;
    end;
    if UnitTable.Caption = LABEL_FOR_SALE then
    begin
        With FormTransfer do
        begin
            RadioButtonInStock.Enabled := True;
            RadioButtonForSale.Enabled := False;
            RadioButtonSold.Enabled := True;
        end;
    end;
    if UnitTable.Caption = LABEL_SOLD then
    begin
        With FormTransfer do
        begin
            RadioButtonInStock.Enabled := True;
            RadioButtonForSale.Enabled := True;
            RadioButtonSold.Enabled := False;
        end;
    end;
End;

Procedure ActionEnableChange(Form: TFormTable; ActionState: Boolean);
Begin
    With Form do
    begin
        ActionAddElem.Enabled := ActionState;
        ActionSave.Enabled := ActionState;
        ActionSaveAs.Enabled := ActionState;
        ActionNewFile.Enabled := ActionState;
    end;
End;

Procedure ResetFixedSG(SG: TStringGrid);
Begin
    SG.Cells[0, 0] := TITLE_NUMBER;
    SG.Cells[1, 0] := TITLE_MANUFACTORER;
    SG.Cells[2, 0] := TITLE_MODEL;
    SG.Cells[3, 0] := TITLE_PRICE;
    SG.Cells[4, 0] := TITLE_AMOUNT;
    SG.Cells[5, 0] := TITLE_DATE;
End;

end.
