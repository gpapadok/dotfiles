(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

(setq packages
      '(timu-macos-theme
	yaml-mode
	web-mode
	mint-mode
	deadgrep
	counsel
	ivy
	helm
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
	use-package
	company
	))

(unless (seq-every-p #'package-installed-p package-list)
  (package-refresh-contents)
  (dolist (p packages)
    (unless (package-installed-p p)
      (package-install p))))

;; mint from git
;; (add-to-list 'load-path "/home/gpapadok/.emacs.d/github/emacs-mint-mode")
;; (load "mint-mode")

(use-package slime
  :bind (("C-c C-v C-v" . slime-eval-buffer))
  :init
  (setq inferior-lisp-program "sbcl")
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (add-to-list 'slime-contribs 'slime-indentation)
  :config
  (require 'slime-cl-indent)
  (put 'define-package 'common-lisp-indent-function '(as defpackage))
  (put 'defroutes 'common-lisp-indent-function '(as defparameter))
  :hook (lisp-mode . rainbow-delimiters-mode))

(use-package elpy
  :init
  (setq elpy-rpc-python-command "python3"))

(use-package ivy
  :bind (("<f-6>" . ivy-resume)
	 ("C-c g" . counsel-git)
	 ("C-c j" . 'counsel-git-grep))
  :init
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers 1))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
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

(defun load-config ()
  (interactive)
  (find-file user-init-file))

(global-set-key (kbd "C-x M-k") 'kill-surrounding-sexp)
(global-set-key (kbd "C-x M-w") 'yank-surrounding-sexp)
(global-set-key (kbd "C-x C-j") 'insert-line-below)
(global-set-key (kbd "C-x M-j") 'insert-line)
(global-set-key (kbd "C-x C-k") 'just-one-space-line)
(global-set-key (kbd "C-x C-y") 'replace-sexp)
(global-set-key (kbd "C-x M-;") 'comment-surrounding-sexp)
;;
(global-set-key (kbd "M-P") 'avy-goto-char)
(global-set-key (kbd "C-s") 'swiper)
