;;; init-lsp.el --- LSP configuration -*- lexical-binding: t -*-

(use-package lsp-mode
  :hook ((clojure-mode . lsp)
         (clojurescript-mode . lsp)))

(provide 'init-lsp)
