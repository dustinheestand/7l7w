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

% With accumulator
rev_accum([], A, A).
rev_accum([H|T], A, R) :-
    rev_accum(T, [H|A], R).

rev_accum(L, R) :-
    rev_accum(L, [], R).

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

% 1.13
dir_run_length([], []).
dir_run_length([H], [H]).
dir_run_length([X|T], [X, Y|Z]) :-
    X\=Y,
    dir_run_length(T, [Y|Z]).
% If dir run length on Z gives me something beginning with a list
% I return a list where the first element is the first element of dir_run_length(Z),
% but with the count incremented
dir_run_length([[N1, X]|T], [X, X|Z]) :-
    dir_run_length([[N, X]|T], [X|Z]),
    N1 is N+1.
% If my first two terms match, but the first term of Z doesn't match,
% I return [[2, first], dir_run_length(Z). 
dir_run_length([[2, X]|T], [X, X|Z]) :-
    dir_run_length([X|T], [X|Z]).

% 1.14
dupe([], []).
dupe([X, X|T], [X|Y]) :-
    dupe(T, Y).

% 1.15
dupe([], [], _).
dupe(L, [X|Y], N) :-
    dupe(L2, Y, N),
    repeat(L1, X, N),
    append(L1, L2, L).

repeat([], _, 0).
repeat([X], X, 1).
repeat([X|Xs], X, N) :-
    N>1,
    N1 is N-1,
    repeat(Xs, X, N1).

% 1.16
% Don't need to handle the case where N==0 because prolog can't 
% match it and just returns false. This is a cool feature!
% In general I don't need to worry about invalid input!
drop_each([], [], _) :-
    !.
drop_each(L, A, N) :-
    N>0,
    N1 is N-1,
    take(L1, A, N1),
    drop(L2, A, N),
    drop_each(L3, L2, N),
    append(L1, L3, L).
    
take([], _, 0) :-
    !.
take([], [], _).
take([H], [H|_], 1) :-
    !.
take([H|L2], [H|T], N) :-
    N1 is N-1,
    take(L2, T, N1).

drop([], [], _).
drop(L, L, 0) :-
    !.
drop(T, [_|T], 1) :-
    !.
drop(T1, [_|T], N) :-
    N1 is N-1,
    drop(T1, T, N1).

% 1.17
split(0, L, [], L) :-
    !.
split(1, [H|T], [H], T) :-
    !.
split(N, [H|T], [H|Hs], L2) :-
    N1 is N-1,
    split(N1, T, Hs, L2).

% 1.18
% Definition of slice is dumb:
% slice(What, [a,b,c], 2, 3), What = [b,c]
slice([], _, _, 0) :-
    !.
slice([H|L], [H|T], 1, K) :-
    K1 is K-1,
    slice(L, T, 1, K1).
slice(L, [_|T], J, K) :-
    J>1,
    K>1,
    J1 is J-1,
    K1 is K-1,
    slice(L, T, J1, K1).

% 1.19
% this doesn't work in reverse and neither does the provided solution
% That makes me sad!
rotate([], [], _) :-
    !.
rotate(L2, L1, N) :-
    length(L1, Len),
    N1 is N mod Len,
    split(N1, L1, R1, R2),
    append(R2, R1, L2).

% 1.20
remove_at(X, L, N, R) :-
    length(L, Len),
    Len>=N,
    kth(X, L, N),
    N1 is N-1,
    split(N1, L, L1, [_|L2]),
    append(L1, L2, R).

% 1.21
insert_at(X, L, N, R) :-
    length(L, Len),
    Len>=N+1,
    remove_at(X, R, N, L).

% 1.22
range(L, L, [L]).
range(L, H, [L|Ns]) :-
    H>=L,
    L1 is L+1,
    range(L1, H, Ns).

% 1.23
% I don't understand why this returns false when I type ;
pick(_, N, []) :-
    N<1,
    !.
pick(L, N, [R|Rs]) :-
    length(L, Len),
    Len>0,
    random(0, Len, I),
    Index is I+1,
    remove_at(R, L, Index, Rest),
    N1 is N-1,
    pick(Rest, N1, Rs).

% 1.24
lotto(R, N, Winner) :-
    range(1, R, Range),
    pick(Range, N, Nos),
    sort(Nos, Winner).

%1.25
permute(L, R) :-
    length(L, Len),
    pick(L, Len, R).

% 1.26
combination(_, 0, []) :-
    !.
combination([H|T], N, [H|Ms]) :-
    N1 is N-1,
    combination(T, N1, Ms).
combination([_|T], N, Ms) :-
    combination(T, N, Ms).

% 1.27
groups(_, [], []).
groups(L, [Size|Sizes], [Group|Groups]) :-
    combination(L, Size, Group),
    subtract(L, Group, L1),
    groups(L1, Sizes, Groups).

% 1.28
% Sorts a list of lists by how long each list is.
% Was mergesort the right thing to do?
% It was much nicer when sorting numbers - just the particular
% task here is pretty annoying for pattern matching

% The reference solution uses keysort! Which means it wasn't necessary to write
% gt_lt and in general this solution isn't making use of language features.
length_sort([], []).
length_sort([E], [E]).
length_sort(L, Result) :-
    recursive_split(L, SplitList),
    merge(SplitList, Result).

recursive_split([], []).
recursive_split([E], [E]) :-
    !.
recursive_split(L, [Split1, Split2]) :-
    length(L, Len),
    Len2 is (Len-1)//2+1,
    split(Len2, L, L1, L2),
    recursive_split(L1, Split1),
    recursive_split(L2, Split2).

% Solution assumes that each of our lists is made of non-lists
merge([], []).
merge([L], [L]).
merge([L1, []], L1).
merge([[], L2], L2).
merge([[[H1H|H1T]|T1], L0], L3) :-
    is_list(H1H),
    merge([[H1H|H1T]|T1], L1),
    merge(L0, L2),
    merge([L1, L2], L3).  
merge([[[H1H|H1T]|T1], [H2|T2]], [HL|Ls]) :-
    \+ is_list(H1H),
    length([H1H|H1T], H1Len),
    length(H2, H2Len),
    gt_lt(H1Len,
          H2Len,
          [[H1H|H1T]|T1],
          [H2|T2],
          [HL|TL],
          G),
    merge([TL, G], Ls).

gt_lt(A, B, AData, BData, LesserData, GreaterData) :-
    A=<B,
    LesserData=AData,
    GreaterData=BData.

gt_lt(A, B, AData, BData, LesserData, GreaterData) :-
    A>B,
    LesserData=BData,
    GreaterData=AData.

% len_freq_sort([], []).
% len_freq_sort([E], [E]).
% len_freq_sort(L, Result) :-
%     recursive_split(L, SplitList),
%     merge(SplitList, Result).

% freq_dict([],[]).

% counts(L,C):-
%     maplist()


% freq_dict([E], [[L, 1]]):-
%     length(E, L).
% freq_dict([H|T],[Freq|Freqs]):-
%     length(H, L),

% combine_dicts([],[],[]).
% combine_dicts(D1, [], D1).
% combine_dicts([], D2, D2).
% combine_dicts([[L1, F1]], [[L1, F2]], [[L1, F3]]):-
%     F3 is F1+F2.
% % combine_dicts([[L1, F1]], [[L2, F2]], [[L1, F1], [L2, F2]]):-
% %     L1 \= L2.
% combine_dicts([HD1|TD1], [HD2|TD2], [HD3|TD3]):-
