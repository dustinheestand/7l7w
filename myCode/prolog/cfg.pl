% A place for exploring context-free grammars!
% s(Z) :-
%     append(X, Y, Z),
%     np(X),
%     vp(Y).
 
% np(Z) :-
%     append(X, Y, Z),
%     det(X),
%     n(Y).
 
% vp(Z) :-
%     append(X, Y, Z),
%     v(X),
%     np(Y).
    
 
% vp(Z) :-
%     v(Z).
 
% det([the]).
% det([a]).
 
% n([woman]).
% % n([man]).
 
% % v([shoots]).
% s(X, Z) :-
%     np(X, Y),
%     vp(Y, Z).
 
% np(X, Z) :-
%     det(X, Y),
%     n(Y, Z).
 
% vp(X, Z) :-
%     v(X, Y),
%     np(Y, Z).
 
% vp(X, Z) :-
%     v(X, Z).
 
% det([the|W], W).
% det([a|W], W).
 
% n([woman|W], W).
% n([man|W], W).
 
% v([shoots|W], W).
s(X) :-
    s(X, []).

simple_s -->
    np,
    vp.

s -->
    simple_s.

s -->
    simple_s,
    conj,
    s.
np -->
    det,
    n.
 
vp -->
    v,
    np.
vp -->
    v.
 
det -->
    [the].
det -->
    [a].
 
n -->
    [woman].
n -->
    [man].
 
v -->
    [shoots].

conj -->
    [but].

conj -->
    [or].

conj -->
    [and].