//expanding to do indentations and attributes

OperatorTable addAssignOperator(":", "atPutAttr")

Builder := Object clone

Builder indent := 0

Builder inOpeningTag := false

Builder forward := method(
  
  //keeping track of a variable to see whether I still need to end my
  //opening tag seems not great -- but otherwise I have to be otherwise
  //smart about whether my argument is a normal string or a map so I can
  //decide whether to close my tag or not
  if(self inOpeningTag, writeln(">"); self inOpeningTag = false)

  //Open tag and indent
  write(" " repeated(self indent), "<", call message name)
  self indent = self indent + 2
  self inOpeningTag = true

  call message arguments foreach(
    arg,
    content := self doMessage(arg);
    if(content type == "Map",
      content attrPrint;
      writeln(">")
    );
    if(content type == "Sequence", 
      writeln(" " repeated(self indent), content)
    );
  )
  
  //Unindent and close tag
  self indent = self indent - 2
  writeln(" " repeated(self indent), "</", call message name, ">")
)

Builder curlyBrackets := method(
  r := Map clone
  //I need to pass this as a string, otherwise the : operator
  //is getting interpreted as a message passed to the key
  call message arguments foreach(arg,
    r doString(arg asSimpleString)
    )
  r
)

Map atPutAttr := method(
  self atPut(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
    call evalArgAt(1)
  )
)

Map attrPrint := method(
  self foreach(k, v, 
    write(" ", k, "=\"", v, "\"")
  )
)

//cloning so as to allow each instance to manage its own variables
// Builder clone ul(
//   li("Io"),
//   li("Lua"),
//   li("JavaScript")
// )

// Builder clone baz("bar")

Builder clone bar(baz({"quux":"foo", "foo": "quux"},"bar"))

//Funny, this won't work if any of my tags has a name that is a slot on object
//Not sure how I'd fix this!
Builder clone and("fdsa")
