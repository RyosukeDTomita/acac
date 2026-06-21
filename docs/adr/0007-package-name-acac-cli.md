---
status: accepted
date: 2026-06-21
decision-makers: "@RyosukeDTomita"
---

# ADR-0007: npm パッケージ名/リポジトリ名を acac-cli にする

## Context and Problem Statement

`npx acac <user>` で使えるようにしたく、本体 npm パッケージ名は素の `acac` を狙った。
レジストリ確認では `acac` は未登録(404)だったが、**publish 時に npm の名前類似ガード**
("Package name too similar to existing packages cac, ava, asap, abab, crc")で **403 で拒否**
された(新規の unscoped 名がタイポスクワット対策で弾かれる)。npm 自身は
スコープ付き `@sigma1881/acac` を提案してきた。

「素の名前で `npx <name>` を素直にしたい」一方で「利用者にスコープを覚えさせたくない」
という条件で、本体パッケージ名(と GitHub リポジトリ名)をどうするか決める必要があった。

## Decision Drivers

* `npx <name>` を素直にしたい(スコープを覚えさせたくない)
* npm の名前類似ガードを確実に通る名前にしたい
* `acac` というプロジェクトの呼称・コマンド名は残したい

## Considered Options

1. `acac`(unscoped) — 名前類似ガードで publish 不可
2. `@sigma1881/acac`(scoped) — publish 可だが利用者がスコープを覚える必要
3. `acac-cli`(unscoped・少し長い) — ガードを通り、スコープ不要、コマンド名は `acac` のまま
4. その他の別名(`atcoder-acac` 等)

## Decision Outcome

Chosen option: "3(`acac-cli`)"。

本体 npm パッケージ名を **`acac-cli`** にする(`npx acac-cli <user>`)。`bin` のコマンド名は
**`acac` のまま**にし、プロジェクトの呼称も `acac` を維持する。GitHub リポジトリ名も
合わせて `acac-cli` にリネームした(remote URL と各 `package.json` の `repository.url` を更新。
旧 URL は GitHub のリダイレクトが効く)。プラットフォーム別パッケージ `acac-linux-x64` は
unscoped のまま publish できたので据え置く([[ADR-0005]] の構成)。

scoped(`@sigma1881/acac`)も回避策になるが、`npx @sigma1881/acac` はスコープを覚える必要が
あり利用体験が落ちるため採らなかった。`acac-cli` は素の名前のまま少し長くすることで
類似ガードを回避でき、実際に `acac-cli@0.1.x` が publish できた。

### Consequences

* Good: `npx acac-cli <user>` で使え、スコープを覚える必要がない
* Good: コマンド名・呼称は `acac` のまま据え置ける
* Bad: パッケージ名(`acac-cli`)と実行コマンド名(`acac`)が一致せず、わずかに紛らわしい
* Bad: 名前類似ガードは将来も理論上は当たりうる(0.1.x では通過済み)
* Note: リポジトリ改名に伴い remote/`repository.url` を更新済み(旧 `acac` リポは redirect)

### Confirmation

`npm/package.json` の `name` が `acac-cli`、`bin` が `acac` であること。`acac-cli@0.1.x` が
npm に publish され、`npx acac-cli <user>` が動作することで確認する。

## Pros and Cons of the Options

### 1. acac(unscoped)

* Good: 最短で理想的な `npx acac`
* Bad: 名前類似ガードで publish 不可(403)

### 2. @sigma1881/acac(scoped)

* Good: ガードを回避でき確実に publish できる
* Bad: 利用者が `@sigma1881/` を覚える必要があり体験が落ちる

### 3. acac-cli(unscoped・少し長い)

* Good: スコープ不要で `npx acac-cli`、コマンド名は `acac` のまま
* Good: 素の名前を少し長くするだけでガードを回避できた
* Bad: パッケージ名と実行コマンド名が一致しない

### 4. 別名(atcoder-acac 等)

* Good: より確実にガードを回避できる
* Bad: `acac` の呼称から離れ、覚えにくくなる場合がある

## More Information

- 関連: [[ADR-0005]](npm 配布方式。命名の経緯もここに記載)
- npm の名前類似ガード(publish 時 403 "Package name too similar to existing packages")
