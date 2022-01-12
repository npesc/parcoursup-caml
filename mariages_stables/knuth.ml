open Definitions

let get_h n = function
| None -> n
| Some h -> h;;

let rec aux liste arr n = function
  | i when i < n -> 
    aux (liste @ [(get_h n (arr.(i)), i )]) arr n (i+1)
  | _ -> liste;;
  let print_conf conf = function
  | true -> print_configuration conf
  | _ -> ()

let algo ?(affiche_config=false) entree =
  if (not(entree_valide entree)) then invalid_arg "entrée invalide" else
  begin
  let n, indesirable  = entree.n, entree.n in
  (* l'indésirable est imaginaire, on ne doit pas l'atteindre *)
  let k = ref 0 in
  let _X = ref 0 in
  let _x = ref 0 in
  let conf = 
    {rang_appel_de=Array.make n 0 ;
      fiance_de=Array.make n (None)} in
  (* fiancer toutes les femmes à Ω; *)

  while (!k < n) 
  do begin
    _X := !k;
    while (!_X <> indesirable) 
    do begin
      
        _x := entree.liste_appel_de.(!_X).(conf.rang_appel_de.(!_X));
        (* x := meilleur choix restant sur la liste de X *)

        let fiance = conf.fiance_de.(!_x) in 

        match fiance with
        | Some h when (entree.prefere.(!_x) (!_X) (h)) -> begin 
          conf.fiance_de.(!_x) <- Some !_X ;
          _X := h;
          conf.rang_appel_de.(!_X) <- conf.rang_appel_de.(!_X) + 1;
          print_conf conf affiche_config;
        end
        | None -> begin 
          conf.fiance_de.(!_x) <- Some (!_X); _X := !_X+1;
          print_conf conf affiche_config;
         end
        | Some h when (!_X = h) -> _X := !_X+1;
        | _ -> begin 
          conf.rang_appel_de.(!_X) <- conf.rang_appel_de.(!_X) + 1;
          print_conf conf affiche_config; end
      
    end;done;
    k := !k+1;
  end done;
 let res:sortie = aux [] conf.fiance_de n 0 in
res;
end