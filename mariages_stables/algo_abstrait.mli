open Definitions

module type PIOCHE = sig

    (* la signature pour un module qui définit des "pioches"
   traitées de manière impératives (i.e. "en place", pas "persistantes") 
*)

  type 'a t (* le type abstrait *)

  val of_list: 'a list -> 'a t 
  (* crée une nouvelle pioche à partir d'une liste *)

  val pioche : 'a t -> 'a  option 
  (* retire un élément de la pioche, renvoie None si la pioche est vide *)

  val defausse : 'a -> 'a t -> unit 
  (* rajoute un élément dans la pioche *)

end

module Pile : PIOCHE

module File : PIOCHE

module Algo(P:PIOCHE) : sig val run:entree -> sortie end

