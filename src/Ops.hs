module Ops where 

import Types

appendList :: [a] -> a -> [a]
appendList x y = x ++ [y]

valOp :: (Int -> Int -> Int) -> (Float -> Float -> Float) -> Val -> Val -> [Val]
valOp i f (Whole a) c = case c of
  (Whole b)    -> [Whole    $ a `i` b]
  (Floating b) -> [Floating $ (fromIntegral a) `f` b]

valOp i f (Floating a) c = appendList [] $ Floating $ case c of
  (Whole b)    -> a `f` (fromIntegral b)
  (Floating b) -> a `f` b

-- Not a number? Return the stack unmodified
-- praise be silent deaths
valOp _ _ a b = [a, b]

valAdd = valOp (+) (+)
valSub = valOp (-) (-)

valMult = valOp (*) (*)

valDiv :: Val -> Val -> [Val]
valDiv (Whole a) b = case b of
  (Whole b)    -> [Floating $ af / fromIntegral b]
  (Floating b) -> [Floating $ af / b]
  where af = fromIntegral a

valDiv (Floating a) b = case b of
  (Whole b)    -> [Floating $ a / fromIntegral b]
  (Floating b) -> [Floating $ a / b]

valDiv a b = [a, b]

