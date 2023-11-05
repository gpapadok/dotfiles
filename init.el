(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

(setq packages
      '(ac-php
	timu-macos-theme
	yaml-mode
	web-mode
	php-mode
	mint-mode
	deadgrep
	counsel
	ivy
	;; helm
	avy
	dockerfile-mode
	lsp-ui
	lsp-mode
	eglot
	;; elpy
	magit
	;; python-mode
	go-mode
	slime
	rainbow-delimiters
	;; cyberpunk-theme
	))

(dolist (p packages)
  (unless (package-installed-p p)
    (package-install p)))

;; mint from git
;; (add-to-list 'load-path "/home/gpapadok/.emacs.d/github/emacs-mint-mode")
;; (load "mint-mode")

;;; SLIME
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(require 'slime-cl-indent)
(add-to-list 'slime-contribs 'slime-indentation)

;;; PYTHON
(elpy-enable)
(setq elpy-rpc-python-command "python3")

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(menu-bar-mode 0)
(show-paren-mode 1)
(column-number-mode 1)
(line-number-mode 1)
(display-line-numbers-mode 1)
(ivy-mode 1)
(counsel-mode 1)
(company-mode 1)

(setq-default truncate-lines 1)
(setq tab-always-indent 'complete)

(add-hook 'web-mode-hook (lambda ()
			   (setq-local standard-indent 2)))

;; (add-hook 'go-mode-hook (lambda ()
;; 			  (setq-local tab-width 4)))


(setq js-indent-level 2)
(setq sql-indent-level 4)

(load-theme 'timu-macos t)

(defun op-surrounding-sexp (op)
  "Perform operation on sexp surrounding point."
  (let ((start (point)))
    (when (not (char-equal (char-after (point)) ?\())
      (condition-case nil
	  (backward-up-list)
	(error nil)))
    (let ((opoint (point)))
      (forward-sexp 1)
      (funcall op opoint (point))
      (goto-char start))))

(defun kill-surrounding-sexp ()
  "Delete the sexp surrounding point"
  (interactive)
  (op-surrounding-sexp #'kill-region))

(defun yank-surrounding-sexp ()
  "Yank the sexp surrounding point"
  (interactive)
  (op-surrounding-sexp #'kill-ring-save))

(defun comment-surrounding-sexp ()
  "Comment the sexp surrounding point"
  (interactive)
  (op-surrounding-sexp #'comment-region))

(defun insert-line-below ()
  "Same as hitting enter at end of line"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun insert-line ()
  "Inserts an indented line at the same line as point"
  (interactive)
  (back-to-indentation)
  (newline-and-indent)
  (previous-line)
  (indent-for-tab-command))

(defun just-one-space-line ()
  (interactive)
  (kill-line)
  (just-one-space))

(defun replace-sexp ()
  (interactive)
  (yank)
  (kill-sexp))

(global-set-key (kbd "C-x M-k") 'kill-surrounding-sexp)
(global-set-key (kbd "C-x M-w") 'yank-surrounding-sexp)
(global-set-key (kbd "C-x C-j") 'insert-line-below)
(global-set-key (kbd "C-x M-j") 'insert-line)
(global-set-key (kbd "C-x C-k") 'just-one-space-line)
(global-set-key (kbd "C-x C-y") 'replace-sexp)
;;
(global-set-key (kbd "C-c C-v C-v") 'slime-eval-buffer)
(global-set-key (kbd "M-P") 'avy-goto-char)
(global-set-key (kbd "C-s") 'swiper)
