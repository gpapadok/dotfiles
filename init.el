(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

;; straight.el
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

(use-package timu-macos-theme :straight t
  :init (load-theme 'timu-macos t))

(use-package yaml-mode :straight t)
(use-package deadgrep :straight t)
(use-package avy :straight t
  :bind (("M-P" . avy-goto-char)))

(use-package dockerfile-mode :straight t)
(use-package eglot :straight t)
(use-package magit :straight t)
(use-package counsel :straight t)
(use-package rainbow-delimiters :straight t)
(use-package company :straight t)

(use-package ivy :straight t
  :bind (("<f-6>" . ivy-resume)
	 ;; ("
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-x b" . counsel-switch-buffer))
  :init
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers 1))

(use-package slime :straight t
  :bind (("C-c b" . slime-eval-buffer))
  :init
  (setq inferior-lisp-program "sbcl")
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (add-to-list 'slime-contribs 'slime-indentation)
  :config
  (require 'slime-cl-indent)
  (put 'define-package 'common-lisp-indent-function '(as defpackage))
  (put 'defroutes 'common-lisp-indent-function '(as defparameter))
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  ;; (slime-mode . (lambda ()
  ;; 		  (unless (slime-connected-p)
  ;; 		    (save-excursion (slime)))))
  )

;; (require 'vim-binds-mode)

;; (use-package vim-binds-mode
;;   :straight (vim-binds-mode
;; 	     :fetcher github :repo "gpapadok/vim-binds-mode"))

(use-package lass :ensure nil
  :load-path "/home/gpapadok/quicklisp/dists/quicklisp/software/lass-20230214-git")

(use-package clojure-mode :straight t)
(use-package cider :straight t)

(use-package flymake-kondor :straight t
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
  ;; (display-line-numbers-mode 1)
  ;; (ivy-mode 1)
  ;; (company-mode 1)
  ;; (vim-binds-mode 1)

  (setq-default truncate-lines 1)
  (setq tab-always-indent 'complete)
  (setq sql-indent-level 4)

  (keymap-global-set "M-P" 'avy-goto-char)
  (keymap-global-set "C-s" 'swiper)
  (keymap-global-set "C-c RET" 'emacs-lisp-macroexpand))

(init)

(defun load-config ()
  (interactive)
  (find-file user-init-file))

(defun project-helm-find ()
  (interactive "P")
  (helm-find-1 (project-root (project-current))))
