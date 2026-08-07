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

(provide 'helpers)
;;; helpers.el ends here
