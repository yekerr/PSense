(* ::Package:: *)

(* ::Input:: *)
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_,vars_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},vars]
distancemax2[p_,q_,cons_,vars_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},vars]
(*distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]*)
edistance[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
edistance2[p_,q_,cons_]:=distance2[extract[f2[p]],extract[f2[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,varsminmax_] :=1/2*(Sum@@(Prepend[varsminmax,FullSimplify[distance2[p,q],cons]]))
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,varsminmax_]:=Sum@@(Prepend[varsminmax,FullSimplify[entropy[p,q],cons]])
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)

runall[p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1)] := Module[
	{vars := Prepend[Map[First,varsminmax],eps]
	},
	single := (Length[vars]==2);
	If[single, runsingle[p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[p,np,(epscons),vars,varsminmax]]
	Print[""]
]

runsingle[p_,np_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{cons := epscons
	},
	pedist[e,ne,epscons,vars];
	pks[p,np,cons,vars];
	ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];
]

runmulti[p_,np_,cons_,vars_,varsminmax_] := Module[
	{},
	pks[p,np,cons,vars];
	ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];
]

pedist[p_,q_,cons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	f2[DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	edistanceres := edistance[p,q,cons][[1]];
	Print["edistance"];
	Print[edistanceres];
	Print["edistanceMax"];
	Print[FindMaximum[{edistanceres,cons},vars]];
	Print[Maximize[{edistanceres,cons},vars]];
	Print[""]
]

pks[p_,q_,cons_,vars_] := Module[
	{disres := FullSimplify[distance[p,q,cons],cons],
	distancemaxres := distancemax[p,q,cons,vars],
	distancemax2res := distancemax2[p,q,cons,vars]
	},
	Print["distance"];
	Print[disres];
	Print["ksmax(distancemax)"];
	Print[distancemaxres];
	Print[distancemax2res];
	Print[""]
]
ptvd[p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := tvd[p,q,cons,varsminmax]
	},
	Print["tvd"];
	Print[tvdres];
	Print["tvdMax"];
	Print[FindMaximum[{tvdres,cons},vars]];
	Print[Maximize[{tvdres,cons},vars]];
	Print[""]
]
pkl[p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := kl[p,q,cons,varsminmax]
	},
	Print["kl"];
	Print[klres];
	Print["klMax"];
	Print[FindMaximum[{klres,cons},vars]];
	Print[Maximize[{klres,cons},vars]];
	Print[""]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
		Print[islinearlist];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		
