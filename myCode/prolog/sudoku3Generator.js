const fs = require("fs");

let string = `:- use_module(library(clpfd)).

% A naive solution
% This is a perfect example - I just tell the machine
% what's true and it goes to town

sudoku(Board, Solution):-
Solution = Board,
Board ins 1..9
Board = [
`;
for (let i = 1; i < 10; i++) {
  for (let j = 1; j < 10; j++) string += `C${i}${j},`;
}
string = string.slice(0, -1);
string += `],
`;
for (let i = 1; i < 10; i++) {
  string += `Row${i} = [`;
  for (let j = 1; j < 10; j++) string += `C${i}${j},`;
  string = string.slice(0, -1);
  string += `],`;
}
string += "\n";
for (let i = 1; i < 10; i++) {
  string += `Col${i} = [`;
  for (let j = 1; j < 10; j++) string += `C${j}${i},`;
  string = string.slice(0, -1);
  string += `],`;
}
string += "\n";
for (let i = 1; i < 10; i++) {
  string += `Box${i} = [`;
  for (let j = 1; j < 10; j++)
    string += `C${Math.floor((i - 1) / 3) * 3 +
      1 +
      Math.floor((j - 1) / 3)}${((j - 1) % 3) + 1 + ((i - 1) % 3) * 3},`;
  string = string.slice(0, -1);
  string += `],`;
}
for (let i = 1; i < 10; i++) {
  string += `all_distinct(Row${i}),
  all_distinct(Col${i}),
  all_distinct(Box${i}),`;
}
string = string.slice(0, -1);
string += ".\n\n";

fs.writeFileSync("sudoku3.pl", string);
