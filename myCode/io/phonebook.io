//just typing out the code to learn

OperatorTable addAssignOperator(":", "atPutNumber")

//So Io magically knows when it sees a set of curly brackets to call `curlyBrackets`
//This is pretty good for making a DSL but pretty unintuitive!!!
curlyBrackets := method(
  r := Map clone
  //With just two methods, curlyBrackets and atPutNumber, we parse the input
  "In curly brackets" println
  call message arguments println
  call message arguments foreach(arg,
    r doMessage(arg)
    )
  r
)
Map atPutNumber := method(
  self atPut(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
    call evalArgAt(1)
  )
)

s := File with("phonebook.txt") openForReading contents
phoneNumbers := doString("{ 
    \"Bob Smith\": \"5195551212\",
    \"Mary Walsh\": \"4162223434\"
}"        
)
//phoneNumbers := doString(s)
// phoneNumbers asList println
// phoneNumbers asObject println
// phoneNumbers justSerialized println
phoneNumbers foreach(k, v, k println)
phoneNumbers keys println
phoneNumbers values println