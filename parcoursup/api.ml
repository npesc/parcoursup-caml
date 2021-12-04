(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
open Hashtbl;;
type etat = | Config | Appel | Close

let get_option = function
| Some x -> x
| None -> raise (Invalid_argument "Option.get");;

let rec remove x l = match l with
  | [] -> []
  | hd :: tl -> if x=hd then remove x tl else hd::remove x tl;;

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
  let rang = ref ((Hashtbl.length session.formations)+1) in
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

let renonce_rang rang_prop table_voeux candidat session =
  Hashtbl.iter (fun voeu rang ->
        if ((get_option rang_prop) < (get_option rang)) then begin
          (* si rang_proposition est inferieur à rang voeu courant *)
          let cap_bis = Hashtbl.find session.formations voeu in
          if (List.mem candidat (Hashtbl.find_all session.propositions voeu)) then begin
          (* si candidat a reçu une proposition pour le voeu courant *)
            Hashtbl.replace session.formations voeu (cap_bis+1);
            Hashtbl.remove session.propositions voeu; 
          end;
          Hashtbl.remove table_voeux voeu;
          Hashtbl.replace session.commissions voeu (remove candidat (Hashtbl.find session.commissions voeu));
          (* suppression du candidat de la liste d'appel du voeu renoncé *)
        end) table_voeux;;

let reunit_commissions session =
  session.etat <- Appel;;

let nouveau_jour session =
  let rec propose f = function
    | [] -> (); (* liste d'appel vide -> rien proposer *)
    | x :: t ->
        if (not(List.mem x (Hashtbl.find_all session.propositions f)) && (Hashtbl.find session.formations f > 0)) then begin
          Hashtbl.add session.propositions f x; (* proposer au mieux classé *)
          Hashtbl.replace session.commissions f t; (* on met à jour la liste d'appel *)
          let capacite_temp = Hashtbl.find session.formations f in
          Hashtbl.replace session.formations f (capacite_temp-1); (* on met à jour la capacité *)  
        end;
        propose f t;in
  Hashtbl.iter (fun formation liste_appel ->
      propose formation liste_appel; 
      if (Hashtbl.length session.propositions > 0) then begin (* si ensemble propositions non vide *)
        Hashtbl.iter (fun proposition candidat -> (* on itère sur les propositions*)
            let voeux_candidat = (Hashtbl.find session.candidats candidat) in
            if (Hashtbl.mem voeux_candidat proposition) then begin (* si proposition est dans les voeu du candidat *)
              let rang_proposition = Hashtbl.find voeux_candidat proposition in
              renonce_rang rang_proposition voeux_candidat candidat session;end) (* renonce au voeux de rang inférieur *)
              session.propositions end) session.commissions;;

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
