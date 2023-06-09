module Test.DaySelection
  ( daySelectionTests
  )
  where

import Prelude

import Control.Monad.Free (Free)
import Data.Date (Date, Day, Month(..), Year, canonicalDate, exactDate)
import Data.Either (Either(..), isLeft)
import Data.Enum (toEnum)
import Data.JSDate (parse, toDate)
import Data.Maybe (Maybe(..))
import DaySelection (takeSuitableDay)
import Effect (Effect)
import Effect.Class.Console (log)
import MaybeUtils (unsafeJust)
import Partial.Unsafe (unsafePartial)
import Test.TestConfigs (allDaysAvailable, everySecondDayAvailable, mondayStart, noDaysAvailable, wednesdayStart)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

daySelectionTests :: Free TestF Unit
daySelectionTests = 
  suite "day selection" do
    suite "all days are available" do
      suite "monday start" do
        firstDayMondayStartAllAvailable
        secondDayMondayStartAllAvailable
        eleventhDayMondayStartAllAvailable
        twentyFirstDayMondayStartAllAvailable
      suite "wednesday start" do
        firstDayWednesdayStartAllAvailable
        secondDayWednesdayStartAllAvailable
        eleventhDayWednesdayStartAllAvailable
        twentyFirstDayWednesdayStartAllAvailable
    suite "some days are available" do
      suite "monday start" do
        firstDayMondayStartSomeAvailable
        secondDayMondayStartSomeAvailable
        eleventhDayMondayStartSomeAvailable
        twentyFirstDayMondayStartSomeAvailable
      suite "wednesday start" do
        firstDayWednesdayStartSomeAvailable
        secondDayWednesdayStartSomeAvailable
        eleventhDayWednesdayStartSomeAvailable
        twentyFirstDayWednesdayStartSomeAvailable
    suite "no days available" do
      firstDayNoDaysAvailable
      secondDayNoDaysAvailable

firstDayMondayStartAllAvailable :: Free TestF Unit
firstDayMondayStartAllAvailable =
    test "Selects first day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  3))
        $ takeSuitableDay mondayStart allDaysAvailable  0 

secondDayMondayStartAllAvailable :: Free TestF Unit
secondDayMondayStartAllAvailable =
    test "Selects second day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  4))
        $ takeSuitableDay mondayStart allDaysAvailable  1 
eleventhDayMondayStartAllAvailable :: Free TestF Unit
eleventhDayMondayStartAllAvailable =
    test "Selects eleventh day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (3 + 10)))
        $ takeSuitableDay mondayStart allDaysAvailable  10
twentyFirstDayMondayStartAllAvailable :: Free TestF Unit
twentyFirstDayMondayStartAllAvailable =
    test "Selects twenty first day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (3 + 20)))
        $ takeSuitableDay mondayStart allDaysAvailable  20

firstDayWednesdayStartAllAvailable :: Free TestF Unit
firstDayWednesdayStartAllAvailable =
    test "Selects first day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  5))
        $ takeSuitableDay wednesdayStart allDaysAvailable  0 

secondDayWednesdayStartAllAvailable :: Free TestF Unit
secondDayWednesdayStartAllAvailable =
    test "Selects second day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  6))
        $ takeSuitableDay wednesdayStart allDaysAvailable  1 
eleventhDayWednesdayStartAllAvailable :: Free TestF Unit
eleventhDayWednesdayStartAllAvailable =
    test "Selects eleventh day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (5 + 10)))
        $ takeSuitableDay wednesdayStart allDaysAvailable  10
twentyFirstDayWednesdayStartAllAvailable :: Free TestF Unit
twentyFirstDayWednesdayStartAllAvailable =
    test "Selects twenty first day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (5 + 20)))
        $ takeSuitableDay wednesdayStart allDaysAvailable  20




firstDayMondayStartSomeAvailable :: Free TestF Unit
firstDayMondayStartSomeAvailable =
    test "Selects first day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  4))
        $ takeSuitableDay mondayStart everySecondDayAvailable  0 

secondDayMondayStartSomeAvailable :: Free TestF Unit
secondDayMondayStartSomeAvailable =
    test "Selects second day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  6))
        $ takeSuitableDay mondayStart everySecondDayAvailable  1 
eleventhDayMondayStartSomeAvailable :: Free TestF Unit
eleventhDayMondayStartSomeAvailable =
    test "Selects eleventh day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (27)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  10
twentyFirstDayMondayStartSomeAvailable :: Free TestF Unit
twentyFirstDayMondayStartSomeAvailable = suite "" do
    test "Selects twenty first day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  ( 20)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  20
    test "Selects twenty second day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  ( 23)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  21
    test "Selects twenty third day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  ( 25)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  22
    test "Selects twenty fourth day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  ( 27)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  23
    test "Selects twenty fifth day from monday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  ( 30)))
        $ takeSuitableDay mondayStart everySecondDayAvailable  24

firstDayWednesdayStartSomeAvailable :: Free TestF Unit
firstDayWednesdayStartSomeAvailable =
    test "Selects first day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  6))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  0 

secondDayWednesdayStartSomeAvailable :: Free TestF Unit
secondDayWednesdayStartSomeAvailable =
    test "Selects second day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  8))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  1 
eleventhDayWednesdayStartSomeAvailable :: Free TestF Unit
eleventhDayWednesdayStartSomeAvailable =
    test "Selects eleventh day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (April) (unsafeJust $ toEnum  (29)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  10
twentyFirstDayWednesdayStartSomeAvailable :: Free TestF Unit
twentyFirstDayWednesdayStartSomeAvailable = suite "" do
    test "Selects twenty first day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  (23)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  20
    test "Selects twenty second day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  (25)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  21

    test "Selects twenty third day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  (27)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  22

    test "Selects twenty fourth day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (May) (unsafeJust $ toEnum  (30)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  23

    test "Selects twenty fifth day from wednesday start" do
      Assert.equal (Right $ unsafeJust $ exactDate (unsafeJust $ toEnum 2023) (June) (unsafeJust $ toEnum  (1)))
        $ takeSuitableDay wednesdayStart everySecondDayAvailable  24


firstDayNoDaysAvailable :: Free TestF Unit
firstDayNoDaysAvailable =
    test "Selects first day from wednesday start" do
      Assert.assert ""  $isLeft
        $ takeSuitableDay wednesdayStart noDaysAvailable  0
secondDayNoDaysAvailable :: Free TestF Unit
secondDayNoDaysAvailable =
    test "Selects second day from wednesday start" do
      Assert.assert "" $ isLeft
        $ takeSuitableDay wednesdayStart noDaysAvailable  1