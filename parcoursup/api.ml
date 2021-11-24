(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
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
  id_session: string;
  mutable etat: etat;
  mutable candidats: etudiant list;
  mutable formations: formation list;
}

let nouvelle_session () = {
  id_session=string_of_float (Unix.time ());
  etat=EnCours;
  candidats=[];
  formations=[];
  }

let ajoute_candidat session ~nom_candidat =
  match nom_candidat with
  | None -> begin 
    session.candidats <- {nom=string_of_int (List.length session.candidats);voeux=[]} :: session.candidats;
    end
  | Some s -> begin session.candidats <- {nom=s;voeux=[]} :: session.candidats end;;

let ajoute_formation session ~nom_formation ~capacite =
  match nom_formation, capacite with
  | Some nom_f, Some cap_f ->
    session.formations <- {nom=nom_f;capacite=cap_f;voeux=[]} :: session.formations
  | _ -> invalid_arg "Paramètres de formation manquants";;
  
  
let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  ignore session;
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
