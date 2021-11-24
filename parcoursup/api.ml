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
  mutable voeux: (int option * string) list; (* (rang_repondeur * nom_formation) list *) 
}

type session = {
  (* id_session: string; *)
  mutable etat: etat;
  mutable candidats: etudiant list;
  mutable formations: formation list;
}

let nouvelle_session () = {
  (* id_session=string_of_float (Unix.time ()); *)
  etat=EnCours;
  candidats=[];
  formations=[];
  }

let ajoute_candidat session ~nom_candidat = session.candidats <- {nom=nom_candidat;voeux=[]} :: session.candidats
let ajoute_formation session ~nom_formation ~capacite =
    session.formations <- {nom=nom_formation;capacite=capacite;voeux=[]} :: session.formations
  

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  let liste_candidats = session.candidats in
  let rang = ref (Float.to_int infinity) in
  match rang_repondeur with | Some n -> rang := n; | _ -> ();
  let voeu = (rang,nom_formation) in


  ignore rang_repondeur;
  ignore nom_candidat;
  ignore nom_formation;
  failwith "non implémenté"

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
