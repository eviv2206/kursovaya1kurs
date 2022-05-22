unit UnitSearch;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, System.UITypes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    Vcl.WinXCalendars, UnitWorkWithTables, UnitTable,
    ClassWatch, ClassLinkedList, ConstantsLinkedList, ConstantsTable,
    UnitUtilities;

type
    TFormSearch = class(TForm)
        Label1: TLabel;
        EditManufactorer: TEdit;
        Label2: TLabel;
        EditModel: TEdit;
        CalendarPicker: TCalendarPicker;
        Label3: TLabel;
        BtnSearch: TButton;
        procedure BtnSearchClick(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    FormSearch: TFormSearch;

implementation

{$R *.dfm}

Procedure ClearAllFields(Form: TFormSearch);
Begin
    Form.EditManufactorer.Text := '';
    Form.EditModel.Text := '';
End;

procedure TFormSearch.BtnSearchClick(Sender: TObject);
var
    Watch: TWatch;
    List: TLinkedList;
begin
    // create an instance of TWatch
    Watch := TWatch.Create();
    if (Length(EditManufactorer.Text) > 0) then
        Watch.Manufactorer := EditManufactorer.Text
    else
        Watch.Manufactorer := EMPTY_STR;
    if (Length(EditModel.Text) > 0) then
        Watch.Model := EditModel.Text
    else
        Watch.Model := EMPTY_STR;
    Watch.Date := CalendarPicker.Date;
    List := TLinkedList.Create; // create new list
    List := UnitTable.List.FindAllElements(Watch); // fill new list
    if (List.Header^.Next <> nil) then // fill String Grid
    begin
        ClearSG(FormTable.SG);
        FillSG(FormTable.SG, List);
        FormTable.Caption := LABEL_SEARCH;
        ActionEnableChange(FormTable, False);
    end
    else
        MessageDlg('По вашему запросу ничего не найдено', mtInformation,
          [mbOK], 0);
    Self.Close;
end;

procedure TFormSearch.FormActivate(Sender: TObject);
begin
    Self.Left := (Monitor.Width - Self.Width) div 2;
    Self.Top := (Monitor.Height - Self.Height) div 2;
    EditManufactorer.MaxLength := 22;
    EditModel.MaxLength := 22;
end;

procedure TFormSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ClearAllFields(Self);
end;

End.
