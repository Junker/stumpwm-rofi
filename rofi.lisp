(in-package :rofi)

(defun escape-item-name (var)
  (substitute #\MODIFIER_LETTER_DOUBLE_PRIME #\" var))

(defun prepare-items (items)
  (format nil "~{~A~^~%~}" (mapcar #'car items)))

(defun run (items &optional (args ""))
  (uiop:run-program (format nil "echo \"~A\" | rofi -dmenu ~A"
                            (escape-item-name (prepare-items items))
                            args)
                    :ignore-error-status t
                    :error-output '(:string :stripped t)
                    :output '(:string :stripped t)))

(defun choose (items args)
  (multiple-value-bind (out-text err-text err-code)
      (run items args)
    (declare (ignore err-text))
    (when (eq err-code 0)
      (assoc out-text items
             :test #'(lambda (chosen-text item-name)
                       (string= chosen-text (escape-item-name item-name)))))))

(defun menu (items &optional (args ""))
  (when-let ((item-val (cdr (choose items args))))
    (if (stringp item-val)
        (run-commands item-val)
        (menu item-val args))))

(defun window-name (window)
  (format nil "~A (~A)"
          (stumpwm::window-class window)
          (stumpwm::window-name window)))

(defcommand rofi-colon () ()
  (let ((commands (mapcar #'list
                          (stumpwm::all-commands))))
    (when-let ((cmd (car (choose commands ""))))
      (run-commands cmd))))

(defcommand rofi-windowlist (&optional window-list) (:rest)
  (if-let ((window-list (mapcar (lambda (w) (cons (window-name w) w))
                                (or window-list
                                    (stumpwm::sort-windows-by-number
                                     (group-windows (current-group)))))))
    (if-let ((window (cdr (choose window-list ""))))
      (group-focus-window (current-group) window)
      (throw 'error :abort))
    (message "No Managed Windows")))

