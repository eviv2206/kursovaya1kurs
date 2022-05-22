unit UnitWorkWithBytes;

interface

uses
    System.SysUtils;

Type
    TArrByte = Array Of Byte;
    LimitedStr = String[22];
Function DateToByteArr(Date: TDate): TArrByte;
Function RealToByteArr(R: Real): TArrByte;
Function IntToByteArr(I: Integer): TArrByte;
Function StrToByteArr(Str: LimitedStr): TArrByte;
Function ByteToDate(var ByteArr: TArrByte): TDate;
Function ByteToReal(var ByteArr: TArrByte): Real;
Function ByteToStr(var ByteArr: TArrByte): LimitedStr;
Function ByteToInt(var ByteArr: TArrByte): Integer;

implementation

Function DateToByteArr(Date: TDate): TArrByte;
Begin
    SetLength(Result, SizeOf(TDate));
    Move(Date, Result[0], SizeOf(TDate));
End;

Function RealToByteArr(R: Real): TArrByte;
Begin
    SetLength(Result, SizeOf(Real));
    Move(R, Result[0], SizeOf(Real));
End;

Function IntToByteArr(I: Integer): TArrByte;
Begin
    SetLength(Result, SizeOf(Integer));
    Move(I, Result[0], SizeOf(Integer));
End;

Function StrToByteArr(Str: LimitedStr): TArrByte;
Begin
    SetLength(Result, SizeOf(LimitedStr));
    Move(Str, Result[0], SizeOf(LimitedStr));
End;

Function ByteToDate(var ByteArr: TArrByte): TDate;
Var
    Pt: ^TDate;
Begin
    If Length(ByteArr) = SizeOf(TDate) then
    begin
        Pt := @ByteArr[0];
        Result := Pt^;
    end;
End;

Function ByteToReal(var ByteArr: TArrByte): Real;
Var
    Pt: ^Real;
Begin
    If Length(ByteArr) = SizeOf(Real) then
    begin
        Pt := @ByteArr[0];
        Result := Pt^;
    end;
End;

Function ByteToStr(var ByteArr: TArrByte): LimitedStr;
Var
    Pt: ^LimitedStr; // typed pointer
Begin
    if Length(ByteArr) = SizeOf(LimitedStr) then
    begin
        Pt := @ByteArr[0];
        Result := Pt^;
    end;
End;

Function ByteToInt(var ByteArr: TArrByte): Integer;
Var
    Pt: ^Integer;
Begin
    If Length(ByteArr) = SizeOf(Integer) then
    begin
        Pt := @ByteArr[0];
        Result := Pt^;
    end;
End;

end.
