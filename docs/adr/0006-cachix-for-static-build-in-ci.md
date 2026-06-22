---

## status: accepted date: 2026-06-21 decision-makers: "@RyosukeDTomita"

# ADR-0006: CI の静的ビルドを Cachix で配る

## Context and Problem Statement

配布用バイナリは musl 静的リンク(\[[ADR-0005]\] の `packages.static`)で、これを
`release.yml` の CI でビルドして npm publish する。ところが **静的(musl)版の Haskell
パッケージは公開キャッシュ(cache.nixos.org)に無い**ため、CI の `nix build .#static` は
static GHC と全依存をソースからビルドし、**GitHub Actions の 60 分上限を超えてタイムアウト**
した(実際に v0.1.0 の release ジョブが 1h0m で cancelled になり publish に到達しなかった)。

CI で静的ビルドを現実的な時間で完了させる手段が必要。

## Decision Drivers

- CI のジョブ時間内(数分)で release を完了させたい
- static GHC / 依存を毎回ソースからビルドしたくない
- **初回ビルドがタイムアウトで成功しない**ため、「CI で1度成功 → 以降キャッシュ」型は使えない(鶏卵問題)
- すでにローカルには静的ビルドが存在する(これを使い回したい)

## Considered Options

1. Cachix(ローカルで焼いて seed し、CI は pull する)
1. GitHub Actions のキャッシュ(`nix-community/cache-nix-action` 等。CI ビルド成功後に保存)
1. `timeout-minutes` を伸ばして毎回ソースビルドする
1. 静的をやめて動的バイナリにする

## Decision Outcome

Chosen option: "1(Cachix)"。

ローカルで `nix build .#static` した成果物を `cachix push acac ./result` で **事前に seed** し、
CI は `cachix/cachix-action`(`name: acac`, `skipPush: true`)で **pull 専用**にする。public
キャッシュなので CI 側に token は不要。これにより CI の `nix build .#static` は
**キャッシュ取得(数秒)** で済み、release ジョブが完走するようになった。

GitHub Actions キャッシュ型(選択肢2)は「初回 CI ビルド成功」が前提のため、初回が
タイムアウトする本件では機能しない。Cachix は **ローカルの完成物から seed できる**点が
決定的だった。

加えて、`callCabal2nix` のソースを `fileset` で `src/app/test/acac.cabal` に絞った
(\[[ADR-0005]\] 実装)。README・npm・docs などを変えても `.#static` の derivation が変わらず、
**キャッシュが効き続ける**ようにするため(これをしないと毎コミットで cache miss になる)。

### Consequences

- Good: release の静的ビルドが数秒(pull)になり、タイムアウトが解消
- Good: ローカル成果物から seed できるので「初回が成功しない」鶏卵問題を回避
- Good: pull 専用(`skipPush`)かつ public キャッシュなので CI に secret 不要
- Bad: `.#static` の derivation が変わる変更時は、タグ前にローカルから seed し直す手間がある
  (手順と判断基準は README の Release 節に記載)
- Bad: 外部サービス(Cachix)とキャッシュの維持に依存する

### Confirmation

`release.yml` に `cachix/cachix-action`(`name: acac`, `skipPush: true`)があり、release ジョブが
数秒で静的バイナリを取得して完走すること。seed 済みかは
`https://acac.cachix.org/<hash>.narinfo` が 200 で確認できる(404 なら未 seed)。

## Pros and Cons of the Options

### 1. Cachix(seed して pull)

- Good: ローカル成果物から seed でき、初回から CI が速い
- Good: pull 専用なら CI に secret 不要
- Bad: derivation が変わると手動 seed が要る

### 2. GitHub Actions キャッシュ(cache-nix-action 等)

- Good: 外部サービス不要(GitHub 内で完結)
- Bad: 「CI で1度ビルド成功」が前提。初回タイムアウトの本件では埋まらない

### 3. timeout を伸ばして毎回ソースビルド

- Good: 仕組みが単純
- Bad: 毎リリース 1 時間級で無駄が大きく、不安定

### 4. 動的バイナリにする

- Good: cache.nixos.org から取れて速い・cachix 不要
- Bad: /nix/store にリンクし、利用者のマシンで動かない(配布不可)

## More Information

- 関連: [[ADR-0004]](%E5%8F%96%E5%BE%97%E6%96%B9%E5%BC%8F) / \[[ADR-0005]\](npm 配布)、`flake.nix` の `packages.static` と `fileset`
- 運用手順: README の Release 節(seed コマンドと再 seed の判断基準)
- Cachix: https://www.cachix.org/
