module DaySelection where

import Data.Maybe (Maybe(..))
import Prelude

import Data.Date (Date)
import Data.DateTime (date, weekday)
import Data.DateTime.Instant (instant, unInstant)
import Data.DateTime.Instant as Instant
import Data.Either (Either(..))
import Data.Enum (fromEnum)
import Data.Int (ceil, toNumber)
import Data.List.Lazy (List)
import Data.List.Lazy as List
import Data.Time.Duration (Milliseconds(..))
import Data.Tuple (Tuple(..))
import Types (AvailableDays, toArrayWithMondayStart)
import DateUtils (millisecondsInDay)
import MaybeUtils (maybeToEither, unsafeJust)

takeSuitableDay :: Date -> AvailableDays -> Int -> Either String Date
takeSuitableDay startDate availableDays chosenAvailableDay =
  if List.length listOfAvailableDays == 0 then
    Left "No available days given, cannot take a suitable day"
  else
    maybeToEither "Generated milliseconds for chosen day are out of bound for UNIX instant" $ (maybeChosenDay listOfAvailableDays)
  where
  startDayInMilliseconds = unInstant (Instant.fromDate startDate)

  listOfAvailableDays =
    List.mapMaybe (\(Tuple isAvailable dayOffset) -> if isAvailable then Just dayOffset else Nothing)
      dayAvailabilityZippedWithIndex

  dayAvailabilityZippedWithIndex =
    List.zipWith
      (\isAvailable dayOffset -> Tuple isAvailable dayOffset)
      (List.fromFoldable (toArrayWithMondayStart availableDays))
      (List.range 0 999)

  weekDaysToSkip = fromEnum (weekday startDate) - 1

  firstAvailableWeekDays = (List.dropWhile (\dayOffset -> dayOffset < weekDaysToSkip) listOfAvailableDays)

  availableWeekDaysToSkip = List.length listOfAvailableDays - List.length firstAvailableWeekDays

  weekOffset =
    max
      0
      $ ceil
          ((toNumber $ (chosenAvailableDay - List.length firstAvailableWeekDays + 1)) / (toNumber $ List.length listOfAvailableDays))

  chosenInWeekDayOffset nonEmptyListOfAvailableDays =
    unsafeJust
      $ List.index nonEmptyListOfAvailableDays (mod (chosenAvailableDay + availableWeekDaysToSkip) (List.length nonEmptyListOfAvailableDays))

  chosenDayOffset :: List Int -> Int
  chosenDayOffset nonEmptyListOfAvailableDays =
    -weekDaysToSkip + weekOffset * 7
      + (chosenInWeekDayOffset nonEmptyListOfAvailableDays)

  maybeChosenDay :: List Int -> Maybe Date
  maybeChosenDay nonEmptyListOfAvailableDays = do
    chosenInstant <-
      instant
        $ startDayInMilliseconds
        <> Milliseconds (millisecondsInDay * toNumber (chosenDayOffset nonEmptyListOfAvailableDays))
    let
      chosenDate = date $ Instant.toDateTime chosenInstant
    pure chosenDate