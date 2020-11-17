;;; Emacs Core
;; Local plugins
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Initialize package manager
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Save all backup files in a dedicated directory
;; https://stackoverflow.com/a/2680682
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

;; Place autosave files in dedicated directory
;; https://www.emacswiki.org/emacs/AutoSave
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backup"))))

;; Place customize files in seperate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Enable syntax highlighting
(global-font-lock-mode t)

;;; Layout
;; Font
(setq default-frame-alist '((font . "Hack-16")))

;; Tab width
(setq-default tab-width 5)

;;; Behavior
;; Editor config
(editorconfig-mode 1)

;; Show line numbers
(global-display-line-numbers-mode)

;; Max line length
(require 'column-marker)
(add-hook 'text-mode-hook (lambda () (interactive) (column-marker-3 80)))
(add-hook 'go-mode-hook (lambda () (interactive) (column-marker-3 80)))

;; Spell check
(add-hook 'text-mode-hook 'flyspell-mode)

;; Highlight hex colors
;;(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
;;  (lambda () (rainbow-mode t)))

;;(my-global-rainbow-mode t)

;; New line at end of file
(setq require-final-newline 'visit-save)

;; Disable top menu bar in tty mode
(unless (display-graphic-p)
  (menu-bar-mode -1))

;; Window movements
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;; Auto indent
(setq auto-indent-on-visit-file t)
(require 'auto-indent-mode)

;; Rename file
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; Auto complete
;; (require 'company)
;; (require 'company-lsp)
;; (require 'lsp-mode)
;; (add-hook 'after-init-hook 'global-company-mode)
;; (push 'company-lsp company-backends)

;; (add-hook 'go-mode-hook 'lsp-mode)

;; Show function arguments on hover
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)

;; Org mode
(setq org-agenda-files (list (expand-file-name "~/documents/notebook.org")))
(setq org-todo-keywords
	 '((sequence "TODO" "DOING" "PAUSED" "|" "DONE" "ABANDONED")))

;;; Languages
;;Salt state
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

;; Markdown
(setq markdown-command "/bin/pandoc")

;; Go
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-hook 'before-save-hook #'gofmt-before-save)

;; LaTeX
(require 'px)

;;; Colors
;;;(load-theme 'zenburn t)
;;;(load-theme 'tangotango t)
(load-theme 'doom-one t)

;;; Key Bindings
;; Make M-f to move to the beginning of the next word
(require 'misc)
(define-key global-map (kbd "M-f") (lambda ()
				     (interactive)
				     (forward-to-word 1)))

;; Make M-F move to end of next word
(define-key global-map (kbd "M-F") (lambda ()
				     (interactive)
				     (forward-word)))

;; Web development
(require 'typescript-mode)
(require 'tide)

(defun setup-tide-mode ()
  (interactive)
  (eldoc-mode +1)   ; Show function documentation on hover
  (company-mode +1) ; Auto complete
  (tide-setup))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; Org mode agenda
(define-key org-mode-map (kbd "C-c a") 'org-agenda)

;; Terminal
;;; GPG pin entry
;;; From: https://emacs.stackexchange.com/a/32882
(setq epa-pinentry-mode 'loopback) ; Configure EasyPG assistant to use loopback
								;(pinentry-start) ; Start the pinentry server
(defun my-term () (interactive) (ansi-term "/usr/bin/bash"))
(global-set-key (kbd "C-c C-<return>") 'my-term)

;;; Line wrapping: Unsure, either enables or disables terminal line wrapping
(toggle-truncate-lines 1)

;;; Kill buffer when inferior shell exits
;;; From: https://stackoverflow.com/a/23691628
(defadvice term-handle-exit
  (after term-kill-buffer-on-exit activate)
(kill-buffer))
 
