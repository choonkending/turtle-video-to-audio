{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix, has, text, Pattern)
import Turtle.Format (format, fp)
import Data.Maybe (fromMaybe)
import Data.Text (stripSuffix)
import Data.Map (fromList, findWithDefault)

introTemplateMap = fromList([("nbm", "INTRO.mp3"), ("bsv", "ONSITE.mp3")])

getIntroFile :: Turtle.Text -> Pattern Turtle.Text
getIntroFile fileName = text (findWithDefault "ONSITE.mp3" fileName introTemplateMap)

stripMp3Suffix :: Turtle.Text -> Turtle.Text
stripMp3Suffix file = fromMaybe file (stripSuffix ".mp3" file)

createOutputFileName :: Turtle.Text -> Turtle.Text
createOutputFileName filePath = stripMp3Suffix filePath <> "-final.mp3"

getMP3Files :: Shell Turtle.FilePath
getMP3Files = find (suffix ".mp3") "/Users/Ken/Downloads/convert/stitch"

getOpeningFile :: Shell Turtle.FilePath
getOpeningFile = find (has (getIntroFile "nbm")) "/Users/Ken/Documents/Buddhist/Editing Templates"

createArguments :: Turtle.FilePath -> Turtle.FilePath -> [Turtle.Text]
createArguments openingFilePath mainFilePath =
  let openingFileName = format fp openingFilePath
      mainFileName = format fp mainFilePath
      outputFileName = createOutputFileName mainFileName
  in ["-i", openingFileName, "-i", mainFileName, "-filter_complex", "concat=n=2:v=0:a=1", outputFileName]

runCommand :: (Turtle.FilePath, Turtle.FilePath) -> IO ()
runCommand (f1, f2) = proc "ffmpeg" (createArguments f1 f2) Turtle.empty >>= print

stitch :: IO ()
stitch = foldIO (Turtle.liftA2 (,) getOpeningFile getMP3Files) (L.sink runCommand)
