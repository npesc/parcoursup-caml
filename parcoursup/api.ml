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
  mutable voeux: string list;
}

type etudiant = {
  nom: string;
  mutable voeux: (string, int option) Hashtbl.t; (* (nom_formation * rang_repondeur) list *) 
}


type session = {
  mutable etat: etat;
  candidats: (string, (string, int option) Hashtbl.t) Hashtbl.t;
  (* (nom_candidat, (nom_formation, Some rang) Hashtable) Hashtable*)
  mutable formations: formation list;
}

let nouvelle_session () = {
  etat=EnCours;
  candidats=Hashtbl.create 1000;
  formations=[];
  }

let ajoute_candidat session ~nom_candidat = 
  let voeu_hashtbl = Hashtbl.create 30 in 
  Hashtbl.add session.candidats nom_candidat voeu_hashtbl
;;

let ajoute_formation session ~nom_formation ~capacite =
    session.formations <- {nom=nom_formation;capacite=capacite;voeux=[]} :: session.formations
  

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  let rang = ref (Float.to_int infinity) in
  match rang_repondeur with | Some n -> rang := n; | _ -> ();
  
  if (Hashtbl.mem session.candidats nom_candidat) then (* si candidat est présent dans hashtable de la session *)
    Hashtbl.replace (Hashtbl.find session.candidats nom_candidat) nom_formation (Some !rang)
  else invalid_arg "Erreur ajout voeu candidat";;

let ajoute_commission session ~nom_formation ~fonction_comparaison = 
  ignore session;
  ignore nom_formation;
  ignore fonction_comparaison;
  failwith "non implémenté"

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
