unit ClassLinkedList;

interface

Uses
    ClassWatch, ConstantsLinkedList, System.SysUtils;

Type
    PList = ^TElement;

    TElement = Record
        Watch: TWatch;
        Next: PList;
        Prev: PList;
    End;

    TLinkedList = class
        Header: PList;
        Tail: PList;
    Private
        { Procedure FillElementWithData(Manufactorer, Model : LimitedStr;
          Amount, Price : Integer; Element : PList); }
    Public
        Constructor Create();
        Procedure AddElementAtEnd(Watch: TWatch);
        Procedure DeleteElement(Watch: TWatch);
        Procedure ChangeElement(CurrentWatch, PrevWatch: TWatch);
        Procedure SaveList(FilePath: string);
        Function FindElementByIndex(Index: Integer): TWatch;
        Function FindElementByModelDate(Model: String; Date: TDate): TWatch;
        Function FindAllElements(Watch: TWatch): TLinkedList;
        Class Function FindList(FileName: string): TLinkedList;
    Private
        Function Compare(Watch, CurrentWatch: TWatch): Boolean;
        Function CompareField(MainStr, ComparableStr: String): Boolean;
    end;

implementation

Uses
    UnitUtilities;

Constructor TLinkedList.Create();
Var
    Elem: PList;
begin
    New(Elem);
    Elem^.Next := nil;
    Elem^.Prev := nil;
    Header := Elem;
    Tail := Elem;
end;

Class Function TLinkedList.FindList(FileName: string): TLinkedList;
Var
    F: File of TRecordWatch;
    TempRecord: TRecordWatch;
    TempWatch: TWatch;
    List: TLinkedList;
Begin
    List := TLinkedList.Create; // create an instance of the class
    AssignFile(F, FileName);
    If (Not(FileExists(FileName))) then
    begin
        Rewrite(F); // create a new file
    end
    else
    begin
        Reset(F); // open existed file
        if FileSize(F) <> 0 then
            while (not Eof(F)) do
            Begin
                Read(F, TempRecord);
                TempWatch := TWatch.ConvertToTWatch(TempRecord);
                // create an instance of the class
                List.AddElementAtEnd(TempWatch);
                // add object to the end of list
            End;
    end;
    CloseFile(F);
    Result := List;
End;

Procedure TLinkedList.AddElementAtEnd(Watch: TWatch);
Var
    TempTail: PList;
begin
    TempTail := Self.Tail;
    New(TempTail^.Next);
    TempTail := TempTail^.Next;
    TempTail^.Watch := Watch;
    TempTail^.Next := nil;
    TempTail^.Prev := Self.Tail;
    Self.Tail := TempTail;
end;

Procedure TLinkedList.DeleteElement(Watch: TWatch);
Var
    TempList: PList;
begin
    TempList := Header^.Next;
    While (TempList^.Watch.Model <> Watch.Model) and
      (TempList^.Watch.Amount <> Watch.Amount) and
      (TempList^.Watch.Date <> Watch.Date) and
      (TempList^.Watch.Price <> Watch.Price) and
      (TempList^.Watch.Manufactorer <> Watch.Manufactorer) do
        TempList := TempList^.Next;
    TempList^.Prev^.Next := TempList^.Next;
    If (TempList^.Next <> nil) then
        TempList^.Next^.Prev := TempList^.Prev;
    Dispose(TempList);
end;

Procedure TLinkedList.ChangeElement(CurrentWatch, PrevWatch: TWatch);
Var
    TempList: PList;
    I: Integer;
begin
    TempList := Header^.Next;
    while (TempList^.Watch.Model <> PrevWatch.Model) and
      (TempList^.Watch.Amount <> PrevWatch.Amount) and
      (TempList^.Watch.Date <> PrevWatch.Date) and
      (TempList^.Watch.Price <> PrevWatch.Price) and
      (TempList^.Watch.Manufactorer <> PrevWatch.Manufactorer) do
        TempList := TempList^.Next;
    TempList^.Watch := CurrentWatch;
end;

Procedure TLinkedList.SaveList(FilePath: string);
Var
    F: File of TRecordWatch;
    TempList: PList;
    TempWatch: TRecordWatch;
begin
    TempList := Self.Header;
    AssignFile(F, FilePath);
    Rewrite(F);
    While TempList^.Next <> nil do
    begin
        TempList := TempList^.Next;
        TempWatch := TempList^.Watch.ConvertToRecord();
        Write(F, TempWatch);
    end;
    CloseFile(F);
end;

Function TLinkedList.FindElementByIndex(Index: Integer): TWatch;
Var
    TempHeader: PList;
    I: Integer;
Begin
    TempHeader := Self.Header;
    For I := 1 to Index do
        TempHeader := TempHeader^.Next;
    Result := TempHeader^.Watch;
End;

Function TLinkedList.FindElementByModelDate(Model: String; Date: TDate): TWatch;
Var
    TempHeader: PList;
    Watch: TWatch;
Begin
    TempHeader := Header;
    Watch := TWatch.Create;
    While TempHeader^.Next <> nil do
    Begin
        TempHeader := TempHeader^.Next;
        If (TempHeader^.Watch.Model = Model) and (TempHeader^.Watch.Date = Date)
        then
            Watch := TempHeader^.Watch;
    End;
    Result := Watch;
End;

Function TLinkedList.FindAllElements(Watch: TWatch): TLinkedList;
Var
    NewList: TLinkedList;
    CurrentElem: PList;
begin
    NewList := TLinkedList.Create;
    CurrentElem := Self.Header;
    while CurrentElem^.Next <> nil do
    begin
        CurrentElem := CurrentElem^.Next;
        if (Compare(Watch, CurrentElem^.Watch)) then
            NewList.AddElementAtEnd(CurrentElem^.Watch);
    end;
    Result := NewList;
end;

Function TLinkedList.CompareField(MainStr, ComparableStr: String): Boolean;
Begin
    Result := MainStr = ComparableStr;
End;

Function TLinkedList.Compare(Watch, CurrentWatch: TWatch): Boolean;
Var
    AreEqual: Boolean;
begin
    AreEqual := True;
    if (Length(Watch.Manufactorer) > 0) then
        AreEqual := CompareField(Watch.Manufactorer, CurrentWatch.Manufactorer);
    if (AreEqual) and (Length(Watch.Model) > 0) then
        AreEqual := CompareField(Watch.Model, CurrentWatch.Model);
    if (AreEqual) and (DateToStr(Watch.Date) <> EMPTY_DATE) then
        AreEqual := CompareField(DateToStr(Watch.Date),
          DateToStr(CurrentWatch.Date));
    Result := AreEqual;
end;

{ Procedure ReverseList();
  Var
  TempList : }

{ Procedure TLinkedList.FillElementWithData(Manufactorer, Model : LimitedStr;
  Amount, Price : Integer; Element : PList);
  Var
  TempWatch : TWatch;
  Begin
  TempWatch := TWatch.Create(Manufactorer, Model, Amount, Price);
  Element^.Watch := TempWatch;
  End; }

end.
