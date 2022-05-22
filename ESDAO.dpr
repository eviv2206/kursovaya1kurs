program ESDAO;

uses
  Vcl.Forms,
  UnitTable in 'UnitTable.pas' {FormTable},
  UnitMainMenu in 'UnitMainMenu.pas' {FormMainMenu},
  ClassLinkedList in 'ClassLinkedList.pas',
  ClassWatch in 'ClassWatch.pas' {ConstantsTable in 'ConstantsTable.pas',
  UnitInStock in 'UnitInStock.pas',
  UnitAddOrDeleteElement in 'UnitAddOrDeleteElement.pas' {FormAddOrDeleteElement},
  ConstantsTable in 'ConstantsTable.pas',
  UnitAddOrDeleteElement in 'UnitAddOrDeleteElement.pas' {FormAddOrDeleteElement},
  ConstantsAddOrDelete in 'ConstantsAddOrDelete.pas',
  UnitWorkWithTables in 'UnitWorkWithTables.pas',
  ConstantsFile in 'ConstantsFile.pas',
  UnitTransfer in 'UnitTransfer.pas' {FormTransfer},
  ConstantsTransfer in 'ConstantsTransfer.pas',
  UnitSearch in 'UnitSearch.pas' {FormSearch},
  ConstantsLinkedList in 'ConstantsLinkedList.pas',
  ClassBinaryTree in 'ClassBinaryTree.pas',
  UnitWorkWithBytes in 'UnitWorkWithBytes.pas',
  UnitExcel in 'UnitExcel.pas',
  UnitUtilities in 'UnitUtilities.pas',
  UnitCurrency in 'UnitCurrency.pas';

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TFormTable, FormTable);
  Application.CreateForm(TFormMainMenu, FormMainMenu);
  Application.CreateForm(TFormAddOrDeleteElement, FormAddOrDeleteElement);
  Application.CreateForm(TFormTransfer, FormTransfer);
  Application.CreateForm(TFormSearch, FormSearch);
  Application.Run;

end.
