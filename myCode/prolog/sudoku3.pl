:- use_module(library(clpfd)).

% A naive solution
% This is a perfect example - I just tell the machine
% what's true and it goes to town
sudoku(Board, Solution) :-
    Solution=Board,
    Board ins 1..9,
    Board=[C11, C12, C13, C14, C15, C16, C17, C18, C19, C21, C22, C23, C24, C25, C26, C27, C28, C29, C31, C32, C33, C34, C35, C36, C37, C38, C39, C41, C42, C43, C44, C45, C46, C47, C48, C49, C51, C52, C53, C54, C55, C56, C57, C58, C59, C61, C62, C63, C64, C65, C66, C67, C68, C69, C71, C72, C73, C74, C75, C76, C77, C78, C79, C81, C82, C83, C84, C85, C86, C87, C88, C89, C91, C92, C93, C94, C95, C96, C97, C98, C99],
    Row1=[C11, C12, C13, C14, C15, C16, C17, C18, C19],
    Row2=[C21, C22, C23, C24, C25, C26, C27, C28, C29],
    Row3=[C31, C32, C33, C34, C35, C36, C37, C38, C39],
    Row4=[C41, C42, C43, C44, C45, C46, C47, C48, C49],
    Row5=[C51, C52, C53, C54, C55, C56, C57, C58, C59],
    Row6=[C61, C62, C63, C64, C65, C66, C67, C68, C69],
    Row7=[C71, C72, C73, C74, C75, C76, C77, C78, C79],
    Row8=[C81, C82, C83, C84, C85, C86, C87, C88, C89],
    Row9=[C91, C92, C93, C94, C95, C96, C97, C98, C99],
    Col1=[C11, C21, C31, C41, C51, C61, C71, C81, C91],
    Col2=[C12, C22, C32, C42, C52, C62, C72, C82, C92],
    Col3=[C13, C23, C33, C43, C53, C63, C73, C83, C93],
    Col4=[C14, C24, C34, C44, C54, C64, C74, C84, C94],
    Col5=[C15, C25, C35, C45, C55, C65, C75, C85, C95],
    Col6=[C16, C26, C36, C46, C56, C66, C76, C86, C96],
    Col7=[C17, C27, C37, C47, C57, C67, C77, C87, C97],
    Col8=[C18, C28, C38, C48, C58, C68, C78, C88, C98],
    Col9=[C19, C29, C39, C49, C59, C69, C79, C89, C99],
    Box1=[C11, C12, C13, C21, C22, C23, C31, C32, C33],
    Box2=[C14, C15, C16, C24, C25, C26, C34, C35, C36],
    Box3=[C17, C18, C19, C27, C28, C29, C37, C38, C39],
    Box4=[C41, C42, C43, C51, C52, C53, C61, C62, C63],
    Box5=[C44, C45, C46, C54, C55, C56, C64, C65, C66],
    Box6=[C47, C48, C49, C57, C58, C59, C67, C68, C69],
    Box7=[C71, C72, C73, C81, C82, C83, C91, C92, C93],
    Box8=[C74, C75, C76, C84, C85, C86, C94, C95, C96],
    Box9=[C77, C78, C79, C87, C88, C89, C97, C98, C99],
    all_distinct(Row1),
    all_distinct(Col1),
    all_distinct(Box1),
    all_distinct(Row2),
    all_distinct(Col2),
    all_distinct(Box2),
    all_distinct(Row3),
    all_distinct(Col3),
    all_distinct(Box3),
    all_distinct(Row4),
    all_distinct(Col4),
    all_distinct(Box4),
    all_distinct(Row5),
    all_distinct(Col5),
    all_distinct(Box5),
    all_distinct(Row6),
    all_distinct(Col6),
    all_distinct(Box6),
    all_distinct(Row7),
    all_distinct(Col7),
    all_distinct(Box7),
    all_distinct(Row8),
    all_distinct(Col8),
    all_distinct(Box8),
    all_distinct(Row9),
    all_distinct(Col9),
    all_distinct(Box9).

% I'm trying to make something that will generate a valid board with a single solution
% This illustrates the weakness of prolog as a general-purpose language
% Because random is not a pure logic function and can't be backtracked onto,
% the logic is too complicated for me to figure out.
% The right thing to do would be use a procedural language.
build_sudoku(Puzzle) :-
    length(Board, 81),
    build_sudoku(Board, Puzzle).

build_sudoku(Board, Puzzle) :-
    random(0, 80, R),
    random(1, 9, N),
    nth0(R, Board, N),
    sudoku(Board, Solution),
    notvars(Solution),
    Puzzle is Board,
    !.

build_sudoku(Board, Puzzle) :-
    random(0, 80, R),
    random(1, 9, N),
    nth0(R, Board, N),
    build_sudoku(Board, Puzzle).

notvars([H|T]) :-
    nonvar(H),
    notvars(T).