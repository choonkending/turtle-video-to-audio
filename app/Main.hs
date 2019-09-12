{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Turtle
import qualified Control.Foldl as L
import Turtle.Prelude (find, shell)
import Turtle.Shell (Shell, fold)
import Turtle.Pattern (suffix)
import Turtle.Format (format, s, (%))
import Data.Either (either)
import Data.Maybe (maybe)
import Data.Text (stripSuffix)

formatFilePath :: Turtle.Text -> Turtle.Text
formatFilePath file = format ("ffmpeg -i \""%s%".mp4\" -q:a 0 -map a \""%s%".mp3\"") file file

stripMp4Suffix :: Turtle.Text -> Turtle.Text
stripMp4Suffix file = maybe file id (stripSuffix ".mp4" file)

ifSuccess :: Turtle.Text -> Turtle.Text
ifSuccess = formatFilePath . stripMp4Suffix

ifFailure :: Turtle.Text -> Turtle.Text
ifFailure = id

createCommand :: Turtle.FilePath -> Turtle.Text
createCommand filePath = either ifFailure ifSuccess (Turtle.toText filePath)

getMP4Files :: Shell Turtle.FilePath
getMP4Files = find (suffix ".mp4") "/Users/Ken/Downloads/test"

runCommand :: Turtle.Text -> IO ()
runCommand command = shell command Turtle.empty >>= print

main :: IO ()
main = fold (createCommand <$> getMP4Files) L.list >>=
  \listOfCommands -> L.fold (L.Fold (\_ -> runCommand) (return ()) id) listOfCommands
