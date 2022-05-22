unit UnitCurrency;

interface

Uses
    Vcl.Forms, Vcl.Grids, System.SysUtils, ClassLinkedList;

Procedure ChangeCurrency(List: PList; SG: TStringGrid; Currency: Double);
Function GetCurrency(NumberOfCurrency: Integer): Real;

implementation

USes
    System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

Function FindAPIString(NumberOfCurrency: Integer): String;
var
    HttpClient: THttpClient;
    HttpResponse: IHttpResponse;
    ResponseStr: String;
Begin
    HttpClient := THttpClient.Create;
    try
        HttpResponse := HttpClient.Get('hhttps://www.nbrb.by/api/exrates/rates/'
          + IntToStr(NumberOfCurrency));
        ResponseStr := HttpResponse.ContentAsString;
    finally
        HttpClient.Free;
    end;
    Result := ResponseStr;
End;

Function SeperateCurrency(ResponseStr: string): string;
Var
    I, J: Integer;
    TempStr: string;
Begin
    I := 0;
    while TempStr <> '"Cur_OfficialRate":' do
    begin
        if ResponseStr[I] = ',' then
            TempStr := ''
        else
            TempStr := TempStr + ResponseStr[I];
        Inc(I);
    end;
    TempStr := '';
    For J := 1 to 5 do
    begin
        If ResponseStr[I] = '.' then
            TempStr := TempStr + ','
        else
            TempStr := TempStr + ResponseStr[I];
        Inc(I);
    end;
    Result := TempStr;
End;

Function GetCurrency(NumberOfCurrency: Integer): Real;
Var
    ResponseStr: String;
    Currency: Double;
Begin
    ResponseStr := FindAPIString(NumberOfCurrency);
    Currency := StrToFloat(SeperateCurrency(ResponseStr));
    Result := Currency;
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

end.
