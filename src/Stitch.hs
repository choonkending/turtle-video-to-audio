{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (appConfig, lookUpConfig, Config)
import Control.Monad.Reader (ReaderT, runReaderT, asks, return)
import Control.Applicative (liftA2)

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
  eitherTemplateDirectory <- asks (lookUpConfig "EDITING_TEMPLATE_DIRECTORY")
  eitherIntroFilename <- asks (lookUpConfig "INTRO_FILENAME")
  let eitherIntroFilePath = liftA2 (<>) eitherTemplateDirectory eitherIntroFilename
  case (eitherInputDirectory, eitherOutputDirectory, eitherIntroFilePath) of
    (Right inputDirectory, Right outputDirectory, Right introFilePath) -> foldIO (getMP3FilesFromPath inputDirectory) (L.sink (runCommand introFilePath outputDirectory))
    (_, _, _) -> return ()

stitch :: IO ()
stitch = runReaderT appStitch appConfig
