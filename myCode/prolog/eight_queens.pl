:- use_module(library(clpfd)).
:- op(920, fy, *).
% My solution
% Makes 10interx more inferences than the reference solution below
eight_queens(Solution) :-
    length(Solution, 8),
    maplist(length_list(2), Solution),
    %Checks that every value is between one and eight
    append(Solution, Vs),
    Vs ins 1..8,
    maplist(get_x, Solution, [1, 2, 3, 4, 5, 6, 7, 8]),
    maplist(get_y, Solution, Ys),
    all_distinct(Ys),
    maplist(get_diag1, Solution, D1s),
    all_distinct(D1s),
    maplist(get_diag2, Solution, D2s),
    all_distinct(D2s),
    label(Ys).

length_list(Length, List) :-
    length(List, Length).

get_x([X, _], X).
get_y([_, Y], Y).
get_diag1([X, Y], D) :-
    D#=X+Y.
get_diag2([X, Y], D) :-
    D#=X-Y.

% This is the provided solution code.
n_queens(N, Qs) :-
    length(Qs, N),
    Qs ins 1..N,
    safe_queens(Qs).

% Once we've placed all the queens, we're good
safe_queens([]).
safe_queens([Q|Qs]) :-
    % Constrain the rest of the Qs to be compatible with this one
    safe_queens(Qs, Q, 1),
    % Place the rest of the queens - we've already constrained all of them
    % to be compatible with Q, so now they just all need to be compatible with
    % one another, subject to that constraint
    safe_queens(Qs).

% Once we've constrained all the queens to the right, we're done
safe_queens([], _, _).
safe_queens([Q|Qs], Q0, D0) :-
    % Constrain the Queen D0 rows over from the one we just placed
    % So that it can't be in the same row.
    Q0#\=Q,
    % D0 is the row difference between the two Q's
    % Constrain the Queen D0 rows over from the one we just placed
    % such that it can't be on the same diagonal, that is, D0 higher
    % or D0 lower
    abs(Q0-Q)#\=D0,
    % Now constrain the next queen in line
    D1#=D0+1,
    safe_queens(Qs, Q0, D1).

% This is an easy system of equations that I was using to understand
% how to properly use constraints
table(TurtleOnTable, CatOnTable, N) :-
    N#>=0,
    max_list([TurtleOnTable, CatOnTable], Max),
    N#=<Max,
    N+C#=CatOnTable,
    N-C#=TurtleOnTable.