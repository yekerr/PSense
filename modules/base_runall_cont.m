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
tvd[p_,q_,epscons_,varscons_,vars_,v_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,epscons && varscons]] /. {eps -> v},{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]
tvdvalue[p_,q_,epscons_,varscons_,vars_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,epscons&&varscons]],{r1,Quiet[Minimize[{r1, varscons},r1]][[1]],Quiet[Maximize[{r1, varscons},r1]][[1]]}]
sample[p_,np_,epscons_,varscons_,vars_,epsrange_] := Table[tvd[p,np,epscons,varscons,vars,v], epsrange]
samplekl[p_, np_,epscons_,varscons_,vars_,epsrange_] := Table[kl[p,np,epscons,varscons,vars,v], epsrange]
entropy[p_,q_] := q*Log2[q/p]
kl[p_,q_,epscons_,varscons_,vars_,v_]:= Quiet[NIntegrate[FullSimplify[entropy[p,q],epscons&&varscons] /. {eps -> v},{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]]
klvalue[p_,q_,epscons_,varscons_,vars_]:=Quiet[NIntegrate[FullSimplify[entropy[p,q],epscons&&varscons],{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]]
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

inrunall[flageps_,p_,np_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_,e_:1,ne_:1,discretevars_:{{r1->0},{r1->1}},vars_:{r1},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x.csv"] := Module[
	{
	},
    (*$stream = OpenAppend["ch0x.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","];*)
	    If[flagexpdist && (Length[vars]==1),
	    pedist[flageps,e,ne,epscons,varscons,vars]
    ];
    If[flagks,
	    pks[flageps,p,np,epscons,varscons,vars]
	(*revkseps[ksres,vars];*) 
    ];
    If[flagtvd,
	    ptvd[flageps,p,np,epscons,varscons,vars]
    ];
    If[flagkl,
	    pkl[flageps,p,np,epscons,varscons,vars]
    ];
    If[flagcustom, 
        pcus[flageps,p,np,epscons,varscons,vars,discretevars,customfun]
    ];
    (*Close[$stream]*)
	Print[""]
]

pedist[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars];
	f[DiracDelta[point_]] := Solve[point==0,vars];
	edistanceres := edistance[p,q,epscons][[1]];
	Print["Expectation Distance"];
	Print[edistanceres];
    If[!flageps,
	    Print["Expectation Distance Max"];
	    Print[Maximize[{edistanceres,epscons && varscons},Prepend[vars,eps]]];
        Print["Is Linear?"];
        Print[islinear2[edistanceres]]];
	Print[""]
]

pcus[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_,customfun_] := Module[
    {},
    cusres := customfun[p,q];
    Print["User Defined Metric"];
    Print[cusres];
    If[!flageps,
        Print["User Defined Metric Max"];
        Print[Maximize[{cusres,epscons && varscons},Prepend[vars,eps]]];
        Print["Is Linear?"];
        Print[islinear2[cusres]]
	];
    Print[""]
]

pks[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
	{},
	disres = FullSimplify[distance[p,q,epscons && varscons],epscons && varscons];
    If[!flageps,
	    Print["Distance"];
	    Print[disres];
	    Print["KS Distance Max"];
	    distancemax2res := distancemax2[p,q,epscons && varscons,Prepend[vars,eps]];
	    Print[distancemax2res];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
	    Print[islinear2[disresr2[r2]]],
    Print["KS Distance"];
        distancemax2res := distancemax2[p,q,varscons,vars];
        Print[distancemax2res]];
	Print[""];
	disres
]
ptvd[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
	{
	},
	Print["TVD"];
	    If[!flageps,
	epsmin = Quiet[Minimize[{eps,epscons},eps]][[1]];
	epsmax = Quiet[Maximize[{eps,epscons},eps]][[1]];
	epsrange = {v,epsmin+(epsmax-epsmin)/10,epsmax,(epsmax-epsmin)/10};
	    xsample = Table[eps /. eps->v,{v,epsmin+(epsmax-epsmin)/10,epsmax,(epsmax-epsmin)/10}];
	    table = sample[p,q,epscons,varscons,vars,epsrange];
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
    Print[tvdvalue[p,q,epscons,varscons,vars]]];
    Print[""]
]
pkl[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
    {},
    Print["KL Divergence"];
    If[!flageps,
	epsmin = Quiet[Minimize[{eps,epscons},eps][[1]]];
	epsmax = Quiet[Maximize[{eps,epscons},eps][[1]]];
	epsrange = {v,epsmin+(epsmax-epsmin)/10,epsmax,(epsmax-epsmin)/10};
            xsample = Table[eps /. eps->v,{v,epsmin+(epsmax-epsmin)/10,epsmax,(epsmax-epsmin)/10}];
	    table = samplekl[p,q,epscons,varscons,vars,epsrange];
	    data = Transpose[{xsample,table}];
	    lm = Quiet[LinearModelFit[data,eps,eps]];
	    k = Quiet[lm["ParameterTableEntries"][[2]][[1]]];
	    Print[" KL Bounds(lower, upper):"];
	    bmax = Max[table - k*xsample];
	    bmin = Min[table - k*xsample];
	    Print[k*eps+bmin];
	    Print[k*eps+bmax];
	    Print["KL Max"];
	    maxSample := Max[table];
	    Print["{",maxSample,", ","{eps -> ",xsample[[Position[table, maxSample][[1]][[1]]]],"}}"],
	Print[klvalue[p,q,epscons,varscons,vars]]];
        Print[""]
    (*Print["KL Max"];
	Print[FindMaximum[{klres,cons},vars]];
	Print[Maximize[{klres,cons},vars]];
	Print[""]*)
]
		
