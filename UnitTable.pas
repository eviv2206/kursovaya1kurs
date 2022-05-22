unit UnitTable;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, System.UITypes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Grids,
    System.Actions,
    Vcl.ActnList, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, System.ImageList,
    Vcl.ImgList, Vcl.ComCtrls, ClassLinkedList, Vcl.StdCtrls,
    System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
    TFormTable = class(TForm)
        MainMenu: TMainMenu;
        MenuFile: TMenuItem;
        MenuFunctions: TMenuItem;
        MenuHelp: TMenuItem;
        MenuTables: TMenuItem;
        SG: TStringGrid;
        ActionList: TActionList;
        ActionNewFile: TAction;
        ActionSave: TAction;
        ActionSaveAs: TAction;
        ActionAddElem: TAction;
        ActionDeleteElem: TAction;
        ActionFindElement: TAction;
        ImageList: TImageList;
        MenuNew: TMenuItem;
        MenuSave: TMenuItem;
        MenuSaveAs: TMenuItem;
        N4: TMenuItem;
        MainMenuExit: TMenuItem;
        MainMenuAddElement: TMenuItem;
        MainMenuDeleteElement: TMenuItem;
        ActionExit: TAction;
        ComboBoxCurrency: TComboBox;
        NetHTTPClient1: TNetHTTPClient;
        ToolBar: TToolBar;
        ToolButtonNew: TToolButton;
        ToolButtonSave: TToolButton;
        ToolButtonSaveAs: TToolButton;
        ToolButton1: TToolButton;
        ToolButtonAddElement: TToolButton;
        ToolButtonDeleteElem: TToolButton;
        ToolButtonSearch: TToolButton;
        LabelCurrency: TLabel;
        OpenDialog: TOpenDialog;
        SaveDialog: TSaveDialog;
        ActionTransfer: TAction;
        ToolButtonTransfer: TToolButton;
        MainMenuTransfer: TMenuItem;
        MainMenuSearch: TMenuItem;
        ActionSort: TAction;
        ProgressBar: TProgressBar;
        ActionExcelSave: TAction;
        MenuExcel: TMenuItem;
        MenuExcelSave: TMenuItem;
        procedure FormActivate(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure MenuTablesClick(Sender: TObject);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState;
          X, Y: Integer);
        procedure FormCanResize(Sender: TObject;
          var NewWidth, NewHeight: Integer; var Resize: Boolean);
        procedure ActionExitExecute(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure MenuHelpClick(Sender: TObject);
        procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
          var CanSelect: Boolean);
        procedure SGDblClick(Sender: TObject);
        procedure ActionAddElemExecute(Sender: TObject);
        procedure ActionDeleteElemExecute(Sender: TObject);
        procedure ComboBoxCurrencySelect(Sender: TObject);
        procedure SGMouseEnter(Sender: TObject);
        procedure ActionSaveExecute(Sender: TObject);
        procedure ActionSaveAsExecute(Sender: TObject);
        procedure ActionNewFileExecute(Sender: TObject);
        procedure ActionTransferExecute(Sender: TObject);
        procedure FormKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
        procedure ActionFindElementExecute(Sender: TObject);
        procedure SGFixedCellClick(Sender: TObject; ACol, ARow: Integer);
        procedure ActionSortExecute(Sender: TObject);
        procedure ActionExcelSaveExecute(Sender: TObject);

        // procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
        // State: TGridDrawState);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Caption: String;
    FormTable: TFormTable;
    List: TLinkedList;
    CurrentRow, FixedCurrentRow, FixedCurrentCol: Integer;
    FileName: String;
    IsShowSaveForm: Boolean;
    IsHigher: Boolean = True;

implementation

Uses
    UnitMainMenu, ConstantsTable, UnitUtilities, UnitAddOrDeleteElement,
    UnitWorkWithTables,
    UnitTransfer, UnitSearch, ClassWatch, ClassBinaryTree, UnitExcel,
    UnitCurrency, ConstantsFile;

{$R *.dfm}

Procedure ResizeSG(SG: TStringGrid; Form: TForm);
Var
    Width: Integer;
Begin
    SG.ColWidths[0] := Form.Width div 10;
    SG.ColWidths[4] := SG.ColWidths[0];
    SG.ColWidths[3] := SG.ColWidths[0];
    SG.ColWidths[5] := Round(SG.ColWidths[0] * 1.5);
    Width := Round((Form.Width - SG.ColWidths[0] * 4.5)) div 2;
    SG.ColWidths[1] := Width;
    SG.ColWidths[2] := Width;
End;

Procedure BtnEnableChange(Form: TFormTable);
Var
    IsEnable: Boolean;
Begin
    With Form do
    Begin
        IsEnable := SG.Cells[1, CurrentRow] <> '';
        ActionDeleteElem.Enabled := IsEnable;
        ActionTransfer.Enabled := IsEnable;
    End;
End;

procedure TFormTable.ActionAddElemExecute(Sender: TObject);
begin
    ComboBoxCurrency.ItemIndex := INDEX_BYN;
    OpenAddOrDeleteForm(FormAddOrDeleteElement, FormTable.SG, SG.RowCount - 1);
end;

procedure TFormTable.ComboBoxCurrencySelect(Sender: TObject);
Var
    Currency: Double;
    IsCorrect: Boolean;
begin
    IsCorrect := True;
    Try
        case ComboBoxCurrency.ItemIndex of // case of currency id
            1:
                Currency := GetCurrency(456) / 100;
            // divide by 10 cause of currency = 100RUB
            2:
                Currency := GetCurrency(431)
        else
            Currency := 1;
        end;
    Except
        on E: ENetHTTPClientException do // processing the error
        Begin
            MessageDlg('Проблемы с соединением.', mtError, [mbOK], 0);
            IsCorrect := False;
        End;
    End;
    if IsCorrect then
        ChangeCurrency(List.Header, SG, Currency)
    else
        ComboBoxCurrency.ItemIndex := INDEX_BYN; // reset currency

end;

procedure TFormTable.ActionDeleteElemExecute(Sender: TObject);
Var
    TempWatch: TWatch;
begin
    TempWatch := TWatch.Create(FormTable.SG.Cells[1, CurrentRow],
      FormTable.SG.Cells[2, CurrentRow],
      StrToInt(FormTable.SG.Cells[3, CurrentRow]),
      StrToInt(FormTable.SG.Cells[4, CurrentRow]),
      StrToDate(FormTable.SG.Cells[5, CurrentRow]));
    // create an instance of class TWatch
    DeleteElementFromList(TempWatch, List); // delete element from list
    DeleteElementFromSG(CurrentRow, FormTable.SG);
    // delete element from StringGrid
    BtnEnableChange(Self); // change condition of buttons
    IsShowSaveForm := True;
    // change condition of variable needed while closing app
end;

procedure TFormTable.ActionExcelSaveExecute(Sender: TObject);
Var
    IsOpen: Boolean;
begin
    IsOpen := True;
    Try
        CreateExcelFile(); // Trying to create and open excel
    Except
        IsOpen := False;
        MessageDlg('Невозможно открыть Excel-файл', mtError, [mbOK], 0);
    End;
    If IsOpen then
    Begin
        List.SaveList(FileName);
        SaveTableInExcel();
    End;
end;

procedure TFormTable.ActionExitExecute(Sender: TObject);
begin
    Self.Close;
end;

procedure TFormTable.ActionFindElementExecute(Sender: TObject);
begin
    FormSearch.ShowModal;
end;

procedure TFormTable.FormActivate(Sender: TObject);
begin
    // ShowWindow(FormMainMenu.Handle, SW_HIDE);
    // ShowWindow(Self.Handle, SW_MAXIMIZE);
    // SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    // Self.Constraints.MinWidth := Monitor.Width;
    // Self.Constraints.MinHeight := Monitor.Height;
    Self.WindowState := wsMaximized;
    // Self.BorderStyle:=bsNone;
    // Self.Width:=Screen.Width;
    // Self.height:=Screen.Height;
    ResizeSG(SG, FormTable);
    ResetFixedSG(SG);
end;

procedure TFormTable.FormCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
    ResizeSG(SG, FormTable);
end;

procedure TFormTable.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    BtnMenu: Integer;
begin
    If IsShowSaveForm then
    begin
        BtnMenu := MessageDlg('Есть несохраненные данные. Сохранить их?',
          mtWarning, [mbYes, mbNo], 0);
        If BtnMenu = mrYes then
        Begin
            List.SaveList(FileName);
            CanClose := True;
        End
        Else if BtnMenu = mrNo then
            CanClose := True
        else
            CanClose := False;
    end;
    BtnMenu := MessageDlg('Вы уверены, что хотите закрыть программу?',
      mtConfirmation, [mbYes, mbNo], 0);
    if BtnMenu = mrYes then
        CanClose := True
    else
        CanClose := False;
end;

procedure TFormTable.FormCreate(Sender: TObject);
begin
    ResetFixedSG(SG);
    List := TLinkedList.Create();
    FileName := FILE_NAME_IN_STOCK;
    UnitTable.Caption := LABEL_IN_STOCK;
    List := TLinkedList.FindList(FileName);
    FillSG(SG, List);
    LabelCurrency.Caption := #13#10 + 'Валюта:';
    CurrentRow := 1;
    IsShowSaveForm := False;
end;

procedure TFormTable.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

    if (Key = VK_ESCAPE) then
        Self.Close;
    If (Key = VK_F1) then
        Self.MenuHelp.Click;
    If (Key = VK_RETURN) and (ActionAddElem.Enabled) then
        SGDblClick(SG);
end;

procedure TFormTable.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
    ResizeSG(SG, FormTable);
end;

procedure TFormTable.MenuHelpClick(Sender: TObject);
begin
    MessageDlg(INFO_LABEL, mtInformation, [mbOK], 0);
end;

procedure TFormTable.MenuTablesClick(Sender: TObject);
begin
    ResetFixedSG(SG);
    List.SaveList(FileName);
    IsShowSaveForm := False;
    FormMainMenu.ShowModal;
end;

procedure TFormTable.ActionNewFileExecute(Sender: TObject);
Var
    Key: Integer;
begin
    Key := MessageDlg
      ('Вы уверены, что хотите стереть старый файл и создать новый?',
      mtConfirmation, [mbYes, mbNo], 0);
    If Key = mrYes then
    Begin
        NewFile(List, FileName);
        ClearSG(SG);
    End;
end;

procedure TFormTable.ActionSaveExecute(Sender: TObject);
begin
    List.SaveList(FileName);
    MessageDlg('Успешно сохранено', mtConfirmation, [mbOK], 0);
    IsShowSaveForm := False;
end;

procedure TFormTable.ActionSortExecute(Sender: TObject);
Var
    BinaryTree: TBinaryTree;
begin
    BinaryTree := TBinaryTree.Create;
    ProgressBar.Visible := True;
    ProgressBar.Position := 10;
    If (FixedCurrentCol <> 0) then
        If (IsHigher) then
        begin
            BinaryTree.ConvertListToTree(List, FixedCurrentCol);
            ProgressBar.Position := 40;
            List := BinaryTree.ConvertTreeToAscendingList;
            ProgressBar.Position := 80;
            ClearSG(SG);
            FillSG(SG, List);
            ProgressBar.Position := 90;
            SG.Cells[FixedCurrentCol, FixedCurrentRow] :=
              TITLE_ARRAY[FixedCurrentCol] + '🔼';
        end
        else
        begin
            BinaryTree.ConvertListToTree(List, FixedCurrentCol);
            ProgressBar.Position := 40;
            List := BinaryTree.ConvertTreeToDescendingList;
            ProgressBar.Position := 80;
            ClearSG(SG);
            FillSG(SG, List);
            ProgressBar.Position := 90;
            SG.Cells[FixedCurrentCol, FixedCurrentRow] :=
              TITLE_ARRAY[FixedCurrentCol] + '🔽';
        end;

    ProgressBar.Visible := False;
    IsHigher := not IsHigher;
end;

procedure TFormTable.ActionSaveAsExecute(Sender: TObject);
begin
    if SaveTableAs(Self, List) then
        MessageDlg('Успешно сохранено', mtConfirmation, [mbOK], 0);
end;

procedure TFormTable.SGDblClick(Sender: TObject);
begin
    ComboBoxCurrency.ItemIndex := INDEX_BYN;
    OpenAddOrDeleteForm(FormAddOrDeleteElement, FormTable.SG, CurrentRow);
end;

procedure TFormTable.SGFixedCellClick(Sender: TObject; ACol, ARow: Integer);
begin
    If (FixedCurrentCol <> ACol) then
    Begin
        ResetFixedSG(SG);
        IsHigher := True;
    End;
    FixedCurrentRow := ARow;
    FixedCurrentCol := ACol;
    ActionSort.Execute;
end;

procedure TFormTable.SGMouseEnter(Sender: TObject);
begin
    BtnEnableChange(Self);
end;

procedure TFormTable.SGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    CurrentRow := ARow;
    BtnEnableChange(Self);
end;

procedure TFormTable.ActionTransferExecute(Sender: TObject);
begin
    ChangeEnableRadioButton(Self, FormTransfer);
    With FormTransfer do
    Begin
        // fill TEdit and TCalendarPicker with data
        EditAmount.Text := FormTable.SG.Cells[4, CurrentRow];
        CalendarPicker.Date := StrToDate(FormTable.SG.Cells[5, CurrentRow]);
        UnitTransfer.Watch := UnitTable.List.FindElementByModelDate
          (FormTable.SG.Cells[2, CurrentRow],
          StrToDate(FormTable.SG.Cells[5, CurrentRow]));
        ShowModal;
    End;
end;

end.
