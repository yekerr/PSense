(* ::Package:: *)

(* ::Input:: *)
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_,vars_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},Union[{eps},vars]]
distancemax2[p_,q_,cons_,vars_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},Union[{eps},vars]]
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
ptvd[p_,q_,cons_,varsminmax_] := Module[
	{tvdres := tvd[p,q,cons,varsminmax]
	},
	Print["tvd"];
	Print[tvdres];
	Print["tvdMax"];
	Print[FindMaximum[{tvdres,cons},Union[{eps},Map[First, varsminmax]]]];
	Print[Maximize[{tvdres,cons},Union[{eps},Map[First, varsminmax]]]];
	Print[""]
]
pkl[p_,q_,cons_,varsminmax_] := Module[
	{klres := kl[p,q,cons,varsminmax]
	},
	Print["kl"];
	Print[klres];
	Print["klMax"];
	Print[FindMaximum[{klres,cons},Union[{eps},Map[First,varsminmax]]]];
	Print[Maximize[{klres,cons},Union[{eps},Map[First,varsminmax]]]];
	Print[""]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
		Print[islinearlist];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		
