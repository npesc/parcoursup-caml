# parcoursup-caml
Projet de programmation fonctionnelle en OCaml.

### Algorithmes  mariages stables
- Knuth - [knuth.ml](https://github.com/npesc/parcoursup-caml/blob/master/mariages_stables/knuth.ml) / [doc](https://www-cs-faculty.stanford.edu/~knuth/mariages-stables.pdf)
- Gale Shapley - [gale_shapley.ml](https://github.com/npesc/parcoursup-caml/blob/master/mariages_stables/gale_shapley.ml) /  [doc](https://www.i3s.unice.fr/~elozes/enseignement/PF/sujet-projet-pf-2021.html#algorithme-de-gale-shapley)
- Abstrait - [algo_abstrait.ml](https://github.com/npesc/parcoursup-caml/blob/master/mariages_stables/algo_abstrait.ml) / [doc](https://www.i3s.unice.fr/~elozes/enseignement/PF/sujet-projet-pf-2021.html#algorithme-abstrait) 

**Format d'entrée** 
```ocaml
(* exemple.ml *)
let exemple_knuth = 
  let a,b,c,d = 0,1,2,3 in
  {
    n = 4;
    liste_appel_de = [|
      [|c;b;d;a|];
      [|b;a;c;d|];
      [|b;d;a;c|];
      [|c;a;d;b|];
    |];
    prefere = prefere_of [|
        [|a;b;d;c|];
        [|c;a;d;b|];
        [|c;b;d;a|];
        [|b;a;c;d|]
      |]
  } 
```
```
SORTIE { Ad Ba Cb Dc }
```

### Parcoursup
Bibliothèque de fonctions utilitaires pour simuler une session [parcoursup](https://fr.wikipedia.org/wiki/Parcoursup).
 - API - [api.ml](https://github.com/npesc/parcoursup-caml/blob/master/parcoursup/api.ml) / [doc](https://github.com/npecs/parcoursup-caml/blob/c7b7d37438f7763f284edb05a02995db2cf9e3be/parcoursup/api.mli)

#### Auteur: [@npesc](https://github.com/npesc)
