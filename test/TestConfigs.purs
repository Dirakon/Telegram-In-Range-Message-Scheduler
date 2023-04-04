module Test.TestConfigs where

import Prelude

import Control.Monad.Free (Free)
import Data.Date (Date, Day, Month(..), Year, canonicalDate, exactDate)
import Data.Enum (toEnum)
import Data.JSDate (parse, toDate)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import MaybeUtils (unsafeJust)
import Partial.Unsafe (unsafePartial)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Types (AvailableDays)

allDaysAvailable:: AvailableDays
allDaysAvailable = { "sunday":true, "monday":true, "tuesday":true, "wednesday":true, "thursday":true, "friday":true, "saturday":true}
everySecondDayAvailable:: AvailableDays
everySecondDayAvailable = { "monday":false, "tuesday":true, "wednesday":false, "thursday":true, "friday":false, "saturday":true, "sunday":false }

noDaysAvailable:: AvailableDays
noDaysAvailable = { "monday":false, "tuesday":false, "wednesday":false, "thursday":false, "friday":false, "saturday":false, "sunday":false }

mondayStart :: Date
mondayStart = unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  3)

wednesdayStart :: Date
wednesdayStart = unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  5)

