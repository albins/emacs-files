(setq warning-suppress-types nil) ;; workaround compile errors
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mail client/reader settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq mm-text-html-renderer 'w3m) ;; Render html mail with w3m

(require 'mime-w3m)

(setq user-mail-address "albin@eval.nu"
      user-full-name "Albin Stjerna")

;; SMTP

(setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info nil ; change to nil once it works
      smtpmail-debug-verb nil)

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it)

(require 'starttls)

;; END SMTP

(setq mime-w3m-safe-url-regexp nil
       mm-w3m-safe-url-regexp nil) ;; Don't bother.
(setq mime-w3m-display-inline-images t) ;; Yes, do render inline images
(setq mm-inline-text-html-with-images t)

;; (add-hook 'notmuch-show-hook (lambda ()
;;                                (if (member "feeds" (notmuch-show-get-tags))
;;                                    (setq mm-w3m-safe-url-regexp   nil
;;                                          mime-w3m-safe-url-regexp nil)
;;                                  (setq mm-w3m-safe-url-regexp     "\\`cid:"
;;                                        mime-w3m-safe-url-regexp   "\\`cid:"))))


;; Mu-cite, for less ugly citations.
(autoload 'mu-cite-original "mu-cite" nil t)
(setq mu-cite-prefix-format '("> "))
(setq mu-cite-top-format '(full-name " wrote:\n\n"))
(add-hook 'mail-citation-hook (function mu-cite-original))

;;;;;;;;;;
;; BBDB ;;
;;;;;;;;;;

(setq bbdb-file "~/.emacs.d/bbdb")           ;; keep ~/ clean; set before loading
(require 'bbdb) 
(bbdb-initialize)
(setq 
 bbdb-offer-save 1                        ;; 1 means save-without-asking
 bbdb-use-pop-up t                        ;; allow popups for addresses
 bbdb-electric-p t                        ;; be disposable with SPC
 bbdb-popup-target-lines  1               ;; very small 
 bbdb-dwim-net-address-allow-redundancy t ;; always use full name
 bbdb-quiet-about-name-mismatches 2       ;; show name-mismatches 2 secs
 bbdb-always-add-address t                ;; add new addresses to existing...
                                          ;; ...contacts automatically
 bbdb-canonicalize-redundant-nets-p t     ;; x@foo.bar.cx => x@bar.cx
 bbdb-completion-type nil                 ;; complete on anything
 bbdb-complete-name-allow-cycling t       ;; cycle through matches
                                          ;; this only works partially
 bbbd-message-caching-enabled t           ;; be fast
 bbdb-use-alternate-names t               ;; use AKA
 bbdb-elided-display t                    ;; single-line addresses
                                          ;; auto-create addresses from mail
 bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook
 bbdb-ignore-some-messages-alist          ;; don't ask about fake addresses
 ;; NOTE: there can be only one entry per header (such as To, From)
 ;; http://flex.ee.uec.ac.jp/texi/bbdb/bbdb_11.html

 '(( "From" . "no.?reply\\|DAEMON\\|daemon\\|facebookmail\\|twitter")))

(add-hook 'mail-mode-hook 'mail-abbrevs-setup)

;; Notmuch code:
(require 'notmuch)

;; use remote notmuch on motoko
(if (string-equal (system-name) "motoko.student.uu.se")
    (setq notmuch-command "/home/albin/.bin/notmuch-net.sh"))

(setq mail-user-agent 'message-user-agent
      message-directory "~/inmail/Gmail/"
      notmuch-fcc-dirs "/home/albin/inmail/Gmail/Sent")

;; notmuch-fcc-dirs (quote (("Sent")))

;; add Cc and Bcc headers to the message buffer
(setq message-default-mail-headers "Cc: \nBcc: \n")

;; postponed message is put in the following draft file
;;(setq message-auto-save-directory "~/inmail/Main/Drafts")

(setq message-send-mail-function 'message-smtpmail-send-it)
(setq send-mail-function 'smtpmail-send-it)

(add-hook 'message-mode-hook (lambda () (visual-line-mode 1)))
(add-hook 'message-mode-hook 'turn-off-auto-fill)
(add-hook 'message-mode-hook (lambda () (guillemets-mode 1)))
(add-hook 'message-mode-hook 'flyspell-mode)
(add-hook 'message-mode-hook 'footnote-mode)

;;(add-hook 'notmuch-show-hook 'offlineimap)

;;sign messages by default
;;(add-hook 'message-setup-hook 'mml-secure-sign-pgpmime)

(setq notmuch-saved-searches '(("personal" . "tag:personal and tag:inbox")
                               ("feeds" . "tag:feeds and tag:inbox")
                               ("Google+" . "tag:googleplus and tag:inbox")
                               ("Facebook" . "tag:facebook and tag:inbox")
                               ("identica" . "tag:identica and tag:inbox")
                               ("local" . "tag:local and tag:inbox")
                               ("list" . "tag:list and tag:inbox and not tag:notmuch")
                               ("notmuch" . "tag:inbox and tag:notmuch")
                               ("read/review" . "tag:read/review and not tag:BiF")
                               ("BiF" . "tag:BiF and tag:inbox")
                               ("Wine" . "tag:wine and tag:inbox")
                               ("Jobb" . "tag:jobb and tag:inbox")
                               ("BiF read/review" . "tag:BiF and tag:read/review")
                               ("waiting" . "tag:waiting")))



;;(execute-kbd-macro (symbol-function 'notmuch-todo)) ;; bind this to
;;T i notmuch-search-mode-map

(defun notmuch-search-read/review ()
  (interactive)
  (notmuch-search-add-tag "read/review")
  (notmuch-search-archive-thread))

(defun notmuch-search-unread/review ()
  (interactive)
  (notmuch-search-remove-tag "read/review")
  (notmuch-search-archive-thread))

(defun notmuch-show-read/review ()
  (interactive)
  (notmuch-show-add-tag "read/review")
  (notmuch-show-archive-thread))

(defun notmuch-show-unread/review ()
  (interactive)
  (notmuch-show-remove-tag "read/review")
  (notmuch-show-archive-thread))

(defun notmuch-show-toggle-recommend ()
  (interactive)
  (if (member "rek" (notmuch-show-get-tags))
      (notmuch-show-remove-tag "rek")
    (notmuch-show-add-tag "rek")
    (notmuch-show-unread/review)))

(defun notmuch-show-toggle-waiting ()
  (interactive)
  (if (member "waiting" (notmuch-show-get-tags))
      (notmuch-show-remove-tag "waiting")
    (notmuch-show-add-tag "waiting")
    (notmuch-show-unread/review)))

(defun notmuch-search-toggle-waiting ()
  (interactive)
  (if (member "waiting" (notmuch-search-get-tags))
      (notmuch-search-remove-tag "waiting")
    (notmuch-search-add-tag "waiting")
    (notmuch-search-unread/review)))


(define-key notmuch-search-mode-map "T" 'notmuch-search-read/review)
(define-key notmuch-search-mode-map "U" 'notmuch-search-unread/review)
(define-key notmuch-search-mode-map "w" 'notmuch-search-toggle-waiting)
(define-key notmuch-show-mode-map "w" 'notmuch-show-toggle-waiting)
(define-key notmuch-show-mode-map "T" 'notmuch-show-read/review)
(define-key notmuch-show-mode-map "U" 'notmuch-show-unread/review)
(define-key notmuch-show-mode-map "R" 'notmuch-show-toggle-recommend)
(define-key notmuch-show-mode-map "\C-c\C-o" 'w3m-view-url-with-external-browser)

;; Integrate notmuch with org-mode's agenda view:
;; (add-hook 'org-finalize-agenda-hook (lambda ()
;;                                       (notmorg-write-file "/home/albin/org/notmorg.org" '("todo" t) "sched")))

(setq ks-monthnames-lastfm "")

;;(add-hook 'message-mode-hook 'tach-minor-mode)

(eudc-set-server "localhost" 'bbdb t)
(eudc-protocol-set 'eudc-inline-expansion-format 
		   '("%s %s <%s>" firstname lastname net)
		   'bbdb)
(eudc-set-server "localhost" 'notmuch t)
(setq eudc-server-hotlist '(("localhost" . bbdb)
			    ("localhost" . notmuch)))
(setq eudc-inline-expansion-servers 'hotlist)

(setq notmuch-addr-query-command "/home/albin/.bin/addrlookup")

;; Process...err...PGP/Mime. :)
(setq notmuch-crypto-process-mime t)

(require 'org-notmuch)

;; just redefine this to use ido-completing-read -- krl's code from https://gist.github.com/869875
(defun eudc-select (choices beg end)
  (let ((replacement
         (ido-completing-read "Multiple matches found; choose one: "
                              (mapcar 'list choices))))
    (delete-region beg end)
    (insert replacement)))

(defun ks-notmuch-show-copy-entry-url ()
      (interactive)
      (let ((raw (shell-command-to-string
                  (concat notmuch-command
                          " show --format=raw "
                          (notmuch-show-get-message-id)))))
        (if (string-match "X-Entry-URL: \\(.*\\)" raw)
            (let ((url (match-string 1 raw)))
              (kill-new url)
              (message "Killed url: %s" url))
          (error "No X-Entry-URL header present"))))

(define-key notmuch-show-mode-map "Y" 'ks-notmuch-show-copy-entry-url)

;; (require 'dbus)
;; (defun schnouki/notmuch-dbus-notify ()
;;   (when (get-buffer "*notmuch-hello*")
;;     (message "Notmuch notify")
;;     (notmuch-hello-update t)))
;; (dbus-register-method :session dbus-service-emacs dbus-path-emacs
;;                       dbus-service-emacs "NotmuchNotify"
;;                       'schnouki/notmuch-dbus-notify)
(provide 'mail)