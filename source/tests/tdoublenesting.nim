# From bug #23
import "../src/protobuf"
import streams
import strutils

const protoSpec = """
syntax = "proto3";

message Example2 {
    string field1 = 1;
}

message Example {
    message ExampleNested {
        Example2 example2 = 1;
    }
    ExampleNested exampleNested = 1;
}
"""
parseProto(protoSpec)

var msg = new Example
msg.exampleNested = initExample_ExampleNested()
# Fill message with enough data to make the size span more than a single byte
let example2 = initExample2(field1 = "This is a test" & "!".repeat(120))
msg.exampleNested.example2 = example2

var strm = newStringStream()
strm.write(msg)
strm.setPosition(0)
assert strm.readAll ==
  "\x0a\x8c\x01\x0a\x89\x01\x0a\x86\x01\x54\x68\x69\x73\x20\x69\x73" &
  "\x20\x61\x20\x74\x65\x73\x74\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21" &
  "\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21\x21"

