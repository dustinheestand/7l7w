% 2.01
prime(N) :-
    Q is N/2,
    \+ integer(Q),
    not_divisible(N, 3).
not_divisible(N, N).
not_divisible(N, M) :-
    Q is N/M,
    \+ integer(Q),
    M1 is M+2,
    not_divisible(N, M1).

% 2.02
factors(N, Factors) :-
    factors(N, 2, Factors).

factors(N, M, [N]) :-
    M*M>N.
factors(N, M, [M|Factors]) :-
    N mod M=:=0,
    Q is N/M,
    factors(Q, M, Factors).
factors(N, M, Factors) :-
    N mod M=\=0,
    M1 is M+1,
    factors(N, M1, Factors).

% 2.03
run_length1([], []).
run_length1([H], [[1, H]]).
run_length1([H, K|T], [[1, H]|T1]) :-
    H\=K,
    run_length1([K|T], T1).
run_length1([H, H|T], [[N, H]|T1]) :-
    run_length1([H|T], [[N1, H]|T1]),
    N is N1+1.

factors_and_multiplicities(N, Factors) :-
    factors(N, FactorList),
    run_length1(FactorList, Factors).

% 2.04
primes(Min, Max, []) :-
    Min>Max,
    !.
primes(Min, Max, [Min|Ns]) :-
    Min1 is Min+1,
    prime(Min),
    primes(Min1, Max, Ns).
primes(Min, Max, Ns) :-
    Min1 is Min+1,
    \+ prime(Min),
    primes(Min1, Max, Ns).

% 2.05 - not my solution! 
goldbach(4, [2, 2]) :-
    !.
goldbach(N, L) :-
    N mod 2=:=0,
    N>4,
    goldbach(N, L, 3).

goldbach(N, [P, Q], P) :-
    Q is N-P,
    Q>=P,
    prime(Q).
goldbach(N, L, P) :-
    P<N,
    next_prime(P, P1),
    goldbach(N, L, P1).

next_prime(P, P1) :-
    P1 is P+2,
    prime(P1),
    !.
next_prime(P, P1) :-
    P2 is P+2,
    next_prime(P2, P1).
% goldbach(N, [A, B]) :-
%     A+B=:=N,
%     prime(A),
%     prime(B).

% 2.06
goldbachs(Min, Max, []) :-
    Min>Max,
    !.
goldbachs(Min, Max, L) :-
    Min<3,
    goldbachs(3, Max, L),
    !.
goldbachs(Min, Max, L) :-
    Min mod 2=\=0,
    Min1 is Min+1,
    goldbachs(Min1, Max, L),
    !.
goldbachs(Min, Max, [Min-N|Ns]) :-
    goldbach(Min, N),
    !,
    Min2 is Min+2,
    goldbachs(Min2, Max, Ns).

% Doesn't really count, rather lists. Still cool! 
count_goldbachs(Min, Max, Cutoff, L) :-
    goldbachs(Min, Max, Gs),
    include(exceed_cutoff(Cutoff), Gs, L).

exceed_cutoff(Cutoff, _-[A, _]) :-
    A>Cutoff.

% 2.07 
gcd(N, N, N) :-
    !.
gcd(M, N, D) :-
    N>M,
    gcd(N, M, D),
    !.
gcd(N, M, M) :-
    N mod M=:=0,
    !.
gcd(N, M, D) :-
    N1 is N mod M,
    gcd(M, N1, D).

% Takes the last argument and makes it the result of the computation.
:- arithmetic_function(gcd/2).

% 2.08
coprime(N, M) :-
    gcd(N, M)=:=1.

% 2.09
totient_phi(N, Phi) :-
    N1 is N-1,
    totient_phi(N, N1, Phi).
totient_phi(_, 1, 1) :-
    !.
totient_phi(N, M, Phi) :-
    coprime(N, M),
    M1 is M-1,
    totient_phi(N, M1, Phi1),
    Phi is Phi1+1.
totient_phi(N, M, Phi) :-
    \+ coprime(N, M),
    M1 is M-1,
    totient_phi(N, M1, Phi).

% 2.10
totient_phi_efficient(N, Phi) :-
    factors_and_multiplicities(N, Factors),
    foldl(multiplicands, Factors, 1, Phi).
    
multiplicands([B, A], C, M) :-
    M is C*(A-1)*(A-1)**(B-1).

% 2.11 (I didn't write this).
totient_test(N) :-
    write('totient_phi (p2_09):'),
    time(totient_phi(N, Phi1)),
    write('result = '),
    write(Phi1),
    nl,
    write('totient_phi_efficient (p2_10):'),
    time(totient_phi_efficient(N, Phi2)),
    write('result = '),
    write(Phi2),
    nl.

add(X, Y, Sum) :-
    Sum is X+Y.