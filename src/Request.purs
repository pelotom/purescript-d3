module Graphics.D3.Request
  ( RequestError ()
  , tsv
  , json
  ) where

import Data.Either
import Data.Foreign
import Data.Foreign.EasyFFI
import Control.Monad.Eff

import Graphics.D3.Base

type RequestError = { status :: Number, statusText :: String }

tsv :: forall a. String -> (Either RequestError [Foreign] -> D3Eff a) -> D3Eff Unit
tsv = ff (\d -> d) Left Right
  where
  ff = unsafeForeignFunction
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.tsv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

json :: forall a. String -> (Either RequestError Foreign -> D3Eff a) -> D3Eff Unit
json = ff Left Right
  where
  ff = unsafeForeignFunction
    ["Left", "Right", "url", "handle", ""]
    "d3.json(url, function (error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"
