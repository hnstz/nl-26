(defun run-calculator ()
  (loop
    (let ((line (read-line *standard-input* nil nil)))
      (unless line (return))
      (handler-case
          (let ((result (eval (read-from-string line))))
            (format t "~a~%" result))
        (error (e)
          (format t "Ошибка: некорректное выражение (~a)~%" e))))))

(run-calculator)

; (+ 10 (* 2 5))