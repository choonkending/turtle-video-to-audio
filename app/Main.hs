{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Data.Maybe (maybe)
import Data.Text (stripSuffix)

stripMp4Suffix :: Turtle.Text -> Turtle.Text
stripMp4Suffix file = maybe file id (stripSuffix ".mp4" file)

createOutputFileName :: Turtle.Text -> Turtle.Text
createOutputFileName filePath = (stripMp4Suffix filePath) <> ".mp3"

createArguments :: Turtle.FilePath -> [Turtle.Text]
createArguments filePath =
  let inputFileName = format fp filePath
      outputFileName = createOutputFileName inputFileName
  in ["-i", inputFileName, "-q:a", "0",  "-map", "a", outputFileName]

getMP4Files :: Shell Turtle.FilePath
getMP4Files = find (suffix ".mp4") "/Users/Ken/Downloads/test"

runCommand :: Turtle.FilePath -> IO ()
runCommand filePath = proc "ffmpeg" (createArguments filePath) Turtle.empty >>= print

main :: IO ()
main = foldIO getMP4Files (L.sink runCommand)
