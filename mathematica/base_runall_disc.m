(* ::Package:: *)

(* ::Input:: *)
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_,vars_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},vars]
distancemax2[p_,q_,cons_,vars_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},vars]
(*distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]*)
edistance[p_,q_,cons_]:=distance[extract[f[p]],extract[f[FullSimplify[q,cons]]],cons]
edistance2[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := 
distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,cons_,varsminmax_] :=1/2*(Sum@@(Prepend[varsminmax,FullSimplify[distance2[p,q],cons]]))
tvdsingle[p_,q_,cons_,varscons_] := 1/2*(Sum@@{FullSimplify[distance2[p,q],cons],{(Variables@Level[varscons,{-1}])[[1]],Map[First,Map[Values,Solve[varscons,(Variables@Level[varscons,{-1}])[[1]]]]]}})
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,varsminmax_]:=Sum@@(Prepend[varsminmax,FullSimplify[entropy[p,q],cons]])
klsingle[p_,q_,cons_,varscons_] := 1/2*(Sum@@{FullSimplify[entropy[p,q],cons],{(Variables@Level[varscons,{-1}])[[1]],Map[First,Map[Values,Solve[varscons,(Variables@Level[varscons,{-1}])[[1]]]]]}})
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)

inrunall[p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x.csv"] := Module[
	{
	 vars = Prepend[Map[First,varsminmax],eps]
	},
	$stream = OpenAppend["ch0x.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","];
	single := (Length[vars]==2);
	If[single, runsingle[p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[p,np,(epscons&&varscons),vars,varsminmax]]
	Close[$stream]
	Print[""]
]

runsingle[p_,np_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{cons := epscons&&varscons,
	 varsnoeps = Map[First,varsminmax]
	},
	pedist[e,ne,epscons,vars];
	pks[p,np,cons,vars];
	(*revkseps[ksres,varsnoeps];*) 
	(*ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];*)
	ptvdsingle[p,np,cons,vars,varscons];
	pklsingle[p,np,cons,vars,varscons];
]

runmulti[p_,np_,cons_,vars_,varsminmax_] := Module[
	{},
	varsnoeps = Map[First,varsminmax]
	pks[p,np,cons,vars];
	(*revkseps[ksres,varsnoeps];*)
	ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];
]

revkseps[disres_,varsnoeps_] := Module[
	{},
	Print["eps range for ks<=0.01"];
	Print[epsmax=Maximize[{eps, disres <= 0.01,(-0.01<=eps<=0.01)&&(r1==0||r1==1)}, varsnoeps]];
	Print[epsmin=Minimize[{eps, disres <= 0.01,r1==0||r1==1}, varsnoeps]];
	Print["(", epsmin[[1]], ", ", epsmax[[1]], ")"];
]

pedist[p_,q_,cons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	f[DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	edistanceres := edistance[p,q,cons][[1]];
	Print["edistance"];
	(*Print[edistanceres[[1]]];*)
	Print[edistance2[p,q,cons][[1]]];
	Print["edistanceMax"];
	(*Print[FindMaximum[{edistanceres,cons},vars]];*)
	Print[Maximize[{edistanceres,cons},vars]];
    Print["Is Linear?"];
    Print[islinear2[edistanceres]];
	Print[""]
]

pks[p_,q_,cons_,vars_] := Module[
	{},
	disres = FullSimplify[distance[p,q,cons],cons];
	(*distancemaxres = distancemax[p,q,cons,vars];
	distancemax2res = distancemax2[p,q,cons,vars];*)
	Print["distance"];
	Print[disres];
	(*Print["ksmax(distancemax)"];
	Print[distancemaxres];
	Print[distancemax2res];*)
    Print["Is Linear?"];
    disresr2[r2_] = (disres /. r1->r2);
	Print[islinear2[disresr2[r2]]];
	Print[""];
	disres
]
ptvdsingle[p_,q_,cons_,vars_,varscons_] := Module[
	{tvdres := tvdsingle[p,q,cons,varscons]
	},
	Print["tvd"];
	Print[tvdres];
	Print["tvdMax"];
	(*Print[FindMaximum[{tvdres,cons},vars]];*)
	Print[Maximize[{tvdres,cons},vars]];
    Print["Is Linear?"];
    Print[islinear2[tvdres]];
	Print[""]
]
ptvd[p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := tvd[p,q,cons,varsminmax]
	},
	Print["tvd"];
	Print[tvdres];
	Print["tvdMax"];
	(*Print[FindMaximum[{tvdres,cons},vars]];*)
	Print[Maximize[{tvdres,cons},vars]];
    Print["Is Linear?"];
    Print[islinear2[tvdres]];
	Print[""]
]
pkl[p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := kl[p,q,cons,varsminmax]
	},
	Print["kl"];
	Print[klres];
	Print["klMax"];
	(*Print[FindMaximum[{klres,cons},vars]];*)
	Print[Maximize[{klres,cons},vars]];
    Print["Is Linear?"];
    Print[islinear2[klres]];
	Print[""]
]
pklsingle[p_,q_,cons_,vars_,varscons_] := Module[
	{klres := klsingle[p,q,cons,varscons]
	},
	Print["kl"];
	Print[klres];
	Print["klMax"];
	(*Print[FindMaximum[{klres,cons},vars]];*)
	Print[Maximize[{klres,cons},vars]];
    Print["Is Linear?"];
    Print[islinear2[klres]];
	Print[""]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
        (*Print[islinearlist];*)
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		
