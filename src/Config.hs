{-# LANGUAGE OverloadedStrings #-}

module Config where

import Data.Text (Text)
import Data.Map (fromList, findWithDefault)

data Config = Config {
  mp4FilesDirectory :: Text,
  mp3FilesDirectory :: Text,
  editInputFilesDirectory :: Text,
  editOutputFilesDirectory :: Text,
  editTemplatesDirectory :: Text,
  introFileName :: Text
}

defaultEditingFileName :: Text
defaultEditingFileName = "BSV INTRO - ONSITE.mp3"

editTemplatesMap = fromList [
    ("nbm", "NBM INTRO.mp3"),
    ("bsv-on", "BSV INTRO - ONSITE.mp3"),
    ("bsv-off", "BSV INTRO - OFFSITE.mp3")
  ]

defaultConfig = Config {
  mp4FilesDirectory = "/Users/Ken/Downloads/convert/mp4/",
  mp3FilesDirectory = "/Users/Ken/Downloads/convert/mp3/",
  editInputFilesDirectory = "/Users/Ken/Downloads/convert/edit/",
  editOutputFilesDirectory = "/Users/Ken/Downloads/convert/final/",
  editTemplatesDirectory = "/Users/Ken/Documents/Buddhist/Editing Templates/",
  introFileName = findWithDefault defaultEditingFileName "nbm" editTemplatesMap
}
