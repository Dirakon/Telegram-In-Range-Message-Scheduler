module TimeSelection where

import Prelude

import Data.DateTime.Instant (Instant)
import Data.Int (toNumber)
import Data.Number (round)
import Data.Time.Duration (Milliseconds(..))
import DateUtils (millisecondsInHour)
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Random (randomInt, randomRange)

chooseTimeOffset :: Int -> Int -> Effect Milliseconds
chooseTimeOffset startingHourInclusive endHourInclusive = 
    if startingHourInclusive > endHourInclusive then 
        throw ("start hour is bigger then the end hour, cannot choose an hour value.")
    else do
        chosenHour <- randomInt startingHourInclusive endHourInclusive
        let hourMilliseconds = millisecondsInHour * (toNumber chosenHour)
        inHourMilliseconds   <- randomRange 0.0 millisecondsInHour
        pure $ Milliseconds ( round $ hourMilliseconds + inHourMilliseconds)
        