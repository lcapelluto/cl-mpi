#+asdf3 (in-package #:asdf-user)

;; this snippet prevents several dozen UIOP redefinition warnings.
(eval-when (:compile-toplevel :load-toplevel :execute)
 (locally
    (declare #+sbcl(sb-ext:muffle-conditions sb-kernel:redefinition-warning))
  (handler-bind
      (#+sbcl(sb-kernel:redefinition-warning #'muffle-warning))
    (asdf:load-system 'cffi-grovel))))

(defsystem #:cl-mpi
  :description "Common Lisp bindings for the Message Passing Interface (MPI)"
  :author "Marco Heisig <marco.heisig@fau.de>"
  :version "0.9"
  :license "MIT"
  :long-description
  "cl-mpi provides CFFI bindings for the Message Passing Interface (MPI). MPI
is typically used in High Performance Computing to utilize big parallel
computers with thousands of cores. It features minimal communication overhead
with a latency in the range of microseconds. "
  :defsystem-depends-on (#:cl-mpi-asdf-utilities)
  :depends-on (#:alexandria #:cffi #:static-vectors #:cl-conspack)
  :in-order-to ((test-op (test-op "cl-mpi-testsuite")))
  :components
  ((:module "mpi"
    :components
    ((:file "packages")

     ;; extract all constants from "mpi.h"
     ("cffi-grovel:grovel-file" "grovel" :depends-on ("packages"))

     ;; load system MPI implementation
     ("cl-mpi-asdf-utilities:mpi-stub" "cl-mpi-stub" :depends-on ("grovel"))

     ;; MPI implementation dependent constants
     (:file "configure" :depends-on ("grovel"))

     ;; CLOS wrappers for MPI handles
     (:file "wrapper-types" :depends-on ("configure"))

     ;; Lisp-accessible variables from mpi.h
     (:file "constants" :depends-on ("wrapper-types"))

     ;; helper functions
     (:file "utilities" :depends-on ("constants"))

     ;; the rest
     (:file "datatypes" :depends-on ("utilities"))
     (:file "collective" :depends-on ("utilities"))
     (:file "contexts" :depends-on ("utilities"))
     (:file "environment" :depends-on ("utilities"))
     (:file "point-to-point" :depends-on ("utilities"))
     (:file "one-sided" :depends-on ("utilities"))
     (:file "extensions" :depends-on ("utilities"))))))
