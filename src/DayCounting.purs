module DayCounting where

import Prelude


import Data.Date (Date)
import Data.DateTime (weekday)
import Data.Enum (fromEnum)
import Data.List.Lazy as List
import Types (AvailableDays, toArrayWithMondayStart)


countSuitableDays :: Date -> Int -> AvailableDays -> Int
countSuitableDays startDate totalDays availableDays =
  if availableDaysInWeek == 0 then
    0
  else
    firstWeekAvailableDaysCount + middleAvailableDaysCount + lastWeekAvailableDaysCount
  where
  listOfAvailableDays = List.fromFoldable (toArrayWithMondayStart availableDays)

  weekDaysToSkip = fromEnum (weekday startDate) - 1

  firstWeekDays = (List.drop weekDaysToSkip (List.take (min 7 totalDays) listOfAvailableDays))

  firstWeekDaysCount = List.length firstWeekDays

  firstWeekAvailableDaysCount =
    List.length
      $ List.filter
          (\isDayAvailable -> isDayAvailable == true)
          firstWeekDays

  lastWeekDays =
    if totalDays == firstWeekDaysCount then
      List.nil
    else
      List.take (mod (totalDays - firstWeekDaysCount) 7) listOfAvailableDays

  lastWeekDaysCount = List.length lastWeekDays

  lastWeekAvailableDaysCount =
    List.length
      $ List.filter
          (\isDayAvailable -> isDayAvailable == true)
          lastWeekDays

  availableDaysInWeek =
    List.length
      $ List.filter
          (\isDayAvailable -> isDayAvailable == true)
          listOfAvailableDays

  wholeWeeksInMiddle = (totalDays - firstWeekDaysCount - lastWeekDaysCount) / 7

  middleAvailableDaysCount = availableDaysInWeek * wholeWeeksInMiddle