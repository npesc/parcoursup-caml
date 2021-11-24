(********************************* NOTION DE SESSION *********************************)

type session
(** 
    Une session est une structure de données mutable qui contient l'état d'avancement
    de la procédure parcoursup en cours. Typiquement chaque année correspond à une nouvelle session
    (session 2021, session 2022, etc).
**)

val nouvelle_session : unit -> session
(**
    Cette fonction crée une nouvelle session; initialement il n'y a aucun candidat
    enregistré ni aucune formation. Les candidats et les formations
    sont ajoutés à la session par les fonctions de configuration de session
    ci-dessous.

    Attention, on doit pouvoir travailler avec plusieurs sessions simultanément
    sans qu'il y ait d'interférences, par exemple une session "parcoursup belge 2030" 
    et une autre session "parcoursup français 2030".
**)

(*********************** FONCTIONS DE LA PHASE DE CONFIGURATION *********************)

(**  
    Les fonctions ci-dessous sont appelées pendant la phase de configuration,
    soit avant la fonction reunit_commission (cf ci-dessous), et 
    avant la phase d'appel de parcoursup. Les candidats et les formations 
    doivent s'enregistrer.
**)

val ajoute_candidat : session -> nom_candidat: string -> unit
(** 
    Ajoute un candidat à la session. On suppose que tous les candidats
    ont des noms différents
**)


val ajoute_formation : session -> nom_formation: string -> capacite: int -> unit
(** 
    Ajoute un formation à la session. On suppose que toutes les formations
    ont des noms différents. On doit préciser le nombre de places disponibles
    dans la formation.
**)

val ajoute_voeu : session -> rang_repondeur: int option -> nom_candidat: string -> nom_formation: string -> unit
(** 
    Un candidat exprime son voeu pour une formation. Il peut classer ses différents
    voeux en donnant un rang à chaque voeu dans son "repondeur automatique" 
    (mais il n'est pas obligé).
    Les voeux de rang 0 sont les voeux préférés, puis ceux de rang 1, etc.
    Si on appelle deux fois ajoute_voeu pour un même candidat et une même formation,
    c'est le rang utilisé au second appel qui est retenu 
    (autrement dit, le candidat peut modifier le classement de ses voeux).
    On suppose pour simplifier que cette fonction n'est pas appelée
    durant la phase d'appel (les candidats ne modifient pas leurs voeux ni
    leur répondeur automatique une fois la phase d'appel démarée).
    Un voeu pour lequel un rang n'a pas été exprimé est un voeu avec un rang "infini"
    (en quelque sorte, "le répondeur automatique n'a pas été activé").
**)



val ajoute_commission : 
    session -> 
    nom_formation: string -> 
    fonction_comparaison: (candidat1:string -> candidat2: string -> bool) ->
    unit
(**
    Une formation peut mettre en place une commission d'examen des candidatures.
    Avant de se réunir, la commission se met d'accord sur un algorithme 
    (appelé parfois "algorithme local") permettant de classer deux candidats
    quelconques (on ne connait pas encore la liste des candidats). 
    La fonction de comparaison f passée en argument renvoie true pour

    f ~candidat1:"Lucas" ~candidat2:"Sonia" 

    si l'algorithme local de la commission classe Lucas avant Sonia. 
    Bien sûr on simplifie ici, on suppose que le classement se fait uniquement sur la 
    base du nom du candidat, ce qui n'est pas le cas en vrai (on espère...)
**)


(************************** FONCTION REUNIT COMMISSIONS **********************)

(**
    Entre la phase de configuration et la phase d'appel, 
    les commissions de classement des différentes
    formations se réunissent et définissent une liste d'appel pour chaque formation. 
    On simplifie un peu, et on suppose que tout candidat qui a émis un voeu pour une formation
    apparait sur la liste d'appel de cette formation 
    (mais en vrai les formations peuvent ne pas classer des candidats "trop faibles").
**)


val reunit_commissions : session -> unit
(**
    Cette fonction est appelée pour clôturer la phase de configuration
    et pour ouvrir la phase d'appel. Elle est appelée exactement une fois.
    Cette fonction calcule les listes d'appels de chaque formation enregistrée en 
    fonction des voeux de candidats enregistés. On suppose que toutes les formations 
    ont mis en place une commission de classement dans la phase de configuration.
**)


(************************** FONCTIONS DE LA PHASE D'APPEL **********************)

(** 
    Les fonctions ci-dessous sont appelées pendant la phase d'appel,
    soit après la fonction reunit_commission.

    Chaque jour les candidats peuvent consulter les formations pour lesquelles
    ils ont reçu une proposition d'affectation. Ils peuvent renoncer à des voeux
    encore en attente ou a des propositions qu'ils ont reçus. S'ils ont défini
    des rangs sur leurs voeux, une nouvelle proposition leur fait automatiquement
    renoncer à toutes les propositions de rangs ultérieurs.
**)




val nouveau_jour : session -> unit
(**
    Cette fonction est appelée chaque jour en début de journée. Elle 
    met à jour la liste des propositions faites à chaque candidat en fonction
    des désistements qui ont eu lieu depuis le dernier appel à nouveau_jour.
    Les rangs d'appels de chaque formation sont donc aussi mis à jour quand
    on appelle cette fonction, de même que la liste des voeux en attente.
    Après appel de nouveau_jour, toute formation a soit épuisé sa liste d'appel,
    soit autant de propositions en attente la concernant que son nombre de places.
    Notez bien qu'un candidat renonce automatiquement à toutes les propositions
    et à tous les voeux de rangs de répondeurs
    supérieurs à une nouvelle proposition qu'il reçoit.
    En particulier, si tous les candidats ont activé leur répondeur automatique
    et ont donné des rangs distincts à leur voeux, la phase d'appel ne dure qu'une 
    journée (en supposant que personne ne renonce ensuite à son unique proposition).
    Enfin, on simplifie ici, et on suppose que les candidats peuvent garder toutes leurs
    propositions sans faire de choix entre elles autant de jours d'affilée qu'ils le 
    veulent.
**)

val renonce : session -> nom_candidat: string -> nom_formation: string -> unit
(**
    Cette fonction est appelée quand un candidat renonce à une formation,
    à savoir soit une des propositions qu'il a reçues, soit un voeu encore en attente.
    Lorsque le candidat renonce à une proposition, il libère une place dans la formation
    concernée, qui devra envoyer de nouvelles propositions à d'autres candidats le jour 
    suivant. Les rangs d'appels des formations et les listes de propositions ne sont 
    donc pas mises à jour immédiatement, c'est la fonction nouveau_jour qui fera 
    l'actualisation.
    Seules les listes des propositions et des voeux en attente du candidat sont
    actualisées par la fonction renonce.
**)

val consulte_propositions : session -> nom_candidat: string -> string list
(**
    Cette fonction permet d'avoir la liste des formations pour lesquelles
    le candidat a reçu une proposition d'affectation qu'il n'a pas refusée.
**)

val consulte_voeux_en_attente : session -> nom_candidat: string -> (string * int) list
(**
    Cette fonction permet d'avoir la liste des formations pour lesquelles
    le candidat a un voeu en attente, et pour chacune son rang sur la liste
    complémentaire, i.e. combien d'autres candidats en attente sont devant lui, 
    soit 0 si le candidat est le premier sur la liste complémentaire.
**)
