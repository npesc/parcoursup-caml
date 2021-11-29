(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
open Hashtbl;;
type etat = | Config | Appel | Close


type session = {
  mutable etat: etat;
  candidats: (string, (string, int option) Hashtbl.t) Hashtbl.t;
  (* (nom_candidat, (nom_formation, Some rang) Hashtable) Hashtable *)
  formations: (string , int) Hashtbl.t;
  (* (formation, capacite) Hashtable *)
  commissions : (string, string list) Hashtbl.t; 
  (* (formation, liste d'appel) Hashtbl.t *)
  propositions: (string, string) Hashtbl.t; 
}

let nouvelle_session () = {
  etat=Config;
  candidats=Hashtbl.create 1000 ~random:false;
  formations=Hashtbl.create 100 ~random:false;
  commissions=Hashtbl.create 10 ~random:false;
  propositions=Hashtbl.create 100 ~random:false;
  }

let ajoute_candidat session ~nom_candidat = 
  let voeu_hashtbl = Hashtbl.create 30 ~random:false in 
  Hashtbl.add session.candidats nom_candidat voeu_hashtbl
;;

let ajoute_formation session ~nom_formation ~capacite =
  Hashtbl.add session.formations nom_formation capacite;;
  

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  let rang = ref (Float.to_int infinity) in
  begin match rang_repondeur with 
    | Some n -> rang := n;
    | _ -> () end;
  Hashtbl.replace (Hashtbl.find session.candidats nom_candidat) nom_formation (Some !rang)

let ajoute_commission session ~nom_formation ~fonction_comparaison = 
  let table_candidats = session.candidats in
  let pretendants =  ref [] in

  Hashtbl.iter (fun nom_c voeux -> (* voeux -> hashtable de voeux du candidat *)
    if Hashtbl.mem voeux nom_formation 
    then pretendants :=  nom_c :: !pretendants)
    table_candidats;
  (* on récupère tous les candidats qui souhaitent intégrer nom_formation 
  et on les ajoute à la liste pretendants *)
  ignore(fonction_comparaison);
  pretendants := List.sort compare !pretendants;
  (* on tri avec notre fonction de comparaison éventuellement compare dans ce cas*)
  Hashtbl.add session.commissions nom_formation !pretendants;; 
  (* on ajoute la liste triée aux commissions *)


let reunit_commissions session =
  session.etat <- Appel;;
let get_option = function
| Some x -> x
| None -> raise (Invalid_argument "Option.get");;
let nouveau_jour session =
(* si nombre propositions >= capacite, ne rien proposer, sinon proposer capacité-nb propositions*)
  Hashtbl.iter (fun formation liste_appel -> begin
  while ((Hashtbl.find session.formations formation > 0) && (liste_appel <> [])) do begin
     (* capacite > 0 et liste_appel non épuisée *)
  match liste_appel with
  | x::t -> begin
    (Hashtbl.replace session.propositions formation x); (* proposer au mieux classé *)
    let capacite_temp = Hashtbl.find session.formations formation in
    (Hashtbl.replace session.commissions formation t); (* on met à jour la liste d'appel *)
    (Hashtbl.replace session.formations formation (capacite_temp-1)); (* on met à jour la capacité *)

    if (Hashtbl.length session.propositions > 0) then begin
      (* si ensemble propositions non vide *)
      Hashtbl.iter (fun formation_bis candidat -> begin
        (* on itère sur les propositions*)
      let voeux_candidat = (Hashtbl.find session.candidats candidat) in
  
      if (Hashtbl.mem voeux_candidat formation_bis) then begin 
        (* si proposition est dans les voeu du candidat *)
        let rang_proposition = Hashtbl.find voeux_candidat formation_bis in

        Hashtbl.iter (fun voeu rang -> begin
          if ((get_option rang_proposition) < (get_option rang)) then begin
            print_string ("Comparaison entre"^voeu^" et "^formation_bis);
            (* si rang_proposition est inferieur à rang voeu courant *)
            let cap_bis = Hashtbl.find session.formations voeu in
            if (List.mem candidat (Hashtbl.find_all session.propositions voeu)) then begin
              (* si candidat a reçu une proposition pour le voeu courant *)
              Hashtbl.replace session.formations voeu (cap_bis+1); end;
            print_string ("Suppression de "^voeu^ "\n")

            end; Hashtbl.remove voeux_candidat formation_bis; end) voeux_candidat
        end end) session.propositions
    end end
  |_ -> () end done end) session.commissions;
  ;;


let renonce session ~nom_candidat ~nom_formation = 
  (* Hashtbl.filter_map_inplace (fun nom v -> match v with |  -> None | _ -> Some v) session.propositions ;; *)
  ignore session;
  ignore nom_candidat;
  ignore nom_formation;
  failwith "non implémenté"

let consulte_propositions session ~nom_candidat =
  ignore session;
  ignore nom_candidat;
  failwith "non implémenté"

let consulte_voeux_en_attente session ~nom_candidat = 
  ignore session;
  ignore nom_candidat;
  failwith "non implémenté"
