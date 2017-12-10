(* ::Package:: *)
Get["base.m"]
(*f[_ DiracDelta[point_]]:=Solve[point==0,r1]
distance[p_,q_] :=Abs[p-q]
distancemax[p_,q_,cons_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax2[p_,q_,cons_] := Maximize[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
edistance[p_,q_,cons_]:=distance[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,min_,max_] :=1/2*Sum[FullSimplify[distance[p,q],cons],{x,min,max}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,min_,max_]:=Sum[FullSimplify[entropy[p,q],cons],{x,min,max}]
*)
(* ::distributions:: *)
uniformp:= (Boole[-1+r1<=0]*r1+Boole[-r1+1!=0]*Boole[-r1+1<=0])*Boole[-r1<=0]
uniformnp:=(((1+eps)*Boole[-r1+1+eps<=0]+Boole[-1+-eps+r1<=0]*Boole[-r1+1+eps!=0]*r1)*(Boole[-1+-eps+r1<=0]*Boole[-r1+1+eps!=0]*Boole[-r1<=0]+Boole[-r1+1+eps<=0])*1/(1+eps)*Boole[-1+-eps!=0]+Boole[-1+-eps==0]*Boole[-r1<=0])*Boole[-1+-eps<=0]
uniforme:=DiracDelta[-r1+1/2]
uniformne:=(Boole[-1+-eps!=0]*DiracDelta[(1/2+1/2*eps^2+eps)*1/(1+eps)+-r1]+Boole[-1+-eps==0]*DiracDelta[r1])*Boole[-1+-eps<=0]

(* ::result:: *)
Print["edistance"]
edistret := edistance[uniforme,uniformne,-0.1<=eps<=0.1][[1]]
Print[edistret]
Print[gtd[edistret]]
Print[ltd[edistret]]
Print[islinear[edistret]]
Print[""]
(*Print["edistancemax"]
Print[edistancemax[uniforme,uniformne,-0.1<=eps<=0.1]]
Print[""]*)
(*Print["distancemax"]
Print[distancemax[uniformp,uniformnp,-0.1<=eps<=0.1 && -100 <=r1 <= 100]]
Print["distancemax2"]
Print[distancemax2[uniformp,uniformnp,-0.1<=eps<=0.1 && -100 <=r1 <= 100]]
*)
(*tvd[flipnp,flipp,eps>=-0.1 && eps <=0.9,-100,100]*)
(*kl[flipp,flipnp,eps>=-0.1 && eps <=0.9,0,100]*)

