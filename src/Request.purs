module Graphics.D3.Request
  ( RequestError ()
  , tsv
  ) where

import Data.Either
import Data.Foreign
import Data.Foreign.EasyFFI
import Control.Monad.Eff

import Graphics.D3.Base

type RequestError = { status :: Number, statusText :: String }

tsv :: forall e a. String -> (Either RequestError [Foreign] -> Eff e a) -> Eff (d3 :: D3 | e) Unit
tsv = ff (\d -> d) Left Right
  where
  ff = unsafeForeignFunction
    ["acc", "Left", "Right", "url", "handle", ""]
    "d3.tsv(url, acc, function(error, data) { if (error) handle(Left(error))(); else handle(Right(data))(); })"

