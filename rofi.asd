;;;; rofi.asd

(asdf:defsystem #:rofi
  :description "Rofi module for StumpWM"
  :author "Dmitrii Kosenkov"
  :license  "GPLv3"
  :version "0.1.0"
  :serial t
  :depends-on (#:stumpwm)
  :components ((:file "package")
               (:file "rofi")))
