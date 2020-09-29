{-# LANGUAGE OverloadedStrings #-}

module Stitch (stitch) where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, proc)
import Turtle.Shell (Shell, foldIO)
import Turtle.Pattern (suffix)
import Turtle.Format (format, fp)
import Config (appConfig, lookUpConfig, Config)
import Control.Monad.Reader (Reader, runReader, asks, return)

getMP3FilesFromPath :: Turtle.Text -> Shell Turtle.FilePath
getMP3FilesFromPath filePath = find (suffix ".mp3") $ Turtle.fromText filePath

createArguments :: Turtle.Text -> Turtle.Text -> Turtle.FilePath -> [Turtle.Text]
createArguments introFileName outputDirectory mainFilePath =
  let mainFileName = format fp mainFilePath
      outputFileName = outputDirectory <> format fp (Turtle.filename mainFilePath)
  in ["-i", introFileName, "-i", mainFileName, "-filter_complex", "concat=n=2:v=0:a=1", outputFileName]

getFilesAndPaths :: Reader Config (Turtle.Text, Turtle.Text, Turtle.Text)
getFilesAndPaths = do
  inputDirectory <- asks (lookUpConfig "EDIT_INPUT_DIRECTORY")
  outputDirectory <- asks (lookUpConfig "EDIT_OUTPUT_DIRECTORY")
  editingTemplateDirectory <- asks (lookUpConfig "EDITING_TEMPLATE_DIRECTORY")
  introFileName <- asks (lookUpConfig "INTRO_FILENAME")
  return (inputDirectory, outputDirectory, editingTemplateDirectory <> introFileName)

runCommand :: Turtle.Text -> Turtle.Text -> Turtle.FilePath -> IO ()
runCommand introFileName outputDirectory filePath = proc "ffmpeg" (createArguments introFileName outputDirectory filePath) Turtle.empty >>= print

stitch :: IO ()
stitch = let
  (inputDirectory, outputDirectory, introFileName) = runReader getFilesAndPaths appConfig
  in
    foldIO (getMP3FilesFromPath inputDirectory) (L.sink (runCommand introFileName outputDirectory))

