{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Monoid (mconcat)
import Control.Monad.Trans (liftIO)
import Data.Text.Lazy

main = scotty 3000 $
  get "/:word" $ do
    --beam <- param "word"
    foo <- liftIO $ return "foo baz"
    text foo
    --html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
