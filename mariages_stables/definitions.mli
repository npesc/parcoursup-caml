type homme = int

val string_of_homme : homme -> string
    (** 
    l'homme 0 est affiché "A", l'homme 1 est affiché "B", etc
    suivant les notations du cours de D. Knuth                  
    **)


type femme = int

val string_of_femme : femme -> string
    (** 
    la femme 0 est affichée "a", la femme 1 "b" , etc
    suivant les notations du cours de D. Knuth                  
    **)

type entree = {

    n : int; 
    (** 
    n = nombre de femmes = nombre d'hommes
    ensemble des hommes = ensemble des femmes = {0,..,n-1}
    **)

    liste_appel_de : femme array array;
    (** 
    entree.liste_appel_de.(aime).(2) vaut desiree si
    Désirée est le troisieme choix d'Aimé 
    (le premier choix est à l'indice 0 du tableau)
    **)

    prefere : (homme -> homme -> bool) array;
    (**
    entree.prefere.(mina) dimitri david vaut true si
    Mina préfère Dimitri à David
    **)

}

val entree_valide : entree -> bool

val print_entree : entree -> unit

type sortie = (homme * femme) list
    (** 
    les couples formés à l'issue de l'algorithme
    comme il y a n hommes et n femmes, il doit y avoir n couples 
    pour une entrée bien formée
    **) 

val print_sortie : sortie -> unit

type configuration = {

    rang_appel_de : int array;
    (**
    conf.rang_appel_de.(habib) vaut 3 si l'une des conditions
    suivantes est vraie : 
    - Habib est actuellement fiancé à son quatrième choix 
      (rappel : son quatrième choix se trouve à l'indice 3 
      de sa liste d'appel)
    - Habib est actuellement célibataire, quand ce sera son tour
      il fera sa prochaine proposition à son quatrième choix
    **)

    fiance_de : homme option array;
    (**
    conf.fiance_de.(fitia) vaut Some milan si Fitia est actuellement
    fiancée à Milan, None si Fitia est actuellement célibataire
    **)

} 

val print_configuration : configuration -> unit