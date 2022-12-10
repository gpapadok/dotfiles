(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)                                                                                                                           
(add-hook 'clojure-mode 'paredit-mode)                                                                                                                                          
(add-hook 'cider-mode 'paredit-mode)                                                                                                                                            
                                                                                                                                                                                
(evil-mode 1)                                                                                                                                                                   
(show-paren-mode 1)                                                                                                                                                             
(column-number-mode 1)                                                                                                                                                          
(line-number-mode 1)                                                                                                                                                            
(rainbow-delimiters-mode 1)                                                                                                                                                     
                                                                                                                                                                                
(setq display-line-numbers-type 'relative)                                                                                                                                      
(setq-default truncate-lines 1)                                                                                                                                                 
(setq js-indent-level 2)                                                                                                                                                        
(setq evil-want-C-u-scroll t) 

;; (setq tab-always-indent 'complete)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes '(manoj-dark))
 '(ispell-dictionary nil)
 '(package-selected-packages '(deadgrep cider clojure-mode cmake-mode helm))
 '(safe-local-variable-values
   '((cider-figwheel-main-default-options . ":dev")
     (cider-default-cljs-repl . figwheel-main)
     (cider-clojure-cli-global-options . "-A:dev")))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
