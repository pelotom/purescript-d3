module Graphics.D3.Base
  ( D3()
  , D3Eff()
  , Primitive
  ) where

import Control.Monad.Eff

foreign import data D3 :: !

type D3Eff a = forall e. Eff (d3 :: D3 | e) a

class Primitive a

instance primString :: Primitive String
instance primNumber :: Primitive Number