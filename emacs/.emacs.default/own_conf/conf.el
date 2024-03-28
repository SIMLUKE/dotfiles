;;; perso_conf --- apearence of the tabs

;;; Commentary:

;;; Code:


;; Terminal openers
(defun my/open-term-from-tree ()
  "Opens an outside terminal and cds to the selected directory."
  (interactive)
  (treemacs-copy-absolute-path-at-point)
  (let ((default-directory (current-kill 0 'DONT-MOVE)))
    (start-process "alacritty-process" nil "alacritty"))
  )
(global-set-key (kbd "C-c y") 'my/open-term-from-tree)

(defun my/projectile-run-alacritty-in-root ()
  "Opens an outside terminal and cds to the current project's root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (start-process "alacritty-process" nil "alacritty")))
(global-set-key (kbd "C-c a") 'my/projectile-run-alacritty-in-root)

(scroll-bar-mode -1)

(window-divider-mode)

(setq treemacs-default-visit-action 'treemacs-visit-node-close-treemacs)

(setq treemacs-position 'right)

;;; conf.el ends here
