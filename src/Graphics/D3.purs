module Graphics.D3
  ( select
  , selectAll
  , enter
  , append
  , bind
  , attr
  ) where

import Graphics.D3.Base
import Graphics.D3.Raw

import Control.Monad.Eff

foreign import getSel
  "function getSel() { return window.__current_d3_sel || d3.select('body'); }"
  :: forall e. Eff (dom :: DOM | e) Selection

foreign import setSel
  "function setSel(sel) { return function () { window.__current_d3_sel = sel; } }"
  :: forall e. Selection -> Eff (dom :: DOM | e) Unit

withSel :: forall e a.
  (Selection -> D3Eff e Selection) ->
  D3Eff e a ->
  D3Eff e a
withSel mkSel action = do
  oldSel <- getSel
  newSel <- mkSel oldSel
  setSel newSel
  result <- action
  setSel oldSel
  return result

select :: forall e a. String -> D3Eff e a -> D3Eff e a
select = withSel <<< d3SelectFrom

selectAll :: forall e a. String -> D3Eff e a -> D3Eff e a
selectAll = withSel <<< d3SelectAllFrom

enter :: forall e a. D3Eff e a -> D3Eff e a
enter = withSel d3Enter

append :: forall e a. String -> D3Eff e a -> D3Eff e a
append = withSel <<< d3AppendTo

bind :: forall d e a. [d] -> D3Eff e a -> D3Eff e a
bind array = withSel (d3SetData array)

attr :: forall e a. String -> a -> D3Eff e Unit
attr key val = getSel >>= d3SetAttr key val >>> void
