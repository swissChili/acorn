module Lib where

import Types
import Data.List (zip)
import Data.Map
import Ops

-- Used as utilities for stack manipulation
drop2 = init . init
last2 = last . init

--     ctx        stack    fn call handler                        body      ret 
run :: Context -> Stack -> (Context -> [Val] -> String -> Val) -> [Node] -> Val
run c s h ((Push a):xs)  = run c (s ++ [a])  h xs
run c s h (Add:xs)       = run c sa          h xs
  where sa = (drop2 s) ++ (last2 s) `valAdd` (last s)
run c s h (Sub:xs)       = run c sa          h xs
  where sa = (drop2 s) ++ (last2 s) `valSub` (last s)
run c s h (Mult:xs)      = run c sa          h xs
  where sa = (drop2 s) ++ (last2 s) `valMult` (last s)
run c s h (Div:xs)       = run c sa          h xs
  where sa = (drop2 s) ++ (last2 s) `valDiv` (last s)
run _ s _ _ = last s

fnbody :: Function -> [Node]
fnbody (Function _ n) = n

argsToCtx :: Context -> [Val] -> [String] -> Context
argsToCtx ctx a an = union ctx $ fromList $ zip an a

runFunc :: Syntax -> Context -> [Val] -> String -> Val
runFunc s ctx args fn = run actx ([Whole 0, Whole 0] :: Stack) (runFunc s) (fnbody $ s ! fn)
  where
    actx = argsToCtx ctx args $ argsFromFn (s ! fn)
    argsFromFn (Function a _) = a
