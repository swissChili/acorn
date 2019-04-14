module Types where

import Data.Map

-- AST representing a series of named functions
type Syntax  = Map String Function
-- Key-Val local storage
type Context = Map String Val

type Stack = [Val]

data Val = Whole Int
         | Floating Float
         | Character Char
         | Array [Val]
        -- Functions are first-class citizens
         | Func String
         deriving (Show)


                        -- Args    Body
data Function = Function [String] [Node]

data Node = Push Val
          | Pop
          -- Math on top two stack elements
          | Add
          | Sub
          | Mult
          | Div
          -- Store top stack element in local var dict by index
          | Store String
          -- Push item from local var by index to stack
          | Get String
          -- Call the function at the top of the stack with the last n
          -- items as arguments
          | Invocation Int
