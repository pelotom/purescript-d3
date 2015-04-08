module Graphics.D3.Request
  ( RequestError ()
  , csv
  , tsv
  , json
  ) where

import Data.Either
import Data.Foreign
import Data.Foreign.EasyFFI
import Control.Monad.Eff

import Graphics.D3.Base

type RequestError = { status :: Number, statusText :: String }

csv :: forall e a. String -> (Either RequestError [Foreign] -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
csv = ff (\d -> d) Left Right
  where
  ff = unsafeForeignFunction
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.csv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

tsv :: forall e a. String -> (Either RequestError [Foreign] -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
tsv = ff (\d -> d) Left Right
  where
  ff = unsafeForeignFunction
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.tsv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

json :: forall e a. String -> (Either RequestError Foreign -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
json = ff Left Right
  where
  ff = unsafeForeignFunction
    ["Left", "Right", "url", "handle", ""]
    "d3.json(url, function (error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"
