// I thought I'd be able to do this by cloning a method with 
// a `/` operator in it before redefining, but no dice!

// There is a way to do this without the exponentiation operator!

Number / = method(a, 
  if(a==0, 0, self * a ** -1)
)

writeln(6 / 4, ", ", 6 / 0)