;;; init.el --- My ever changing emacs initialization script
(defvar helm-alive-p nil)
;; account for windows

(if (equal system-type 'windows-nt)
    (progn (setq explicit-shell-file-name "cmdproxy.exe")
           (setq explicit-sh.exe-args '("/K" "C:/Users/prak/Anaconda/Scripts/activate.bat C:/Users/prak/Anaconda"))
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

(defun zencolor (colorname)
  "Convert hc-zenburn color symbol to hex string"
  (cdr (assoc (symbol-name colorname) hc-zenburn-colors-alist))
  )

;; visual customizations
(set-face-attribute 'mode-line nil :box `(:line-width -1 :color ,(zencolor 'hc-zenburn-bg+1) :style nil))
(set-face-attribute 'mode-line-inactive nil
                    :box `(:line-width -1 :color ,(zencolor 'hc-zenburn-bg+1) :style nil))

;; autocomplete customizations
(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-anaconda)
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
     (define-key company-active-map (kbd "<backtab>") 'company-select-previous))
  )
;; (setq company-require-match 'never)
;; (setq company-auto-complete t)

;; (add-to-list 'company-backends 'company-anaconda)

;; Javascript customizations
(require 'flycheck)
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(setq-default flycheck-disabled-checkers
              (append (append flycheck-disabled-checkers '(javascript-jshint)) '(json-jsonlist)))
(flycheck-add-mode 'javascript-eslint 'web-mode)

(setq js-indent-level 2)
;; Python customizations

(require 'conda)
;; interactive shell support
(conda-env-initialize-interactive-shells)
;; eshell support
(conda-env-initialize-eshell)
;; auto-activation
(conda-env-autoactivate-mode t)

;; Automatically remove trailing whitespace when file is saved.
(add-hook 'python-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (delete-trailing-whitespace))))))

(setq py-autopep8-options '("--max-line-length=79"))
(add-hook 'python-mode-hook
          (lambda()
            (setq-default fill-column 79)))

(add-hook 'python-mode-hook 'anaconda-mode)

(setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "--simple-prompt -i")

;; open confluence page
(global-set-key (kbd "C-x w f") 'confluence-get-page)

;; setup confluence mode
(add-hook 'confluence-mode-hook
          (lambda()
            (local-set-key (kbd "C-x w") 'confluence-prefix-map)))

(add-hook 'confluence-mode-hook
          (lambda()
            (visual-line-mode t)))

(add-hook 'confluence-mode-hook
          (lambda()
            (global-set-key (kbd "C-c C-r") (lambda()
                                              (mark-whole-buffer)
                                              (confluence-xml-reformat)))))

;; special charaters in shell 
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(conda-anaconda-home "/home/prak/anaconda")
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" default)))
 '(nil nil t)
 '(package-selected-packages
   (quote
    (anaconda-mode company-anaconda conda pyvenv visual-regexp-steroids visual-fill-column smart-mode-line-powerline-theme slime-company slime-annot shackle py-autopep8 popwin markdown-mode+ json-mode js2-mode jedi-direx inf-mongo helm-projectile hc-zenburn-theme graphene fill-column-indicator ein confluence))))


;; SLIME configuration
(cond
 (system-type "gnu/linux") (setq inferior-lisp-program "/usr/bin/sbcl")
 (system-type "darwin") (setq inferior-lisp-program "/opt/local/bin/sbcl"))
(setq slime-contribs '(slime-fancy))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
