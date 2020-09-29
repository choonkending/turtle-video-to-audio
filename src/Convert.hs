{-# LANGUAGE OverloadedStrings #-}

module Convert where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (appConfig, lookUpConfig, Config)
import Control.Monad.Reader (Reader, runReader, asks, return)

createArguments :: Turtle.Text -> Turtle.FilePath -> [Turtle.Text]
createArguments mp3Directory filePath =
  let baseFileName = Turtle.basename filePath
      inputFileName = format fp filePath
      outputFileName = mp3Directory <> format fp baseFileName <> ".mp3"
  in ["-i", inputFileName, "-q:a", "0",  "-map", "a", outputFileName]

getMP4FilesFromPath :: Turtle.Text -> Shell Turtle.FilePath
getMP4FilesFromPath filepath = find (suffix ".mp4") $ Turtle.fromText filepath

getDirectories :: Reader Config (Turtle.Text, Turtle.Text)
getDirectories = do
  mp4Directory <- asks (lookUpConfig "MP4_DIRECTORY")
  mp3Directory <- asks (lookUpConfig "MP3_DIRECTORY")
  return (mp4Directory, mp3Directory)

runCommand :: Turtle.Text -> Turtle.FilePath -> IO ()
runCommand mp3Directory filePath = proc "ffmpeg" (createArguments mp3Directory filePath) Turtle.empty >>= print

convert :: IO ()
convert =
  let (mp4Directory, mp3Directory) = runReader getDirectories appConfig
  in
    foldIO (getMP4FilesFromPath mp4Directory) (L.sink (runCommand mp3Directory))
