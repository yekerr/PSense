(* ::Package:: *)
Get["base2.m"]

(*(* ::Input:: *)
f[_ DiracDelta[point_]]=Solve[point==0,r1]


(* ::Input:: *)
distance[p_,q_] :=Abs[p-q]


(* ::Input:: *)
distancemax[p_,q_,cons_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},eps]


(* ::Input:: *)
edistance[p_,q_]:=distance[extract[f[p]],extract[f[q]]]


extract[f_] := Values[f][1]
(* ::Input:: *)
edistancemax[p_, q_, cons_] := 
 distancemax[extract[f[p]], extract[f[q]], cons]

(* ::Input:: *)
tvd[p_,q_,cons_,min_,max_] :=1/2*Sum[FullSimplify[distance[p,q],cons],{x,min,max}]


(* ::Input:: *)
entropy[p_,q_] := q*Log2[q/p]


(* ::Input:: *)
kl[p_,q_,cons_,min_,max_]:=Sum[FullSimplify[entropy[p,q],cons],{x,min,max}]


(* ::Text:: *)
(* *)
*)

(* ::Item:: *)
(*Flip*)


(* ::Input:: *)
flipp:=1/10*Boole[-x+1<=0]+9/10*Boole[-x<=0]
flipnp:=((-eps+9/10)*Boole[-x<=0]+(1/10+eps)*Boole[-x+1<=0])*Boole[-1/10+-eps<=0]*Boole[-9/10+eps<=0]
flipe:=DiracDelta[-r1+1/10]
flipne:=10*Boole[-1+r1<=0]*Boole[-r1<=0]*DiracDelta[-10*r1+1+10*eps]


(* ::Input:: *)
Print["edistance"]
Print[edistance[flipe,flipne]]


(* ::Input:: *)
(*Print["edistancemax"]
Print[edistancemax[flipe,flipne,eps>=-0.1 && eps <=0.2]]
*)

(* ::Input:: *)
(*{0.19999987665076904`,{eps->0.19999987665076904`}}*)


(* ::Input:: *)
Print["distance"]
Print[distance[flipnp ,flipp]]


(* ::Input:: *)
Print["tvd"]
Print[tvd[flipnp,flipp,eps>=-0.1 && eps <=0.9,-100,100]]


(* ::Input:: *)
Print["kl"]
Print[kl[flipp,flipnp,eps>=-0.1 && eps <=0.9,0,100]]


(* ::Input:: *)
(*FullSimplify[distance[flipnp,flipp],eps>=-0.1 && eps <=0.9 &&(x==0 || x==1)]*)


(* ::Input:: *)
(*Print[NMaximize[{Abs[Boole[-(1/10)-eps<=0] Boole[-(9/10)+eps<=0] ((1/10+eps) Boole[1-x<=0]+(9/10-eps) Boole[-x<=0])-(1/10 Boole[1-x<=0]+9/10 Boole[-x<=0])],eps>=-0.1 && eps <=0.9 &&(x==0 || x==1)},{Element[x,Integers],eps}]]
*)

(* ::Input:: *)
(**)
(**)
