(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name
		       "straight/repos/straight.el/bootstrap.el"
		       (or (bound-and-true-p straight-base-dir)
			   user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(use-package timu-macos-theme
  :straight t
  :init (load-theme 'timu-macos t))

(use-package yaml-mode
  :straight t)
(use-package deadgrep
  :straight t)
(use-package avy
  :straight t
  :bind (("M-P" . avy-goto-char)))
(use-package expand-region
  :straight t
  :bind (("M-O" . er/expand-region)))

(use-package dockerfile-mode
  :straight t)
(use-package eglot
  :straight t)
(use-package magit
  :straight t)
(use-package rainbow-delimiters
  :straight t)
(use-package company
  :straight t)

(use-package vertico
  :straight t
  :init
  (vertico-mode))

(defun surround-print-at-point ()
  (interactive)
  (save-excursion
    (unless (char-equal (char-after) ?\()
      (backward-up-list))
    (insert "(print ")
    (forward-sexp)
    (insert ?\))))

(defun remove-print-at-point ()
  (interactive)
  (save-excursion
    (let ((done nil))
      (while (not done)
	(let ((c (char-after)))
	  (forward-char)
	  (if (and (char-equal c ?\() (string= (thing-at-point 'word t) "print"))
	      (progn
		(backward-char)
		(kill-word 1)
		(delete-char 1)
		(forward-sexp)
		(delete-char 1)
		(backward-sexp)
		(setq done t))
	    (progn
	      (backward-char)
	      (backward-up-list))))))))

(use-package slime
  :straight t
  :init
  (setq inferior-lisp-program "sbcl")
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (add-to-list 'slime-contribs 'slime-indentation)
  :config
  (require 'slime-cl-indent)
  (put 'define-package 'common-lisp-indent-function '(as defpackage))
  :bind
  (("C-x v p" . surround-print-at-point)
   ("C-x v M-p" . remove-print-at-point))
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  (slime-mode . (lambda ()
		  (unless (slime-connected-p)
		    (save-excursion (slime))))))

(use-package vice-mode
  :straight (vice
	     :host github
	     :repo "gpapadok/vice"
	     :local-repo "vice"
	     :branch "master"
	     :files (:defaults "vice-mode.el"))
  :init (vice-mode))

(use-package lass
  :ensure nil
  :load-path "/home/gpapadok/quicklisp/dists/quicklisp/software/lass-20230214-git")

(use-package clojure-mode
  :straight t)

(use-package cider
  :straight t)

(use-package flymake-kondor
  :straight t
  :hook (clojure-mode . flymake-kondor-setup)
  :bind (("M-n" . flymake-goto-next-error)
	 ("M-p" . flymake-goto-prev-error)))

(defun init ()
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  (menu-bar-mode 0)
  (show-paren-mode 1)
  (column-number-mode 1)
  (line-number-mode 1)

  (setq-default truncate-lines 1)
  (setq tab-always-indent 'complete)
  (setq sql-indent-level 4)

  (keymap-global-set "M-P" 'avy-goto-char)
  (keymap-set emacs-lisp-mode-map "C-c RET" 'emacs-lisp-macroexpand))

(init)

(defun load-config ()
  (interactive)
  (find-file user-init-file))

(defun project-helm-find ()
  (interactive "P")
  (helm-find-1 (project-root (project-current))))

(defun current-file-new-frame ()
  (interactive)
  (shell-command (format "emacs --no-splash %s" (buffer-file-name))))
