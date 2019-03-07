List sum2d := method(self flatten sum)

List sum2dInconvenient := method(
  self map(sub, sub reduce(+)) reduce(+) 
)

writeln(list(list(2,3),list(7,8)) sum2d)
writeln(list(list(2,3),list(7,8)) sum2dInconvenient)