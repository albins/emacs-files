
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Settings for synchronous communication (jabber/IRC) ;;
;; secrets.el MUST BE LOADED                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'secrets)

;;;;;;;;;;;;
;; Jabber ;;
;;;;;;;;;;;;

(require 'jabber)

;;(add-to-list 'load-path "~/projects/repos/emacs-jabber/")
;; (eval-after-load 'jabber '(require 'jabber-libnotify))

(eval-after-load 'jabber
  '(jabber-keepalive-start))

(setq jabber-auto-reconnect t
      jabber-chat-buffer-format "%n"
      jabber-chat-time-format "%H:%M:%S"
      jabber-debug-keep-process-buffers t
      jabber-history-enable-rotation t
      jabber-history-enabled t
      jabber-roster-buffer "*jabber*" 
      jabber-roster-line-format "%c %-25n %u %-8s  %S"
      jabber-show-resources nil
      jabber-use-global-history nil
      jabber-vcard-avatars-retrieve t
      jabber-chat-fill-long-lines nil)


(add-hook 'jabber-post-connect-hooks 'jabber-keepalive-start)
(add-hook 'jabber-post-connect-hooks 'jabber-autoaway-start)

;; Neat quotes:
(add-hook 'jabber-chat-mode-hook 'guillemets-mode)

;; I can't spell:
(add-hook 'jabber-chat-mode-hook 'flyspell-mode)


;;;;;;;;;;;;;;;;;;;
;; End of Jabber ;;
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
;; Begin ERC code ;;
;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path "~/projects/repos/erc/")
;; (require 'erc)
;; (require 'erc-stamp)
;; (require 'erc-bbdb)
;; (require 'erc-button)
;; (require 'erc-fill)
;; (require 'erc-match)
;; (require 'erc-netsplit)
;; (require 'erc-networks)
;; (require 'erc-ring)
;; (require 'erc-stamp)
;; (require 'erc-track)
;; (require 'erc-imenu)


;; Code to connect and identify with my ZNC bouncer
;; (defun irc-bnc ()
;;   "Connect to ZNC bouncer via ERC, specified by variable znc-accounts"
;;   (interactive)
;;   (dolist (account znc-accounts)
;;     (let ((account-name (car account))
;;           (account-plist (cadr account)))
;;       (cond ((plist-get account-plist 'ssl)
;;              (erc-tls ;; replace with erc-ssl
;;               :server (plist-get account-plist 'hostname)
;;               :port (plist-get account-plist 'port)
;;               :nick (plist-get account-plist 'username)
;;               :password (format "%s:%s" 
;;                                 (plist-get account-plist 'username) 
;;                                 (plist-get account-plist 'password))))
;;             (t 
;;              (erc
;;               :server (plist-get account-plist 'hostname)
;;               :port (plist-get account-plist 'port)
;;               :nick (plist-get account-plist 'username)
;;               :password (format "%s:%s" 
;;                                 (plist-get account-plist 'username) 
;;                                 (plist-get account-plist 'password))))))))
     
;; (setq erc-auto-query 'window-noselect)

;; ;;Pretty timestamps (defunct?)
;; (setq erc-insert-timestamp-function 'erc-insert-timestamp-left
;;       erc-timestamp-format "(%H:%M:%S) "
;;       erc-timestamp-only-if-changed-flag nil
;;       erc-hide-timestamps nil)

;; ;; Clean up
;; (setq erc-kill-server-buffer-on-quit t
;;       erc-kill-buffer-on-part t
;;       erc-kill-queries-on-quit t)

;; ;; Channel-specific prompt:
;; (setq erc-prompt (lambda
;;                    ()
;;      (if (and (boundp 'erc-default-recipients) (erc-default-target))
;;          (erc-propertize (concat (erc-default-target) ">") 'read-only t 'rear-nonsticky t 'front-nonsticky t)
;;        (erc-propertize (concat "ERC>") 'read-only t 'rear-nonsticky t 'front-nonsticky t))))

;; (setq erc-server-reconnect-timeout 4
;;       erc-server-reconnect-attempts 3
;;       erc-current-nick-highlight-type 'nick
;;       erc-track-exclude-types '("PART" "QUIT" "NICK" "MODE" "324" "329" "332" "333" "353" "477")
;;       erc-track-use-faces t
;;       erc-track-faces-priority-list '(erc-current-nick-face erc-keyword-face)
;;       erc-track-priority-faces-only 'all
;;       erc-hide-list '("JOIN" "PART" "QUIT" "NICK")
;;       erc-modules '(autojoin bbdb button completion fill irccontrols list match
;;                               move-to-prompt netsplit networks noncommands readonly ring stamp track))

     

;; (defface erc-header-line-disconnected
;;   '((t (:foreground "black" :background "indianred")))
;;   "Face to use when ERC has been disconnected.")
 
;; (defun erc-update-header-line-show-disconnected ()
;;   "Use a different face in the header-line when disconnected."
;;   (erc-with-server-buffer
;;     (cond ((erc-server-process-alive) 'erc-header-line)
;;           (t 'erc-header-line-disconnected))))
;;           (setq erc-header-line-face-method 'erc-update-header-line-show-disconnected)
 
;; (setq erc-header-line-face-method 'erc-update-header-line-show-disconnected)

(defun kill-all-ii-buffers()
      "Kill all ii-mode buffers."
      (interactive)
      (save-excursion
        (let((count 0))
          (dolist(buffer (buffer-list))
            (set-buffer buffer)
            (when (equal major-mode 'ii-mode)
              (setq count (1+ count))
              (kill-buffer buffer)))
          (message "Killed %i ii buffer(s)." count ))))


(defun kill-all-erc-buffers()
      "Kill all erc buffers."
      (interactive)
      (save-excursion
        (let((count 0))
          (dolist(buffer (buffer-list))
            (set-buffer buffer)
            (when (equal major-mode 'erc-mode)
              (setq count (1+ count))
              (kill-buffer buffer)))
          (message "Killed %i ERC buffer(s)." count ))))

(defun kill-all-jabber-buffers()
      "Kill all jabber buffers."
      (interactive)
      (save-excursion
        (let((count 0))
          (dolist(buffer (buffer-list))
            (set-buffer buffer)
            (when  (or (equal major-mode 'jabber-chat-mode)
                       (equal major-mode 'jabber-roster-mode))
              (setq count (1+ count))
              (kill-buffer buffer)))
          (message "Killed %i Jabber buffer(s)." count ))))

(add-hook 'jabber-post-disconnect-hook 'kill-all-jabber-buffers)
(add-hook 'ii-mode-hook 'guillemets-mode)

(setq ii-completing-read 'ido-completing-read)
(setq ii-censor nil)


;; Auto-change Erc filling to fit window:
;; (add-hook 'window-configuration-change-hook 
;;  	  '(lambda ()
;;  	     (setq erc-fill-column (abs (- (window-width) 1)))))

;; Notify my when someone mentions my nick.
;; (defun erc-global-notify (matched-type nick msg)
;;   (interactive)
;;   (when (eq matched-type 'current-nick)
;;     (shell-command
;;      (concat "notify-send --icon /usr/share/xfm/pixmaps/emacs.xpm -t 4000 -c \"im.received\" \""
;;              (car (split-string nick "!"))
;;              " mentioned your nick\" '"
;;              msg
;;              "'"))))

;; (add-hook 'erc-text-matched-hook 'erc-global-notify)

;;;;;;;;;;;;;;;;;;;;;
;; END of ERC code ;;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
;; Functions (meta) ;;
;;;;;;;;;;;;;;;;;;;;;;

(defun net-start ()
  "Connect to internet-facing services i.e. IRC and Jabber"
  (interactive)
  (jabber-connect-all)
  (jabber-send-presence "" "" 10)) ;;this is an ugly hack; jabber don't seem to
;;connect unless we tell it to set a presence.


(defun net-stop ()
  "Disconnect from internet-facing services and kill
   all ERC buffers still lying around."
  (interactive)
  (when (functionp 'jabber-disconnect)
    (jabber-disconnect))
  (kill-all-ii-buffers))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End functions (meta) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'ii-mode)
(setf ii-irc-directory "/home/albin/irc/")
(add-to-list 'auto-mode-alist `(,(concat ii-irc-directory ".*/out\\'") . ii-mode))

(set-face-attribute 'ii-face-nick nil :foreground "chocolate2")
(set-face-attribute 'ii-face-date nil :foreground "#999")
(set-face-attribute 'ii-face-time nil :foreground "#bbb")
(set-face-attribute 'ii-face-give-voice nil :foreground "#0ff")
(set-face-attribute 'ii-face-take-voice nil :foreground "#f0f")
(set-face-attribute 'ii-face-shadow nil :foreground "#ccc")
(set-face-attribute 'ii-face-prompt nil :foreground "#0f0")
(set-face-attribute 'ii-face-msg nil :foreground "#0000") 
(set-face-attribute 'ii-face-bold nil :bold t)
(set-face-attribute 'ii-face-underline nil :underline t)

(setf ii-notify-regexps '(".*>.*\\balbins\\b"
                          ".*>.*\\s+albins\\b"))

(global-set-key (kbd "C-x  C-v") 'ii-visit-notified-file)
