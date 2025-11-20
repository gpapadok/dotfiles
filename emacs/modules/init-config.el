;;; init-config.el --- Generic configuration -*- lexical-binding: t -*-

(defun init ()
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'emacs-startup-hook 'display-startup-time)

  ;; (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (show-paren-mode 1)
  (column-number-mode 1)
  (line-number-mode 1)

  (setq-default truncate-lines 1
                tab-width 4
                indent-tabs-mode nil)
  (setq tab-always-indent 'complete
        gc-cons-threshold (* 60 1000 1000)) ; 60MB

  (keymap-global-set "C-c l" 'insert-lambda)
  (when (string= system-type "darwin")
    (keymap-global-set "C-M-m" 'mark-sexp))
  (keymap-set emacs-lisp-mode-map "C-c RET" 'emacs-lisp-macroexpand)
  (keymap-set completion-in-region-mode-map "M-p" 'minibuffer-previous-completion)
  (keymap-set completion-in-region-mode-map "M-n" 'minibuffer-next-completion))

(init)

(provide 'init-config)
