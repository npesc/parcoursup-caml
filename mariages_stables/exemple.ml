open Mariages_stables.Definitions
(* open Mariages_stables.Knuth *)

let prefere_of_classement classement =
  let n = Array.length classement in
  let rk = Array.make n 0 in
  for i = 0 to n - 1 do rk.(classement.(i)) <- i done;
  fun h1 h2 -> rk.(h1) < rk.(h2)

let prefere_of tab = Array.map prefere_of_classement tab

(** 
exemple 1 page 12 du cours de D. Knuth
repris ensuite pages 22-26 du même cours
**)
let exemple_knuth = 

  let a,b,c,d = 0,1,2,3 in
  {
    n = 4;
    liste_appel_de = [|
      [|c;b;d;a|];
      [|b;a;c;d|];
      [|b;d;a;c|];
      [|c;a;d;b|];
    |];
    prefere = prefere_of [|
      [|a;b;d;c|];
      [|c;a;d;b|];
      [|c;b;d;a|];
      [|b;a;c;d|]
    |]
  }

type algo = ?affiche_config:bool -> entree -> sortie

let traite entree nom (algo:algo) = 
  print_endline (Format.sprintf "EXEMPLE %s" nom);
  print_entree entree;
  let sortie = algo ~affiche_config:true entree in
  print_sortie sortie
  
(* let run algo = traite exemple_knuth "Knuth pages 12 et 22-26" algo
let sortie = algo ~affiche_config:true exemple_knuth;;
print_sortie sortie;; *)