(package-initialize)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

;;default.el
(setq inhibit-default-init t)

;;起動時のメッセージを非表示
(setq inhibit-startup-screen t)

;;バックアップ作成させない
(setq backup-inhibited t)

;;終了時自動保存ファイルを削除
(setq delete-auto-save-files t)

;;末尾の余計な改行を消す
(setq next-line-add-newlines nil)

;;バックスラッシュ
(global-set-key [?¥] [?\\])

;;時間を表示
(display-time)

;;行番号
(line-number-mode 1)
(column-number-mode 1)
;;(global-linum-mode t)

;;対応する括弧の強調
(setq show-paren-delay 0)
(show-paren-mode t)

;;選択範囲の可視化
(setq-default transient-mark-mode t)

;;折り返し表示
(setq truncate-lines t)

;;yes-noをy-nに
(fset 'yes-or-no-p 'y-or-n-p)

;;beep音
(defun my-bell-function ()
  (unless (memq this-command
		'(isearch-abort abort-recursive-edit exit-minibuffer
				keyboard-quit mwheel-scroll down up
				next-line previous-line backward-char
				forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;;メタキーをOptionに
(setq mac-option-modifier 'meta)

;;Cask
(when (require 'cask  nil t)
  (cask-initialize))

;;GDB/GUD
(defvar gud-gdb-history (list "gdb --annnotate=3 "))
(setq gdb-many-windows t)
(setq gdb-use-sparate-io-buffer t)

(add-hook 'gdb-mode-hook
	  '(lambda ()
	     (gud-tooltip-mode t) ;;mauseover時に値を表示
	     (gud-break-main nil)
	     (gud-run nil)))

;;helm
(when (require 'helm-config nil t)
  (helm-mode 1)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-M-z") 'helm-resume)
  ;;自動補完を無効にしTABで手動補完
  (custom-set-variables '(helm-ff-auto-update-initial-value nil))
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char))
(when (require 'helm-ack nil t)
  (setq helm-c-ack-version 2)
  (setq helm-c-ack-auto-set-filetype nil)
  (setq helm-c-ack-thing-at-point 'symbol)
  (global-set-key (kbd "C-x g") 'helm-ack))

(when (require 'helm-c-moccur nil t)
  (setq helm-c-moccur-helm-idle-delay 0.1)
  (setq helm-c-moccur-higligt-info-line-flag t)
  (setq helm-c-moccur-enable-auto-look-flag t)
  (setq helm-c-moccur-enable-initial-pattern t)

  ;;バッファ内検索
  (define-key global-map (kbd "M-o") 'helm-c-moccur-occur-by-moccur)
  ;;ディレクトリ
  (define-key global-map (kbd "M-d") 'helm-c-moccur-dmoccur)
  ;;現在選択中の候補の位置を他のwindowに表示する
  (define-key global-map (kbd "s-o") 'helm-c-moccur-buffer-list)
  (define-key isearch-mode-map (kbd "M-o") 'helm-c-moccur-from-isearch)
)

(when (require 'helm-gtags nil t)
  (add-hook 'helm-gtags-mode-hook
	    '(lambda ()
	       (setq helm-gtags-ignore-case t)
	       (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
	       (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
	       (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
	       (local-set-key (kbd "C-q") 'helm-gtags-pop-stack)
	       (local-set-key (kbd "C-c C-f") 'helm-gtags-find-file))))

(when (require 'helm-etags+ nil t)
  (global-set-key (kbd "M-.") 'helm-etags+-select)
  (global-set-key (kbd "M-*") 'helm-etags+-history-go-back))

;;yasnippet
(when (require 'yasnippet nil t)
  (setq yas-snippet-dirs
       '("~/.emacs.d/local/yasnippet/snippets"
	 "~/.emacs.d/elisp/yasnippet/snippets"
	 ))
  (yas-global-mode t))

;;highlight
;(add-to-list 'load-path "~/.emacs.d/vendor/Highlight-Indentation-for-Emacs")
(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#95799E")
(add-hook 'highlight-indentation-mode-hook 'highlight-indentation-current-column-mode)

;;auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-modes 'markdown-mode)
  (add-to-list 'ac-modes 'js2-mode)
  (add-to-list 'ac-modes 'web-mode)
  (add-to-list 'ac-modes 'enh-ruby-mode)
  (ac-config-default)
  (setq ac-auto-start 4)
  (setq ac-dwim t)
  (setq ac-use-menu-map t)
  (setq ac-comphist-file "~/.emacs.d/local/ac-comphist.dat")
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict"))

;markdown-mode
(when (require 'markdown-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode)))

;;matlab-mode
(when (require 'matlab-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.m$" . matlab-mode)))

;web-mode
(when (require 'web-mode nil t)
  (setq php-mode-force-pear t)
  (add-to-list 'auto-mode-alist '("\\.html$" . web-mode)))

(when (require 'web-mode nil t)
  (setq php-mode-force-pear t)
  (add-to-list 'auto-mode-alist '("\\.htm$" . web-mode)))

(when (require 'web-mode nil t)
  (setq php-mode-force-pear t)
  (add-to-list 'auto-mode-alist '("\\.php$" . web-mode)))

(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))

(add-hook 'web-mode-hook 'web-mode-hook)

(add-hook 'php-mode-hook
	  (lambda ()
	    (when (require 'php-completion)
	      (php-completion-mode t)
	      (define-key php-mode-map (kbd "C-o") 'phpcmp-comlete)
	      (make-local-variable 'ac-sources)
	      (setq ac-sources '(
				 ac-source-words-in-same-mode-buffers
				 ac-source-php-completion
				 ac-source-filename
				 )))))

;;yatex
(add-to-list 'load-path "~/.emacs.d/site-lisp/yatex")
;; YaTeX mode
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")
;; use Preview.app
(setq dvi2-command "open -a Preview")
(setq bibtex-command "pbibtex")
		  
;;python-mode
(when (require 'python-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode)))

(add-hook 'python-mode-hook 'highlight-indentation-mode)
;;jedi
(add-hook 'python-mode-hook
	  'jedi:setup
	  'py-autopep8-enable-on-save
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (setq indent-level 4)
	     (setq python-indent 4)
	     (setq tab-width 4)
	     (define-key python-mode-map (kbd "RET") 'newline-and-indent)
	     ))
(setq jedi:complete-on-dot t)

;;docstring comment
;; C-c dで関数のコメントを作成
(defun python-docstring-comment()
  (interactive)
  (let* ((begin-point (point-at-bol))
	 (end-point (point-at-eol))
	 (function-line (buffer-substring begin-point end-point))
	 (space (format "    %s" (replace-regexp-in-string "def.*" "" function-line))))
    (goto-char end-point)
    (insert "\n")
    (insert (format "%s\"\"\"\n" space))
    (when (string-match ".*(\\(.+\\)):" function-line)
      (dolist (arg (split-string (match-string 1 function-line) ","))
	(if (not (equal arg "self"))
	    (insert (format "%s:param TYPE %s:\n" space (replace-regexp-in-string "^\\s-+\\|\\s-+$" "" arg))))))
    (insert (format "%s:rtype: TYPE\n" space))
    (insert (format "%s\"\"\"" space))))

(define-key python-mode-map (kbd "C-c d") 'python-docstring-comment)

;;autopep8
(require 'tramp-cmds)
(when (load "flymake" t)
  (defun flymake-pyflakes-init()
    (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
			 'flymake-create-temp-inplace))
	     (local-file (file-relative-name
			  temp-file
			  (file-name-directory buffer-file-name))))
	(list "pyflakes" (list local-file)))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pyflakes-init)))

(add-hook 'python-mode-hook
	  (lambda ()
	    (flymake-mode t)))
