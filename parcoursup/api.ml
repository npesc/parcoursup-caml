(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
type etat = | EnCours | Close
type session = {mutable etat: etat}


let nouvelle_session () = 
  failwith "non implémenté"

let ajoute_candidat session ~nom_candidat = 
  ignore session;
  ignore nom_candidat;
  failwith "non implémenté"

let ajoute_formation session ~nom_formation ~capacite =
  ignore session;
  ignore nom_formation;
  ignore capacite;
  failwith "non implémenté"

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
