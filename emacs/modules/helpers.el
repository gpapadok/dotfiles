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
  (find-file user-init-file))

(defun open-file-new-frame ()
  "Opens the current file in a new window.
Used to copy files when working with terminal Emacs."
  (interactive)
  (shell-command (format "emacs --no-splash %s" (buffer-file-name))))

(provide 'helpers)
;;; helpers.el ends here
