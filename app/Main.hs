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
  ll <- ask
  liftIO $ putStrLn "Computing..."
  return (ll ++ " got fooed")

--bar :: ReaderT String IO Int
bar :: App Int
--bar = reader Prelude.length
bar = do
  ll <- ask
  liftIO $ putStrLn "Computing again..."
  return $ Prelude.length ll

foobar :: App String
foobar = do
  f <- foo
  b <- bar
  return (f ++ show b)

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
