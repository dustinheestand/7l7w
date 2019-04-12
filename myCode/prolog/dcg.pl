% type phrase(as, N) to get all the lists this dcg can represent
(as) -->
    [].
(as) -->
    [a],
    (as).

% The below doesn't terminate because it refers to a non-terminal before a terminal
% This makes it left-recursive
% This means it just keeps looking deeper and deeper down the left subtree
% to see if it can reach the goal
% tree_nodes(nil) -->
%     [].
% tree_nodes(node(Name, Left, Right)) -->
%     tree_nodes(Left),
%     [Name],
%     tree_nodes(Right).


% The query that will give us all the trees is Ns = [a,b,c,d], phrase(tree_nodes(Tree, Ns, _), Ns).
% That _, if replaced by a variable, shows us it is always the empty list! 
% So, I understand the empty list as "nothing left over" but how does it fit???
%
% So, say we have the tree
% a
%  \
%   b
%    \
%     c
%      \
%       d
%
% Left is nil, so we need to evaluate to an empty list. Thus Ls0 == Ls1.
% So then we have [a], then tree_nodes(b-c-d, [b,c,d], []).
% If we don't start with Ls empty, then once our tree has used up all 
% the nodes, we'll call tree_nodes(nil, [], [X|Y]). Which won't match!
%
% Let's do another tree for my edification.
%   b
%  / \
% a   c
%      \
%       d
%
% Left is node(a, nil, nil). Right is node(c, nil, node(d, nil,nil)).
% tree_nodes(Tree, [a|[b,c,d]], []) - we have Left = Left above, Right = Right above
% name = b, Ls0 = [b,c,d], Ls = []
% tree_nodes(node(a,nil,nil), [b,c,d], ?) - Left = nil, Right = nil, Ls0 = [c,d]
% Ls1 must equal [c,d] for left to evaluate to nil.
% Ls must equal [c,d] for right to evaluate to nil.
% So now Ls1 is [c,d] and we know that's what has to go in the right tree.
% tree_nodes(node(c, nil, node(d, nil,nil), [c,d], []).
% and of course this tree will exhaust [c,d] with [] left over.
%
% This terminates because every time I go a level deeper on the left I lose
% an element from the initial list. And I can't match [_|Ls0] with an empty
% list. So I fail and come back up the tree.
tree_nodes(nil, Ls, Ls) -->
    [].
tree_nodes(node(Name, Left, Right), [_|Ls0], Ls) -->
    tree_nodes(Left, Ls0, Ls1),
    [Name],
    tree_nodes(Right, Ls1, Ls).

state(S), [S] -->
    [S].

state(S0, S), [S] -->
    [S0].

% Amusingly this can't be used to generate trees
num_leaves(nil) -->
    state(N0, N),
    { N#=N0+1
    }.
num_leaves(node(_, Left, Right)) -->
    num_leaves(Left),
    num_leaves(Right).

quicksort([]) -->
    [].
quicksort([L|Ls]) -->
    { partition(#>(L), Ls, Less, Greater)
    },
    quicksort(Less),
    [L],
    quicksort(Greater).


% Use with this command: length(Ms, _), phrase(moves([jug(a,8),jug(b,0),jug(c,0)]), Ms).
% The length thing preceding makes it try with 0, then 1, then 2, and so on until it gets a match
% Otherwise it goes deep looking for a list starting with a certain move and continuing with that
% same move, probably just pouring water back and forth.
jug_capacity(a, 8).
jug_capacity(b, 5).
jug_capacity(c, 3).

% Success condition
moves(Jugs) -->
    { memberchk(jug(a, 4), Jugs),
      memberchk(jug(b, 4), Jugs)
    }.
moves(Jugs0) -->
    % Get some list Jugs1 by removing an element from Jugs0
    { select(jug(AID, AF), Jugs0, Jugs1),
    % Such that the removed element is not empty
      AF#>0,
      % Get some list Jugs2 by removing a second element
      select(jug(BID, BF), Jugs1, Jugs2),
      jug_capacity(BID, BC),
      % Such that the selected jug is not full
      BF#<BC,
      % Whichever is less: all the water in the first jub
      % Or the amount of water we would need to fill the second jug
      Move#=min(AF, BC-BF),
      % Move from the first jug
      AF1#=AF-Move,
      % To the second jug
      BF1#=BF+Move
    },
    % Now append the move to the list of moves
    [from_to(AID, BID)],
    % Now append the rest of the moves
    moves([jug(AID, AF1), jug(BID, BF1)|Jugs2]).
    
% ESCAPE FROM ZURG
% My code
% This doesn't assume that taking a trip all the way across the bridge is optimal.
% Turns out it is! Which I'm sure I could prove mathematically if I thought hard enough.
% Anyway, the query is toys_init(Toys),length(Ms,7), phrase(crossings(Toys, 0, 0, forward), Ms).
toys_init([toy(buzz, 0), toy(woody, 0), toy(rex, 0), toy(hamm, 0)]).

toy_time(buzz, 5).
toy_time(woody, 10).
toy_time(rex, 20).
toy_time(hamm, 25).

safe(toy(_, N)) :-
    N#=5.

crossings(Toys, Time, _, back) -->
    { Time#=<60,
      maplist(safe, Toys)
    }.

crossings(Toys0, Time0, FlashPos, forward) -->
    { Time0#=<60,
      select(toy(NameA, FlashPos), Toys0, Toys1),
      select(toy(NameB, PosB), Toys1, NonCrossers),
      PosB#>=FlashPos,
      NewPos in 1..5,
      NewPos#>PosB,
      ADistance#=PosB-FlashPos,
      toy_time(NameA, SpeedA),
      toy_time(NameB, SpeedB),
      max_list([SpeedA, SpeedB], SlowSpeed),
      BDistance#=NewPos-PosB,
      Time1#=Time0+(ADistance*SpeedA+BDistance*SlowSpeed)//5
    },
    [from_to(NameA, NameB, NewPos)],
    crossings([toy(NameA, NewPos), toy(NameB, NewPos)|NonCrossers],
              Time1,
              NewPos,
              back).

crossings(Toys0, Time0, FlashPos, back) -->
    { Time0#=<60,
      select(toy(NameA, FlashPos), Toys0, Toys1),
      select(toy(_, PosB), Toys1, _),
      PosB#<FlashPos,
      toy_time(NameA, Speed),
      Distance#=FlashPos-PosB,
      Time1#=Time0+Distance*Speed//5
    },
    [from_to(NameA, NewPos)],
    crossings([toy(NameA, NewPos)|Toys1],
              Time1,
              NewPos,
              forward).


% More or less the same code, but assumes that we always want to cross
% all the way.
% And it runs a million times faster!
safe2(toy(_, N)) :-
    N#=1.

crossings2(Toys, Time, back) -->
    { Time#=<60,
      maplist(safe2, Toys)
    }.

crossings2(Toys0, Time0, forward) -->
    { Time0#=<60,
      select(toy(NameA, PosA), Toys0, Toys1),
      select(toy(NameB, PosA), Toys1, NonCrossers),
      PosA#=0,
      toy_time(NameA, SpeedA),
      toy_time(NameB, SpeedB),
      SpeedA#>SpeedB,
      max_list([SpeedA, SpeedB], SlowSpeed),
      Time1#=Time0+SlowSpeed
    },
    [from_to(NameA, NameB, forward)],
    crossings2([toy(NameA, 1), toy(NameB, 1)|NonCrossers], Time1, back).

crossings2(Toys0, Time0, back) -->
    { Time0#=<60,
      select(toy(NameA, PosA), Toys0, Toys1),
      PosA#=1,
      toy_time(NameA, Speed),
      Time1#=Time0+Speed
    },
    [from_to(NameA, back)],
    crossings2([toy(NameA, 0)|Toys1], Time1, forward).