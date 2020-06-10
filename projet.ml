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


(* question 1*)

let rec existe h t=match t with
|[]-> []
|a::t1-> if (a=h) then existe h t1 else [a]@(existe h t1);;

let rec supprimedoublons t= match t with
 |[]->[]
 |h::[]-> existe h t
 |h::n::t1 -> if (h=n) then [h]@(supprimedoublons t1)
             else [h;n]@(supprimedoublons t1);; 

let rec getVars (f:tformula)= match f with
  |Value true -> []
  |Value false->[]
  |Var (v) -> [v]
  |Not (t) -> supprimedoublons(List.sort compare (getVars t))
  |And (t1,t2)->supprimedoublons(List.sort compare (getVars t1  @ getVars t2))
  |Or(t1,t2)->supprimedoublons( List.sort compare (getVars t1 @getVars t2))
  |Implies(t1,t2)->supprimedoublons(List.sort compare (getVars t1 @getVars t2))
  |Equivalent(t1,t2)->supprimedoublons(List.sort compare (getVars t1 @ getVars t2));; 



(*question 2*)
type env= (string*bool) list

let rec search (env:env) v= match env with
  |[]-> ("",false)
  |h::t-> if (v= (fst h)) then h else search t v;;

let variable (t:env) (v:string)= snd(search t v);; 

let rec evalFormula (t:env) (f:tformula)= match f with
 |Value v->v
 |Var v-> variable t v 
 |Not v-> if ((evalFormula t v)=true) then false else true
 |And(v1,v2) -> (match (evalFormula t v1, evalFormula t v2) with
                 |(true,true)->true
                 |(_,_)->false)
 |Or(v1,v2) -> (match (evalFormula t v1, evalFormula t v2) with
                 |(false,false)->false
                 |(_,_)->true)
 |Implies (v1,v2)->(match (evalFormula t v1, evalFormula t v2) with
                 |(true, false)->false
                 |(_,_)->true)
 |Equivalent (v1,v2)->(match (evalFormula t v1, evalFormula t v2) with
                 |(true, true)->true
                 |(false, false)->true
                 |_,_->false);;


(*question 3*)

let rec buildTreeAux (t:tformula) (e:env) (l:string list) = match l with
 |[]-> DecLeaf (evalFormula e t )
 |h::l1 -> DecRoot(h, (buildTreeAux t (e@[h,false]) l1), (buildTreeAux t (e@[h,true]) l1));;
 
let buildTree (t:tformula)= buildTreeAux t [] (getVars t);;

(*question 4*)
(*j'initialise juste cette fonction pour que mon code compile sans erreur, lors de la création de la fonction isTautology ou areEquivalent.*)
let rec buildBDD (t:tformula) : bdd= (1,[]);;

(*question 5*)
let rec sup  l= match l with
|[]-> []
|h::l1-> match h with |BddNode (a,b,c,d)-> if (c=d) then (sup l1) else [h]@(sup l1)
                      |BddLeaf (_,_)->[h]@(sup l1);;

let rec remplace n p l= match l with
|[]->[]
|h::l1->match h with |BddNode (e,t,a,b)-> if ((a=n)&&(b!=n)) then [BddNode(e,t,p,b)]@(remplace n p l1)
else if ((a!=n)&&(b=n)) then [BddNode(e,t,a,p)]@(remplace n p l1)
else if((a=n)&&(b=n)) then [BddNode(e,t,p,p)]@(remplace n p l1)
else [h]@(remplace n p l1)
|BddLeaf(a,b)->[BddLeaf(a,b)]@(remplace n p l1) ;;

let rec double list= match list with
|(_,[])->[]
|(a,h::l1)->match h with |BddNode(a,_,n,m)-> if (n=m) then [a]@(double(a,l1)) else (double (a,l1))
                     |_->double (a, l1);;

let longueur l= List.length(l);;

let rec recup i l =match l with
|(_,[])->0
|(a,h::l1)->match h with |BddNode(r,s,t,u)->if (r=i) then t else (recup i (a,l1) )
                         |_->(recup i (a,l1) );;


let simplifyBDD (b:bdd):bdd= 
let d=double b in
let i=longueur d-1 in
let rec remplacement b i= match i with 
|0->(fst(b), remplace (List.nth d 0) (recup (List.nth d 0) b)   (snd(b)))
|a-> remplacement ((fst(b), (remplace (List.nth d a) (recup (List.nth d a) b)   (snd(b))))) (a-1) in
let sup=sup (snd(remplacement b i))
in (fst(b), sup);;



(*question 6*)
let isTautology (f:tformula)= let m= simplifyBDD(buildBDD f) in match m with
  |(_,[BddLeaf(_,true)])->true
  |_->false;;


(*question 7*)
let rec comparer (t1: 'a list) (t2: 'a list) = match t1,t2 with
  |[],[]-> true
  |_,[]->false
  |[],_->false
  |h::t3,n::t4-> if (h=n) then (comparer t3 t4)
                 else false;;

let areEquivalent (t:tformula) (f:tformula)= comparer (snd(simplifyBDD(buildBDD t))) (snd(simplifyBDD(buildBDD f)));;


(*question bonus*)
let dotBDD (nom:string) (b:bdd)= 
let file=open_out nom in
let init=output_string file "digraph G {\n" in 
let list=snd(b) in 
let rec ecrire l2= match l2 with 
|[]->(output_string file "}")
|h::l-> match h with |BddLeaf (a,false) -> (output_string file (String.concat "" [(string_of_int a);"[style=bold, label=";(string_of_bool false);"]";";\n"])); (ecrire l);
|BddLeaf (a,true) -> (output_string file (String.concat "" [(string_of_int a);"[style=bold, label=";(string_of_bool true);"]";";\n"])); ecrire l;
                     |BddNode (a,b,c,d)-> (output_string file (String.concat "" [(string_of_int a);" [label=";b;"];\n";(string_of_int a);"->";(string_of_int c);" [color=red, style=dashed];\n";(string_of_int a);"->";(string_of_int d);";\n"])); (ecrire l)
in let ecriture=(ecrire list) in
init;ecriture; close_out(file);;




let dotTree (nom:string) (t:decTree)= 
let file=open_out nom in
let init=output_string file "digraph G {\n" in 
let rec ecrire i t= match t with 
|DecLeaf(a) -> (output_string file (String.concat "" [(string_of_int i);"[style=bold, label=";(string_of_bool a);"]";";\n"]));
|DecRoot (a,sag,sad) -> (output_string file (String.concat "" [(string_of_int i);"[label=";a;"]";";\n"]));
(output_string file (String.concat "" [(string_of_int (i));"->";(string_of_int (2*i));"[color=red, style=dashed]";";\n"]));
(output_string file (String.concat "" [(string_of_int (i));"->";(string_of_int (2*i+1));";\n"])); ecrire (2*i) sag; ecrire (2*i+1) sad;
in let ecriture=ecrire 1 t in
let ende=(output_string file "}") in init;ecriture;ende; close_out(file);;


(*TEST*)

(* Je ne peux pas tester les fonctions isTautology et areEquivalent pusiqu'elles font appels à la fonction buildBDD que je n'ai pas su coder. Je l'ai seulement défini pour permettre à l'ensemble du code de compiler*)
