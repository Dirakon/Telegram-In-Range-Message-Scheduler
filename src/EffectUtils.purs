module EffectUtils where

import Prelude

import Data.Date (Date)
import Data.Either (Either(..))
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Exception (throw)
import MaybeUtils (maybeToEither)

assertAsRight :: forall a. Either String a -> Effect a
assertAsRight eitherValue = case eitherValue of
  Left error -> throw error
  Right value -> pure value

parseDateAndAssertValidity :: String -> Effect Date
parseDateAndAssertValidity rawDate = do
  parsedDateOrError <- parseDate rawDate
  assertAsRight parsedDateOrError

parseDate :: String -> Effect (Either String Date)
parseDate rawDate = do
  jsDate <- JSDate.parse rawDate
  pure $ (JSDate.toDate >>> maybeToEither ("Unable to parse date: " <> rawDate)) jsDate