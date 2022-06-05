# StumpWM Rofi

Rofi module for StumpWM

## Requrements

- [Rofi](https://github.com/davatorium/rofi) installed

## Installation

```bash
cd ~/.stumpwm.d/modules/
git clone https://github.com/Junker/stumpwm-rofi rofi
```

```lisp
(stumpwm:add-to-load-path "~/.stumpwm.d/modules/rofi")
(load-module "rofi")
```

## Usage

```lisp
;; list of pairs '(("name" . "command"))
(defvar *my-menu*
  '(("Terminal" . "exec kitty")
    ("Editor" . "exec featherpad")
    ("Krusader" . "exec krusader")
    ("💼  Work >" . (("Emacs" . "app-emacs")
                     ("DBeaver" . "app-dbeaver")
                     ("QOwnNotes" . "app-qownnotes")))
    ("🌍  Inet >" . (("Firefox" . "app-firefox")
                     ("Telegram" . "app-telegram")
                     ("Mail" . "exec thunderbird")))))

(defcommand my-menu () ()
  (rofi:menu *my-menu*)
  ;; or with rofi arguments
  (rofi:menu *my-menu* "-show-icons -theme gruvbox-dark-hard -cycle false"))

(define-key *top-map* (kbd "s-x") "my-menu")

;; windowlist
(define-key *top-map* (kbd "s-Tab") "rofi-windowlist")

;; custom list choose
(message (cdr (rofi:choose '(("1" . "one") ("2" . "two") ("3" . "three")) 
                            "-theme fancy")))
```
