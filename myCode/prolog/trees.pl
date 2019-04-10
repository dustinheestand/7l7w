% 4.01
is_tree(nil).
is_tree(t(_, L, R)) :-
    is_tree(L),
    is_tree(R).

% 4.02
balanced_tree(0, nil) :-
    !.
balanced_tree(N, t(x, A, B)) :-
    N0 is N-1,
    N1 is N0//2,
    N2 is N0-N1,
    distrib(N1, N2, N3, N4),
    balanced_tree(N3, A),
    balanced_tree(N4, B).

distrib(N, N, N, N) :-
    !.
distrib(N1, N2, N1, N2).
distrib(N1, N2, N2, N1).

% 4.03
symmetric_tree(nil).
symmetric_tree(t(_, L, R)) :-
    mirror_image(L, R).

mirror_image(T1, T2) :-
    flip(T2, T2Reverse),
    same_structure(T1, T2Reverse).

flip(nil, nil).
flip(t(X, L, R), t(X, R1, L1)) :-
    flip(L, L1),
    flip(R, R1).

same_structure(nil, nil).
same_structure(t(_, L1, R1), t(_, L2, R2)) :-
    same_structure(L1, L2),
    same_structure(R1, R2).

% 4.04
construct_BST(A, T) :-
    construct_BST(A, -inf, inf, T).
construct_BST([], _, _, nil).
construct_BST([E|Es], Min, Max, t(E, A, B)) :-
    E>Min,
    E=<Max,
    construct_BST(Es, Min, E, A),
    construct_BST(Es, E, Max, B).
construct_BST([E|Es], Min, Max, T) :-
    (   E=<Min
    ;   E>Max
    ),
    construct_BST(Es, Min, Max, T).

test_symmetric(A) :-
    construct_BST(A, T),
    symmetric_tree(T).

% 4.05
count_balanced(Nodes, 0) :-
    Nodes mod 2=:=0,
    !.

count_balanced(Nodes, N) :-
    findall(Tree, balanced_tree(Nodes, Tree), Trees),
    length(Trees, N).

% 4.06
height_balanced_tree(0, nil).
height_balanced_tree(1, t(x, nil, nil)).
height_balanced_tree(N, t(x, A, B)) :-
    N>1,
    N1 is N-1,
    N2 is N-2,
    distrib_hbal(N1, N2, N3, N4),
    height_balanced_tree(N3, A),
    height_balanced_tree(N4, B).

distrib_hbal(N1, _, N1, N1).
distrib_hbal(N1, N2, N1, N2).
distrib_hbal(N1, N2, N2, N1).

% 4.07 - this one got boring
min_nodes(0, 0).
min_nodes(1, 1).
min_nodes(H, N) :-
    H>1,
    H1 is H-1,
    H2 is H-2,
    min_nodes(H1, N1),
    min_nodes(H2, N2),
    N is N1+N2+1.

max_height(N, 0) :-
    N<1,
    !.
max_height(N, H) :-
    max_height(N, 0, H).
max_height(N, Acc, Acc) :-
    to_extend(Acc, Extend),
    N1 is N-Extend,
    N>0,
    N1=<0,
    !.
% max_height(N, Acc, H):-
%     to_extend(H, Extend),
%     N1 is N-Extend.
to_extend(0, 1).
to_extend(1, 1).
to_extend(H, N) :-
    H1 is H-1,
    H2 is H-2,
    to_extend(H1, N1),
    to_extend(H2, N2),
    N is N1+N2.

% 4.08
count_leaves(nil, 0).
count_leaves(t(_, nil, nil), 1) :-
    !.
count_leaves(t(_, A, B), N) :-
    count_leaves(A, N1),
    count_leaves(B, N2),
    N is N1+N2.

% 4.09
find_leaves(nil, []).
find_leaves(t(V, nil, nil), [V]) :-
    !.
find_leaves(t(_, A, B), Vs) :-
    find_leaves(A, Vs1),
    find_leaves(B, Vs2),
    append(Vs1, Vs2, Vs).

%4.10
internals(nil, []).
internals(t(_, nil, nil), []) :-
    !.
internals(t(V, A, B), [V|Vs]) :-
    internals(A, Vs1),
    internals(B, Vs2),
    append(Vs1, Vs2, Vs).

%4.11
% at_level(N, t(N, _, _), 1) :-
%     !.
% at_level(N, t(K, A, _), L):-
%     N =\= K,
%     at_level(N, A, L1),
%     L is L1+1.
% at_level(N, t(K, _, B), L):-
%     N =\= K,
%     at_level(N, B, L1),
%     L is L1+1.
at_level(1, t(N, _, _), [N]) :-
    !.
at_level(Level, t(_, Left, Right), List) :-
    Level1 is Level-1,
    at_level(Level1, Left, List1),
    at_level(Level1, Right, List2),
    append(List1, List2, List).

% 4.12
complete_binary_tree(N, T) :-
    complete_binary_tree(N, 1, T).
complete_binary_tree(N, Addr, nil) :-
    Addr>N,
    !.
complete_binary_tree(N, Addr, t(Addr, Left, Right)) :-
    AddrL is Addr*2,
    AddrR is Addr*2+1,
    complete_binary_tree(N, AddrL, Left),
    complete_binary_tree(N, AddrR, Right).

% 4.13
layout(T, WithLayout) :-
    size_L(T, N),
    X is N+1,
    layout(T, X, 1, WithLayout).
layout(nil, _, _, nil).
layout(t(W, L, R), X, Y, t(W, X, Y, L1, R1)) :-
    Y1 is Y+1,
    size_R(L, RightOfLeft),
    XL is X-RightOfLeft-1,
    size_L(R, LeftOfRight),
    XR is X+LeftOfRight+1,
    layout(L, XL, Y1, L1),
    layout(R, XR, Y1, R1).

count_tree(nil, 0).
count_tree(t(_, L, R), N) :-
    count_tree(L, N1),
    count_tree(R, N2),
    N is N1+N2+1.

size_L(nil, 0).
size_L(t(_, L, _), N) :-
    count_tree(L, N).

size_R(nil, 0).
size_R(t(_, _, R), N) :-
    count_tree(R, N).

% layout2(T, WithLayout) :-
%     layout2(T, 0, 1, WithLayout).
% layout2(nil, _, _, nil).
% layout2(t(W, L, R), XInc, Y, t(W, X, Y, L1, R1)) :-
%     Y1 is Y+1,
%     x_coord(t(W, L, R), XInc, X),
%     x_coord(L, XInc, LX),
%     XIncR is LX+2,
%     layout2(L, XInc, Y1, L1),
%     layout2(R, XIncR, Y1, R1).

% x_coord(nil, _, 0).
% x_coord(t(_, nil, _), left_child, XCoord) :-
%     1
% x_coord(t(_, L, _), ParentXInc, X1) :-
%     x_coord(L, ParentXInc, X),
%     X1 is X+1.
nodes(nil, []).
nodes(t(W, X, Y, L, R), SortedList) :-
    nodes(L, List1),
    nodes(R, List2),
    append([t(W, X, Y)|List1], List2, List),
    sort(1, @=<, List, SortedList).

% 4.14
layout2(T, WithLayout):-
    