#use "projet.ml";;

let p1= Var "P1";;
let p2= Var "P2";;
let q1= Var "Q1";;
let q2= Var "Q2";;
let r1= Var "R1";;
let r2= Var "R2";;
let i1=Or(r1,r2);;
let i2=Implies(r1,r2);;
let f1= Equivalent(q1,q2);;
let f2= Equivalent(p1,p2);;
let ex1= And(f1,f2);;
let ex2= (10, [BddNode (10, "P1", 8, 9); BddNode (9, "P2", 7, 5); BddNode (8, "P2", 5, 7); BddNode (7, "Q1", 6, 6); BddNode (6, "Q2", 2, 2); BddNode (5, "Q1", 3, 4); BddNode (4, "Q2", 2, 1); BddNode (3, "Q2", 1, 2); BddLeaf (2, false); BddLeaf (1,true)]);;
let ex3=And((And(f1,f2)),(Or(i1,i2)));;
let ex4=["P1";"P1";"Q2";"Q3";"Q3"];;
let ex5=["P1",true;"P2",true;"Q1",true;"Q2",true;"R1",false;"R2",true];;
let ex6=["P1",false;"P2",true;"Q1",true;"Q2",true;"R1",false;"R2",true];;
let ex7=And (q1,q2);;
let ex8= ["Q1",true;"Q2",false];;
let ex9=["Q1",true;"Q2",true];;
let ex10=[BddNode (5,"P1",4,3); BddNode (4,"P2",3,2); BddNode (3,"Q1",2,1); BddLeaf (2,false); BddLeaf(1,true)];;
let ex11=(5,[BddNode (5,"P1",4,3); BddNode (4,"P2",3,2); BddNode (3,"Q1",2,1); BddLeaf (2,false); BddLeaf(1,true)]);;

let testgetvars=assert (getVars ex3= ["P1"; "P2"; "Q1"; "Q2"; "R1"; "R2"]);;

let testsupprimedoublons=assert (supprimedoublons ex4= ["P1";"Q2";"Q3"]);;

let testsearch=assert (search ex5 "P2" = ("P2",true));;

let testevalformula1=assert (evalFormula ex5 ex3 = true);;

let testevalformula2=assert (evalFormula ex8 ex7 = false);;

let testevalformula3=assert (evalFormula ex9 ex7 = true);;

let testbuildtree=assert (buildTree ex7=DecRoot ("Q1", DecRoot ("Q2", DecLeaf false, DecLeaf false), DecRoot ("Q2", DecLeaf false, DecLeaf true)));;

let tessup= assert (sup (snd(ex2))= [BddNode (10, "P1", 8, 9); BddNode (9, "P2", 7, 5); BddNode (8, "P2", 5, 7); BddNode (5, "Q1", 3, 4); BddNode (4, "Q2", 2, 1); BddNode (3, "Q2", 1, 2); BddLeaf (2, false); BddLeaf (1,true)]);;

let testremplace= assert (remplace 4 3 ex10= [BddNode (5, "P1", 3, 3); BddNode (4, "P2", 3, 2); BddNode (3,"Q1",2,1); BddLeaf (2,false); BddLeaf(1,true)]);;
 
let testrecup=assert (recup 4 (10, [BddNode (4,"A",2,2)])=2);;
