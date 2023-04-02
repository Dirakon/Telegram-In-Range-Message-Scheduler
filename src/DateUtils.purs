module DateUtils where

import Prelude

import Data.Date (Date)
import Data.DateTime.Instant (unInstant)
import Data.DateTime.Instant as Instant
import Data.Int (round)
import Data.Newtype (unwrap)

dayDifference :: Date -> Date -> Int
dayDifference startDate endDate = round $ (millisecondDifference startDate endDate) / millisecondsInDay

millisecondsInHour :: Number
millisecondsInHour = 60.0 * 60.0 * 1000.0

millisecondsInDay :: Number
millisecondsInDay =  millisecondsInHour * 24.0

millisecondsInWeek :: Number
millisecondsInWeek = millisecondsInDay * 7.0

weekDifference :: Date -> Date -> Int
weekDifference startDate endDate = round ((millisecondDifference startDate endDate) / millisecondsInWeek)

millisecondDifference :: Date -> Date -> Number
millisecondDifference startDate endDate = (endDateInMilliseconds - startDateInMilliseconds)
  where
  startDateInMilliseconds = unwrap (unInstant (Instant.fromDate startDate))

  endDateInMilliseconds = unwrap (unInstant (Instant.fromDate endDate))