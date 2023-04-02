module MaybeUtils where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)

maybeToEither :: forall a. forall b. b -> Maybe a -> Either b a
maybeToEither defaultLeft maybeValue = case maybeValue of
  Just value -> Right value
  Nothing -> Left defaultLeft

unsafeJust :: forall a. Maybe a -> a
unsafeJust =
  unsafePartial
    $ case _ of
        Just a -> a