module Graphics.D3.Base
  ( D3()
  , D3Eff()
  , d3
  ) where

-- import Control.Monad.Eff
import Effect (Effect)

foreign import data D3 :: Type

foreign import d3 :: D3

-- type D3Eff a = forall e. Eff (d3 :: D3 | e) a

-- | The D3 effect monad
type D3Eff a = Effect a

-- runD3Eff :: forall a. D3Eff a -> Effect a
-- runD3Eff (D3Eff a) = a

-- instance functorD3Eff :: Functor D3Eff where
--   map f (D3Eff a) = D3Eff (map f a)

-- instance applyD3Eff :: Apply D3Eff where
--   apply (D3Eff f) (D3Eff a) = D3Eff (apply f a)

-- instance applicativeD3Eff :: Applicative D3Eff where
--   pure = D3Eff <<< pure

-- instance bindD3Eff :: Bind D3Eff where
--   bind (D3Eff a) f = D3Eff (a >>= (runD3Eff <<< f))

-- instance monadD3Eff :: Monad D3Eff

-- unsafeD3EffEffect :: forall a. Effect a -> D3Eff a
-- unsafeD3EffEffect = D3Eff
