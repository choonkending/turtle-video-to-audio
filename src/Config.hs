{-# LANGUAGE OverloadedStrings #-}

module Config where

import Prelude (id, (<>))
import Data.Text (Text)
import Data.Map (Map, fromList, findWithDefault, lookup)
import Data.Either (Either)
import Data.Either.Combinators (maybeToRight)

type Config = Map Text Text
data ConfigError = ConfigNotFound

defaultEditingFileName :: Text
defaultEditingFileName = "NBM INTRO.mp3"

editingTemplateConfig :: Config
editingTemplateConfig = fromList [
     ("NBM", "NBM INTRO.mp3"),
     ("BSV-ONSITE", "BSV INTRO - ONSITE.mp3"),
     ("BSV-OFFSITE", "BSV INTRO - OFFSITE.mp3")
  ]

defaultEditingFilePath :: Text
defaultEditingFilePath = "/Users/Ken/Documents/Buddhist/Editing Templates/" <> findWithDefault defaultEditingFileName "NBM" editingTemplateConfig

appConfig :: Config
appConfig = fromList [
    ("MP4_DIRECTORY", "/Users/Ken/Downloads/convert/mp4/"),
    ("MP3_DIRECTORY", "/Users/Ken/Downloads/convert/mp3/"),
    ("EDIT_INPUT_DIRECTORY", "/Users/Ken/Downloads/convert/edit/"),
    ("EDIT_OUTPUT_DIRECTORY", "/Users/Ken/Downloads/convert/final/"),
    ("INTRO_FILEPATH", defaultEditingFilePath)
  ]

lookUpConfig :: Text -> Config -> Either ConfigError Text
lookUpConfig name config = maybeToRight ConfigNotFound (lookup name config)
