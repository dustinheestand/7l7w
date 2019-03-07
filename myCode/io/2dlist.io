TwoDList := List clone

TwoDList dim := method(x, y,
  //I'd prefer not to have to initialize to nil but I don't see a way around it
  self setSize(y)
  self foreach(i, v, self atPut(i, List clone setSize(x)))
  //for chaining
  self
)

TwoDList set := method(x, y, value,
  if(x > -1 and x < self at(0) size and y > -1 and y < self size,
    self at(y) atPut(x, value)
  )
  //for chaining
  self
  //prefer return nil rather than out of bounds error if OOB
)

TwoDList get := method(x, y,
  if(x > -1 and x < self at(0) size and y > -1 and y < self size,
    self at(y) at(x)
  )
  //prefer return nil rather than out of bounds error if OOB
)

TwoDList transpose := method(
  newList := TwoDList clone dim(self size, self at(0) size) 
  //looks positively lispy
  self foreach(i, v, 
    v foreach(j, w,
      newList set(i,j,w)
    )  
  )
  newList
)

myList := TwoDList clone dim(4,5) set(2,1,7) set(2,2,"foo")
//No op
myList set(55,1,9)

writeln(myList transpose get(1,2))

f := File with("matrix.txt")
f remove
f openForUpdating
f write(myList transpose asString)
f close