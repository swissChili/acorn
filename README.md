Acorn is a high level stack based virtual machine.

## assembly

The assembler isnt written yet, but this will be the syntax. 
This also may be useful to see how the machine works. Current
stack value is commented after every operation.

```rb
# says a print function that takes unlimited arguments
# should be gotten somehow externally. Either from
# standard lib, or included at runtime. Linking support
# would be cool too.
extern IO.print

# fib takes one argument
def fib int
  # push first arg to stack
  arg 0
  # [whatever the arg is]
  int 2
  # [arg0, 2]
  lt
  # arg < 2 ? 1 : 0
  # let's call this lt_2 from now on
  if
    int 1
    # [lt_2, 0]
    return
    # return 0 from the function
  else
    # else if isnt a thing, just nest if statements. 

    arg 0
    # [..., arg0]
    int 1
    sub
    # [arg0 - 1]
    fn fib
    eval 1
    # call fib(arg0-1)

    # same thing as above, result from first call
    # is still on the stack.
    arg 0 
    int 2
    sub 
    fn fib
    eval 1

    # Now the results from both functions are on the
    # stack, can return their sum
    add
    return
  end


# main takes zero arguments
def main
  int 5
  # [1]
  fn fib
  # [1, fib]
  eval 1
  # Last item in stack (fib) is called with 1 argument.
  fn print
  eval 1
  # Call the print function with the return from fib
```

## bytecode

The acorn bytecode is far simpler than that of many other
comparable virtual machines. It consists of a simple header,
and then one or more [function](#functions) blocks.

### header

- magic number: 3 byte ascii literal `avm`
- version: unsigned 8 bit int
- externs: ascii space (`\s`) terminated ascii strings. e.g: `IO.print, Package.function`, ends with a null char (`\0`)
- types: null seperated type declarations, see [types](#types)

### types

Acorn, being a functional vm, does not support classes or imperative types like structs. Instead, everything is accomplished via named union types, (e.g: haskell's `data` types). Types and their variants are named.

- name: ascii null terminated string, containging characters matching regex `[a-zA-Z]`

- 1 or more:
  
  - name: ascii null terminated string, same character range as name
  
  - types: either
    
    - a byte corresponding to the instruction opcode to push that type to the stack. e.g: for an unsigned 32 bit int, the byte `0x03` would be used.
    
    - a null byte (`0x00`) followed by an ascii name of the type. This type can be from an external package which was imported via the extern section in the header, or a type defined in the same package. The order of types does not matter, so a type can reference a type defined after it.
  
  - a null byte (`0x00`)

### functions

One or more of these function blocks:

- name: null terminated ascii string
- arguments, 0 or more of:
  - either:
    - single byte corresponding to the opcode used to push that type (used for literals)
    - ascii string of type name
  - null byte (`0x00`)
- body: many [instructions](#instructions)

### instructions

Each instruction has a one byte opcode followed by zero or more
arguments.

#### literals

| opcode | assembly name | argument size          | **description** |
| ------ | ------------- | ---------------------- | --------------- |
| `0x01` | int           | 32 bit int             | push int        |
| `0x02` | int64         | 64 bit int             | push int        |
| `0x03` | uint          | 32 bit unsigned int    | push uint       |
| `0x04` | uint64        | 64 bit unsigned int    | push uint       |
| `0x05` | float         | 32 bit float           | push float      |
| `0x06` | float64       | 64 bit float           | push float      |
| `0x07` | fn            | null terminated string | push function   |
| `0x08` | str           | null terminated string | push string     |
| `0x09` | char          | one byte ascii char    | push char       |

## building

```sh
$ stack build
```
