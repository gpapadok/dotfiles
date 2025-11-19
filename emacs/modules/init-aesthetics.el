;;; init-aesthetics.el --- Aesthetics configuration -*- lexical-binding: t -*-

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

(use-package rainbow-delimiters)

(provide 'init-aesthetics)
