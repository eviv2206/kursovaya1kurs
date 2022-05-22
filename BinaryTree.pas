unit ClassBinaryTree;

interface

Uses
    SysUtils, ClassWatch, ClassLinkedList;

Type
    TArrByte = Array of Byte;
    PNode = ^TNode;
    TNode = Record
        Watch : TWatch;
        Data : Array of Byte;
        LeftChild: PNode;
        RightChild: PNode;
    End;
    TBinaryTree = Class
    RootNode: PNode;
    private
        Procedure TreeToListAscendingRecursion(List : TLinkedList; CurrentNode : PNode);
        Procedure TreeToListDescendingRecursion(List : TLinkedList; CurrentNode : PNode);
    public
        Constructor Create();
        Function Root(): PNode;
        Function FindNodeByData(Data: Integer): PNode;
        Procedure InsertNode(Data: TArrByte; Watch : TWatch);
        Procedure ConvertListToTree(List : TLinkedList; NumberOfField : Integer);
        Function ConvertTreeToDescendingList(): TLinkedList;
        Function ConvertTreeToAscendingList(): TLinkedList;
        Procedure Sort();
    End;

implementation

Constructor TBinaryTree.Create();
Begin
    RootNode := nil;
End;

Function TBinaryTree.Root(): PNode;
Begin
    Result := Self.RootNode;
End;

Procedure TBinaryTree.InsertNode(Data : TArrByte; Watch : TWatch);
Var
    CurrentNode, PrevNode, NewNode: PNode;
    NotInserted: Boolean;
Begin
    New(NewNode);
    NewNode^.Data := Data;
    NewNode^.Watch := Watch;
    NewNode^.LeftChild := Nil;
    NewNode^.RightChild := Nil;
    If (Self.RootNode = Nil) then
        Self.RootNode := NewNode
    Else
    Begin
        CurrentNode := Self.RootNode;
        While (NotInserted) do
        Begin
            PrevNode := CurrentNode;
            If (Data = CurrentNode.Data) then
                NotInserted := False
            Else
            If (Data < CurrentNode^.Data) then
            Begin
                CurrentNode := CurrentNode^.LeftChild;
                If (CurrentNode = Nil) then
                Begin
                    PrevNode^.LeftChild := NewNode;
                    NotInserted := False;
                End;
            End
            Else
            Begin
                CurrentNode := CurrentNode^.RightChild;
                If (CurrentNode = Nil) then
                Begin
                    PrevNode^.RightChild := NewNode;
                    NotInserted := False;
                End;
            End;
        End;
    End;
End;

Function DisposeAllTree(Node: PNode) : PNode;
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

Procedure TBinaryTree.ConvertListToTree(List : TLinkedList; NumberOfField : Integer);
Var
    TempHeader : PList;
Begin
    TempHeader := List.Header;
    while (TempHeader^.Next <> nil) do
    begin
        TempHeader := TempHeader^.Next;
        Case NumberOfField of
            1 : Self.InsertNode(TempHeader^.Watch.Manufactorer, TempHeader^.Watch);
            2 : Self.InsertNode(TempHeader^.Watch.Model, TempHeader^.Watch);
            3 : Self.InsertNode(TempHeader^.Watch.Price, TempHeader^.Watch);
            4 : Self.InsertNode(TempHeader^.Watch.Amount, TempHeader^.Watch);
        End;
    end;
End;

Procedure TBinaryTree.TreeToListAscendingRecursion(List : TLinkedList; CurrentNode : PNode);
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

Procedure TBinaryTree.TreeToListDescendingRecursion(List : TLinkedList; CurrentNode : PNode);
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
    List : TLinkedList;
begin
    List := TLinkedList.Create;
    TreeToListDescendingRecursion(List, Self.RootNode);
    Result := List;
end;


end.
