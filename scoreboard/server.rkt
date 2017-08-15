#lang racket

(require "../lib/logging.rkt"
         "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         web-server/dispatch)

(define app-port 9090)

(define (root-handler req)
  (response/ok "Scoreboard Server"))

(define (score-handler req)
  (response/ok "TODO: get scoreboard"))

(define (results-handler req)
  (let ([data (post-data->jsexpr req)])
    (log/info (format "Data: ~a" data))
    (response/created "TODO: save player results")))

(define-values (router req)
  (dispatch-rules
   [("")           #:method "get" root-handler]
   [("scoreboard") #:method "get" score-handler]
   [("results")    #:method "post" results-handler]
   [else           (lambda (req) (response/not-found))]))

(serve
 app-port
 (lambda (req)
   (dispatch-request
    req router
    #:pre  (list middleware/log-request)
    #:post (list middleware/log-response))))
