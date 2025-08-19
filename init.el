;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;;; Author: gpapadok

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
(setq straight-use-package-by-default t)

;;;; Aesthetics

(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(use-package nerd-icons)
(use-package dashboard
  :init
  (setq dashboard-display-icons-p t
        dashboard-icon-type "nerd-icons"
        dashboard-set-heading-icons t
        dashboard-set-file-icons t)
  :config
  (dashboard-setup-startup-hook))
(use-package page-break-lines)

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)
   ("C-c C-d" . helpful-at-point)))

(use-package buffer-name-relative
  :config (buffer-name-relative-mode))

(use-package golden-ratio
  :init (setq golden-ratio-auto-scale t)
  :config (golden-ratio-mode t))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package beacon
  :config (beacon-mode 1))
;;;; end Aesthetics

(use-package which-key
  :config
  (which-key-mode))

(use-package yaml-mode)
(use-package deadgrep
  :bind (("C-x p g" . deadgrep)))
(use-package avy
  :bind (("C-c '" . avy-goto-char)
         ("C-c c" . avy-goto-char-2)
         ("C-c t" . avy-goto-char-timer)
         ("C-c k" . avy-goto-line)
         ("C-c w" . avy-goto-word-1)))

(use-package expand-region
  :bind (("M-O" . er/expand-region)))

(use-package dockerfile-mode)
(use-package magit)
(use-package rainbow-delimiters)
(use-package company
  :hook (after-init . global-company-mode))

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))
(use-package savehist
  :init
  (savehist-mode))
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package clojure-mode)
(use-package cider)
(use-package flymake-kondor
  :hook (clojure-mode . flymake-kondor-setup)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

(use-package simple-httpd)

(defun surround-print-at-point ()
  "Surrounds a sexp with a print statement.  For debugging Lisp."
  (interactive)
  (save-excursion
    (unless (char-equal (char-after) ?\()
      (backward-up-list))
    (insert "(print ")
    (forward-sexp)
    (insert ?\))))

(defun remove-print-at-point ()
  "Remove a surrounding print statement from a sexp."
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
  :init
  (setq inferior-lisp-program "sbcl")
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (add-to-list 'slime-contribs 'slime-indentation)
  :config
  (require 'slime-cl-indent)
  (put 'define-package 'common-lisp-indent-function '(as defpackage))
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  (slime-mode . (lambda ()
                  (unless (slime-connected-p)
                    (save-excursion (slime)))))
  :bind
  (("C-x v p" . surround-print-at-point)
   ("C-x v M-p" . remove-print-at-point)))

(use-package lass
  :ensure nil
  :load-path (concat (getenv "HOME") "/quicklisp/dists/quicklisp/software/lass-20230214-git"))

;;; rover - Helper functions for running cl-rove tests.
(defun rover-defun-name-at-point (&optional form)
  (let ((form (or form (slime-defun-at-point))))
    (cadr (read form))))

(defun rover-is-rove-test-form (&optional form)
  (let ((form (or form (slime-defun-at-point))))
    (or (string-match "^(deftest" form)
        (string-match "^(rove:deftest" form))))

(defun rover-run-test-at-point ()
  (interactive)
  (slime-compile-defun)
  (let ((form (slime-defun-at-point)))
    (if (rover-is-rove-test-form form)
        (progn
          (print (slime-interactive-eval
                  (prin1-to-string `(rove:run-test ',(rover-defun-name-at-point form)))))
          (slime-switch-to-output-buffer))
      (error "Top-level form not a rove test"))))

(defun rover-run-current-suite ()
  (interactive)
  (slime-compile-and-load-file)
  (slime-interactive-eval
   (prin1-to-string '(rove:run-suite (intern (package-name *package*) :keyword)))))
;;; end rover

(use-package vice-mode
  :straight (vice
             :host github
             :repo "gpapadok/vice"
             :local-repo "vice"
             :branch "master"
             :files (:defaults "vice-mode.el"))
  :init (vice-mode))

(defun insert-lambda ()
  "Insert λ."
  (interactive)
  (insert 955))

(defun display-startup-time ()
  (message "Emacs loaded in %.2f seconds with %d garbage collections."
           (float-time
            (time-subtract after-init-time before-init-time))
           gcs-done))

(defun init ()
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'emacs-startup-hook 'display-startup-time)

  (scroll-bar-mode 0)
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

(defun load-config ()
  "Opens the user init file."
  (interactive)
  (find-file user-init-file))

(defun open-file-new-frame ()
  "Opens the current file in a new window.
Used to copy files when working with terminal Emacs."
  (interactive)
  (shell-command (format "emacs --no-splash %s" (buffer-file-name))))

;;; Because I can.
(defconst selected-themes '(zenburn timu-macos cyberpunk solarized-dark planet))

(defun theme-package (theme)
  (if (equal theme 'solarized-dark)
      'solarized-theme
    (intern (concat (symbol-name theme) "-theme"))))

(defun ensure-installed-and-load-theme (theme)
  (condition-case nil
      (load-theme theme t)
    (error
     (straight-use-package (theme-package theme))
     (ensure-installed-and-load-theme theme)))
  (message "Theme %s loaded." theme))

(let ((available-themes selected-themes))
  (defun cycle-themes ()
    (interactive)
    (when (null available-themes)
      (setf available-themes selected-themes))
    (ensure-installed-and-load-theme (car available-themes))
    (setf available-themes (cdr available-themes))))
