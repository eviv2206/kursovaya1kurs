unit UnitMainMenu;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, System.UITypes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls;

type
    TFormMainMenu = class(TForm)
        BtnOpenInStock: TButton;
        Label1: TLabel;
        MenuMain: TMainMenu;
        MenuHelp: TMenuItem;
        BtnOpenOnSale: TButton;
        BtnOpenSold: TButton;
        procedure FormActivate(Sender: TObject);
        procedure MenuHelpClick(Sender: TObject);
        procedure BtnOpenInStockClick(Sender: TObject);
        procedure FormKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
        procedure BtnOpenOnSaleClick(Sender: TObject);
        procedure BtnOpenSoldClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    FormMainMenu: TFormMainMenu;

implementation

Uses
    UnitTable, ConstantsFile, UnitUtilities, UnitWorkWithTables, ConstantsTable;
{$R *.dfm}

procedure TFormMainMenu.BtnOpenInStockClick(Sender: TObject);
Begin
    OpenTable(LABEL_IN_STOCK, FormTable, FormMainMenu, FILE_NAME_IN_STOCK);
End;

procedure TFormMainMenu.BtnOpenOnSaleClick(Sender: TObject);
begin
    OpenTable(LABEL_FOR_SALE, FormTable, FormMainMenu, FILE_NAME_FOR_SALE);
end;

procedure TFormMainMenu.BtnOpenSoldClick(Sender: TObject);
begin
    OpenTable(LABEL_SOLD, FormTable, FormMainMenu, FILE_NAME_SOLD_PRODUCT);
end;

procedure TFormMainMenu.FormActivate(Sender: TObject);
begin
    Self.Left := (Monitor.Width - Self.Width) div 2;
    Self.Top := (Monitor.Height - Self.Height) div 2;
end;

procedure TFormMainMenu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_ESCAPE) then
        Self.Close;
    If (Key = VK_F1) then
        Self.MenuHelp.Click;
end;

procedure TFormMainMenu.MenuHelpClick(Sender: TObject);
begin
    MessageDlg('Выберите таблицу из предложенных.', mtInformation,
      [mbOK], SW_HIDE);
end;

end.
