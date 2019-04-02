my_last(H, [H]).
my_last(H, [_|T]) :-
    my_last(H, T).

penultimate(H, [H, _]).
penultimate(H, [_|T]) :-
    penultimate(H, T).

kth(H, [H|_], N) :-
    N==1.
kth(H, [_|T], N) :-
    N1 is N-1,
    kth(H, T, N1).

% The first thing that can be true - count elems of an empty list is 0
count_elems(0, []).
% The second thing that can be true - count elems of a list matching the pattern
% [_|T] is C1
count_elems(C1, [_|T]) :- 
    % But what is C1?
    % Well, if we can match a pattern count_elems(C, T), where T is bound above
    % and C is unbound and must be determined by matching elsewhere, 
    % then C1 is C+1. But of course if T matches [_|T] (where this T is not the same as the above)
    % then we call this case recursively. But if we match [] with T, we hit the base case.
    % In general, where we have arithmetic, we need `is`.
    count_elems(C, T),
    C1 is C+1.

% Two base cases
reverse_list([], []).
reverse_list([H], [H]).
% If my list matches the pattern [H|T], I need to append [H] to the reversal of T
reverse_list(L, [H|T]) :-
    reverse_list(T1, T),
    append(T1, [H], L).

% 1.06
% Cheating?
% But deleting / checking the last element of a list is tedious
palindrome(L) :-
    reverse_list(L, L).

% 1.07
my_flatten([], []).
% If the head is not a list then flatten the tail and append [H] to the flattened tail
my_flatten([H|L1], [H|T]) :-
    \+ is_list(H),
    my_flatten(L1, T).
% if the head of my list is a list, I need to recursively flatten each piece of the list
% then append my_flatten(H) + my_flatten(T)
my_flatten(L, [H|T]) :-
    my_flatten(L1, H),
    my_flatten(L2, T),
    append(L1, L2, L).

% 1.08
dedupe([], []).
dedupe([H], [H]).
% I had an explicit equals in my cases, but instead the right thing to do
% is just give the two variables the same name
% Also don't need nested lists here!
dedupe([H, H|T], L) :-
    dedupe([H|T], L).
dedupe([H, H1|T], [H|L]) :-
    H\=H1,
    dedupe([H1|T], L).

% 1.09
pack([], []).
pack([[H]], [H]).
% In more familiar notation: pack([X, Y|Z]) = [[X], pack[Y|Z]]
% where X != Y
pack([[X]|T], [X, Y|Z]) :-
    X\=Y,
    pack(T, [Y|Z]).
% Where the first two elements are equal, i.e. matches pack[X, X|Z]:
% [ [X|head(pack[X|Z])] | tail(pack([X|Z])) ]
pack([[X|Xs]|T], [X, X|Z]) :-
    pack([Xs|T], [X|Z]).

% 1.10
run_length(Result, L) :-
    pack(Packed, L),
    translate_packed(Result, Packed).
    
translate_packed([], []).
translate_packed([[C, H1]|T1], [[H1|Rest]|T]) :-
    translate_packed(T1, T),
    count_elems(C, [H1|Rest]).

% 1.11
mod_run_length(Result, L) :-
    run_length(Run, L),
    shorten_run_length(Result, Run).

shorten_run_length([], []).
shorten_run_length([H|T1], [[1, H]|T]) :-
    shorten_run_length(T1, T).
shorten_run_length([[N, H]|T1], [[N, H]|T]) :-
    N>1,
    shorten_run_length(T1, T).

% 1.12
decode([], []).
decode([H|T1], [H|T]) :-
    \+ is_list(H),
    decode(T1, T).
decode([H|T1], [[N, H]|T]) :-
    N>1,
    N1 is N-1,
    decode(T1, [[N1, H]|T]).
decode([H|T1], [[1, H]|T]) :-
    decode(T1, T).
    