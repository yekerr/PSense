(* ::Package:: *)

(* ::Input:: *)
f[_ DiracDelta[point_]] := Solve[point==0,r1]
f2[DiracDelta[point_]] := Solve[point==0,r1]
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax2[p_,q_,cons_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},{eps,r1}]
distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]
edistance[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
edistance2[p_,q_,cons_]:=distance2[extract[f2[p]],extract[f2[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,min_,max_] :=1/2*Sum[FullSimplify[distance2[p,q],cons],{r1,min,max}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,min_,max_]:=Sum[FullSimplify[entropy[p,q],cons],{r1,min,max}]
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)
pedist[p_,q_,cons_] := Module[
	{edistanceres := edistance[p,q,cons][[1]]
	},
	Print["edistance"];
	Print[edistanceres];
	Print["edistanceMax"];
	Print[FindMaximum[{edistanceres,cons},{eps,r1}]];
	Print[Maximize[{edistanceres,cons},{eps,r1}]];
	Print[""]
]

pks[p_,q_,cons_] := Module[
	{disres := FullSimplify[distance[p,q,cons],cons],
	distancemaxres := distancemax[p,q,cons],
	distancemax2res := distancemax2[p,q,cons],
	distancemax3res := distancemax3[p,q,cons]
	},
	Print["distance"];
	Print[disres];
	Print["ksmax(distancemax)"];
	Print[distancemaxres];
	Print[distancemax2res];
	Print[distancemax3res];
	Print[""]
]
ptvd[p_,q_,cons_] := Module[
	{tvdres := tvd[p,q,cons,0,1]
	},
	Print["tvd"];
	Print[tvdres];
	Print["tvdMax"];
	Print[FindMaximum[{tvdres,cons},{eps,r1}]];
	Print[Maximize[{tvdres,cons},{eps,r1}]];
	Print[""]
]
pkl[p_,q_,cons_] := Module[
	{klres := kl[p,q,cons,0,1]
	},
	Print["kl"];
	Print[klres];
	Print["klMax"];
	Print[FindMaximum[{klres,cons},{eps,r1}]];
	Print[Maximize[{klres,cons},{eps,r1}]];
	Print[""]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
		Print[islinearlist];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		