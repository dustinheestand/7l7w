sudoku(Board, WithData) :-
    flatten(Board, FlatBoard),
    add_attributes(FlatBoard, 0, WithData),
    check(WithData).


check(WithData) :-
    maplist(checkCell(WithData), WithData).

checkCell(_,  (V, _, _, _)) :-
    \+ var(V),
    !.

% This check doesn't work because the cells are finding themselves
% The approach is not quite right.
checkCell(WithData,  (V, R, C, B)) :-
    member(V, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
    \+ member((V, R, _, _), WithData),
    \+ member((V, _, C, _), WithData),
    \+ member((V, _, _, B), WithData).
    
add_attributes([], _, []).
add_attributes([0|BoardT], I, [(_, RowNo, ColNo, BoxNo)|WithDataT]) :-
    row(I, RowNo),
    column(I, ColNo),
    box(I, BoxNo),
    I1 is I+1,
    % member(Var, [1,2,3,4,5,6,7,8,9]),
    add_attributes(BoardT, I1, WithDataT).
add_attributes([BoardH|BoardT], I, [(BoardH, RowNo, ColNo, BoxNo)|WithDataT]) :-
    BoardH=\=0,
    row(I, RowNo),
    column(I, ColNo),
    box(I, BoxNo),
    I1 is I+1,
    add_attributes(BoardT, I1, WithDataT).

row(Index, RowNo) :-
    RowNo is Index//9.

column(Index, ColNo) :-
    ColNo is Index mod 9.

box(Index, BoxNo) :-
    BoxNo is Index mod 9//3+Index//27.

%matches(N, N) :-
%     N=\=0.
% matches(0, N) :-
%     member(N, [1, 2, 3, 4, 5, 6, 7, 8, 9]).

% fill([], _,_,_, []).
% fill([BoardH|BoardT], Index, Rows, Cols, Boxes, [SolutionH|SolutionT]) :-
%     matches(BoardH, SolutionH),
%     Index1 is Index+1,
%     fill(BoardT, Index1, SolutionT).
% fill([BoardH|BoardT], Index, Rows, Cols, Boxes, [SolutionH|SolutionT]) :-
%     matches(BoardH, SolutionH),
%     Index1 is Index+1,
%     fill(BoardT, Index1, SolutionT).