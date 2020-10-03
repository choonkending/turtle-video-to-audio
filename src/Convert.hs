{-# LANGUAGE OverloadedStrings #-}

module Convert where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (appConfig, lookUpConfig, Config)
import Data.Either (either)
import Control.Monad.Reader (MonadReader, MonadIO, Reader, ReaderT, runReaderT, asks, return, liftIO)

createArguments :: Turtle.Text -> Turtle.FilePath -> [Turtle.Text]
createArguments mp3Directory filePath =
  let baseFileName = Turtle.basename filePath
      inputFileName = format fp filePath
      outputFileName = mp3Directory <> format fp baseFileName <> ".mp3"
  in ["-i", inputFileName, "-q:a", "0",  "-map", "a", outputFileName]

getMP4FilesFromPath :: Turtle.Text -> Shell Turtle.FilePath
getMP4FilesFromPath filepath = find (suffix ".mp4") $ Turtle.fromText filepath

runCommand :: Turtle.Text -> Turtle.FilePath -> IO ()
runCommand mp3Directory filePath = proc "ffmpeg" (createArguments mp3Directory filePath) Turtle.empty >>= print

appConvert :: ReaderT Config IO ()
appConvert = do
  eitherMP4Directory <- asks (lookUpConfig "MP4_DIRECTORY")
  eitherMP3Directory <- asks (lookUpConfig "MP3_DIRECTORY")
  case (eitherMP4Directory, eitherMP3Directory) of
    (Right mp4Dir, Right mp3Dir) -> foldIO (getMP4FilesFromPath mp4Dir) (L.sink (runCommand mp3Dir))
    (_, _) -> liftIO $ putStrLn "Error: Config value not found"

convert :: IO ()
convert = runReaderT appConvert appConfig
