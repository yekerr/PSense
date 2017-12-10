(* ::Package:: *)

(* ::Input:: *)
f[_ DiracDelta[point_]] := Solve[point==0,r1]
f2[DiracDelta[point_]] := Solve[point==0,r1]
distance[p_,q_] :=Abs[p-q]
subs[p_, q_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax2[p_,q_,cons_] := Maximize[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
edistance[p_,q_,cons_]:=distance[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
edistance2[p_,q_,cons_]:=distance[extract[f2[p]],extract[f2[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,min_,max_] :=1/2*Sum[FullSimplify[distance[p,q],cons],{x,min,max}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,min_,max_]:=Sum[FullSimplify[entropy[p,q],cons],{x,min,max}]

(* ::Input:: *)
betap:= (-2*Boole[-1+r1<=0]*r1^3+3*Boole[-1+r1<=0]*r1^2+Boole[-r1+1!=0]*Boole[-r1+1<=0])*Boole[-r1<=0]
betanp:=(((-Boole[-1+r1<=0]*Boole[-r1+1!=0]*r1^(3+eps)+-Boole[-r1+1<=0])*1/(3+eps)+(Boole[-1+r1<=0]*Boole[-r1+1!=0]*r1^(2+eps)+Boole[-r1+1<=0])*1/(2+eps))*Boole[-2+-eps!=0]*Boole[-r1<=0]+Boole[-2+-eps==0]*Boole[-r1<=0])*((-1/(3+eps)+1/(2+eps))*Boole[-2+-eps!=0]+Boole[-2+-eps==0])*((1/((-1/(-2+-eps)*Boole[-2+-eps!=0]*Boole[2+eps<=0]*2+1/(2+eps)*2*Boole[-2+-eps<=0])*(-1/(3+eps)*Boole[-3+-eps<=0]+1/(-3+-eps)*Boole[-3+-eps!=0]*Boole[3+eps<=0])+1/(4+4*eps+eps^2)*Boole[-2+-eps!=0]*Boole[2+eps<=0]+1/(4+4*eps+eps^2)*Boole[-2+-eps<=0]+1/(6*eps+9+eps^2)*Boole[-3+-eps!=0]*Boole[3+eps<=0]+1/(6*eps+9+eps^2)*Boole[-3+-eps<=0])*Boole[-1/(2+eps)+1/(3+eps)<=0]+1/((-1/(-3+-eps)*Boole[-3+-eps!=0]*Boole[3+eps<=0]+1/(3+eps)*Boole[-3+-eps<=0])*(-1/(2+eps)*Boole[-2+-eps<=0]*2+1/(-2+-eps)*2*Boole[-2+-eps!=0]*Boole[2+eps<=0])+1/(4+4*eps+eps^2)*Boole[-2+-eps!=0]*Boole[2+eps<=0]+1/(4+4*eps+eps^2)*Boole[-2+-eps<=0]+1/(6*eps+9+eps^2)*Boole[-3+-eps!=0]*Boole[3+eps<=0]+1/(6*eps+9+eps^2)*Boole[-3+-eps<=0])*Boole[-1/(3+eps)+1/(2+eps)!=0]*Boole[-1/(3+eps)+1/(2+eps)<=0])*Boole[-2+-eps!=0]+Boole[-2+-eps==0])*Boole[-2+-eps<=0]*Boole[-3+-eps!=0]
betae:=
betane:=DiracDelta[-r1+eps]

(* ::Input:: *)
Print["edistance"]
Print[edistance2[gaussiane,gaussianne,-0.1<=eps<=0.1]]
Print[""]
(*Print["edistancemax"]*)
(*Print[edistancemax[gaussiane,gaussianne,-0.1<=eps<=0.1]]*)
(*Print[""]*)
Print["distancemax"]
d := distancemax[gaussianp,gaussiannp,-0.1<=eps<=0.1 && -100 <=r1 <= 100]
Print[d]
Print[d[[1]]==subs[gaussianp, gaussiannp,d[[2]]]]
Print["distancemax2"]
g := distancemax2[gaussianp,gaussiannp,-0.1<=eps<=0.1 && -100 <=r1 <= 100]
Print[g]
Print[g[[1]]==subs[gaussianp, gaussiannp,g[[2]]]]
(*tvd[flipnp,flipp,eps>=-0.1 && eps <=0.9,-100,100]*)
(*kl[flipp,flipnp,eps>=-0.1 && eps <=0.9,0,100]*)

