#lang racket

(require "../lib/logging.rkt"
         "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         web-server/dispatch)

(define app-port 9090)

(define (root-handler req)
  (response/ok "Scoreboard Server"))

(define-values (router req)
  (dispatch-rules
   [("") root-handler]
   [else (lambda (req) (response/not-found))]))

(run-server
 app-port
 (lambda (req)
   (dispatch-request req router logging-middleware)))
