type tformula=
  |Value of bool
  |Var of string
  |Not of tformula
  |And of tformula*tformula
  |Or of tformula*tformula
  |Implies of tformula*tformula
  |Equivalent of tformula*tformula

type decTree=
  |DecLeaf of bool
  |DecRoot of string*decTree*decTree

type bddNode=
 | BddLeaf of int*bool
 | BddNode of int*string*int*int

type bdd= (int*(bddNode list))
type env= (string*bool) list

(*q1*)
(* cette fonction prend en argument un élément et une liste d'éléments du même type que l'élément précédent et renvoie une liste. Elle permet de vérifier si un élément est dans la liste plusieurs fois. S'il y est plusieurs fois, on le garde qu'une seule fois.*)
val existe : 'a-> 'a list -> 'a list

(*Cette fonction prends en argument une liste et renvoie la liste sans doublons. Elle fait appel à la fonction précedente si elle possède un nombre impair d'éléments*)
val supprimedoublons: 'a list -> 'a list

(*Cette fonction prend un tformula en argument et renvoie une liste de toutes les variables présentes dans la tformula sans doublons *)
val getVars: tformula-> string list

(*q2*)
(* Cette fonction prend en argument un env et un string et renvoie le couple (string*bool) associé à la string en argument*)
val search: env ->string->string*bool

(* cette fonction prend en argument un env et une string et renvoie le booléen associé à la string dans l'env. On utilise la fonction précédente pour récupérer le couple puis on extrait le second élément du couple*)
val variable:env->string->bool

(* Cette fonction prend en argument un env et un tformula et renvoie la valeur de la tformula lorsque les variables prennent les valeurs dans l'env. On fait appel à la fonction variable lorsque la tformula est une Var *)
val evalFormula: env->tformula->bool

(*q3*)
(*Cette fonction contstruit un arbre à partir d'une tformula, d'un env et d'une string list. Tant que la string list n'est pas vide, on continue de construire l'arbre en ajoutant à l'env le couple (h,false) pour le sous arbre gauche, (h,true) pour le droit*)
val buildTreeAux: tformula->env->string list ->decTree

(*Cette fonction construit l'arbre en faisant appel à buildTreeAux, en initialisant l'env avec une liste vide et la string list par l'ensemble des variables de la tformula*)
val buildTree: tformula->decTree


(*q4*)
val buildBDD: tformula->bdd

(*q5*)

(*cette fonction prend en argument une bddNode list et renvoie la bddNode list sans BddNode de la forme (n,s,p,p)*)
val sup: bddNode list ->bddNode list

(* Cette fonction remplace le premier argument par le second dans la bdd. La valeur des noeuds ne change pas mais on change seulement la valeur des descendants.*)
val remplace: int->int->bddNode list->bddNode list

(* Cette fonction  prend en argument une bdd et renvoie la liste des noeuds ayant 2 fois le meme descendants*)
val double: int*bddNode list->int list

(*Cette fonction récupère les descendants du noeud associé à l'entier rentré en arguments. Je renvois seulement un élément et non 2 car dans ma fonction finale, je récupère seulement les descendants des noeuds ayant 2 fois le même descendants. Par exemple,recup n BddNode (n,s,p,p) renvoie p. Il est nécessaire de rentrer en argument une BddNode (n,s,p,p) *) 

val recup: int->'a*bddNode list->int

(*Cette fonction simplifie une bdd commme souhaité. Elle fait appel a toutes les fonctions définies juste au dessus. On recupère la liste des noeuds ayant des descendants similaires. On recupère le numéro de ces descendants. On remplace dans la bdd, on remplace seulement les descendants. Une fois les remplacement fais, on supprime les doublons puis on renvoie la bdd. *)
val simplifyBDD: bdd->bdd

(*q6*)
(* cette fonction vérifie si on a la bdd d'une tautologie. Elle prend en argument une tformula qui est transformé en bdd. On simplifie la bdd et on vérifie si on obtient la formule donnée dans l'énoncé.*)
val isTautology: tformula-> bool

(*q7*)
(*Cette fonction permet de comparer 2 listes et renvoie true si les listes sont égales, false sinon.*)
val comparer: 'a list-> 'a list->bool

(*Cette fonction compare 2 tformula. Si elle possèdent la même bdd, alors elles sont identiques. La numérotation des noeuds est très importants ici. Il faut respecter un ordre de numérotation puisque si un numéro diffère, areEquivalent renverra false même si elles sont identiques dans la réalité.*)
val areEquivalent: tformula->tformula->bool

(*q8*)
(*Cette fonction renvoie un fichier DOT contenant la description de la BDD pour ensuite tracer dans un df le graphique associé à la BDD *)
val dotBDD:string->bdd->unit

(*q9*)
(*Cette fonction renvoie un fichier DOT contenant la description de la BDD pour ensuite tracer dans un df le graphique associé à l'arbre*)
val dotTree:string->decTree->unit