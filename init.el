(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;; SLIME
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (add-hook 'prog-mode-hook 'paredit-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; (evil-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(display-line-numbers-mode 1)

;; (setq display-line-numbers-type 'relative)
(setq-default truncate-lines 1)
(setq js-indent-level 2)
(setq sql-indent-level 4)
;; (setq evil-want-C-u-scroll t)

;; (setq tab-always-indent 'complete)

(load-theme 'cyberpunk t)

;; (global-set-key (kbd "C-M-k") 'kill-whole-line)
;; (global-set-key (kbd "C-M-k") 'kill-sexp)

(defun kill-surrounding-sexp ()
  (interactive)
  (backward-up-list)
  (kill-sexp))

(defun yank-surrounding-sexp ()
  (interactive)
  (backward-up-list)
  (let ((opoint (point)))
    (forward-sexp 1)
    (kill-ring-save opoint (point))))
