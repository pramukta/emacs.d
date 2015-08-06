;;; init.el --- My ever changing emacs initialization script

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

(defun zencolor (colorname)
  "Convert hc-zenburn color symbol to hex string"
  (cdr (assoc (symbol-name colorname) hc-zenburn-colors-alist))
  )

;; visual customizations
(set-face-attribute 'mode-line nil :box `(:line-width -1 :color ,(zencolor 'hc-zenburn-bg+1) :style nil))
(set-face-attribute 'mode-line-inactive nil
                    :box `(:line-width -1 :color ,(zencolor 'hc-zenburn-bg+1) :style nil))

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

;; Confluence Integration
(require 'confluence)
(setq confluence-url "https://timbr-io.atlassian.net/wiki/rpc/xmlrpc")

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" default)))
 '(sml/mode-width
   (if
       (eq powerline-default-separator
           (quote arrow))
       (quote right)
     (quote full)))
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (car powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active1)
                   nil)))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (car powerline-default-separator-dir)))
                   nil
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active2)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
