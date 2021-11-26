(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
open Unix;;
open Hashtbl;;
type etat = | EnCours | Close

type formation = {
  nom: string;
  mutable capacite: int;
}

type etudiant = {
  nom: string;
  voeux: (string, int option) Hashtbl.t; (* (nom_formation * rang_repondeur) list *) 
}


type session = {
  mutable etat: etat;
  candidats: (string, (string, int option) Hashtbl.t) Hashtbl.t;
  (* (nom_candidat, (nom_formation, Some rang) Hashtable) Hashtable*)
  formations: (formation , string array) Hashtbl.t;
  (* (formation, commission) Hashtable *)
}

let nouvelle_session () = {
  etat=EnCours;
  candidats=Hashtbl.create 1000;
  formations= Hashtbl.create 100;
  }

let ajoute_candidat session ~nom_candidat = 
  let voeu_hashtbl = Hashtbl.create 30 in 
  Hashtbl.add session.candidats nom_candidat voeu_hashtbl
;;

let ajoute_formation session ~nom_formation ~capacite =
  Hashtbl.add session.formations {nom=nom_formation;capacite=capacite;} [||];;
  

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  let rang = ref (Float.to_int infinity) in
  begin match rang_repondeur with 
    | Some n -> rang := n;
    | _ -> (); end;
  if (Hashtbl.mem session.candidats nom_candidat) then (* si candidat est présent dans hashtable de la session *)
    Hashtbl.replace (Hashtbl.find session.candidats nom_candidat) nom_formation (Some !rang)
  else invalid_arg "Erreur ajout voeu, candidat introuvable";;

let ajoute_commission session ~nom_formation ~fonction_comparaison = 
  let table_candidats = session.candidats in
  let pretendants =  ref (Array.make (Hashtbl.length table_candidats) "") in
  Hashtbl.iter (fun nom_c voeux ->
    if Hashtbl.mem voeux nom_formation 
    then pretendants := Array.append !pretendants [|nom_c|];)
    table_candidats;
  (Array.sort fonction_comparaison !pretendants);;


let reunit_commissions session =
  ignore session;
  failwith "non implémenté"

let nouveau_jour session =
  ignore session;
  failwith "non implémenté"

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
