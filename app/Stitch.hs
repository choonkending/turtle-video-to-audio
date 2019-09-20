{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import Turtle.Prelude (find)
import Turtle.Shell (Shell, view)
import Turtle.Pattern (suffix, has)

getMP3Files :: Shell Turtle.FilePath
getMP3Files = find (suffix ".mp3") "/Users/Ken/Downloads/test"

getOpeningFile :: Shell Turtle.FilePath
getOpeningFile = find (has "BSV INTRO - ONSITE.mp3") "/Users/Ken/Downloads/test/opening"

stitch :: IO ()
stitch = view getOpeningFile
