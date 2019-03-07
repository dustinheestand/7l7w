List myAverage := method(
  e := try(avg := self reduce(+) / self size)
  e catch(Exception raise("Your list should contain Numbers"))
  avg
)

writeln(list(1,2,3,4,5) myAverage)
writeln(list("a", "foo") myAverage)