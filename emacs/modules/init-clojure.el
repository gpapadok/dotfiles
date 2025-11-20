;;; init-clojure.el --- Clojure configuration -*- lexical-binding: t -*-

(use-package clojure-mode)

(use-package cider)

(use-package flymake-kondor
  :hook (clojure-mode . flymake-kondor-setup)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

(provide 'init-clojure)
