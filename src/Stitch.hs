{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (defaultConfig, editInputFilesDirectory, editOutputFilesDirectory, editTemplatesDirectory, introFileName)

getMP3Files :: Shell Turtle.FilePath
getMP3Files = find (suffix ".mp3") $ Turtle.fromText $ editInputFilesDirectory defaultConfig

createArguments :: Turtle.FilePath -> [Turtle.Text]
createArguments mainFilePath =
  let openingFileName = editTemplatesDirectory defaultConfig <> introFileName defaultConfig
      mainFileName = format fp mainFilePath
      outputFileName = editOutputFilesDirectory defaultConfig <> format fp (Turtle.filename mainFilePath)
  in ["-i", openingFileName, "-i", mainFileName, "-filter_complex", "concat=n=2:v=0:a=1", outputFileName]

runCommand :: Turtle.FilePath -> IO ()
runCommand filePath = proc "ffmpeg" (createArguments filePath) Turtle.empty >>= print

stitch :: IO ()
stitch = foldIO getMP3Files (L.sink runCommand)
