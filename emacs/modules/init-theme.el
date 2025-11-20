;;; init-theme.el --- Themes configuration -*- lexical-binding: t -*-

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

(provide 'init-theme)
