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
  propositions: (string, string list) Hashtbl.t; 
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

let nouveau_jour session =
  (* si nombre propositions >= capacite, ne rien proposer, sinon proposer capacité-nb propositions*)
    Hashtbl.iter (fun formation liste_appel -> begin
    while ((Hashtbl.find session.formations formation > 0) && (liste_appel <> [])) do begin
    match liste_appel with
    | x::t -> begin
      let prop_temp = (Hashtbl.find session.propositions formation) in
      (Hashtbl.replace session.propositions formation (x :: prop_temp));
      let capacite_temp = Hashtbl.find session.formations formation in
      (Hashtbl.replace session.commissions formation t); (* on met à jour la liste d'appel *)
      (Hashtbl.replace session.formations formation (capacite_temp-1)); end (* on met à jour la capacité *)
    |_ -> () end done end) session.commissions;;


let renonce session ~nom_candidat ~nom_formation = 
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
