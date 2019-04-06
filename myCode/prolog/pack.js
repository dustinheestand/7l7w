// % 1.09
// pack([], []).
//   pack([[H]], [H]).
// % In more familiar notation: pack([X, Y | Z]) = [[X], pack[Y | Z]]
//   % where X != Y
// pack([[X] | T], [X, Y | Z]) : -
//   X\=Y,
//     pack(T, [Y | Z]).
// % Where the first two elements are equal, i.e.matches pack[X, X | Z]:
// % [[X | head(pack[X | Z])] | tail(pack([X | Z]))]
// pack([[X | Xs] | T], [X, X | Z]) : -
//   pack([Xs | T], [X | Z]).

function pack(str) {
  if (str == "") return [];
  if (str.length == 1) return [[str]];
  //Return the first char in brackets, then pack the tail
  if (str[0] != str[1]) return [[str[0]], ...pack(str.slice(1))];
  //Return the first char, added to the first group of the packed tail as the first element of the array
  //And the rest of the array is just the tail of the packed tail
  return [[str[0], ...pack(str.slice(1))[0]], ...pack(str.slice(1)).slice(1)];
}

console.log(pack("aaaabbbbcdeef"));
