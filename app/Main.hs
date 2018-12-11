{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Data.Monoid (mconcat)
import Control.Monad.Trans (liftIO)
import Data.Text.Lazy
import Control.Monad.Reader

type Env = String

type App = ReaderT Env IO

run :: Env -> App a -> IO a
run e app = runReaderT app e

--foo :: ReaderT String IO String
foo :: App String
foo = do
  l <- bar
  ll <- ask
  liftIO $ putStrLn "Computing..."
  return (ll ++ ", length: " ++ show l)

--bar :: ReaderT String IO Int
bar :: App Int
bar = reader Prelude.length

baz :: ReaderT String Maybe Int
baz = ReaderT $ \s -> if (s == "baz") then Just (Prelude.length s) else Nothing

buzz :: ReaderT String Maybe Int
buzz = do
  l <- baz
  return $ l + 2

main = scotty 3000 $
  get "/:word" $ do
    --beam <- param "word"
    foo <- liftIO $ return "foo baz"
    text foo
    --html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
