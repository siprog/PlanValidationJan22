(define (domain transport)
  (:requirements :typing)
  (:types
        location target locatable - object
        vehicle package - locatable
  )

  (:predicates 
     (road ?l1 ?l2 - location)
     (at ?x - locatable ?v - location)
     (in ?x - package ?v - vehicle)
  )

  (:task deliver :parameters (?p - package ?l - location))
  (:task get-to :parameters (?v - vehicle ?l - location))
  (:task load :parameters (?v - vehicle ?l - location ?p - package))
  (:task unload :parameters (?v - vehicle ?l - location ?p - package))

  (:method m-deliver
    :parameters (?p - package ?l1 ?l2 - location ?v - vehicle)
    :task (deliver ?p ?l2)
    :between-conditions(and
      (1 3 (in ?p ?v))
      (0 1 (not (in ?p ?v))))
     :ordered-subtasks (and
      (get-to ?v ?l1)
      (load ?v ?l1 ?p)
      (get-to ?v ?l2)
      (unload ?v ?l2 ?p))
  )

  (:method m-unload
    :parameters (?v - vehicle ?l - location ?p - package)
    :task (unload ?v ?l ?p)
    :subtasks (and
      (drop ?v ?l ?p))
  )

  (:method m-load
    :parameters (?v - vehicle ?l - location ?p - package)
    :task (load ?v ?l ?p)
    :subtasks (and
      (pick-up ?v ?l ?p))
  )
  
  (:method m-drive-to
    :parameters (?v - vehicle ?l1 ?l2 - location)
    :task (get-to ?v ?l2)
    :subtasks (and
        (drive ?v ?l1 ?l2))
  )

  (:method m-drive-to-via
    :parameters (?v - vehicle ?l2 ?l3 - location)
    :task (get-to ?v ?l3)
    :ordered-subtasks (and
        (get-to ?v ?l2)
        (drive ?v ?l2 ?l3))
  )

  (:method m-i-am-there
    :parameters (?v - vehicle ?l - location)
    :task (get-to ?v ?l)
    :subtasks (and
        (noop ?v ?l))
  )
  
  (:action drive
    :parameters (?v - vehicle ?l1 ?l2 - location)
    :precondition (and
        (at ?v ?l1)
        (road ?l1 ?l2))
    :effect (and
        (not (at ?v ?l1))
        (at ?v ?l2))
  )

  (:action noop
    :parameters (?v - vehicle ?l2 - location)
    :precondition (and
      (at ?v ?l2))
    :effect ()
  )

 (:action pick-up
    :parameters (?v - vehicle ?l - location ?p - package)
    :precondition (and
        (at ?v ?l)
        (at ?p ?l)
      )
    :effect (and
        (not (at ?p ?l))
        (in ?p ?v)
      )
  )

  (:action drop
    :parameters (?v - vehicle ?l - location ?p - package)
    :precondition (and
        (at ?v ?l)
        (in ?p ?v)

      )
    :effect (and
        (not (in ?p ?v))
        (at ?p ?l)
      )
  )

)
