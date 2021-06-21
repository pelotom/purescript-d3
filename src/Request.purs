module Graphics.D3.Request
  ( RequestError ()
  , csv
  , tsv
  , json
  , xml
  ) where

import Control.Promise
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn2, runEffectFn2, EffectFn3, runEffectFn3)
import Foreign (Foreign)
import Web.DOM.Document (Document)

import Graphics.D3.Base (D3, d3)

import Prelude (($))

type RequestError = { status :: Number, statusText :: String }

foreign import csvImpl :: forall newRow. EffectFn3
                                    D3
                                    String
                                    (Foreign -> newRow)
                                    (Promise (Array newRow))

csv :: forall newRow. String -> (Foreign -> newRow) -> Aff (Array newRow)
csv url handle = toAffE $ runEffectFn3 csvImpl d3 url handle

foreign import tsvImpl :: forall newRow. EffectFn3
                                    D3
                                    String
                                    (Foreign -> newRow)
                                    (Promise (Array newRow))

tsv :: forall newRow. String -> (Foreign -> newRow) -> Aff (Array newRow)
tsv url handle = toAffE $ runEffectFn3 tsvImpl d3 url handle

foreign import jsonImpl :: forall a. EffectFn2
                                 D3
                                 String
                                 (Promise a)

json :: forall a. String -> Aff a
json url = toAffE $ runEffectFn2 jsonImpl d3 url

-- foreign import xmlImpl :: forall a. EffectFn2
--                                 D3
--                                 String
--                                 (Promise a)
foreign import xmlImpl :: EffectFn2
                           D3
                           String
                           (Promise Document)

-- xml :: forall a. String -> Aff a
xml :: String -> Aff Document
xml url = toAffE $ runEffectFn2 xmlImpl d3 url
