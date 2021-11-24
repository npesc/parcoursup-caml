open Definitions

module type PIOCHE = sig
  type 'a t
    val of_list: 'a list -> 'a t 
    val pioche : 'a t -> 'a option 
    val defausse : 'a -> 'a t -> unit 
end



module Pile : PIOCHE = struct
  
  type 'a t = {mutable pile: 'a list}

  let of_list (l:'a list) = 
    {pile = l};;

  let pioche p =
    match p.pile with
    | [] -> None;
    | h::t -> p.pile <- t; Some h;;

  let defausse x p =
    p.pile <- x::p.pile;;

end



module File : PIOCHE = struct

  type 'a cell = {elt : 'a ; mutable next:'a cell}
  type 'a t = 'a cell option ref


  let pioche p = match !p with
  | None -> None;
  | Some last -> 
      if last.next==last 
      then begin 
        p := None;
        Some last.elt
      end else begin
        let first = last.next in
          last.next <- first.next;
          Some first.elt
      end;;

  let defausse x p = match !p with
    | None -> let rec cell =  {elt=x;next=cell} in p := Some cell
    | Some last -> 
        let cell = {elt=x; next=last.next} 
        in last.next <- cell;
          p := Some cell;;

  let of_list l = 
    let q = ref None in
    let rec aux q list = match list with 
      | [] -> begin q; end
      | h :: t -> 
        begin
          defausse h q;
          aux q t;
        end; 
      in
    aux q l;;

end


let rec init_celib n i = match n,i with
| n,i when n = i -> []
| n,i -> i :: init_celib n (i+1);;

let get_h n = function
| None -> n
| Some h -> h;;

let rec aux  liste arr n  = function
  | i when i < n -> 
    aux (liste @ [(get_h n (arr.(i)), i )]) arr n (i+1)
  | _ -> liste;;

module Algo(P:PIOCHE) = struct

  let run entree = 
    (* initialisation *)
    let n = entree.n in
    let pioche = P.of_list (init_celib n 0) in
    let _X = ref 0 in
    let _x = ref 0 in
    let conf = {rang_appel_de=Array.make n 0 ; fiance_de=Array.make n (None)} in
    let g_p = [|n;n|] in
    (* initialisation *)
    _X := get_h n (P.pioche pioche); 
    (* Si l'homme pioché est None (<=> pioche est vide) get_h retourne n *)

    while (!_X <> n) do
        _x := entree.liste_appel_de.(!_X).(conf.rang_appel_de.(!_X));
        if (conf.fiance_de.(!_x) = None) then conf.fiance_de.(!_x) <- Some !_X
        else
          begin
            if (entree.prefere.(!_x) !_X (get_h n conf.fiance_de.(!_x)))
              then begin g_p.(0) <- !_X; g_p.(1) <- get_h n conf.fiance_de.(!_x); end
              else begin g_p.(0) <- get_h n conf.fiance_de.(!_x); g_p.(1) <- !_X; end;
              
              conf.fiance_de.(!_x) <- Some g_p.(0);
              conf.rang_appel_de.(g_p.(1)) <- conf.rang_appel_de.(g_p.(1)) + 1;
              P.defausse (g_p.(1)) pioche;
            end;
        _X := get_h n (P.pioche pioche);
    done;
    let res:sortie = aux [] conf.fiance_de n 0 in
    res
end