(add-to-list 'load-path "~/.emacs.d/site-lisp")
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-pinned-packages '(projectile . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)
(package-initialize)
;; package installations
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)


(load-theme 'monokai-pro t)

;; Font
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono-10"))
;; Title
(setq-default frame-title-format
	      (concat
	       "%b - "
	       invocation-name "@" (car (split-string system-name "\\."))
	       ))

(put 'dired-find-alternate-file 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(menu-bar-mode t)
 '(package-selected-packages
   '(projectile slime paredit sly vterm xresources-theme monokai-pro-theme magit))
 '(safe-local-variable-values
   '((vc-prepare-patches-separately)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")
     (emacs-lisp-docstring-fill-column . 65)))
 '(scroll-bar-mode 'right)
 '(tool-bar-mode nil)
 '(magit-define-global-key-bindings 'recommended))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-window-scroll-bars (minibuffer-window) nil nil)

;; SLY / SBCL configuration
(setq inferior-lisp-program "sbcl")

;; paredit configuration
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)

;; projectile config
(require 'projectile)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

;; account for windows
(if (equal system-type 'windows-nt)
    (progn
;;      (setq explicit-shell-file-name "cmd.exe")
;;      (setq explicit-sh.exe-args '("/K" "C:/cmder/vendor/init.bat"))
;;      (setq shell-file-name explicit-shell-file-name)
;;      (setenv "SHELL" shell-file-name)
      (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
      (setq tramp-default-method "ssh")
      (setq inferior-lisp-program "C:/sbcl/sbcl.exe")))
