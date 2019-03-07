Object fib := method(n,
  if(n < 3,
    1,
    fib(n-1) + fib(n-2)
  )
)

Object fibiter := method(n,
  a := 0
  b := 1
  for(i, 1, n - 1, 
    temp := a
    a = b
    b = temp + a
  )
)

writeln(fib(17))
writeln(fibiter(30))