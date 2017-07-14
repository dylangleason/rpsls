#lang racket

(require "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         "./play.rkt"
         web-server/dispatch)

(define app-port 8080)

(define (root-handler req)
  (response-ok "Hello"))

(define (health-handler req)
  (response-ok "OK"))

(define (choice-handler req)
  (response-ok (random-choice)))

(define (choices-handler req)
  (response-ok choices))

(define (play-handler req)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (response-unprocessable-entity
                      (hash 'Error (exn-message e))))])
    (response-ok
     (play (query-param->int req "player")
           (query-param->int req "computer")))))

(define-values (route req)
  (dispatch-rules
   [("")        root-handler]
   [("health")  #:method "get" health-handler]
   [("choice")  #:method "get" choice-handler]
   [("choices") #:method "get" choices-handler]
   [("play")    #:method "get" play-handler]
   [else        (lambda (req) (response-not-found))]))

(run-server
 (lambda (req) (route req)) app-port)
