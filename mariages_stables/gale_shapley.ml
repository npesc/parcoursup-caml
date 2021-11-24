open Definitions
let get_h n = function
| None -> n
| Some h -> h;;
let rec aux  liste arr n  = function
  | i when i < n -> 
    aux (liste @ [(get_h n (arr.(i)), i )]) arr n (i+1)
  | _ -> liste;;
let print_conf conf = function
| true -> print_configuration conf
| _ -> ();;
let rec init_celib n i = match n,i with
| n,i when n = i -> []
| n,i -> i :: init_celib n (i+1);;
let rec remove x l = match l with
  | [] -> []
  | hd :: tl -> if x=hd then remove x tl else hd::remove x tl;;
let algo ?(affiche_config=false) entree =
  (* INITIALISATION *)
  let n = entree.n in
  let _X = ref 0 in
  let _x = ref 0 in
  let conf = {rang_appel_de=Array.make n 0 ; fiance_de=Array.make n (None)} in
  let celib =  ref (init_celib n 0) in
  let pretendants = Array.make n [] in
  (* INITIALISATION *)

  let rec pretendant_pref x = function
    | [p] -> Some p
    | p :: l -> begin
      let q = pretendant_pref x l in
      match q with
      | None -> Some p
      | Some h -> if (entree.prefere.(x) p h) then Some p else Some h end
    | _ -> None
    in

  let rec incremente h = function
  | hd :: tl when hd <> h -> begin conf.rang_appel_de.(hd) <- conf.rang_appel_de.(hd) + 1; incremente h tl; end;
  | _::tl -> incremente h tl;
  | _ -> ();
  in

  while (!celib <> []) do
    for i = 0 to ((List.length !celib)-1) do
    _x := entree.liste_appel_de.(i).(conf.rang_appel_de.(i));
    pretendants.(!_x) <- i :: pretendants.(!_x);done;

    for j = 0 to n-1 do
      _x := j;
      if ((List.length pretendants.(!_x)) > 0) then
        begin 
        _X := get_h n (pretendant_pref (!_x) pretendants.(!_x));
        begin
          match conf.fiance_de.(!_x) with 
          | None ->
            begin 
              conf.fiance_de.(!_x) <- Some !_X; celib := remove !_X !celib;
            end;
          | Some h when (entree.prefere.(!_x) !_X h) -> 
            begin 
              conf.fiance_de.(!_x) <-  Some !_X;celib := h :: (remove !_X !celib);
              conf.rang_appel_de.(h) <- conf.rang_appel_de.(h) + 1;
            end;
          | _ ->(); 
        end;
          incremente (get_h n conf.fiance_de.(!_x)) pretendants.(!_x);
          pretendants.(!_x) <- [];
        end;done;
      print_conf conf affiche_config;done;
  let res:sortie = aux [] conf.fiance_de n 0 in
  res;
          

          




  
