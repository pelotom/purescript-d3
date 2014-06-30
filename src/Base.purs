module Graphics.D3.Base
  ( DOM()
  , Effect()
  , Change()
  , void
  ) where

import Control.Monad.Eff

-- The type of effects having to do with observing and modifying the DOM
foreign import data DOM :: !

-- An action which may observe or modify the DOM
type Effect a = forall e. Eff (dom :: DOM | e) a

-- A state transition which may have an effect
type Change a = a -> Effect a

-- Remove this once it's available in Prelude
void :: forall f a. (Functor f) => f a -> f Unit
void fa = const unit <$> fa
