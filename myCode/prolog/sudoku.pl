solve(Board, Solution) :-
    length(Solution, 9),
    build_rows(Board, [], Solution),
    % Pretty slow because it has to create a whole solution
    % that works for rows and columns, and only then check whether
    % the boxes work. For easy ones, not a problem. For hard ones,
    % it runs until I get bored.
    boxes(Solution, Sol_Boxes),
    match_1_to_9(Sol_Boxes).

build_rows([], _, []).
build_rows([BoardH|BoardT], SolutionRowsSoFar, [SolutionH|SolutionT]) :-
    consistent(BoardH, [], SolutionH),
    append(SolutionRowsSoFar, BoardT, BoardSoFar),
    columns(BoardSoFar, Cols),
    maplist(not_in, SolutionH, Cols),
    append(SolutionRowsSoFar, [SolutionH], NewSolutionRows),
    %print(NewSolutionRows),
    build_rows(BoardT, NewSolutionRows, SolutionT).

consistent([], _, []).
consistent([BoardRH|BoardRT], RowSoFar, [BoardRH|SolutionRT]) :-
    BoardRH=\=0,
    append(RowSoFar, [BoardRH], NewRow),
    consistent(BoardRT, NewRow, SolutionRT).
consistent([0|BoardRT], RowSoFar, [SolutionRH|SolutionRT]) :-
    append(BoardRT, RowSoFar, Taken),
    member(SolutionRH, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
    not_in(SolutionRH, Taken),
    append(RowSoFar, [SolutionRH], NewRow),
    consistent(BoardRT, NewRow, SolutionRT).

equal_or_zero(N, N).
equal_or_zero(0, _).

not_in(E, L) :-
    \+ member(E, L).


match_1_to_9(Solution) :-
    maplist(permutation([1, 2, 3, 4, 5, 6, 7, 8, 9]), Solution).

columns([], []).
columns(Board, Cols) :-
    findall(Col, column(_, Board, Col), Cols).
column(_, [], []).
column(N, [BoardH|BoardT], [Num|Nums]) :-
    nth1(N, BoardH, Num),
    column(N, BoardT, Nums).

boxes([], []).
boxes([Row1, Row2, Row3|Rows], [Box1, Box2, Box3|Boxes]) :-
    Rows123=[Row1, Row2, Row3],
    columns(Rows123, ToCols),
    box_group(ToCols, [Box1, Box2, Box3]),
    boxes(Rows, Boxes).

box_group([], []).
box_group([R1, R2, R3|Rs], [Box|Boxes]) :-
    flatten([R1, R2, R3], Box),
    box_group(Rs, Boxes).

