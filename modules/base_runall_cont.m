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
tvdvalue[p_,q_,cons_,varsminmax_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,cons]],varsminmax[[1]]]
sample[p_, np_,cons_,varsminmax_] := Table[tvd[p, np, cons,varsminmax, v], {v, 0.01, 0.1, 0.01}]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,cons_,varsminmax_]:=NIntegrate[FullSimplify[entropy[p,q],cons],varsminmax[[1]]]
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
(*islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))*)
islinear2ks[p_] := Module[
		{islinearlist := {}},
		Do[
            AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps>0],eps],_Symbol,Infinity]];
            AppendTo[islinearlist,DeleteDuplicates@Cases[D[FullSimplify[p[i],eps<0],eps],_Symbol,Infinity]],
        {i,-5,5}
        ];
		NoneTrue[islinearlist, Function[x, MemberQ[x,Symbol["eps"]]]]
  ]
islinear2[p_]:= Module[
    {},
    !MemberQ[DeleteDuplicates@Cases[D[FullSimplify[p,eps>0],eps],_Symbol,Infinity],Symbol["eps"]]
]
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)

inrunall[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x"] := Module[
	{vars:=Map[First,varsminmax]
	},
	single=(Length[vars]==1);
    If[!flageps,vars=Prepend[vars,eps]];
	If[single,
        runsingle[flageps,p,np,flagexpdist,flagks,flagtvd,flagkl,flagcustom,customfun,e,ne,epscons,varscons,vars,varsminmax],
        runmulti[flageps,p,np,flagexpdist,flagks,flagtvd,flagkl,flagcustom,customfun,(epscons&&varscons),vars,varsminmax]
    ];
	Print[""]
]
runsingle[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
    {},
	If[!flageps,cons:=epscons&&varscons,cons:=varscons];
	If[flagexpdist,
        pedist[flageps,e,ne,epscons,vars]
    ];
    If[flagks,
	    pks[flageps,p,np,cons,vars]
    ];
    If[flagtvd,
	    ptvd[flageps,p,np,cons,vars,varsminmax]
    ];
    If[flagkl,
        Print["KL Divergence is not supported for continuous distributions"]
    ];
    (*pkl[flageps,p,q,cons,vars,varsminmax];*)
    If[flagcustom, 
        pcus[flageps,p,np,cons,vars,customfun]
    ];
]

runmulti[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,cons_,vars_,varsminmax_] := Module[
	{},
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

pedist[flageps_,p_,q_,cons_,vars_] := Module[
	{},
    If[flageps,onlyvar:=vars[[1]],onlyvar:=vars[[2]]];
	f[_ DiracDelta[point_]] := Solve[point==0,onlyvar];
	f[DiracDelta[point_]] := Solve[point==0,onlyvar];
	edistanceres := edistance[p,q,cons][[1]];
	Print["Expectation Distance"];
	Print[edistanceres];
    If[!flageps,
	    Print["Expectation Distance Max"];
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
    If[!flageps,
	    Print["Distance"];
	    disres := FullSimplify[distance[p,q,cons],cons];
	    Print[disres];
	    Print["KS Distance Max"];
	    (*distancemaxres := distancemax[p,q,cons,vars];
	    Print[distancemaxres];*)
	    distancemax2res := distancemax2[p,q,cons,vars];
	    Print[distancemax2res];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
	    Print[islinear2[disresr2[r2]]],
    Print["KS Distance"];
        distancemax2res := distancemax2[p,q,cons,vars];
        Print[distancemax2res]];
    Print[""]
]
ptvd[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
	{
	},
	Print["TVD"];
    If[!flageps,
	    xsample = Table[eps, {eps, 0.01, 0.1, 0.01}];
	    (*Print[xsample];*)
	    table = sample[p, q, cons, varsminmax];
	    (*Print[table];*)
	    data = Transpose[{xsample,table}];
	    lm = Quiet[LinearModelFit[data,eps,eps]];
	    k = Quiet[lm["ParameterTableEntries"][[2]][[1]]];
	    Print[" TVD Bounds(lower, upper):"];
	    bmax = Max[table - k*xsample];
	    bmin = Min[table - k*xsample];
	    Print[k*eps+bmin];
	    Print[k*eps+bmax];
	    Print["TVD Max"];
	    maxSample := Max[table];
	    Print["{",maxSample,", ","{eps -> ",xsample[[Position[table, maxSample][[1]][[1]]]],"}}"],
    Print[tvdvalue[p, q, cons, varsminmax]]];
    Print[""]
]
pkl[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
    {},
    If[flageps,
        klres := kl[p,q,cons,varsminmax];
	    Print["KL Divergence"];
	    Print[klres];
        Print[""]]
    (*Print["KL Max"];
	Print[FindMaximum[{klres,cons},vars]];
	Print[Maximize[{klres,cons},vars]];
	Print[""]*)
]
		
