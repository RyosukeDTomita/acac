---

## name: sync-readme-en description: 日本語の README.ja.md を正として、英語の README.md を原文に忠実に翻訳・同期する。README.ja.md を編集したあと英語版を最新化したいとき、「英語READMEを更新」「READMEを同期」などと言われたときに使う。

# Sync English README from Japanese

`README.ja.md`(日本語・正)を原文として、`README.md`(英語)を忠実に翻訳・同期し、
さらに `README.md` から `npm/README.md`(npm ページ用)を派生させる。
正は常に `README.ja.md`。英語側に独自の内容を足したり省いたりしない。

## 手順

1. `README.ja.md`・`README.md`・`npm/README.md` を読む。
1. `README.ja.md` を英語へ翻訳し、`README.md` を上書きする(下記「翻訳ルール」)。
1. `README.md` から **`## For Developer Memo` セクション以降を除いたもの**を `npm/README.md` に書き出す(下記「npm/README.md ルール」)。
1. 差分を確認し、構成が一致しているか・原文に忠実か・英語として自然かを点検する。
1. コミットと push はユーザに任せる(明示指示が無ければしない)。

## 翻訳ルール

- 見出し・節の順序・階層・箇条書き・コードブロック・表・リンクは**原文の構成をそのまま維持**する(増減・並べ替えをしない)。
- 次は**翻訳しない**でそのままコピーする: コマンド・コード・パス・識別子・型名・URL・バッジ。
- 出力例の box-drawing テーブル(`┌─┬─┐` 等)はそのまま貼る。
- バッジ(test / release / License)は言語非依存なので**両 README の先頭に同じものを置く**。
- 英語 `README.md` の先頭(バッジ直後)に日本語版へのリンク `[(日本語READMEはこちら)](README.ja.md)` を残す。無ければ追加する。
  - 日本語 `README.ja.md` 側には英語版へのリンクは**入れない**(リンクは英語→日本語の片方向のみ)。
- 技術用語は意味を変えない。意訳しすぎず、原文に忠実(faithful)に訳す。
- Markdown の水平線は `---`(ハイフン3つ)を使う。

## npm/README.md ルール

`npm/README.md` は npm の `acac-cli` ページに表示される。`README.md`(英語)を正として派生させる。

- 内容は **`README.md` から `## For Developer Memo` セクション(その見出し以降すべて)を除いたもの**。
- 除去に伴い宙に浮く要素も落とす: `For Developer Memo` への参照リンク(例 `See [For Developer Memo](#for-developer-memo) ...`)と、その直前の区切り線 `---`。
- それ以外(タイトル・バッジ・日本語版へのリンク・ABOUT・HOW TO USE)は `README.md` と同一にする。独自加筆はしない。

## 注意

- `README.md`(英語)を直接編集して内容を増やさない。内容変更は必ず `README.ja.md` に入れてから本スキルで同期する。
- 翻訳漏れ・節の欠落が無いか、見出し数が `README.ja.md` と `README.md` で一致しているかを最後に確認する。
- `npm/README.md` が `README.md`(For Developer Memo を除いた範囲)と一致しているかも確認する。
