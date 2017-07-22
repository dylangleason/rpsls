#lang racket

;;; Game Rules:
;;; - scissors cuts paper
;;; - paper covers rock
;;; - rock crushes lizard
;;; - lizard poisons Spock
;;; - spock smashes scissors
;;; - scissors decapitates lizard
;;; - lizard eats paper
;;; - paper disproves Spock
;;; - Spock vaporizes rock
;;; - rock crushes scissors

(provide choices
         play
         random-choice)

(define action-interface (interface () win? lose?))

(define action%
  (class object%
    (super-new)
    (define/public (play their-action)
      (cond
       [(send this win? their-action) "win"]
       [(send this lose? their-action) "lose"]
       [else "tie"]))))

(define rock%
  (class* action% (action-interface)
    (super-new)
    (define/public (win? their-action)
      (or (is-a? their-action lizard%)
          (is-a? their-action scissors%)))
    (define/public (lose? their-action)
      (or (is-a? their-action paper%)
          (is-a? their-action spock%)))))

(define paper%
  (class* action% (action-interface)
    (super-new)
    (define/public (win? their-action)
      (or (is-a? their-action rock%)
          (is-a? their-action spock%)))
    (define/public (lose? their-action)
      (or (is-a? their-action lizard%)
          (is-a? their-action scissors%)))))

(define scissors%
  (class* action% (action-interface)
    (super-new)
    (define/public (win? their-action)
      (or (is-a? their-action lizard%)
          (is-a? their-action paper%)))
    (define/public (lose? their-action)
      (or (is-a? their-action rock%)
          (is-a? their-action spock%)))))

(define lizard%
  (class* action% (action-interface)
    (super-new)
    (define/public (win? their-action)
      (or (is-a? their-action paper%)
          (is-a? their-action spock%)))
    (define/public (lose? their-action)
      (or (is-a? their-action rock%)
          (is-a? their-action scissors%)))))

(define spock%
  (class* action% (action-interface)
    (super-new)
    (define/public (win? their-action)
      (or (is-a? their-action rock%)
          (is-a? their-action scissors%)))
    (define/public (lose? their-action)
      (or (is-a? their-action lizard%)
          (is-a? their-action paper%)))))

(define choices
  (list #hash((Id . 1) (Name . "rock"))
        #hash((Id . 2) (Name . "paper"))
        #hash((Id . 3) (Name . "scissors"))
        #hash((Id . 4) (Name . "lizard"))
        #hash((Id . 5) (Name . "spock"))))

(define (random-choice)
  (list-ref choices (random (length choices))))

(define (play p-choice c-choice)
  (define (make-action choice)
    (case choice
      [(1) (new rock%)]
      [(2) (new paper%)]
      [(3) (new scissors%)]
      [(4) (new lizard%)]
      [(5) (new spock%)]
      [else
       (error (format "Invalid choice ID: ~a" choice))]))
  (hash 'Results
        (send (make-action p-choice) play (make-action c-choice))))
