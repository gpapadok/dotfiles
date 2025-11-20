;;; init-common-lisp.el --- Common Lisp configuration -*- lexical-binding: t -*-

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

;; (use-package lass
;;   :ensure nil
;;   :load-path "/Users/gpapadok/quicklisp/dists/quicklisp/software/lass-20250622-git")

(add-to-list 'load-path "/Users/gpapadok/quicklisp/dists/quicklisp/software/lass-20250622-git")
(require 'lass)

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

(provide 'init-common-lisp)
