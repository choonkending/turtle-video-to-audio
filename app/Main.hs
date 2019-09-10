{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle (Text, empty)
import Turtle.Prelude (shell)
import Turtle.Line (Line)

command :: Text
command = "ffmpeg -i a.mp4 -q:a 0 -map a a.mp3"

main :: IO ()
main = shell command empty >>= (\exitCode -> putStrLn $ show exitCode)
