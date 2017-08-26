#lang racket

(require "../lib/logging.rkt"
         "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         "scoreboard.rkt"
         web-server/dispatch)

(define app-port 9090)

(define-values (add-score get-scores)
  (make-scoreboard "Player" "Computer"))

(define (root-handler req)
  (response/ok "Scoreboard Server"))

(define (score-handler req)
  (response/ok (get-scores)))

(define (reset-score-handler req)
  (set!-values (add-score get-scores)
               (make-scoreboard "Player" "Computer"))
  (response/no-content))

(define (results-handler req)
  (let ([data (post-data->jsexpr req)])
    (log/info (format "Data: ~a" data))
    (response/created "TODO: save player results")))

(define-values (router req)
  (dispatch-rules
   [("")           #:method "get"    root-handler]
   [("scoreboard") #:method "get"    score-handler]
   [("scoreboard") #:method "delete" reset-score-handler]
   [("results")    #:method "post"   results-handler]
   [else           (lambda (req) (response/not-found))]))

(serve
 app-port
 (lambda (req)
   (dispatch-request
    req router
    #:pre  (list middleware/log-request)
    #:post (list middleware/log-response))))
