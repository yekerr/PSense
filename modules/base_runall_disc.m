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

inrunall[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,flage_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x.csv"] := Module[
	{
    vars := Map[First,varsminmax]
	},
    (*$stream = OpenAppend["ch0x.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","];*)
	single = (Length[vars]==1);
    If[!flageps,vars=Prepend[vars,eps]];
	If[single, runsingle[flageps,p,np,flagexpdist,flagks,flagtvd,flagkl,flagcustom,customfun,e,ne,epscons,varscons,vars,varsminmax],runmulti[flageps,p,np,flagexpdist,flagks,flagtvd,flagkl,flagcustom,customfun,epscons,vars,varsminmax]]
    (*Close[$stream]*)
	Print[""]
]

runsingle[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{
	},
    If[!flageps,cons=epscons&&varscons,cons=varscons];
    varsnoeps = Map[First,varsminmax];
    If[flagexpdist,
	    pedist[flageps,e,ne,epscons,cons,vars]
    ];
    If[flagks,
	    pks[flageps,p,np,cons,vars]
    ];
	(*revkseps[ksres,varsnoeps];*) 
	(*ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];*)
    If[flagtvd,
	    ptvdsingle[flageps,p,np,cons,vars,varscons]
    ];
    If[flagkl,
	    pklsingle[flageps,p,np,cons,vars,varscons]
    ];
    If[flagcustom, 
        pcus[flageps,p,np,cons,vars,customfun]
    ];
]

runmulti[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,cons_,vars_,varsminmax_] := Module[
	{},
	varsnoeps = Map[First,varsminmax];
    If[flagks,
	    pks[flageps,p,np,cons,vars]
    ];
	(*revkseps[ksres,varsnoeps];*)
    If[flagtvd,
	    ptvd[flageps,p,np,cons,vars,varsminmax]
    ];
    If[flagkl,
	    pkl[flageps,p,np,cons,vars,varsminmax]
    ];
    If[flagcustom, 
        pcus[flageps,p,np,cons,vars,customfun]
    ];
]

revkseps[disres_,varsnoeps_] := Module[
	{},
	Print["eps range for ks<=0.01"];
	Print[epsmax=Maximize[{eps, disres <= 0.01,(-0.01<=eps<=0.01)&&(r1==0||r1==1)}, varsnoeps]];
	Print[epsmin=Minimize[{eps, disres <= 0.01,r1==0||r1==1}, varsnoeps]];
	Print["(", epsmin[[1]], ", ", epsmax[[1]], ")"];
]

pedist[flageps_,p_,q_,epscons_,cons_,vars_] := Module[
	{},
    If[flageps,onlyvar:=vars[[1]],onlyvar:=vars[[2]]];
	f[_ DiracDelta[point_]] := Solve[point==0,onlyvar];
	f[DiracDelta[point_]] := Solve[point==0,onlyvar];
	edistanceres := edistance[p,q,epscons][[1]];
	Print["Expectation Distance"];
	Print[edistanceres];
    (*Print[edistance2[p,q,epscons][[1]]];*)
    If[!flageps,
	    Print["Expectation Distance Max"];
        (*Print[cons];*)
	    (*Print[FindMaximum[{edistanceres,cons},vars]];*)
	    Print[Maximize[{edistanceres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[edistanceres]]];
	Print[""]
]

pcus[flageps_,p_,q_,cons_,vars_,customfun_] := Module[
    {},
    cusres := FullSimplify[customfun[p,q,cons,varscons],cons];
    Print["User Defined Function"];
    Print[cusres];
    If[!flageps,
        Print["User Defined Function Max"];
        (*Print[FindMaximum[{tvdres,cons},vars]];*)
        Print[Maximize[{cusres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[cusres]]];
    Print[""]
]

pks[flageps_,p_,q_,cons_,vars_] := Module[
	{},
	disres = FullSimplify[distance[p,q,cons],cons];
    If[!flageps,
	    Print["Distance"];
	    Print[disres];
	    Print["KS Distance Max"];
	    (*distancemaxres = distancemax[p,q,cons,vars];*)
        (*Print[distancemaxres];*)
	    distancemax2res := distancemax2[p,q,cons,vars];
	    Print[distancemax2res];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
	    Print[islinear2[disresr2[r2]]],
    Print["KS Distance"];
        distancemax2res := distancemax2[p,q,cons,vars];
        Print[distancemax2res]];
	Print[""];
	disres
]
ptvdsingle[flageps_,p_,q_,cons_,vars_,varscons_] := Module[
	{tvdres := tvdsingle[p,q,cons,varscons]
	},
	Print["TVD"];
	Print[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    (*Print[FindMaximum[{tvdres,cons},vars]];*)
	    Print[Maximize[{tvdres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[tvdres]]];
	Print[""]
]
ptvd[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := tvd[p,q,cons,varsminmax]
	},
	Print["TVD"];
	Print[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    (*Print[FindMaximum[{tvdres,cons},vars]];*)
	    Print[Maximize[{tvdres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[tvdres]]];
	Print[""]
]
pkl[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := kl[p,q,cons,varsminmax]
	},
	Print["KL Divergence"];
	Print[klres];
    If[!flageps,
	    Print["KL Max"];
	    (*Print[FindMaximum[{klres,cons},vars]];*)
	    Print[Maximize[{klres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[klres]]];
	Print[""]
]
pklsingle[flageps_,p_,q_,cons_,vars_,varscons_] := Module[
	{klres := klsingle[p,q,cons,varscons]
	},
	Print["KL Divergence"];
	Print[klres];
    If[!flageps,
	    Print["KL Max"];
	    (*Print[FindMaximum[{klres,cons},vars]];*)
	    Print[Maximize[{klres,cons},vars]];
        Print["Is Linear?"];
        Print[islinear2[klres]]];
	Print[""]
]
islinear2[p_]:= Module[
    {},
    !MemberQ[DeleteDuplicates@Cases[D[FullSimplify[p,eps>0],eps],_Symbol,Infinity],Symbol["eps"]]
]
islinear2ks[p_] := Module[
            {islinearlist := {}},
        Do[AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],{i,-5,5}];
        Print[islinearlist];
        NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
]

