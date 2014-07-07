module Graphics.D3.Base
  ( D3()
  , D3Eff()
  ) where

import Control.Monad.Eff

foreign import data D3 :: !

type D3Eff a = forall e. Eff (d3 :: D3 | e) a