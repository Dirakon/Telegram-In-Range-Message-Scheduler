module Test.DayCounting where

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
import Test.TestConfigs (allDaysAvailable, everySecondDayAvailable, mondayStart, noDaysAvailable, wednesdayStart)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

dayCountingTests :: Free TestF Unit
dayCountingTests = 
  suite "day counting" do
    suite "all days are available" do
      suite "monday start" do
        nonFullFirstWeekAtMondayStart
        fullFirstWeekAtMondayStart
      suite "non-monday start" do
        nonFullFirstWeekAtNonMondayStart
        fullFirstWeekAtNonMondayStart
    suite "some days are unavailable" do
      suite "monday start" do
        nonFullFirstWeekAtMondayStartNotAllDaysAvailable
        fullFirstWeekAtMondayStartNotAllDaysAvailable
      suite "non-monday start" do
        nonFullFirstWeekAtNonMondayStartNotAllDaysAvailable
        fullFirstWeekAtNonMondayStartNotAllDaysAvailable
    suite "all days are unavailable" do
      suite "monday start" do
        nonFullFirstWeekAtMondayStartNoDaysAvailable
        fullFirstWeekAtMondayStartNoDaysAvailable
      suite "non-monday start" do
        nonFullFirstWeekAtNonMondayStartNoDaysAvailable
        fullFirstWeekAtNonMondayStartNoDaysAvailable

nonFullFirstWeekAtMondayStart :: Free TestF Unit
nonFullFirstWeekAtMondayStart =
    test "Counts non-full first week at monday start" do
      Assert.equal 6
        $ countSuitableDays mondayStart 6 allDaysAvailable

fullFirstWeekAtMondayStart :: Free TestF Unit
fullFirstWeekAtMondayStart =
    test "Counts full first week at monday start" do
      Assert.equal 7
        $ countSuitableDays mondayStart 7 allDaysAvailable

nonFullFirstWeekAtNonMondayStart :: Free TestF Unit
nonFullFirstWeekAtNonMondayStart =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 6
        $ countSuitableDays wednesdayStart 6 allDaysAvailable

fullFirstWeekAtNonMondayStart :: Free TestF Unit
fullFirstWeekAtNonMondayStart =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 7
        $ countSuitableDays wednesdayStart 7 allDaysAvailable

nonFullFirstWeekAtMondayStartNotAllDaysAvailable :: Free TestF Unit
nonFullFirstWeekAtMondayStartNotAllDaysAvailable =
    test "Counts non-full first week at monday start" do
      Assert.equal 3
        $ countSuitableDays mondayStart 6 everySecondDayAvailable

fullFirstWeekAtMondayStartNotAllDaysAvailable :: Free TestF Unit
fullFirstWeekAtMondayStartNotAllDaysAvailable =
    test "Counts full first week at monday start" do
      Assert.equal 3
        $ countSuitableDays mondayStart 7 everySecondDayAvailable

nonFullFirstWeekAtNonMondayStartNotAllDaysAvailable :: Free TestF Unit
nonFullFirstWeekAtNonMondayStartNotAllDaysAvailable =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 3
        $ countSuitableDays wednesdayStart 6 everySecondDayAvailable

fullFirstWeekAtNonMondayStartNotAllDaysAvailable :: Free TestF Unit
fullFirstWeekAtNonMondayStartNotAllDaysAvailable =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 3
        $ countSuitableDays wednesdayStart 7 everySecondDayAvailable


nonFullFirstWeekAtMondayStartNoDaysAvailable :: Free TestF Unit
nonFullFirstWeekAtMondayStartNoDaysAvailable =
    test "Counts non-full first week at monday start" do
      Assert.equal 0
        $ countSuitableDays mondayStart 6 noDaysAvailable

fullFirstWeekAtMondayStartNoDaysAvailable :: Free TestF Unit
fullFirstWeekAtMondayStartNoDaysAvailable =
    test "Counts full first week at monday start" do
      Assert.equal 0
        $ countSuitableDays mondayStart 7 noDaysAvailable

nonFullFirstWeekAtNonMondayStartNoDaysAvailable :: Free TestF Unit
nonFullFirstWeekAtNonMondayStartNoDaysAvailable =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 0
        $ countSuitableDays wednesdayStart 6 noDaysAvailable

fullFirstWeekAtNonMondayStartNoDaysAvailable :: Free TestF Unit
fullFirstWeekAtNonMondayStartNoDaysAvailable =
    test "Counts non-full first week at non-monday start" do
      Assert.equal 0
        $ countSuitableDays wednesdayStart 7 noDaysAvailable
