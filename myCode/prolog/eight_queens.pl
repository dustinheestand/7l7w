:- use_module(library(clpfd)).

% My solution
% Makes 100x more inferences than the reference solution below
eight_queens(Solution) :-
    length(Solution, 8),
    maplist(length_list(2), Solution),
    %Checks that every value is between one and eight
    append(Solution, Vs),
    Vs ins 1..8,
    maplist(get_x, Solution, [1, 2, 3, 4, 5, 6, 7, 8]),
    maplist(get_y, Solution, Ys),
    all_distinct(Ys),
    label(Ys),
    maplist(get_diag1, Solution, D1s),
    all_distinct(D1s),
    maplist(get_diag2, Solution, D2s),
    all_distinct(D2s).

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
    safe_queens(Qs),
    label(Qs).

safe_queens([]).
safe_queens([Q|Qs]) :-
    safe_queens(Qs, Q, 1),
    safe_queens(Qs).

safe_queens([], _, _).
safe_queens([Q|Qs], Q0, D0) :-
    Q0#\=Q,
    abs(Q0-Q)#\=D0,
    D1#=D0+1,
    safe_queens(Qs, Q0, D1).

