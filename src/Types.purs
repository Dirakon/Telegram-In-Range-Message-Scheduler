module Types where

import Prelude

type RangeSettings
  = { startDayInclusiveUtc :: String
    , endDayInclusiveUtc :: String
    , startHourInclusiveUtc :: Int
    , endHourInclusiveUtc :: Int
    , availableDays :: AvailableDays
    }

type AvailableDays
  = { sunday :: Boolean, monday :: Boolean, tuesday :: Boolean, wednesday :: Boolean, thursday :: Boolean, friday :: Boolean, saturday :: Boolean }

toArrayWithMondayStart :: AvailableDays -> Array Boolean
toArrayWithMondayStart { monday, tuesday, wednesday, thursday, friday, saturday, sunday } = [ monday, tuesday, wednesday, thursday, friday, saturday, sunday ]