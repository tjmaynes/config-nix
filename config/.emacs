;; --- dot emacs ---
;; Author:  TJ Maynes <tj at tjmaynes dot com>
;; Website: https://tjmaynes.com/

(defun utilities/ensure-file-location-exists (directory filename)
  (let ((file-location (format "%s/%s" directory filename)))
    (unless (file-exists-p file-location)
      (write-region "" nil file-location))
    file-location))

(defun utilities/ensure-program-installed (program)
  (if (not (executable-find program))
      (error (format "Please install missing program: %s" program))))

(defun utilities/ensure-programs-installed (&rest programs)
  (dolist (program programs)
    (utilities/ensure-program-installed (symbol-name program))))

(defun utilities/get-environment-variable (env-name)
  (let ((value (getenv env-name)))
    (if (not value) (error (format "Missing environment variable: %s." env-name)))
    value))

(defun utilities/fail-if-program-does-not-exist (program)
  (if (not (executable-find program))
      (error (concat "Program '"program"' not found; please install!"))))

(defun utilities/pt-pbpaste ()
  "Paste data from pasteboard."
  (interactive)
  (shell-command-on-region
   (point)
   (if mark-active (mark) (point)) "pbpaste" nil t))

(defun utilities/pt-pbcopy ()
  "Copy region to pasteboard."
  (interactive)
  (print (mark))
  (when mark-active
    (shell-command-on-region (point) (mark) "pbcopy")
    (kill-buffer "*Shell Command Output*")))

(defun utilities/read-json-file (json-file)
  (require 'json)
  (let* ((json-object-type 'hash-table)
	 (json-array-type 'list)
	 (json-key-type 'string)
	 (data (json-read-file json-file)))
    data))

(defvar package-manager/package-manager-refreshed nil)

(defun package-manager/package-manager-refresh-once ()
  (when (not package-manager/package-manager-refreshed)
    (setq package-manager/package-manager-refreshed t)
    (package-refresh-contents)))

(defun package-manager/ensure-packages-installed (&rest packages)
  (dolist (package packages)
    (when (not (package-installed-p package))
      (package-manager/package-manager-refresh-once)
      (package-install package))))

(defun package-manager/setup ()
  (setq package-enable-at-startup nil)
  (package-initialize)
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives
	       '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives
	       '("gnu" . "https://elpa.gnu.org/packages/") t))

(defun backup/setup ()
  (package-manager/ensure-packages-installed 'magit)  
  (setq backup-by-copying t
	backup-directory-alist `((".*" . ,temporary-file-directory))
	auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
	delete-old-versions t
	kept-new-versions 6
	kept-old-versions 2
	version-control t))

(defun key-bindings/setup ()
  (global-set-key (kbd "C-c m") 'mu4e)
  (global-set-key (kbd "C-c g") 'magit-status)
  (global-set-key (kbd "C-c p") 'package-list-packages)
  (global-set-key (kbd "C-c 3") 'w3m-goto-url)
  (global-set-key (kbd "C-c n") 'elfeed)
  (global-set-key (kbd "C-c w") 'w3m-browse-url)
  (global-set-key (kbd "C-c t") 'eshell)
  (global-set-key (kbd "C-c r") 'irc)
  (global-set-key (kbd "C-c e p") 'emms-play-directory)
  (global-set-key (kbd "C-c e <left>") 'emms-previous)
  (global-set-key (kbd "C-c e <right>") 'emms-next)
  (global-set-key (kbd "C-c e <up>") 'emms-play)
  (global-set-key (kbd "C-c e <down>") 'emms-stop)
  (global-set-key (kbd "C-c e r") 'emms-streams)
  (global-set-key (kbd "C-c e s") 'emms-shuffle)
  (global-set-key (kbd "C-c e o") 'emms-playlist-mode-go)
  (global-set-key (kbd "C-x <left>") 'windmove-left)
  (global-set-key (kbd "C-x <right>") 'windmove-right)
  (global-set-key (kbd "C-x <up>") 'windmove-up)
  (global-set-key (kbd "C-x <down>") 'windmove-down)
  (global-set-key (kbd "C-x C-i") 'indent-region)
  (global-set-key (kbd "C-u") 'undo)
  (global-set-key (kbd "M-]") 'doc-view-next-page)
  (global-set-key (kbd "M-[") 'doc-view-previous-page)
  (global-set-key (kbd "C-x C-y") 'utilities/pt-pbpaste)
  (global-set-key (kbd "C-x M-w") 'utilities/pt-pbcopy))

(defun development/file-setup ()
  (package-manager/ensure-packages-installed 'json-mode 'yaml-mode 'markdown-mode)
  (setq mode-require-final-newline t)
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))

(defun development/html-setup ()
  (package-manager/ensure-packages-installed 'web-mode)
  (setq web-mode-markup-indent-offset 2
	web-mode-code-indent-offset 2
	web-mode-css-indent-offset 2
	web-mode-enable-auto-pairing t
	web-mode-enable-auto-expanding t
	web-mode-enable-css-colorization t)
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(defun development/elisp-mode-hook ()
  (paredit-mode +1)
  (prettify-symbols-mode +1)
  (show-paren-mode +1))

(defun development/elisp-setup ()
  (package-manager/ensure-packages-installed 'paredit)
  (require 'paredit)
  (add-hook 'emacs-lisp-mode-hook 'development/elisp-mode-hook))

(defun development/clojure-mode-hook ()
  (paredit-mode +1)
  (enable-show-paren-mode)
  (define-key clojure-mode-map (kbd "C-c C-a") 'align-cljlet)
  (dolist (macro '(fresh conde run run* for-all for-map go go-loop
			 for> doseq> fn> defn> defprotocol> gen-for))
    (put-clojure-indent macro 'defun))
  (clj-refactor-mode 1)
  (cljr-add-keybindings-with-prefix "C-c C-v")
  (local-set-key (kbd "RET") 'newline-and-indent))

(defun development/clojure-setup ()
  (package-manager/ensure-packages-installed 'clojure-mode 'cider 'align-cljlet 'paredit 'clj-refactor)
  (setq cider-prompt-for-symbol nil)
  (add-hook 'clojure-mode-hook 'development/clojure-mode-hook)
  (add-hook 'cider-repl-mode-hook 'paredit-mode))

(defun development/devops-setup ()
  (package-manager/ensure-packages-installed 'dockerfile-mode 'k8s-mode))

(defun development/set-exec-path-from-shell-PATH ()
  (let ((path-from-shell
	 (replace-regexp-in-string "[ \t\n]*$" ""
				   (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "SHELL" "/bin/zsh")
    (setenv "PATH" path-from-shell)
    (setq exec-path (append exec-path '("/usr/local/bin"))
	  eshell-path-env path-from-shell
	  exec-path (split-string path-from-shell path-separator))))

(defun development/general-setup ()
  (package-manager/ensure-packages-installed 'auto-complete)
  (ac-config-default))

(defun development/nix-setup ()
  (package-manager/ensure-packages-installed 'nix-mode)
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(defun development/setup ()
  (development/general-setup)
  (development/file-setup)
  (development/html-setup)
  (development/elisp-setup)
  (development/clojure-setup)
  (development/devops-setup)
  (development/nix-setup))

(defun theme/gui-setup ()
  (package-manager/ensure-packages-installed 'circadian 'solarized-theme)
  (setq circadian-themes '(("8:00" . solarized-light)
			   ("19:30" . solarized-dark)))
  (circadian-setup))

(defun theme/cli-setup ()
  (package-manager/ensure-packages-installed 'zenburn-theme)
  (load-theme 'zenburn t))

(defun theme/default-setup ()
  (setq inhibit-splash-screen t
	initial-scratch-message ""
	mac-allow-anti-aliasing t
	scroll-step 1000
	scroll-conservatively 1000
	redisplay-dont-pause t
	scroll-preserve-screen-position 1
	ring-bell-function 'ignore
	display-time-day-and-date t
	ns-use-proxy-icon nil
	frame-title-format nil
	default-frame-alist '((font . "Inconsolata-12")))
  (ido-mode t)
  (fset 'yes-or-no-p 'y-or-n-p)
  (display-time)
  (menu-bar-mode -1)
  (tool-bar-mode -1))

(defun theme/setup ()
  (theme/default-setup)
  (if (display-graphic-p)
      (theme/gui-setup)
    (theme/cli-setup)))

(defun chat/connect (password)
  (package-manager/ensure-packages-installed 'erc)
  (let* ((config (utilities/read-json-file "~/.emacs.json"))
	 (chat-config (gethash "chat" config))
	 (chat-directory (gethash "directory" chat-config))
	 (rooms (gethash "rooms" chat-config))
	 (server (gethash "server" chat-config))
	 (port (gethash "port" chat-config))
	 (nickname (gethash "nickname" chat-config))
	 (fullname (gethash "fullname" chat-config))
	 (userid (gethash "userid" chat-config)))
    (setq erc-enable-logging t
	  erc-kill-buffer-on-part t
	  erc-log-channels-directory chat-directory
	  erc-save-buffer-on-part nil
	  erc-save-queries-on-quit nil
	  erc-log-write-after-send t
	  erc-log-write-after-insert t
	  erc-autojoin-channels-alist rooms)
    (erc-fill-mode t)
    (erc-scrolltobottom-mode t)
    (erc-tls :server server :port port :password password
	     :nick nickname :full-name fullname)))

(defun writing/org-setup ()
  (package-manager/ensure-packages-installed 'org 'org-journal)
  (setq initial-major-mode 'org-mode
	org-startup-truncated nil)
  (setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")
  (setq org-capture-templates
	'(("t" "Todo" entry (file org-default-notes-file)
	   "* TODO %?\n%u\n%a\n" :clock-in t :clock-resume t)
	  ("m" "Meeting" entry (file org-default-notes-file)
	   "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
	    ("i" "Idea" entry (file org-default-notes-file)
	     "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
	    ("n" "Next Task" entry (file+headline org-default-notes-file "tasks")
	     "** NEXT %? \nDEADLINE: %t")))
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	  (sequence "WAITING(w@/!)" "INACTIVE(i@/!)" "|" "CANCELLED(c@/!)" "MEETING")))
  (setq org-todo-state-tags-triggers
	'(("CANCELLED" ("CANCELLED" . t))
	  ("WAITING" ("WAITING" . t))
	  ("INACTIVE" ("WAITING") ("INACTIVE" . t))
	  (done ("WAITING") ("INACTIVE"))
	  ("TODO" ("WAITING") ("CANCELLED") ("INACTIVE"))
	  ("NEXT" ("WAITING") ("CANCELLED") ("INACTIVE"))
	  ("DONE" ("WAITING") ("CANCELLED") ("INACTIVE"))))
  (setq org-todo-keyword-faces
	'(("TODO" :foreground "red" :weight bold)
	    ("NEXT" :foreground "blue" :weight bold)
	    ("DONE" :foreground "forest green" :weight bold)
	    ("WAITING" :foreground "orange" :weight bold)
	    ("INACTIVE" :foreground "magenta" :weight bold)
	    ("CANCELLED" :foreground "forest green" :weight bold)
	    ("MEETING" :foreground "forest green" :weight bold))))

(defun writing/spellchecker-setup ()
  (setq ispell-program-name "aspell"
	ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")
	ispell-personal-dictionary "")
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
  (add-to-list 'ispell-skip-region-alist '("#\\+begin_src" . "#\\+end_src"))
  (add-to-list 'ispell-skip-region-alist '("#\\+begin_quote" . "#\\+end_quote")))

(defun writing/latex-setup ()
  (setq latex-run-command "tex")
  (setq-default TeX-engine 'xetex
		TeX-PDF-mode t))

(defun writing/setup ()
  (writing/org-setup)
  (writing/spellchecker-setup)
  (writing/latex-setup))

(defun media/music-setup ()
  (utilities/ensure-programs-installed 'mpv)
  (package-manager/ensure-packages-installed 'emms)
  (setq
   emms-player-list '(emms-player-mpv)
   emms-info-asynchronously t
   emms-show-format "♪ %s"
   emms-playlist-default-major-mode 'emms-playlist-mode)
  (emms-standard)
  (emms-default-players))

(defun media/rss-feed-setup ()
  (package-manager/ensure-packages-installed 'elfeed 'elfeed-web)
  (setq elfeed-search-filter "-junk @6-months-ago +unread"
	elfeed-feeds '(("https://nullprogram.com/feed/" emacs)
		       ("https://www.cinephiliabeyond.org/feed/" filmmaking)
		       ("https://kubernetes.io/feed.xml" kubernetes)
		       ("https://blog.rust-lang.org/feed.xml" rust)
		       ("https://sachachua.com/blog/category/emacs/feed" emacs)
		       ("https://blog.printf.net/feed/" decentralized)
		       ("https://emacs.cafe/feed.xml" emacs)
		       ("https://endlessparentheses.com/atom-planet.xml" emacs))))

(defun media/ebook-setup ()
  (package-manager/ensure-packages-installed 'nov)
  (setq nov-text-width 80
	nov-text-width t)
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (add-hook 'nov-mode-hook (lambda ()
			     (face-remap-add-relative 'variable-pitch
						      :family "Liberation Mono"
						      :height 1.0)))
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'visual-fill-column-mode))

(defun media/setup ()
  (media/music-setup)
  (media/rss-feed-setup)
  (media/ebook-setup))

(defun web-browser/setup ()
  (package-manager/ensure-packages-installed 'w3m)
  (setq w3m-coding-system 'utf-8
	w3m-file-coding-system 'utf-8
	w3m-file-name-coding-system 'utf-8
	w3m-input-coding-system 'utf-8
	w3m-output-coding-system 'utf-8
	w3m-terminal-coding-system 'utf-8
	browse-url-browser-function 'w3m-goto-url-new-session))

(defun version-control/clone-repo (repo destination)
  (let* ((path (concat destination "/" repo))
	 (clone-command (format "git clone git@github.com:%s.git %s && cd %s" repo path path)))
    (if (not (file-directory-p path))
	(shell-command clone-command))))

(defun version-control/setup (version-control-config)
  (let ((repos (gethash "repos" version-control-config))
	(directory (gethash "directory" version-control-config)))
    (require 'seq)
    (seq-map '(lambda (repo) (version-control/clone-repo repo directory)) repos)))

(defun initialize () 
  (development/set-exec-path-from-shell-PATH)
  (package-manager/setup)
  (theme/setup)
  (key-bindings/setup)
  (backup/setup)
  (web-browser/setup)
  (development/setup)
  (writing/setup)
  (media/setup))

(initialize)
