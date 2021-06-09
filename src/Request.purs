module Graphics.D3.Request
  ( RequestError ()
  , csv
  , tsv
  , json
  ) where

import Data.Either (Either(..))
import Effect (Effect)
import Foreign (Foreign)

import Graphics.D3.Base (D3Eff, D3)
import Graphics.D3.Util (ffiD3)

import Prelude ( Unit() )

type RequestError = { status :: Number, statusText :: String }

csv :: forall a. String -> (Either RequestError (Array Foreign) -> Effect a) -> D3Eff Unit
csv = ff (\d -> d) Left Right
  where
  ff = ffiD3
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.csv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

tsv :: forall a. String -> (Either RequestError (Array Foreign) -> Effect a) -> D3Eff Unit
tsv = ff (\d -> d) Left Right
  where
  ff = ffiD3
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.tsv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

json :: forall a. String -> (Either RequestError Foreign -> Effect a) -> D3Eff Unit
json = ff Left Right
  where
  ff = ffiD3
    ["Left", "Right", "url", "handle", ""]
    "d3.json(url, function (error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"
