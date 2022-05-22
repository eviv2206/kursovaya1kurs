unit UnitTransfer;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCalendars,
    ClassWatch;

type
    TFormTransfer = class(TForm)
        RadioButtonForSale: TRadioButton;
        RadioButtonSold: TRadioButton;
        Label1: TLabel;
        EditAmount: TEdit;
        CalendarPicker: TCalendarPicker;
        Label2: TLabel;
        BtnTransfer: TButton;
        Label3: TLabel;
        RadioButtonInStock: TRadioButton;
        procedure FormActivate(Sender: TObject);
        procedure RadioButtonInStockClick(Sender: TObject);
        procedure RadioButtonForSaleClick(Sender: TObject);
        procedure RadioButtonSoldClick(Sender: TObject);
        procedure BtnTransferClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    FormTransfer: TFormTransfer;
    Watch: TWatch;

implementation

Uses
    ConstantsTransfer, ConstantsFile, ClassLinkedList, UnitWorkWithTables,
    UnitTable, UnitUTilities;

{$R *.dfm}

Var
    RBSelected: Byte;
    FileName: String;

Procedure ChangeEnableTransferBtn(Form: TFormTransfer);
Begin
    If (RBSelected <> 0) and (Form.EditAmount.Text <> '') then
        Form.BtnTransfer.Enabled := True
    else
        Form.BtnTransfer.Enabled := False;
End;

procedure TFormTransfer.BtnTransferClick(Sender: TObject);
var
    TempAmount: Integer;
begin
    TempAmount := Watch.Amount - StrToInt(EditAmount.Text);
    // find amount of prev elem
    if TempAmount < 0 then
    begin
        MessageDlg('¬ведено количество превышающее наличие.', mtError,
          [mbOK], 0);
        EditAmount.Text := '';
    end
    else
    begin
        Watch.Date := CalendarPicker.Date;
        Watch.Amount := StrToInt(EditAmount.Text);
        if Watch.Amount < 1 then
            UnitTable.List.DeleteElement(Watch);
        AddElementToFile(Watch, FileName);
        // add element to other table by adding to file
        Watch.Amount := TempAmount;
        // reset String Grid
        ClearSG(FormTable.SG);
        FillSG(FormTable.SG, UnitTable.List);
        FormTable.ActionAddElem.Enabled := True;
        FormTable.Caption := UnitTable.Caption;
        IsShowSaveForm := True;
        Self.Close;
    end;
end;

procedure TFormTransfer.FormActivate(Sender: TObject);
begin
    Self.Left := (Monitor.Width - Self.Width) div 2;
    Self.Top := (Monitor.Height - Self.Height) div 2;
    EditAmount.MaxLength := 7;
    RBSelected := RB_INITIALIZED;
end;

procedure TFormTransfer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    EditAmount.Text := '';
end;

procedure TFormTransfer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_ESCAPE) then
        Self.CloseQuery;
end;

procedure TFormTransfer.RadioButtonForSaleClick(Sender: TObject);
begin
    RBSelected := RB_IN_STOCK;
    FileName := FILE_NAME_FOR_SALE;
    ChangeEnableTransferBtn(Self);
end;

procedure TFormTransfer.RadioButtonInStockClick(Sender: TObject);
begin
    RBSelected := RB_FOR_SALE;
    FileName := FILE_NAME_IN_STOCK;
    ChangeEnableTransferBtn(Self);
end;

procedure TFormTransfer.RadioButtonSoldClick(Sender: TObject);
begin
    RBSelected := RB_SOLD;
    FileName := FILE_NAME_SOLD_PRODUCT;
    ChangeEnableTransferBtn(Self);
end;

end.
