% Code from Power of Prolog
hailstone(N, N).
hailstone(N0, N) :-
    N0#=2*N1,
    hailstone(N1, N).
hailstone(N0, N) :-
    N0#=2*_+1,
    N1#=3*N0+1,
    hailstone(N1, N).


% The original doesn't terminate because prolog can represent X as
% X and not(not(X)) and not(not(not(X))) etc.
% So if we juse define a rule naively it will keep matching goals.
adjacent_(a, b).
adjacent_(e, f).
adjacent(X, Y) :-
    adjacent_(Y, X).
adjacent(X, Y) :-
    adjacent_(X, Y).


list_length([], 0).
list_length([_|Ls], Length) :-
    % Without this restriction, prolog thinks maybe there is a match
    % to this list_length([_|Ls], 0), and will keep decrementing
    % length and trying again in the hope of finding a terminating condition
    % somewhere in the negative integers, which of course it won't do.
    Length>0,
    Length#=Length0+1,
    list_length(Ls, Length0).
    