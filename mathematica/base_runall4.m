(* ::Package:: *)

(* ::Input:: *)
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_,vars_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},vars]
distancemax2[p_,q_,cons_,vars_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},vars]
(*distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]*)
edistance[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
edistance2[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[q]]][[1]]
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
		AllTrue[islinearlist, NumberQ]
  ]
*)
runall[p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1)] := Module[
	{vars := Prepend[Map[First,varsminmax],eps]
	},
	Print[$ScriptCommandLine[[1]]];
	single := (Length[vars]==2);
	If[single, runsingle[p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[p,np,(epscons&&varscons),vars,varsminmax]]
	Print[""]
]

runsingle[p_,np_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{cons := epscons&&varscons
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

printfindmax[distanceres_,cons_,vars_] := Module[
	{},
	Print[distanceres];
	Print[islinear[distanceres]];	
	findmaximum := Check[FindMaximum[{distanceres,cons},vars],"error"];
	maximize := Check[Maximize[{distanceres,cons},vars],"error"];
	If[Not[StringQ[findmaximum]]&&Not[StringQ[maximize]],
		If[findmaximum[[1]]>maximize[[1]],
			Print[findmaximum],
			Print[maximize]],
		If[Not[StringQ[findmaximum]],
			Print[findmaximum],
			If[Not[StringQ[maximize]],
				Print[maximize],
				Print["error"]
			]
		]
	]
]

pedist[p_,q_,cons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	f[DiracDelta[point_]] := Solve[point==0,vars[[2]]];
	edistanceres := Check[edistance[p,q,cons][[1]],"error"];
	edistanceres2 := Check[edistance2[p,q,cons][[1]],"error"];
	If[Not[StringQ[edistanceres]],
		printfindmax[edistanceres,cons,vars],
		If[Not[StringQ[edistanceres2]],
			printfindmax[edistanceres2,cons,vars]
			,Print["error"]
		]
	];
	Print[""]
]


findlarger[expr1_,expr2_] := (
	If[Not[StringQ[expr1]]&&Not[StringQ[expr2]],
		If[findmaximum[[1]]>maximize[[1]],
			Return[expr1],
			Return[expr2]
		],
		If[Not[StringQ[expr1]],
			Return[expr1],
			If[Not[StringQ[expr2]],
				Return[expr2],
				Return["error"]
			]
		]
	]
	
)

pks[p_,q_,cons_,vars_] := Module[
	{
	},
	disres := Check[FullSimplify[distance[p,q,cons],cons],"error"];
	Print[disres];
	If[Not[StringQ[disres]],
		(disresr2[r2_] = (disres /. r1->r2);
		Print[islinear2[disresr2]];
		distancemaxres := Check[distancemax[p,q,cons,vars],"error"];
		distancemax2res := Check[distancemax2[p,q,cons,vars],"error"];
		Print[findlarger[distancemaxres,distancemax2res]]		)
	];
	Print[""]
]
ptvd[p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := Check[tvd[p,q,cons,varsminmax],"error"]
	},
	Print[tvdres];
	If[Not[StringQ[tvdres]],(
		Print[islinear[tvdres]];	
		findmaximum := Check[FindMaximum[{tvdres,cons},vars],"error"];
		maximize := Check[Maximize[{tvdres,cons},vars],"error"];
		Print[findlarger[findmaximum,maximize]])
	]
	Print[""]
]
pkl[p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := Check[kl[p,q,cons,varsminmax],"error"]
	},
	Print[klres];
	If[Not[StringQ[klres]],(
		Print[islinear[klres]];	
		findmaximum := Check[FindMaximum[{klres,cons},vars],"error"];
		maximize := Check[Maximize[{klres,cons},vars],"error"];
		Print[findlarger[findmaximum,maximize]])
	]
	Print[""]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
		Print[islinearlist];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		
