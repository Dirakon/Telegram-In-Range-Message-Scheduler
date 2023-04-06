module Main
  ( chooseRandomDate
  ) where

import Prelude
import Data.DateTime.Instant (Instant, unInstant)
import Data.DateTime.Instant as Instant
import Data.Either (Either(..))
import Data.Int (toNumber)
import Data.Time.Duration (Milliseconds(..))
import DateUtils (dayDifference, weekDifference)
import DayCounting (countSuitableDays)
import DaySelection (takeSuitableDay)
import Effect (Effect)
import Effect.Random (randomInt)
import EffectUtils (assertAsRight, parseDateAndAssertValidity)
import MaybeUtils (maybeToEither)
import TimeSelection (chooseTimeOffset)
import Types (RangeSettings)

chooseRandomDate :: RangeSettings -> Effect Instant
chooseRandomDate settings = do
  startDateInclusive <- parseDateAndAssertValidity settings.startDayInclusiveUtc
  endDateInclusive <- parseDateAndAssertValidity settings.endDayInclusiveUtc
  availableDays <-
    assertAsRight
      $ case countSuitableDays startDateInclusive (dayDifference startDateInclusive endDateInclusive) settings.availableDays of
          0 -> Left "No suitable days found"
          n -> Right n
  chosenAvailableDay <- randomInt 0 (availableDays - 1)
  chosenDay <- assertAsRight $ takeSuitableDay startDateInclusive settings.availableDays chosenAvailableDay
  chosenHourInstantOffset <- chooseTimeOffset settings.startHourInclusiveUtc settings.endHourInclusiveUtc
  instant <-
    assertAsRight
      $ maybeToEither
          "Generated milliseconds are out of bound for UNIX instant"
          (Instant.instant (unInstant (Instant.fromDate chosenDay) <> chosenHourInstantOffset))
  pure instant
