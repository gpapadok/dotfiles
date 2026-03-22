;;; init-config.el --- Generic Emacs configuration -*- lexical-binding: t -*-

;;; Code:

(use-package emacs
  :hook
  ((prog-mode . display-line-numbers-mode)
   (before-save . delete-trailing-whitespace)
   (emacs-lisp-mode . flymake-mode)
   (emacs-startup . display-startup-time))

  :bind
  (("C-c l" . insert-lambda)
   :map emacs-lisp-mode-map
   ("C-c RET" . emacs-lisp-macroexpand)
   :map completion-in-region-mode-map
   ("M-p" . minibuffer-previous-completion)
   ("M-n" . minibuffer-next-completion))

  :init
  (when (string= system-type "darwin")
    (keymap-global-set "C-M-m" 'mark-sexp))

  :config
  (setq-default truncate-lines 1
                tab-width 4
                indent-tabs-mode nil)
  (setq js-indent-level 2
        tab-always-indent 'complete
        gc-cons-threshold (* 60 1000 1000)) ; 60MB
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (show-paren-mode 1)
  (column-number-mode 1)
  (line-number-mode 1))

(provide 'init-config)
;;; init-config.el ends here
