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
runall[p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),filename_:"ch0x.csv"] := Module[
	{vars := Prepend[Map[First,varsminmax],eps]
	},
	Print["mathematica start"];
	$stream = OpenAppend["ch0x.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","];
	single := (Length[vars]==2);
	If[single, runsingle[p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[p,np,(epscons&&varscons),vars,varsminmax]];
	(*Export[$stream,output,"CSV"];*)
	Print["mathematica finished"];
	Close[$stream]
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
	WriteString[$stream,",,,,,"];
	pks[p,np,cons,vars];
	ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];
]

addquote[expr_] := (
	WriteString[$stream,"\""];
	WriteString[$stream,InputForm[expr]];
	WriteString[$stream,"\""];
)

printmaxinval[findmaximum_] := (
	If[Not[StringQ[findmaximum]],
		(addquote[findmaximum[[1]]];
		WriteString[$stream,","];
		addquote[Values[findmaximum[[2]][[1]]]];
		WriteString[$stream,","];
		addquote[Values[findmaximum[[2]][[2]]]];),
		WriteString[$stream,"error,,"]
	]
)

printfindmax[distanceres_,cons_,vars_] := Module[
	{},
	addquote[distanceres];
	WriteString[$stream,","];
	addquote[Check[islinear[distanceres],"error"]];
	WriteString[$stream,","];
	findmaximum := Check[FindMaximum[{distanceres,cons},vars],"error"];
	maximize := Check[Maximize[{distanceres,cons},vars],"error"];
	If[Not[StringQ[findmaximum]]&&Not[StringQ[maximize]],
		If[findmaximum[[1]]>maximize[[1]],
			(printmaxinval[findmaximum];
			WriteString[$stream,","]),
			(printmaxinval[maximize];
			WriteString[$stream,","])],
		If[Not[StringQ[findmaximum]],
			(printmaxinval[findmaximum];
			WriteString[$stream,","]),
			If[Not[StringQ[maximize]],
				(printmaxinval[maximize];
				WriteString[$stream,","]),
				(WriteString[$stream,"error"];
				WriteString[$stream,",,,"])
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
			,WriteString[$stream,"error,,,,,"]
		]
	];
]


findlarger[expr1_,expr2_] := (
	If[Not[StringQ[expr1]]&&Not[StringQ[expr2]],
		If[expr1[[1]]>expr2[[1]],
			Return[expr1],
			Return[expr2]
		],
		If[Not[StringQ[expr1]],
			Return[expr1],
			If[Not[StringQ[expr2]],
				Return[expr2],
				Return["error,,"]
			]
		]
	]
	
)

pks[p_,q_,cons_,vars_] := Module[
	{
	},
	disres := Check[FullSimplify[distance[p,q,cons],cons],"error"];
	addquote[disres];
	WriteString[$stream,","];
	If[Not[StringQ[disres]],
		(disresr2[r2_] = (disres /. r1->r2);
		addquote[islinear2[disresr2]];
		WriteString[$stream,","];
		distancemaxres := Check[distancemax[p,q,cons,vars],"error"];
		distancemax2res := Check[distancemax2[p,q,cons,vars],"error"];
		printmaxinval[findlarger[distancemaxres,distancemax2res]];
		WriteString[$stream,","]),
		WriteString[$stream, ",,"]
	];
]
ptvd[p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := Check[tvd[p,q,cons,varsminmax],"error"]
	},
	addquote[tvdres];
	WriteString[$stream,","];
	If[Not[StringQ[tvdres]],(
		addquote[islinear[tvdres]];
		WriteString[$stream,","];
		findmaximum := Check[FindMaximum[{tvdres,cons},vars],"error"];
		maximize := Check[Maximize[{tvdres,cons},vars],"error"];
		printmaxinval[findlarger[findmaximum,maximize]];
		WriteString[$stream,","];
		),
		WriteString[$stream,",,"]
	]
]
pkl[p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := Check[kl[p,q,cons,varsminmax],"error"]
	},
	addquote[klres];
	WriteString[$stream,","];
	If[Not[StringQ[klres]],(
		addquote[islinear[klres]];
		WriteString[$stream,","];
		findmaximum := Check[FindMaximum[{klres,cons},vars],"error"];
		maximize := Check[Maximize[{klres,cons},vars],"error"];
		printmaxinval[findlarger[findmaximum,maximize]];
		WriteString[$stream,"\n"];
		),
		WriteString[$stream,",\n"]
	]
]
islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
		
