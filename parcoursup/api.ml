(* 
┌─┐┌─┐┬─┐┌─┐┌─┐┬ ┬┬─┐┌─┐┬ ┬┌─┐
├─┘├─┤├┬┘│  │ ││ │├┬┘└─┐│ │├─┘
┴  ┴ ┴┴└─└─┘└─┘└─┘┴└─└─┘└─┘┴   
 *)
(* open Hashtbl *)
type etat = | Config | Appel

let rec ind x lst c = match lst with
  | [] -> raise(Failure "Not Found")
  | hd::tl -> if (hd=x) then c else ind x tl (c+1);;
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
  propositions: (string, string list) Hashtbl.t; 
  (* formation, fonction_comparaison *)
  algo_locaux: (string, (string -> string -> int)) Hashtbl.t;
}
let get_option session = function
| Some x -> x
| None -> ((Hashtbl.length session.formations)+1);;

let nouvelle_session () = {
  etat=Config;
  candidats=Hashtbl.create 1000 ~random:false;
  formations=Hashtbl.create 100 ~random:false;
  commissions=Hashtbl.create 100 ~random:false;
  propositions=Hashtbl.create 100 ~random:false;
  algo_locaux=Hashtbl.create 100 ~random:false;
  }

let ajoute_candidat session ~nom_candidat = 
  let voeu_hashtbl = Hashtbl.create 30 ~random:false in 
  Hashtbl.add session.candidats nom_candidat voeu_hashtbl
;;

let ajoute_formation session ~nom_formation ~capacite =
  Hashtbl.add session.formations nom_formation capacite;
  Hashtbl.add session.propositions nom_formation [];;
  

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = 
  Hashtbl.replace (Hashtbl.find session.candidats nom_candidat) nom_formation rang_repondeur;;

let ajoute_commission session ~nom_formation ~fonction_comparaison = 
  let aux candidat1 candidat2 = match fonction_comparaison ~candidat1 ~candidat2 with | true -> 1 | _ -> -1 in
  Hashtbl.replace session.algo_locaux nom_formation aux;;

let renonce_rang rang_prop table_voeux candidat session =
  Hashtbl.iter (fun voeu rang ->
      if (get_option session (rang_prop) < (get_option session (rang))) then begin
      (* si rang_proposition est inferieur à rang voeu courant *)
        let cap_bis = Hashtbl.find session.formations voeu in
        if ((List.mem candidat (Hashtbl.find session.propositions voeu) && (rang <> None))) then begin
        (* si candidat a reçu une proposition pour le voeu courant et qu'il a activé son répondeur *)
          Hashtbl.replace session.formations voeu (cap_bis+1);
        end;
  
        if (List.length (Hashtbl.find session.propositions voeu) > 0) then
          Hashtbl.replace session.propositions voeu (remove candidat (Hashtbl.find session.propositions voeu));
        Hashtbl.remove table_voeux voeu;
        Hashtbl.replace session.commissions voeu (remove candidat (Hashtbl.find session.commissions voeu)); 
      (* suppression du candidat de la liste d'appel du voeu renoncé *)
      end) table_voeux;;

let reunit_commissions session =
  session.etat <- Appel;
  let table_candidats = session.candidats in
  Hashtbl.iter (fun nom_c voeux -> (* voeux -> hashtable de voeux du candidat *)
    Hashtbl.iter (fun voeu _ -> 
      let commission = ref [] in
      begin match (Hashtbl.find_opt session.commissions voeu) with
        | None -> () | Some l -> commission := l end;
      if not(List.mem nom_c !commission) 
      then Hashtbl.replace session.commissions voeu (nom_c :: !commission)) voeux) table_candidats;
  Hashtbl.iter (fun formation com -> 
    Hashtbl.replace session.commissions formation (List.rev (List.sort (Hashtbl.find session.algo_locaux formation) com)))
    session.commissions;;
  (* on ajoute la liste triée aux commissions *)

let nouveau_jour session =
  let rec propose f = function
    | [] -> (); (* liste d'appel vide -> rien proposer *)
    | x :: t ->
      if (not(List.mem x (Hashtbl.find session.propositions f)) && (Hashtbl.find session.formations f > 0)) then begin
        let prop_list = Hashtbl.find session.propositions f in
        Hashtbl.replace session.propositions f (x::prop_list); (* proposer au mieux classé *)
        Hashtbl.replace session.commissions f t; (* on met à jour la liste d'appel *)
        let capacite_temp = Hashtbl.find session.formations f in
        Hashtbl.replace session.formations f (capacite_temp-1); (* on met à jour la capacité *)  
      end; propose f t;in
  Hashtbl.iter (fun formation liste_appel ->
      propose formation liste_appel; 
      if (Hashtbl.length session.propositions > 0) then begin (* si ensemble propositions non vide *)
        Hashtbl.iter (fun proposition liste_candidats -> (* on itère sur les propositions *)
            List.iter (fun candidat -> 
                let voeux_candidat = (Hashtbl.find session.candidats candidat) in 
                let rang_proposition = Hashtbl.find voeux_candidat proposition in
                renonce_rang rang_proposition voeux_candidat candidat session) liste_candidats)
                (* renonce aux voeux de rang inférieur *)
          session.propositions end) session.commissions;
  (* itération finale pour reproposer dans le cas où des propositions ont été refusées automatiquement *)
  Hashtbl.iter (fun f liste_appel -> if (Hashtbl.find session.formations f > 0) then propose f liste_appel;) 
  session.commissions;; 

let renonce session ~nom_candidat ~nom_formation = 
  let prop_temp = Hashtbl.find session.propositions nom_formation in 
  if (List.mem nom_candidat prop_temp) then begin
    let capacite_temp = Hashtbl.find session.formations nom_formation in
    Hashtbl.replace session.propositions nom_formation (remove nom_candidat prop_temp);
    Hashtbl.replace session.formations nom_formation (capacite_temp+1) end;
  Hashtbl.remove (Hashtbl.find session.candidats nom_candidat) nom_formation; (* suppression du voeu dans la tablevoeux du candidat *) 
  let liste_appel = Hashtbl.find session.commissions nom_formation in
  Hashtbl.replace session.commissions nom_formation (remove nom_candidat liste_appel);;

let consulte_propositions session ~nom_candidat =
  let liste = ref [] in
  Hashtbl.iter (fun formation propositions -> 
      if (List.mem nom_candidat propositions) then liste := formation :: !liste)
    session.propositions;
  List.rev !liste;;

let consulte_voeux_en_attente session ~nom_candidat = 
  let res = ref [] in
  Hashtbl.iter (fun voeu _ ->
      if (not(List.mem nom_candidat (Hashtbl.find session.propositions voeu)))
      then res := (voeu, ind nom_candidat (Hashtbl.find session.commissions voeu) 0) :: !res;)
    (Hashtbl.find session.candidats nom_candidat);
  !res;;