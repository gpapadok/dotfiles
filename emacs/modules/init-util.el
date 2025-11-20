;;; init-util.el --- Utility packages -*- lexical-binding: t -*-

(use-package which-key
  :config
  (which-key-mode))

(use-package deadgrep
  :bind (("C-x p g" . deadgrep)))

(use-package avy
  :bind (("C-c '" . avy-goto-char)
         ("C-c c" . avy-goto-char-2)
         ("C-c t" . avy-goto-char-timer)
         ("C-c k" . avy-goto-line)
         ("C-c w" . avy-goto-word-1)))

(use-package magit)

(use-package expand-region
  :bind (("M-O" . er/expand-region)))

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

(use-package vice-mode
  :straight (vice
             :host github
             :repo "gpapadok/vice"
             :local-repo "vice"
             :branch "master"
             :files (:defaults "vice-mode.el"))
  :init (vice-mode))

(provide 'init-util)
