type homme = int

type femme = int

let ascii_code_of_A = Char.code 'A'

let ascii_code_of_a = Char.code 'a'

let string_of_homme h =
  if h < 0 || h > 23 
  then raise (Invalid_argument "string_of_homme")
  else Format.sprintf "%c" (Char.chr (ascii_code_of_A + h))

let string_of_femme f =
  if f < 0 || f > 23 
  then raise (Invalid_argument "string_of_femme")
  else Format.sprintf "%c" (Char.chr (ascii_code_of_a + f))
  
type entree = {
    n : int; 
    liste_appel_de : femme array array;
    prefere : (homme -> homme -> bool) array;
}

let est_permutation tab = 
  let n = Array.length tab in
  let vu = Array.make n false in
  let rec verifie i = 
    if i = n then true else
    if vu.(tab.(i)) then false 
    else begin
      vu.(tab.(i)) <- true;
      verifie (i+1)
    end in
  verifie 0

let entree_valide entree =
  entree.n = Array.length entree.liste_appel_de &&
  entree.n = Array.length entree.prefere &&
  Array.for_all est_permutation entree.liste_appel_de

let print_entree entree = 
  print_endline (Format.sprintf "ENTREE {\n  n=%d" entree.n);
  for i=0 to entree.n - 1 do
    print_endline (Format.sprintf "  %s : %s"
      (string_of_homme i)
      ( entree.liste_appel_de.(i)
        |> Array.to_list |> List.map string_of_femme
        |> String.concat ","
      )
    )
  done;
  let hommes = List.init entree.n (fun i->i) in
  let liste_of i  =
    let compare x y = if entree.prefere.(i) x y then -1 else 1 in
    List.sort compare hommes in
  for i=0 to entree.n - 1 do
    print_endline (Format.sprintf "  %s : %s"
      (string_of_femme i)
      (liste_of i |> List.map string_of_homme |> String.concat ",")
    )
  done;
  print_endline "}"


type sortie = (homme * femme) list

let print_sortie sortie = 
  print_endline (Format.sprintf "SORTIE { %s }"
    ( sortie
      |> List.sort compare  
      |> List.map (fun (h,f) -> (string_of_homme h)^(string_of_femme f))
      |> String.concat " "
    )
  )

type configuration = {
    rang_appel_de : int array;
    fiance_de : homme option array;
}

let string_of_homme_option = function
| None -> "?"
| Some h -> string_of_homme h

let print_configuration conf = 
  print_endline (Format.sprintf "CONFIGURATION {\n  %s\n  %s\n}"
    ( conf.rang_appel_de 
      |> Array.to_list 
      |> List.mapi (fun h rg -> (string_of_homme h)^(string_of_int rg))
      |> String.concat " "            
    )
    (
      conf.fiance_de
      |> Array.to_list
      |> List.mapi (fun f h -> (string_of_femme f)^(string_of_homme_option h))
      |> String.concat " "
    )
  )

