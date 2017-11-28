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
tvd[p_,q_,cons_,varsminmax_,v_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,cons]] /. {eps -> v},varsminmax[[1]]]
sample[p_, np_,cons_,varsminmax_] := Table[tvd[p, np, cons,varsminmax, v], {v, 0.01, 0.1, 0.01}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,varsminmax_]:=Integrate[FullSimplify[entropy[p,q],cons],varsminmax[[1]]]
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)

runall[p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x"] := Module[
	{vars := Prepend[Map[First,varsminmax],eps]
	},
	single := (Length[vars]==2);
	Print["run single"];
	If[single, runsingle[p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[p,np,(epscons&&varscons),vars,varsminmax]]
	Print[""]
]

runsingle[p_,np_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{cons := epscons&&varscons
	},
	timeed = Timing[pedist[e,ne,epscons,vars]];
	Print["timeed"];
	Print[timeed];
	timeks = Timing[pks[p,np,cons,vars]];
	Print["timeks"];
	Print[timeks];
	Print["start tvd"];
	timetvd = Timing[ptvd[p,np,cons,vars,varsminmax]];
	Print["timetvd"];
	Print[timetvd];
]

pedist[p_,q_,cons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	f[DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	edistanceres := edistance[p,q,cons][[1]];
	Print["edistance"];
	Print[edistanceres];
	Print["edistanceMax"];
	Print[FindMaximum[{edistanceres,cons},vars]];
	Print[Maximize[{edistanceres,cons},vars]];
	Print[""]
]

pks[p_,q_,cons_,vars_] := Module[
	{},
	Print["distance"];
	disres := FullSimplify[distance[p,q,cons],cons];
	Print[disres];
	Print["ksmax(distancemax)"];
	distancemaxres := distancemax[p,q,cons,vars];
	Print[distancemaxres];
	distancemax2res := distancemax2[p,q,cons,vars];
	Print[distancemax2res];
	Print[""]
]
ptvd[p_,q_,cons_,vars_,varsminmax_] := Module[
	{
	},
	Print["tvd"];
	xsample = Table[x, {x, 0.01, 0.1, 0.01}];
	Print[xsample];
	table = sample[p, q, cons, varsminmax];
	Print[table];
	data = Transpose[{xsample,table}];
	lm = LinearModelFit[data,x,x];
	k = lm["ParameterTableEntries"][[2]][[1]];
	bmax = Max[table - k*xsample];
	bmin = Min[table - k*xsample];
	Print[k*x+bmin];
	Print[k*x+bmax];
	Print["tvdMax"];
	maxSample := Max[table];
	Print["{",maxSample,", ","{eps -> ",xsample[[Position[table, maxSample][[1]][[1]]]],"}}"];
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
		
