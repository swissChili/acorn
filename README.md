# acorn

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
extern IO.print ...

# fib takes one argument
def fib 1
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
def main 0
  int 5
  # [1]
  fn fib
  # [1, fib]
  eval 1
  # Last item in stack (fib) is called with 1 argument.
  print
  eval 1
  # Call the print function with the return from fib
``` 

## building

```sh
$ stack build
```
