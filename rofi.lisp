(in-package :rofi)

(defun run (items &optional (args ""))
  (uiop:run-program (format nil "echo \"~A\" | rofi -dmenu ~A"
                            (prepare-items items)
                            args)
                    :ignore-error-status t
                    :error-output '(:string :stripped t)
                    :output '(:string :stripped t)))


(defun choose (items args)
  (multiple-value-bind (out-text err-text err-code)
      (run items args)
    (declare (ignore err-text))
    (when (eq err-code 0)
      (assoc out-text items :test #'string=))))

(defun menu (items &optional (args ""))
  (when-let ((item-val (cdr (choose items args))))
    (if (stringp item-val)
        (run-commands item-val)
        (menu item-val args))))

(defun window-name (window)
  (format nil "~A (~A)"
          (stumpwm::window-class window)
          (stumpwm::window-name window)))

(defcommand rofi-windowlist (&optional window-list) (:rest)
  (if-let ((window-list (mapcar (lambda (w) (cons (window-name w) w))
                                (or window-list
                                    (stumpwm::sort-windows-by-number
                                     (group-windows (current-group)))))))
    (if-let ((window (cdr (choose window-list ""))))
      (group-focus-window (current-group) window)
      (throw 'error :abort))
    (message "No Managed Windows")))

(defun prepare-items (items)
  (format nil "~{~A~^~%~}" (mapcar #'car items)))
