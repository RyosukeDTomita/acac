{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  # nix ファイルの整形(従来 nixfmt-tree が担当していた分)。
  # nixfmt-tree と同じ RFC 166 スタイルに揃えて差分を出さない。
  programs.nixfmt.enable = true;
  programs.nixfmt.package = pkgs.nixfmt-rfc-style;

  # mdformat 本体は thematic break を変換するため、`---` のまま出力する
  # mdformat-simple-breaks プラグインを使う。programs.mdformat は package
  # 上書きを尊重しないため settings.formatter で直接指定する。
  settings.formatter.mdformat = {
    command = "${pkgs.mdformat.withPlugins (ps: with ps; [ ps.mdformat-simple-breaks ])}/bin/mdformat";
    includes = [ "*.md" ];
  };

  programs.ormolu.enable = true;
  programs.ormolu.package = pkgs.haskell.packages.ghc9122.ormolu;

  # treefmt controls mode/idempotence itself; pass only parser options.
  settings.formatter.ormolu.options = [
    "--ghc-opt"
    "-XImportQualifiedPost"
  ];
}
