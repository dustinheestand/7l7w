answer := Random value(0,100) ceil
writeln("Guess a number between one and ONE HUNDRED.")
writeln("You get ten guesses!")

for(guessCount, 1, 10, 
  writeln("Guess #", guessCount)  
  guess := File standardInput readLine asNumber

  if (guess == answer, 
    writeln("Success!")
    break
  )

  if (guessCount > 1,
    newDiff := (guess - answer) abs
    if (newDiff < diff, writeln("Warmer"), writeln("Colder")),
    if (guess != answer, writeln("Nope"))
  )

  diff := (guess - answer) abs
)

if (guess != answer, writeln("Failure, HAHAHAHA"))
