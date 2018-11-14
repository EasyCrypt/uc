(* Work in progress *)

type msg_t, state_t, id_t

module type Adv = {
    fun next(messages : (id_t, list msg_t) map) : (id_t, list msg_t) map
}

module type Party = {
    fun init(id : id_t, state : state_t) : unit
    fun next(msg : msg_t) : (id_t, list msg_t) map
}

module type Scheduler = {
    var states : (id_t, state_t) map
    var pending : id_t * msg_t list
    fun next : unit
}