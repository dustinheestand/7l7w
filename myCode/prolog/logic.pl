%3.01 - not my solutions!
and(A, B) :-
    A,
    B.

or(A, _) :-
    A.
or(_, B) :-
    B.

equ(A, B) :-
    or(and(A, B), and(not(A), not(B))).

A xor B :-
    not(equ(A, B)).

nor(A, B) :-
    not(or(A, B)).

nand(A, B) :-
    not(and(A, B)).

% Implies
impl(A, B) :-
    or(not(A), B).

% bind(X) :- instantiate X to be true and false successively
bind(true).
bind(fail).

table(A, B, Expr) :-
    bind(A),
    bind(B),
    do(A, B, Expr),
    fail.

do(A, B, _) :-
    write(A),
    write('  '),
    write(B),
    write('  '),
    fail.
do(_, _, Expr) :-
    Expr,
    !,
    write(true),
    nl.
do(_, _, _) :-
    write(fail),
    nl.

% 3.04
gray(1, ["0", "1"]) :-
    !.
gray(C, L) :-
    C1 is C-1,
    gray(C1, L1),
    reverse(L1, L2),
    maplist(string_concat("0"), L1, L3),
    maplist(string_concat("1"), L2, L4),
    append(L3, L4, L).
    
%To see the whole list in the console, `gray(X, L) ; true.`

% 3.05
huffman(Fs, Hs) :-
    sort(2, @=<, Fs, Sorted),
    compress(Sorted, Compressed),
    enumerate(Compressed, Hs).

compress([], []) :-
    !.
compress([E], E) :-
    !.
compress([fs(C1, F1), fs(C2, F2)|Cs], Compressed) :-
    F is F1+F2,
    C=fs([(C1, "0"),  (C2, "1")], F),
    % Would be better to write insert function rather than doing a whole new sort
    sort(2, @=<, [C|Cs], Sorted),
    compress(Sorted, Compressed).

% insert(C, [], [C]).
% insert([], [C0|Cs], C1s):-
enumerate((A, N), [hc(A, N)]) :-
    atom(A).
enumerate(([A, B], N), Hcs) :-
    enumerate(A, As),
    enumerate(B, Bs),
    maplist(build_code(N), As, A1s),
    maplist(build_code(N), Bs, B1s),
    append(A1s, B1s, Hcs).
    
enumerate(fs(G, _), Hs) :-
    enumerate((G, ""), Hs).

build_code(N, hc(A, S), hc(A, S1)) :-
    string_concat(N, S, S1).

huffman_test(N) :-
    write(huffman),
    time(huffman(N, L)),
    write('result = '),
    write(L),
    nl.
%The solution code is about twice as efficient1

% huffman(Fs, Cs) :-
%     initialize(Fs, Ns),
%     make_tree(Ns, T),
%     traverse_tree(T, Cs).

% initialize(Fs, Ns) :-
%     init(Fs, NsU),
%     sort(NsU, Ns).

% init([], []).
% init([fr(S, F)|Fs], [n(F, S)|Ns]) :-
%     init(Fs, Ns).

% make_tree([T], T).
% make_tree([n(F1, X1), n(F2, X2)|Ns], T) :-
%     F is F1+F2,
%     insert(n(F, s(n(F1, X1), n(F2, X2))),
%            Ns,
%            NsR),
%     make_tree(NsR, T).

% % insert(n(F,X),Ns,NsR) :- insert the node n(F,X) into Ns such that the
% %    resulting list NsR is again sorted with respect to the frequency F.
% insert(N, [], [N]) :-
%     !.
% insert(n(F, X), [n(F0, Y)|Ns], [n(F, X), n(F0, Y)|Ns]) :-
%     F<F0,
%     !.
% insert(n(F, X), [n(F0, Y)|Ns], [n(F0, Y)|Ns1]) :-
%     F>=F0,
%     insert(n(F, X), Ns, Ns1).

% % traverse_tree(T,Cs) :- traverse the tree T and construct the Huffman 
% %    code table Cs,
% traverse_tree(T, Cs) :-
%     traverse_tree(T, '', Cs1-[]),
%     sort(Cs1, Cs).

% traverse_tree(n(_, A), Code, [hc(A, Code)|Cs]-Cs) :-
%     atom(A). % leaf node
% traverse_tree(n(_, s(Left, Right)), Code, Cs1-Cs3) :-         % internal node
%     atom_concat(Code, '0', CodeLeft),
%     atom_concat(Code, '1', CodeRight),
%     traverse_tree(Left, CodeLeft, Cs1-Cs2),
%     traverse_tree(Right, CodeRight, Cs2-Cs3).