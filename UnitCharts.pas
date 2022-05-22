unit UnitCharts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart;

type
  TFormCharts = class(TForm)
    Chart1: TChart;
    Series1: TPieSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form—harts: TFormCharts;

implementation

{$R *.dfm}

end.
