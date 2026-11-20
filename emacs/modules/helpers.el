;;; helpers.el --- Helper functions -*- lexical-binding: t -*-

;;; Code:

(defun insert-lambda ()
  "Insert λ."
  (interactive)
  (insert 955))

(defun display-startup-time ()
  (message "Emacs loaded in %.2f seconds with %d garbage collections."
           (float-time
            (time-subtract after-init-time before-init-time))
           gcs-done))

(defun load-config ()
  "Opens the user init file."
  (interactive)
  (load-file user-init-file))

(defun kill-unmodified-buffers ()
  "Kill all Dired or file buffers with no unsaved changes.
Keeps the current buffer and buffers an emacsclient is waiting on."
  (interactive)
  (let ((current (current-buffer)))
    (mapc #'kill-buffer
          (seq-filter (lambda (b)
                        (and (not (eq b current))
                             (with-current-buffer b
                               (and (not (bound-and-true-p server-buffer-clients))
                                    (or (derived-mode-p 'dired-mode)
                                        (and buffer-file-name
                                             (not (buffer-modified-p))))))))
                      (buffer-list)))))

(provide 'helpers)
;;; helpers.el ends here
