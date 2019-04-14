module Main where

import Types
import Lib
import Data.Map

main :: IO ()
main =
  print $ runFunc s c a "main"
    where
      s = fromList [("main", Function [] [ Push (Whole 1)
                                         , Push (Whole 3)
                                         , Add
                                         , Push (Floating 23.1241)
                                         , Add
                                         , Push (Whole 4)
                                         , Sub
                                         , Push (Whole 2)
                                         , Mult ])]
      c = fromList [] :: Map String Val
      a = [] :: [Val]
