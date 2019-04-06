% Basically the idea is the prolog tries each clause in the proposition
% in order, then backtracks once it fails. Certain predicates like write/1
% are not "resatisfiable", but dog/1 is, as long as there is still a 
% dog outstanding that hasn't already been used to satisfy dog/1
dog(john).
dog(ted).
dog(ralph).

alldogs :-
    dog(X),
    write(X),
    nl,
    fail.
alldogs.