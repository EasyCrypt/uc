(* Simple example for One Time Pad encryption.                          *)
(* Only two parties identified by a bool: false for 0, true for 1.      *)
(* Shared OTP known at init.                                            *)

(* -------------------------------------------------------------------- *)
require import AllCore List Distr.
require (*--*) Cc.

(* -------------------------------------------------------------------- *)
clone Cc as MyCc with type id_t <- bool, msg_t <- int, state_t <- int * int.

(* -------------------------------------------------------------------- *)
module M : MyCc.Party = {
  (* Each pair of the array is the state of a party. fst: pad. snd: msg *)
  val mutable states = [|(0,0);(0,0)|]
  
  proc init (id_ : id_t) =
  | false -> states.(0) = (42, 314)
  | true -> states.(1) = (42, 0)
    
  (* lossless, no-side effects, involutive *)
  proc state (id : id_t) =
  | false -> states.(0)
  | true -> states.(1)

  (* does not change the state of other IDs *)
  (* In this execution, only the receiver expects a (single) message. *)
  proc next (id : id_t, msg : msg_t list) =
  | (false, []) -> fmap (true, [lxor (fst states.(0)) (snd states.(0))])    (* syntax for fmap? *)
  | (true, [ciphertext : msg_t]) -> let pad = fst states(1) in states.(1) = (pad, lxor pad ciphertext); (empty: queue_t)
}.
