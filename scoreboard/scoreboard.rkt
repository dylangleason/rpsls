#lang racket

(require racket/splicing)

(struct player (name [score #:mutable]))

(define (scores->json players)
  (for/list ([(i) (in-naturals 1)]
             [(k v) players])
    (hash 'Id i 'Name k 'Score (player-score v))))

(define (make-scoreboard name-1 name-2)
  (splicing-let ([players (hash name-1 (player name-1 0)
                                name-2 (player name-2 0))])
    (define (add-score name result)
      (let ([player (hash-ref players name)])
        (set-player-score! player (+ result (player-score player)))))
    (define (get-score)
      (scores->json players)))
  (values add-score get-score))

(provide make-scoreboard)
