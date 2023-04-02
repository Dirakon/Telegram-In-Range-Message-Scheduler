module Main
  ( AvailableDays(..)
  , RangeSettings(..)
  , chooseRandomDate
  , countSuitableDays
  , takeSuitableDay
  , unsafeJust
  )
  where

import Data.Maybe
import Prelude

import Data.Argonaut (toString)
import Data.Date (Date, weekday)
import Data.Date as Date
import Data.DateTime (DateTime(..), Day, Millisecond, date, weekday)
import Data.DateTime as DateTime
import Data.DateTime.Instant (Instant, instant, unInstant)
import Data.DateTime.Instant as Instant
import Data.Either (Either(..))
import Data.Enum (fromEnum, toEnum)
import Data.Int (ceil, round, toNumber)
import Data.Interval (millisecond)
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Data.List.Lazy (List)
import Data.List.Lazy as List
import Data.Newtype (unwrap)
import Data.Time.Duration (class Duration, Milliseconds(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Console (debugShow)
import Effect.Exception (throw)
import Effect.Random (randomInt)
import Effect.Unsafe (unsafePerformEffect)
import Partial.Unsafe (unsafePartial)

type RangeSettings
  = 
  { 
    startDayInclusive:: String,
    endDayInclusive:: String, 
    startHourInclusive:: Int,
    endHourInclusive:: Int,
    availableDays:: AvailableDays
}
type AvailableDays = { sunday::Boolean, monday::Boolean, tuesday::Boolean, wednesday::Boolean, thursday::Boolean, friday::Boolean, saturday::Boolean}
toArrayWithMondayStart :: AvailableDays -> Array Boolean
toArrayWithMondayStart {monday, tuesday, wednesday, thursday, friday, saturday, sunday} = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]

chooseRandomDate :: RangeSettings -> Effect Instant
chooseRandomDate settings = do
  startDateInclusive <- parseDateAndAssertValidity settings.startDayInclusive
  endDateInclusive <- parseDateAndAssertValidity settings.endDayInclusive
  chosenWeekOffset <- randomInt 0 (weekDifference endDateInclusive endDateInclusive)
  instant <- assertAsRight $
    maybeToEither 
      "Generated milliseconds are out of bound for UNIX instant" 
      (Instant.instant (Milliseconds (toNumber settings.startHourInclusive)))
    
  pure instant


weekDifference :: Date -> Date -> Int
weekDifference startDate endDate = round ((millisecondDifference startDate endDate) / millisecondsInWeek)

millisecondDifference :: Date -> Date -> Number
millisecondDifference  startDate endDate =  (endDateInMilliseconds - startDateInMilliseconds)
  where
    startDateInMilliseconds =unwrap  (unInstant (Instant.fromDate startDate))
    endDateInMilliseconds =unwrap  (unInstant (Instant.fromDate endDate)) 

countSuitableDays :: Date -> Int -> AvailableDays -> Int
countSuitableDays startDate totalDays availableDays = 
  if availableDaysInWeek == 0 then 
    0 
  else
    firstWeekAvailableDaysCount + middleAvailableDaysCount + lastWeekAvailableDaysCount
  where
    listOfAvailableDays = List.fromFoldable (toArrayWithMondayStart availableDays)
    weekDaysToSkip = fromEnum ( weekday startDate) - 1

    firstWeekDays = (List.drop weekDaysToSkip (List.take (min 7 totalDays) listOfAvailableDays))
    firstWeekDaysCount = List.length firstWeekDays
    firstWeekAvailableDaysCount = List.length $
      List.filter 
        (\isDayAvailable -> isDayAvailable == true) 
        firstWeekDays

    lastWeekDays = 
      if totalDays == firstWeekDaysCount then List.nil
      else List.take (mod (totalDays - firstWeekDaysCount)  7) listOfAvailableDays
    lastWeekDaysCount = List.length lastWeekDays
    lastWeekAvailableDaysCount = List.length $
      List.filter 
        (\isDayAvailable -> isDayAvailable == true) 
        lastWeekDays

    availableDaysInWeek = List.length $
      List.filter 
        (\isDayAvailable -> isDayAvailable == true) 
        listOfAvailableDays
    wholeWeeksInMiddle =  (totalDays - firstWeekDaysCount - lastWeekDaysCount) / 7
    middleAvailableDaysCount = availableDaysInWeek * wholeWeeksInMiddle


takeSuitableDay :: Date-> AvailableDays -> Int -> Either String Date
takeSuitableDay startDate availableDays chosenAvailableDay = 
  if List.length listOfAvailableDays == 0 then 
    Left "No available days given, cannot take a suitable day"
  else 
    maybeToEither "Generated milliseconds for chosen day are out of bound for UNIX instant" $ maybeChosenDay
  where 
    startDayInMilliseconds =  unInstant (Instant.fromDate startDate)

    listOfAvailableDays = List.mapMaybe (\(Tuple isAvailable dayOffset) -> if isAvailable then Just dayOffset else Nothing) 
      dayAvailabilityZippedWithIndex
    dayAvailabilityZippedWithIndex = List.zipWith 
        (\isAvailable dayOffset -> Tuple isAvailable dayOffset)
        ( List.fromFoldable (toArrayWithMondayStart availableDays)) 
        (List.range 0 999)
    weekDaysToSkip = fromEnum ( weekday startDate) - 1

    firstAvailableWeekDays = (List.dropWhile (\dayOffset -> dayOffset < weekDaysToSkip)  listOfAvailableDays)
    availableWeekDaysToSkip = List.length listOfAvailableDays - List.length firstAvailableWeekDays

    -- TODO: fix this
    weekOffset = max 
      0 
      $ ceil
        ((toNumber $ (chosenAvailableDay - List.length firstAvailableWeekDays)) / (toNumber $ List.length listOfAvailableDays))
        
    chosenDayOffset :: Int
    chosenDayOffset = - weekDaysToSkip + weekOffset*7 +  
      (unsafeJust $ List.index listOfAvailableDays (mod (chosenAvailableDay + availableWeekDaysToSkip) (List.length listOfAvailableDays)))
    
    maybeChosenDay :: Maybe Date
    maybeChosenDay = do
      chosenInstant <- instant (startDayInMilliseconds <> Milliseconds (millisecondsInDay * toNumber chosenDayOffset))
      let chosenDate = date $ Instant.toDateTime chosenInstant 
      pure chosenDate
    
   -- s = unsafePerformEffect $ debugShow (show chosenDayOffset <> "-" <> show startDate <> "-" <> show maybeChosenDay <> show ( ))

dayDifference :: Date -> Date -> Int
dayDifference startDate endDate = round $ (millisecondDifference startDate endDate) / millisecondsInDay

millisecondsInDay::Number 
millisecondsInDay = 24.0*60.0*60.0*1000.0
millisecondsInWeek::Number 
millisecondsInWeek = millisecondsInDay*7.0

-- rawDateToDay :: String -> Effect Day
-- rawDateToDay rawDate = do
--   errorOrParsedDate <- parseDate rawDate
--   parsedDate <- assertAsRight errorOrParsedDate
--   pure $ (date>>>day) parsedDate

assertAsRight ::forall a.  Either String a -> Effect a
assertAsRight eitherValue = case  eitherValue of
    Left error -> throw error
    Right value -> pure value

parseDateAndAssertValidity:: String -> Effect Date
parseDateAndAssertValidity rawDate = do
  parsedDateOrError <- parseDate rawDate
  assertAsRight parsedDateOrError

parseDate:: String -> Effect ( Either String Date)
parseDate rawDate = do
  jsDate <- JSDate.parse rawDate
  pure $ (JSDate.toDate >>> maybeToEither ("Unable to parse date: " <> rawDate)) jsDate

maybeToEither:: forall a. forall b. b -> Maybe a -> Either b a
maybeToEither defaultLeft maybeValue = case maybeValue of
  Just value -> Right value
  Nothing -> Left defaultLeft





unsafeJust :: forall a. Maybe a -> a
unsafeJust =
  unsafePartial
    $ case _ of
        Just a -> a