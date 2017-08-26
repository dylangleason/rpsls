#lang racket

(require "../lib/logging.rkt"
         "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         "play.rkt"
         racket/random
         web-server/dispatch)

(define app-port 8080)

(define (root-handler req)
  (response/ok "Game Server"))

(define (choice-handler req)
  (response/ok (random-ref choices)))

(define (choices-handler req)
  (response/ok choices))

(define (play-handler req)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (let ([msg (exn-message e)])
                       (response/unprocessable-entity
                        (hash 'Error msg))))])
    (response/ok
     (play (query-param->int req "player")
           (hash-ref (random-ref choices) 'Id)))))

(define-values (router req)
  (dispatch-rules
   [("")        #:method "get" root-handler]
   [("choice")  #:method "get" choice-handler]
   [("choices") #:method "get" choices-handler]
   [("play")    #:method "get" play-handler]
   [else        (lambda (req) (response/not-found))]))

(serve
 app-port
 (lambda (req)
   (dispatch-request
    req router
    #:pre (list middleware/log-request)
    #:post (list middleware/log-response))))
