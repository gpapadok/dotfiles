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

(add-to-list 'load-path (expand-file-name "gpapadok/modules" user-emacs-directory))

(defvar init-modules
  '(init-python
    init-aesthetics
    init-clojure
    init-common-lisp
    init-util
    init-misc
    init-config
    init-theme
    helpers))

(dolist (mod init-modules)
  (require mod))
