module Graphics.D3.Layout.Base
  ( GraphLayout
  , size
  , nodes
  , links
  ) where

import Graphics.D3.Base

class GraphLayout l where
  nodes :: forall a. [a] -> l -> D3Eff l
  links :: forall a. [a] -> l -> D3Eff l
  size :: forall d. { width :: Number, height :: Number | d } -> l -> D3Eff l

class (GraphLayout l) <= HierarchyLayout l where
  -- TODO: children, sort, value, revalue