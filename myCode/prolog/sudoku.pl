solve(Board, Solution) :-
    match(Board, Solution),
    match_1_to_9(Solution),
    match_1_to_9(Sol_Columns),
    columns(Solution, Sol_Columns),
    match_1_to_9(Sol_Boxes),
    boxes(Solution, Sol_Boxes).

match_1_to_9(Solution) :-
    maplist(sort, Solution, Sorted),
    maplist(==([1, 2, 3, 4, 5, 6, 7, 8, 9]), Sorted).

match([], _).
match([BoardH|BoardT], [SolH|SolT]) :-
    match_row(BoardH, SolH),
    match(BoardT, SolT).

match_row([], _).
match_row([BdRowH|BdRowT], [SolRowH|SolRowT]) :-
    SolRowH=BdRowH,
    match_row(BdRowT, SolRowT).

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

