;;;;;;;;;;;;;;
; Emacs Core ;
;;;;;;;;;;;;;;

; Local plugins
(add-to-list 'load-path "/home/noah/.emacs.d/lisp")

; Initialize package manager
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize) 

; Save all backup files in a dedicated directory
; https://stackoverflow.com/a/2680682
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
)

; Place autosave files in dedicated directory
; https://www.emacswiki.org/emacs/AutoSave
(setq backup-directory-alist
    `(("." . ,(concat user-emacs-directory "backup"))))

; Place customize files in seperate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

; Enable syntax highlighting
(global-font-lock-mode t)

;;;;;;;;;;;;
; Behavior ;
;;;;;;;;;;;;


; Show line numbers
(global-display-line-numbers-mode)

; Max line length
(require 'column-marker)
(add-hook 'text-mode-hook (lambda () (interactive) (column-marker-3 80)))

; Spell check
(add-hook 'text-mode-hook 'flyspell-mode)

; Highlight hex colors
(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode t)))

(my-global-rainbow-mode t)

; New line at end of file
(setq require-final-newline 'visit-save)

; Disable top menu bar in tty mode
(unless (display-graphic-p)
   (menu-bar-mode -1))

; Window movements
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

; Auto indent
(setq auto-indent-on-visit-file t)
(require 'auto-indent-mode)

;;;;;;;;;;;;;
; Languages ;
;;;;;;;;;;;;;

; Salt state
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

; Markdown
(setq markdown-command "/bin/pandoc")

; Go
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

; LaTeX
(require 'px)

;;;;;;;;;;
; Colors ;
;;;;;;;;;;

(set-face-foreground 'font-lock-comment-face "magenta")
