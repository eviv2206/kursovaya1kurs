unit ClassBinaryTree;

interface

Uses
    SysUtils, ClassWatch, ClassLinkedList, UnitWorkWithBytes;

Type

    PNode = ^TNode;

    TNode = Record
        Watch: TWatch;
        Data: TArrByte;
        LeftChild: PNode;
        RightChild: PNode;
    End;

    TBinaryTree = Class
        RootNode: PNode;
    private
        Procedure TreeToListAscendingRecursion(List: TLinkedList;
          CurrentNode: PNode);
        Procedure TreeToListDescendingRecursion(List: TLinkedList;
          CurrentNode: PNode);
    public
        Constructor Create();
        Function GetRoot(): PNode;
        Procedure InsertNode(Data: TArrByte; Watch: TWatch;
          CompareFunc: TComparatorFunc);
        Procedure ConvertListToTree(List: TLinkedList; NumberOfField: Integer);
        Function ConvertTreeToDescendingList(): TLinkedList;
        Function ConvertTreeToAscendingList(): TLinkedList;
    End;

implementation

Constructor TBinaryTree.Create();
Begin
    RootNode := nil;
End;

Function TBinaryTree.GetRoot(): PNode;
Begin
    Result := Self.RootNode;
End;

Procedure TBinaryTree.InsertNode(Data: TArrByte; Watch: TWatch;
  CompareFunc: TComparatorFunc);
var
    CurrentNode, PrevNode, NewNode: PNode;
    NotInserted: Boolean;
    CmpRes: Integer;
begin
    New(NewNode);
    NewNode^.Data := Data;
    NewNode^.Watch := Watch;
    NewNode^.LeftChild := Nil;
    NewNode^.RightChild := Nil;
    NotInserted := True;
    if (Self.RootNode = Nil) then
        Self.RootNode := NewNode
    else
    begin
        CurrentNode := Self.RootNode;
        while (NotInserted) do
        begin
            PrevNode := CurrentNode;
            CmpRes := CompareFunc(Data, CurrentNode^.Data);
            if (CmpRes < 1) then
            begin
                CurrentNode := CurrentNode^.LeftChild;
                if (CurrentNode = Nil) then
                begin
                    PrevNode^.LeftChild := NewNode;
                    NotInserted := False;
                end;
            end
            else
            begin
                CurrentNode := CurrentNode^.RightChild;
                if (CurrentNode = Nil) then
                begin
                    PrevNode^.RightChild := NewNode;
                    NotInserted := False;
                end;
            end;
        end;
    end;
end;

Function DisposeAllTree(Node: PNode): PNode;
Begin
    If (Node <> Nil) then
    Begin
        Node^.LeftChild := DisposeAllTree(Node^.LeftChild);
        Node^.RightChild := DisposeAllTree(Node^.RightChild);
        Dispose(Node);
    End;
    Node := nil;
    DisposeAllTree := Node;
End;

Procedure TBinaryTree.ConvertListToTree(List: TLinkedList;
  NumberOfField: Integer);
Var
    TempHeader: PList;
Begin
    TempHeader := List.Header;
    while (TempHeader^.Next <> nil) do
    begin
        TempHeader := TempHeader^.Next;
        Case NumberOfField of
            1:
                begin
                    Self.InsertNode
                      (StrToByteArr(TempHeader^.Watch.Manufactorer),
                      TempHeader^.Watch, TWatch.ComparatorStr);
                end;
            2:
                Begin
                    Self.InsertNode(StrToByteArr(TempHeader^.Watch.Model),
                      TempHeader^.Watch, TWatch.ComparatorStr);
                End;
            3:
                Begin
                    Self.InsertNode(RealToByteArr(TempHeader^.Watch.Price),
                      TempHeader^.Watch, TWatch.ComparatorReal);
                End;
            4:
                Begin
                    Self.InsertNode(IntToByteArr(TempHeader^.Watch.Amount),
                      TempHeader^.Watch, TWatch.ComparatorInt);
                End;
            5:
                begin
                    Self.InsertNode(DateToByteArr(TempHeader^.Watch.Date),
                      TempHeader^.Watch, TWatch.ComparatorDate);
                end;
        End;
    end;
End;

Procedure TBinaryTree.TreeToListAscendingRecursion(List: TLinkedList;
  CurrentNode: PNode);
Begin
    If (CurrentNode <> nil) then
    Begin
        TreeToListAscendingRecursion(List, CurrentNode^.LeftChild);
        List.AddElementAtEnd(CurrentNode^.Watch);
        TreeToListAscendingRecursion(List, CurrentNode^.RightChild);
    End;
End;

Function TBinaryTree.ConvertTreeToAscendingList(): TLinkedList;
Var
    List: TLinkedList;
Begin
    List := TLinkedList.Create;
    TreeToListAscendingRecursion(List, Self.RootNode);
    Result := List;
End;

Procedure TBinaryTree.TreeToListDescendingRecursion(List: TLinkedList;
  CurrentNode: PNode);
Begin
    If (CurrentNode <> nil) then
    Begin
        TreeToListDescendingRecursion(List, CurrentNode^.RightChild);
        List.AddElementAtEnd(CurrentNode^.Watch);
        TreeToListDescendingRecursion(List, CurrentNode^.LeftChild);
    End;
End;

Function TBinaryTree.ConvertTreeToDescendingList(): TLinkedList;
Var
    List: TLinkedList;
begin
    List := TLinkedList.Create;
    TreeToListDescendingRecursion(List, Self.RootNode);
    Result := List;
end;

end.
