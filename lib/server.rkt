#lang racket

(require  "./logging.rkt"
          web-server/servlet
          web-server/servlet-env
          web-server/dispatchers/dispatch-log)

(provide dispatch-request
         logging-middleware
         run-server)

(define (logging-middleware req)
  (begin
    (access-log/info req)
    req))

(define dispatch-request
  (lambda (req router-fun . middleware-funs)
    (router-fun
     (let loop ([req req]
                [funs middleware-funs])
       (if (empty? funs)
           req
           (loop ((car funs) req) (cdr funs)))))))

(define (run-server port dispatch-fn)
  (begin
    (app-log/info (format "Server listening on port ~a" port))
    (serve/servlet
     dispatch-fn
     #:command-line? #t
     #:launch-browser? #f
     #:port port
     #:servlet-path "/"
     #:servlet-regexp #rx""
     #:stateless? #t)))
