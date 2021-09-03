								; Plugins
;; Local plugins
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Built in package manager
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

;; Use Package
(eval-when-compile
  (require 'use-package))

;; Place customize files in seperate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

								; Layout
;; Enable syntax highlighting
(global-font-lock-mode t)

;; Font
(setq default-frame-alist '((font . "Hack-12")))
(set-face-attribute 'default nil :height 80)

;; Tab width
(setq-default tab-width 5)

								; Colors
;;;(load-theme 'zenburn t)
;;;(load-theme 'tangotango t)
(load-theme 'doom-one t)
;(set-face-foreground 'font-lock-comment-face "green")

								; Behavior
;; Auto Save
;;; Save all backup files in a dedicated directory
;;; https://stackoverflow.com/a/2680682
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
)

;;; Place autosave files in dedicated directory
;;; https://www.emacswiki.org/emacs/AutoSave
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backup"))))

;; C-<return> = Exit search at beginning of match
(define-key isearch-mode-map [(control return)]
  #'isearch-exit-other-end)
(defun isearch-exit-other-end ()
  "Exit isearch, at the opposite end of the string."
  (interactive)
  (isearch-exit)
  (goto-char isearch-other-end))

;; Editor config
(editorconfig-mode 1)

;; Line numbers
(global-linum-mode)

;; Max line length
;;; (use-package column-marker)
;;; (add-hook 'text-mode-hook (lambda () (interactive) (column-marker-3 80)))
;;; (add-hook 'go-mode-hook (lambda () (interactive) (column-marker-3 80)))

;; Spell check
(add-hook 'text-mode-hook 'flyspell-mode)

;; Highlight hex colors
(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
 (lambda () (rainbow-mode t)))

(my-global-rainbow-mode t)

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

;; Transpose split windows
(global-set-key (kbd "C-x /") 'transpose-frame);(lambda () (interactive) (transpose-frame)))

;; Auto indent
;; (setq auto-indent-on-visit-file t)
;; (require 'auto-indent-mode)

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

;; C-x x Save and kill buffer
(defun save-and-kill-buffer ()
  "Save and kill a buffer, similar to save-buffers-kill-terminal but only kills the
current buffer."
  (interactive)
  (progn (save-buffer)
	    (kill-buffer)))
(global-set-key (kbd "C-c x") 'save-and-kill-buffer)

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
;; (setq org-agenda-files (list (expand-file-name "~/documents/notebook.org")))
(setq org-agenda-files
	 (mapcar 'expand-file-name
		    (list
			"~/documents/planner.org"
			"~/documents/school/y5/afroam/afroam-133/planner.org"
			"~/documents/school/y5/afroam/afroam-133/lectures.org"
			"~/documents/school/y5/afroam/afroam-133/reading.org"
			"~/documents/school/y5/cs/cs-alligator/planner.org"
			"~/documents/school/y5/cs/cs-370/planner.org"
			"~/documents/school/y5/spanish/spanish-240/planner.org"
			"~/documents/school/y5/cs/cics-305/planner.org" 
			"~/documents/school/y5/cs/cs-590a/planner.org")))
(setq org-todo-keywords
	 '((sequence "TODO" "DOING" "PAUSED" "|" "DONE" "ABANDONED")))

(setq org-tempo-keywords-alist
	 '(("L" . "latex")
	  ("H" . "html")
	  ("A" . "ascii")
	  ("i" . "index")
	  ("s" . "src")))

;; Organize buffers by project
;; (projectile-mode +1)
;; (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Ensure not garbage collecting too quickly
;;; I found in large org mode files the input lag was very high. After googling I found out that this is bc Emacs was garbage collecting after every keystroke. This Reddit post suggested setting a minimum time of 5 seconds between gc rounds and setting a higher memory cap.
;;; Original googled Reddit post: https://www.reddit.com/r/emacs/comments/6uhzc9/very_slow_org_mode/
;;; Linked to this comment: https://www.reddit.com/r/emacs/comments/6uhzc9/very_slow_org_mode/dlwyzmg/
;;; Links to this og Reddit post: https://www.reddit.com/r/emacs/comments/55ork0/is_emacs_251_noticeably_slower_than_245_on_windows/d8cmm7v/
(setq gc-cons-threshold (* 511 1024 1024))
(setq gc-cons-percentage 0.5)
(run-with-idle-timer 5 t #'garbage-collect)

;; Terminal
(defun my-term () (interactive) (ansi-term (substitute-env-vars "$SHELL")))
(global-set-key (kbd "C-c C-<return>") 'my-term)

;;; Kill buffer when inferior shell exits
;;; From: https://stackoverflow.com/a/23691628
(defadvice term-handle-exit
  (after term-kill-buffer-on-exit activate)
(kill-buffer))
 
;;; Shell management
(require 'shell-switcher)
(setq shell-switcher-mode t)
(setq-default shell-switcher-new-shell-function 'my-term)

;;; Hide line numbers
(add-hook 'term-mode-hook
		(lambda () (linum-mode 0)))
(setq term-suppress-hard-newline t)

;; VTerm
;;; Trying out to see how it is
(use-package vterm
  :ensure t)

;; Git integration
(use-package magit
  :ensure t)

;; Dired
(use-package dired-avfs
  :ensure t)
(use-package dired-subtree
  :ensure t)

								; Programming Languages
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

								; Key Bindings
;; Make M-f to move to the beginning of the next word
(require 'misc)
(define-key global-map (kbd "M-f") (lambda ()
				     (interactive)
				     (forward-to-word 1)))

;; Make M-F move to end of next word
(define-key global-map (kbd "M-F") (lambda ()
				     (interactive)
				     (forward-word)))

;; Org mode agenda
(define-key org-mode-map (kbd "C-c a") 'org-agenda)
