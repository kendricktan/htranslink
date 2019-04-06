{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Data.ByteString.Lazy               as LBS
import           Data.Function
import           GTFS.RealTime.Protobuf.FeedMessage
import           Network.HTTP.Simple                (Request, getResponseBody,
                                                     httpLBS)
import qualified Text.ProtocolBuffers               as Protobuf

translinkFeedLink = "https://gtfsrt.api.translink.com.au/feed"

main :: IO ()
main = do
  resp <- httpLBS translinkFeedLink
  msg <- case Protobuf.messageGet $ getResponseBody resp of
           Left err                       -> fail err
           Right (msg :: FeedMessage, "") -> return msg
           _                              -> fail "parse incomplete"
  print msg
