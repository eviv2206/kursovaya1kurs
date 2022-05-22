unit ClassWatch;

interface

Uses
    Vcl.Imaging.jpeg, System.Classes, System.SysUtils, UnitWorkWithBytes;

Type
    TRecordWatch = Record
        Manufactorer: LimitedStr;
        Model: LimitedStr;
        Price: Real;
        Amount: Integer;
        Date: TDate;
    End;

    LimitedStr = string[22];
    TComparatorFunc = Function(Data, CurrentData: TArrByte): Integer of Object;

    TWatch = class
        Manufactorer: LimitedStr;
        Model: LimitedStr;
        Price: Real;
        Amount: Integer;
        Date: TDate;
    Public
        Constructor Create(Manufactorer, Model: LimitedStr; Price: Real;
          Amount: Integer; Date: TDate); overload;
        Constructor Create(); overload;

        Function ConvertToRecord(): TRecordWatch;
        Class Function ConvertToTWatch(TempRecord: TRecordWatch): TWatch;
        Class Function ComparatorStr(Data, CurrentData: TArrByte): Integer;
        Class Function ComparatorInt(Data, CurrentData: TArrByte): Integer;
        Class Function ComparatorDate(Data, CurrentData: TArrByte): Integer;
        Class Function ComparatorReal(Data, CurrentData: TArrByte): Integer;
    end;

implementation

Constructor TWatch.Create();
Begin
    Self.Manufactorer := '';
    Self.Model := '';
    Self.Amount := 0;
    Self.Price := 0;
    Self.Date := StrToDate('11.11.1111');
End;

Constructor TWatch.Create(Manufactorer, Model: LimitedStr; Price: Real;
  Amount: Integer; Date: TDate);
Begin
    Self.Manufactorer := Manufactorer;
    Self.Model := Model;
    Self.Price := Price;
    Self.Amount := Amount;
    Self.Date := Date;
End;

Class Function TWatch.ComparatorStr(Data, CurrentData: TArrByte): Integer;
Var
    TypedData, TypedCurrentData: LimitedStr;
Begin
    TypedData := ByteToStr(Data); // convert to LimitedStr
    TypedCurrentData := ByteToStr(CurrentData);
    If (TypedData > TypedCurrentData) then
        Result := 1
    else if (TypedData < TypedCurrentData) then
    begin
        Result := -1;
    end
    else
        Result := 0;
End;

Class Function TWatch.ComparatorInt(Data, CurrentData: TArrByte): Integer;
Var
    TypedData, TypedCurrentData: Integer;
Begin
    TypedData := ByteToInt(Data);
    TypedCurrentData := ByteToInt(CurrentData);
    If (TypedData > TypedCurrentData) then
        Result := 1
    else if (TypedData < TypedCurrentData) then
    begin
        Result := -1;
    end
    else
        Result := 0;
End;

Class Function TWatch.ComparatorDate(Data, CurrentData: TArrByte): Integer;
Var
    TypedData, TypedCurrentData: TDate;
Begin
    TypedData := ByteToDate(Data);
    TypedCurrentData := ByteToDate(CurrentData);
    If (TypedData > TypedCurrentData) then
        Result := 1
    else if (TypedData < TypedCurrentData) then
    begin
        Result := -1;
    end
    else
        Result := 0;
End;

Class Function TWatch.ComparatorReal(Data, CurrentData: TArrByte): Integer;
Var
    TypedData, TypedCurrentData: Real;
Begin
    TypedData := ByteToReal(Data);
    TypedCurrentData := ByteToReal(CurrentData);
    If (TypedData > TypedCurrentData) then
        Result := 1
    else if (TypedData < TypedCurrentData) then
    begin
        Result := -1;
    end
    else
        Result := 0;
End;

Class Function TWatch.ConvertToTWatch(TempRecord: TRecordWatch): TWatch;
Begin
    Result := TWatch.Create(TempRecord.Manufactorer, TempRecord.Model,
      TempRecord.Price, TempRecord.Amount, TempRecord.Date);
End;

Function TWatch.ConvertToRecord(): TRecordWatch;
Var
    RecordWatch: TRecordWatch;
Begin
    RecordWatch.Manufactorer := Self.Manufactorer;
    RecordWatch.Model := Self.Model;
    RecordWatch.Amount := Self.Amount;
    RecordWatch.Price := Self.Price;
    RecordWatch.Date := Self.Date;
    Result := RecordWatch;
End;

end.
