;; Set custom path locations
(setenv "PATH" (concat (getenv "PATH") ":" "/usr/local/bin"))
(setq ispell-program-name "/usr/bin/aspell")
(add-to-list 'exec-path "/usr/local/bin")
