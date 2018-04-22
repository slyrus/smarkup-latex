
(asdf:defsystem :smarkup-latex
  :name "smarkup-latex"
  :author "Cyrus Harmon <cyrus@bobobeach.com>"
  :licence "BSD"
  :description "Latex stuff for smarkup"
  :depends-on (:smarkup :bibtex)
  :serial t
  :components
  ((:cl-source-file "package")
   (:cl-source-file "smarkup-latex")
   (:cl-source-file "smarkup-latex-asdf")))
