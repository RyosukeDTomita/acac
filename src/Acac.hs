{-# LANGUAGE OverloadedStrings #-}

module Acac
  ( formatProblemId,
  )
where

import Data.Text (Text)

-- | 提出の contest_id と problem_id から表示用ラベルを作る。
-- 例: formatProblemId "abc457" "abc457_c" == "abc457C"
-- TODO: 実装する(現状はredにするためのstub)。
formatProblemId :: Text -> Text -> Text
formatProblemId _contestId _problemId = ""
