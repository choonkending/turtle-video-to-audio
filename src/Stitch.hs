{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (appConfig, lookUpConfig, Config)
import Control.Monad.Reader (ReaderT, runReaderT, asks, return, liftIO)

getMP3FilesFromPath :: Turtle.Text -> Shell Turtle.FilePath
getMP3FilesFromPath filePath = find (suffix ".mp3") $ Turtle.fromText filePath

createArguments :: Turtle.Text -> Turtle.Text -> Turtle.FilePath -> [Turtle.Text]
createArguments introFileName outputDirectory mainFilePath =
  let mainFileName = format fp mainFilePath
      outputFileName = outputDirectory <> format fp (Turtle.filename mainFilePath)
  in ["-i", introFileName, "-i", mainFileName, "-filter_complex", "concat=n=2:v=0:a=1", outputFileName]

runCommand :: Turtle.Text -> Turtle.Text -> Turtle.FilePath -> IO ()
runCommand introFileName outputDirectory filePath = proc "ffmpeg" (createArguments introFileName outputDirectory filePath) Turtle.empty >>= print

appStitch :: ReaderT Config IO ()
appStitch = do
  eitherInputDirectory <- asks (lookUpConfig "EDIT_INPUT_DIRECTORY")
  eitherOutputDirectory <- asks (lookUpConfig "EDIT_OUTPUT_DIRECTORY")
  eitherIntroFilePath <- asks (lookUpConfig "INTRO_FILEPATH")
  case (eitherInputDirectory, eitherOutputDirectory, eitherIntroFilePath) of
    (Right inputDirectory, Right outputDirectory, Right introFilePath) -> foldIO (getMP3FilesFromPath inputDirectory) (L.sink (runCommand introFilePath outputDirectory))
    (_, _, _) -> liftIO $ putStrLn "Error: Config value not found"

stitch :: IO ()
stitch = runReaderT appStitch appConfig
