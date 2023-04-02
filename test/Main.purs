module Test.Main where

import Prelude

import Control.Monad.Free (Free)
import Data.Date (Date, Day, Month(..), Year, canonicalDate, exactDate)
import Data.Enum (toEnum)
import Data.JSDate (parse, toDate)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import Main (AvailableDays, countSuitableDays, unsafeJust)
import Partial.Unsafe (unsafePartial)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Test.DayCounting (dayCountingTests)
import Test.DaySelection (daySelectionTests)

main :: Effect Unit
main = do
  runTest do
    tests


tests :: Free TestF Unit
tests = suite "test" do
  dayCountingTests
  daySelectionTests