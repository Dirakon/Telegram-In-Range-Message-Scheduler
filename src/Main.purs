module Main
  (
   chooseRandomDate
  ) where

import Prelude

import Data.DateTime.Instant (Instant, unInstant)
import Data.DateTime.Instant as Instant
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
  startDateInclusive <- parseDateAndAssertValidity settings.startDayInclusive
  endDateInclusive <- parseDateAndAssertValidity settings.endDayInclusive
  let availableDays = countSuitableDays startDateInclusive (dayDifference startDateInclusive endDateInclusive) settings.availableDays
  chosenAvailableDay <- randomInt 0 availableDays
  chosenDay <- assertAsRight $ takeSuitableDay startDateInclusive settings.availableDays chosenAvailableDay
  chosenHourInstantOffset <- chooseTimeOffset settings.startHourInclusive settings.endHourInclusive

  instant <-
    assertAsRight
      $ maybeToEither
          "Generated milliseconds are out of bound for UNIX instant"
          (Instant.instant (unInstant (Instant.fromDate chosenDay) <> chosenHourInstantOffset))
  pure instant


