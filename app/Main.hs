{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle (Text, empty)
import Turtle.Prelude (shell, find)
import Turtle.Line (Line)
import Turtle.Shell (view)
import Turtle.Pattern (suffix)

command :: Text
command = "ffmpeg -i a.mp4 -q:a 0 -map a a.mp3"

runCommand :: IO ()
runCommand = shell command empty >>= (\exitCode -> putStrLn $ show exitCode)

main :: IO ()
main = view (find (suffix ".mp4") "/Users/Ken/Downloads")
