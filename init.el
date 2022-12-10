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
