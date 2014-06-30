module Graphics.D3.Base
  ( DOM()
  , D3Eff()
  , (|.)
  , void
  ) where

import Control.Monad.Eff

-- The type of effects having to do with observing and modifying the DOM
foreign import data DOM :: !

type D3Eff e a = Eff (dom :: DOM | e) a

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
(|.) = (>>=)

-- Remove this once it's available in Prelude
void :: forall f a. (Functor f) => f a -> f Unit
void fa = const unit <$> fa
