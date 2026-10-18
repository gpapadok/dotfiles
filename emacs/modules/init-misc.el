;;; init-misc.el --- Miscellaneous -*- lexical-binding: t -*-

(use-package markdown-mode)

(use-package nix-mode)

(use-package yaml-mode)

(use-package dockerfile-mode)

(use-package simple-httpd)

(use-package lua-mode)

(use-package nginx-mode)

(use-package terraform-mode)

(use-package mermaid-mode)

(use-package envrc
  :hook (after-init . envrc-global-mode))

(provide 'init-misc)
