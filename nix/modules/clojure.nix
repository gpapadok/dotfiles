{ pkgs, ...}:

{
  home.packages = with pkgs; [
    clojure
    leiningen
    clojure-lsp
    clj-kondo
  ];
}
