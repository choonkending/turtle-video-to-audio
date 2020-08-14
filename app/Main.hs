{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (defaultConfig, mp4FilesDirectory, mp3FilesDirectory)

createArguments :: Turtle.FilePath -> [Turtle.Text]
createArguments filePath =
  let baseFileName = Turtle.basename filePath
      inputFileName = format fp filePath
      outputFileName = mp3FilesDirectory defaultConfig <> format fp baseFileName <> ".mp3"
  in ["-i", inputFileName, "-q:a", "0",  "-map", "a", outputFileName]

getMP4Files :: Shell Turtle.FilePath
getMP4Files = find (suffix ".mp4") $ Turtle.fromText $ mp4FilesDirectory defaultConfig

runCommand :: Turtle.FilePath -> IO ()
runCommand filePath = proc "ffmpeg" (createArguments filePath) Turtle.empty >>= print

main :: IO ()
main = foldIO getMP4Files (L.sink runCommand)
