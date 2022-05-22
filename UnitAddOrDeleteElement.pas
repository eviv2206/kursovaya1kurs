unit UnitAddOrDeleteElement;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, System.UITypes,
    Vcl.Controls, Vcl.WinXCalendars, Vcl.StdCtrls, Vcl.Graphics,
    Vcl.Forms, Vcl.Dialogs;

type
    TFormAddOrDeleteElement = class(TForm)
        Label1: TLabel;
        EditManufactorer: TEdit;
        Label2: TLabel;
        EditModel: TEdit;
        Label3: TLabel;
        EditPrice: TEdit;
        Label4: TLabel;
        EditAmount: TEdit;
        BtnChange: TButton;
        BtnDelete: TButton;
        BtnAdd: TButton;
        Label5: TLabel;
        CalendarPicker: TCalendarPicker;
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure BtnAddClick(Sender: TObject);
        procedure BtnDeleteClick(Sender: TObject);
        procedure EditManufactorerChange(Sender: TObject);
        procedure EditModelChange(Sender: TObject);
        procedure EditPriceChange(Sender: TObject);
        procedure EditAmountChange(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure BtnChangeClick(Sender: TObject);
        procedure EditPriceKeyPress(Sender: TObject; var Key: Char);
        procedure EditAmountKeyPress(Sender: TObject; var Key: Char);
        procedure CalendarPickerChange(Sender: TObject);
        procedure FormKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);

    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    FormAddOrDeleteElement: TFormAddOrDeleteElement;

implementation

{$R *.dfm}

Uses
    UnitTable, UnitWorkWithTables, ClassWatch, UnitUtilities;

Procedure ClearAllFields(Form: TFormAddOrDeleteElement);
Begin
    With Form do
    begin
        EditManufactorer.Text := '';
        EditModel.Text := '';
        EditPrice.Text := '';
        EditAmount.Text := '';
        CalendarPicker.IsEmpty := true;
    end;
End;

procedure ChangeEnableAddBtn(Form: TFormAddOrDeleteElement);
Begin
    With Form do
    begin
        if (BtnAdd.Visible) and (EditManufactorer.Text <> '') and
          (EditModel.Text <> '') and (EditPrice.Text <> '') and
          (EditAmount.Text <> '') and
          (DateToStr(CalendarPicker.Date) <> '00.00.0000') then
            BtnAdd.Enabled := true
        else
            BtnAdd.Enabled := False;

    end;
End;

procedure TFormAddOrDeleteElement.BtnAddClick(Sender: TObject);
Var
    Watch: TWatch;
begin
    If IsValidPriceAndAmount(EditPrice.Text, EditAmount.Text) then
    // checks valid input data
    Begin
        Watch := TWatch.Create(EditManufactorer.Text, EditModel.Text,
          StrToFloat(EditPrice.Text), StrToInt(EditAmount.Text),
          CalendarPicker.Date);
        AddElementToList(Watch, UnitTable.List); // create an instance of TWatch
        ShowElementInSG(FormTable.SG, Watch);
        IsShowSaveForm := true;
        Self.Close;
    End
    else
    begin
        MessageDlg('¬ведите корректно данные', mtError, [mbOK], 0);
    end;
end;

procedure TFormAddOrDeleteElement.BtnChangeClick(Sender: TObject);
var
    Watch, PrevWatch: TWatch;
    Index: Integer;
begin
    If IsValidPriceAndAmount(EditPrice.Text, EditAmount.Text) then
    begin
        PrevWatch := TWatch.Create(FormTable.SG.Cells[1, CurrentRow],
          FormTable.SG.Cells[2, CurrentRow],
          StrToFloat(FormTable.SG.Cells[3, CurrentRow]),
          StrToInt(FormTable.SG.Cells[4, CurrentRow]),
          StrToDate(FormTable.SG.Cells[5, CurrentRow]));
        // previous instance of TWatch
        Watch := TWatch.Create(EditManufactorer.Text, EditModel.Text,
          StrToFloat(EditPrice.Text), StrToInt(EditAmount.Text),
          CalendarPicker.Date);
        Index := StrToInt(FormTable.SG.Cells[0, UnitTable.CurrentRow]);
        // new instance of TWatch
        List.ChangeElement(Watch, PrevWatch);
        ChangeElementInSG(FormTable.SG, Watch, Index);
        IsShowSaveForm := true;
        Self.Close;
    end
    else
        MessageDlg('¬ведите корректно данные', mtError, [mbOK], 0);
end;

procedure TFormAddOrDeleteElement.BtnDeleteClick(Sender: TObject);
Var
    TempWatch: TWatch;
begin
    TempWatch := TWatch.Create(FormTable.SG.Cells[1, CurrentRow],
      FormTable.SG.Cells[2, CurrentRow],
      StrToInt(FormTable.SG.Cells[3, CurrentRow]),
      StrToInt(FormTable.SG.Cells[4, CurrentRow]),
      StrToDate(FormTable.SG.Cells[5, CurrentRow]));
    // create an instance of TWatch
    DeleteElementFromList(TempWatch, UnitTable.List); // delete from list
    DeleteElementFromSG(UnitTable.CurrentRow, FormTable.SG);
    // delete from StringGrid
    IsShowSaveForm := true;
    Self.Close;
end;

procedure TFormAddOrDeleteElement.CalendarPickerChange(Sender: TObject);
begin
    ChangeEnableAddBtn(Self);
end;

procedure TFormAddOrDeleteElement.EditAmountChange(Sender: TObject);
begin
    ChangeEnableAddBtn(Self);
end;

procedure TFormAddOrDeleteElement.EditAmountKeyPress(Sender: TObject;
  var Key: Char);
begin
    KeyForAmount(Key, EditAmount.Text);
end;

procedure TFormAddOrDeleteElement.EditManufactorerChange(Sender: TObject);
begin
    ChangeEnableAddBtn(Self);
end;

procedure TFormAddOrDeleteElement.EditModelChange(Sender: TObject);
begin
    ChangeEnableAddBtn(Self);
end;

procedure TFormAddOrDeleteElement.EditPriceChange(Sender: TObject);
begin
    ChangeEnableAddBtn(Self);
end;

procedure TFormAddOrDeleteElement.EditPriceKeyPress(Sender: TObject;
  var Key: Char);
begin
    KeyForPrice(Key, EditPrice.Text);
end;

procedure TFormAddOrDeleteElement.FormActivate(Sender: TObject);
begin
    Self.Left := (Monitor.Width - Self.Width) div 2;
    Self.Top := (Monitor.Height - Self.Height) div 2;
    EditManufactorer.MaxLength := 22;
    EditModel.MaxLength := 22;
    EditPrice.MaxLength := 7;
    EditAmount.MaxLength := 7;

end;

procedure TFormAddOrDeleteElement.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    ClearAllFields(Self);
end;

procedure TFormAddOrDeleteElement.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If (Key = VK_ESCAPE) then
        Self.Close;
end;

end.
