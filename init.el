;; account for windows
(if (equal system-type 'windows-nt)
    (progn (setq explicit-shell-file-name
                 "C:/Program Files (x86)/Git/bin/bash.exe")
           (setq explicit-sh.exe-args '("--login" "-i"))
           (setq shell-file-name explicit-shell-file-name)
           (setenv "SHELL" shell-file-name)
           (add-to-list 'exec-path "c:/Program Files (x86)/Git/bin")
           (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; graphene setup
(require 'graphene)

;; disable project-persist
(require 'project-persist)
(project-persist-mode 0)

;; put helm buffers in popwin
(require 'popwin)
;; (setq display-buffer-function 'popwin:display-buffer)
(push '("^\*helm .+\*$" :regexp t) popwin:special-display-config)
(add-hook 'helm-after-initialize-hook (lambda ()
                                          (popwin:display-buffer helm-buffer t)
                                          (popwin-mode -1)))

 ;;  Restore popwin-mode after a Helm session finishes.
 (add-hook 'helm-cleanup-hook (lambda () (popwin-mode 1)))


;; configure helm keybindings
(require 'helm)
(require 'helm-config)
;; helm prefix key-binding
(global-set-key (kbd "C-c h") 'helm-command-prefix-key)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-buffers-list)

;; configure projectile
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(setq projectile-switch-project-action 'projectile-dired)

;; configure helm-projectile
(require 'helm-projectile)
(helm-projectile-on)

;; hc-zenburn theme
(load-theme 'hc-zenburn t)

;; Javascript customizations
(setq js-indent-level 2)
;; Python customizations

;; Automatically remove trailing whitespace when file is saved.
(add-hook 'python-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (delete-trailing-whitespace))))))

(add-to-list 'auto-mode-alist '("\\.hpy\\'" . python-mode))
(setq py-autopep8-options '("--max-line-length=79"))
(add-hook 'python-mode-hook
          (lambda()
            (setq-default fill-column 79)))

(add-to-list 'company-backends 'company-anaconda)
(add-hook 'python-mode-hook 'anaconda-mode)
