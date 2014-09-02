
(in-package :smarkup)

(defparameter *pdflatex-program* "pdflatex")

(defclass object-latex-file (object-from-variable generated-file) ())

(defmethod perform ((op generate-op) (c object-latex-file))
  (call-next-method)
  (render-as :latex
             (symbol-value (object-symbol c))
             (component-pathname c)))

(defmacro with-component-directory ((component) &body body)
  `(with-current-directory
       (make-pathname
        :directory (pathname-directory
                    (component-pathname ,component)))
     ,@body))

(defmethod perform ((operation compile-op) (c object-latex-file))
  (with-component-directory (c)
    (let ((unix-path (namestring (component-pathname c))))
      (run-program *pdflatex-program*
                   (list unix-path)
                   :search t)
      ;; we have to do this twice to get the references right!
      ;; maybe 3x?
      (run-program *pdflatex-program*
                   (list unix-path)
                   :search t))))

(defmethod operation-done-p ((o generate-op) (c object-latex-file))
  (let ((on-disk-time
         (file-write-date (component-pathname c)))
        (obj (asdf:find-component
              (asdf:component-parent c)
              (asdf::coerce-name (object-input-object c)))))
    
    (let ((obj-date (asdf:component-property obj 'last-loaded)))
      (and on-disk-time
           obj-date
           (>= on-disk-time obj-date)))))

