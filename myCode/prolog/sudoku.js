class Sudoku {
  constructor(board) {
    this.board = board;
    this.solution = [...board].map(r => [...r]);
    this.backtrack = 0;
  }
  row(n, board = this.board) {
    return board[n];
  }
  col(n, board = this.board) {
    return board.map(r => r[n]);
  }
  box(n, board = this.board) {
    return board
      .slice(Math.floor(n / 3) * 3, Math.floor((n + 3) / 3) * 3)
      .map(r => r.slice((n % 3) * 3, (n % 3) * 3 + 3))
      .reduce((acc, r) => [...acc, ...r], []);
  }
  in_box(row, col) {
    return Math.floor(row / 3) * 3 + Math.floor(col / 3);
  }
  position(n) {
    return [Math.floor(n / 9), n % 9];
  }
  getPosition(row, col) {
    return this.board[row][col];
  }
  fits(row, col, n) {
    return (
      this.row(row, this.solution).indexOf(n) == -1 &&
      this.col(col, this.solution).indexOf(n) == -1 &&
      this.box(this.in_box(row, col), this.solution).indexOf(n) == -1
    );
  }
  solve() {
    for (let i = 0; i < 81; i++) {
      const [row, col] = this.position(i);
      //If the slot isn't specified on the board
      if (!this.getPosition(row, col)) {
        let proposal = this.solution[row][col] + 1;
        while (!this.fits(row, col, proposal)) proposal++;
        this.solution[row][col] = proposal;
        if (this.solution[row][col] > 9) this.solution[row][col] = 0;
        //If we've cycled all the way around back to zero for a cell
        //keep moving backwards until you find a cell that isn't specified
        if (!this.solution[row][col]) {
          i--;
          while (this.getPosition(...this.position(i))) {
            i--;
          }
          //Have to go back an extra one because my for loop is i++
          i--;
          this.backtrack++;
        }
      }
    }
    console.log(this.solution, this.backtrack);
  }
}

const sudoku = new Sudoku([
  [0, 0, 4, 8, 0, 0, 0, 1, 7],
  [6, 7, 0, 9, 0, 0, 0, 0, 0],
  [5, 0, 8, 0, 3, 0, 0, 0, 4],
  [3, 0, 0, 7, 4, 0, 1, 0, 0],
  [0, 6, 9, 0, 0, 0, 7, 8, 0],
  [0, 0, 1, 0, 6, 9, 0, 0, 5],
  [1, 0, 0, 0, 8, 0, 3, 0, 6],
  [0, 0, 0, 0, 0, 6, 0, 9, 1],
  [2, 4, 0, 0, 0, 1, 5, 0, 0]
]);
const hardSudoku = new Sudoku([
  [0, 0, 0, 0, 0, 1, 0, 0, 3],
  [7, 0, 0, 0, 2, 9, 0, 4, 0],
  [0, 3, 0, 0, 0, 4, 0, 0, 8],
  [3, 0, 6, 0, 0, 7, 0, 5, 0],
  [0, 0, 8, 0, 0, 0, 6, 0, 0],
  [0, 7, 0, 5, 0, 0, 3, 0, 4],
  [8, 0, 0, 9, 0, 0, 0, 3, 0],
  [0, 1, 0, 4, 3, 0, 0, 0, 9],
  [5, 0, 0, 1, 0, 0, 0, 0, 0]
]);
const evilSudoku = new Sudoku([
  [0, 2, 0, 0, 0, 7, 3, 0, 1],
  [0, 3, 0, 8, 0, 0, 0, 0, 9],
  [0, 7, 0, 0, 0, 0, 0, 0, 8],
  [5, 0, 0, 3, 0, 9, 0, 0, 0],
  [0, 0, 0, 7, 0, 1, 0, 0, 0],
  [0, 0, 0, 2, 0, 8, 0, 0, 6],
  [7, 0, 0, 0, 0, 0, 0, 8, 0],
  [6, 0, 0, 0, 0, 2, 0, 1, 0],
  [9, 0, 2, 4, 0, 0, 0, 5, 0]
]);
sudoku.solve();
hardSudoku.solve();
evilSudoku.solve();

t(
  5,
  t(1, nil, t(3, nil, t(4, nil, nil))),
  t(7, nil, t(9, nil, t(87, t(24, nil, t(52, nil, nil)), t(723, nil, nil))))
);
