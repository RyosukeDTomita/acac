{-# LANGUAGE OverloadedStrings #-}

import Acac (formatProblemId)
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "formatProblemId" $ do
    it "abc457 と abc457_c を abc457C に変換する" $
      formatProblemId "abc457" "abc457_c" `shouldBe` "abc457C"
