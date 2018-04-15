(* ::Package:: *)

(* ::Input:: *)
numPrecision12[num_] := ToString[FortranForm[SetPrecision[num,12]]]
distance[p_,q_,cons_] :=FullSimplify[Abs[p-q],cons]
distance2[p_,q_] :=Abs[p-q]
subs[p_, q_,cons_,params_] := FullSimplify[Abs[p-q],cons] /. params 
distancemax[p_,q_,cons_,vars_] := FindMaximum[{FullSimplify[Abs[p-q],cons],cons},vars]
distancemax2[p_,q_,cons_,vars_] := NMaximize[{FullSimplify[Abs[p-q],cons],cons},vars]
(*distancemax3[p_,q_,cons_] := Maximize[{Abs[p-q],cons},{eps,Element[r1,Integers]}]*)
edistance[p_,q_,cons_]:=distance[extract[f[p]],extract[f[FullSimplify[q,cons]]],cons]
edistance2[p_,q_,cons_]:=distance2[extract[f[p]],extract[f[FullSimplify[q,cons]]]]
extract[f_] := Values[f][[1]]
edistancemax[p_, q_, cons_] := distancemax[extract[f[p]], extract[f[FullSimplify[q,cons]]], cons]
tvd[p_,q_,epscons_,discretevars_] := 1/2*Total[Map[ReplaceAll[FullSimplify[distance2[p, q],epscons],#] &, discretevars]]
entropy[p_,q_] := q*Log2[q/p]
kl[p_, q_, epscons_, discretevars_] := 
 Total[Map[ReplaceAll[FullSimplify[entropy[p, q], epscons], #] &, 
   discretevars]]
tvdcont[p_,q_,epscons_,varscons_,vars_,v_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,epscons && varscons]] /. {eps -> v},{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]
tvdvaluecont[p_,q_,epscons_,varscons_,vars_] := 1/2*NIntegrate[Abs[p-FullSimplify[q,epscons&&varscons]],{r1,Quiet[Minimize[{r1, varscons},r1]][[1]],Quiet[Maximize[{r1, varscons},r1]][[1]]}]
sample[p_,np_,epscons_,varscons_,vars_,epsrange_] := Table[Quiet[tvdcont[p,np,epscons,varscons,vars,v]], epsrange]
samplekl[p_, np_,epscons_,varscons_,vars_,epsrange_] := Table[klcont[p,np,epscons,varscons,vars,v], epsrange]
klcont[p_,q_,epscons_,varscons_,vars_,v_]:= Quiet[NIntegrate[FullSimplify[entropy[p,q],epscons&&varscons] /. {eps -> v},{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]]
klvaluecont[p_,q_,epscons_,varscons_,vars_]:=Quiet[NIntegrate[FullSimplify[entropy[p,q],epscons&&varscons],{r1,Minimize[{r1, varscons},r1][[1]],Maximize[{r1, varscons},r1][[1]]}]]
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

Printerror[exp_] := If[StringContainsQ[exp, "error"],Print["error"],Print[exp]]
printPrecision12[num_] := (
    maxValue = ToString[numPrecision12[num[[1]]]];
    maxArgeps = "eps -> " <> ToString[(numPrecision12 /@ Association[num[[2]]])[eps]];
    maximizeResult = ToString[Append[{maxValue}, maxArgeps]];
    If[StringFreeQ[maximizeResult, "error"],Print[maximizeResult], Print["error"]]
)
printCheckExp[exp_] := Print[If[Not[StringQ[exp]],exp,"error"]]

revkseps[disres_,varsnoeps_] := Module[
	{},
	Print["eps range for ks<=0.01"];
	Print[epsmax=Maximize[{eps, disres <= 0.01,(-0.01<=eps<=0.01)&&(r1==0||r1==1)}, varsnoeps]];
	Print[epsmin=Minimize[{eps, disres <= 0.01,r1==0||r1==1}, varsnoeps]];
	Print["(", epsmin[[1]], ", ", epsmax[[1]], ")"];
]

pedist[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
	{},
	f[_ DiracDelta[point_]] := Solve[point==0,vars];
	f[DiracDelta[point_]] := Solve[point==0,vars];
	edistanceres = Check[edistance[p,q,epscons][[1]],"error"];
	Print["Expectation Distance"];
	printCheckExp[edistanceres];
    If[!flageps,
	    Print["Expectation Distance Max"];
	    expmax = Maximize[{edistanceres,epscons && varscons},Prepend[vars,eps]];
	    printPrecision12[expmax];
        Print["Is Linear?"];
        Print[islinear2[edistanceres]]];
	Print[""]
]

pcus[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_,customfun_] := Module[
    {},
    cusres = customfun[p,q];
    Print["User Defined Metric"];
    Print[cusres];
    If[!flageps,
        Print["User Defined Metric Max"];
        printPrecision12[Maximize[{cusres,epscons && varscons},Prepend[vars,eps]]];
        Print["Is Linear?"];
        Print[islinear2[cusres]]
	];
    Print[""]
]

pks[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
	{},
	disres = Quiet[Check[FullSimplify[distance[p,q,epscons && varscons],epscons && varscons],"error"]];
    If[!flageps,
	    Print["KS Distance"];
	    printCheckExp[disres];
	    Print["KS Distance Max"];
	    distancemax2res = Quiet[distancemax2[p,q,epscons && varscons,Prepend[vars,eps]]];
	    printPrecision12[distancemax2res];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
	    Print[islinear2[disresr2[r2]]],
    Print["KS Distance"];
        distancemax2res = Quiet[distancemax2[p,q,varscons,vars]];
        printPrecision12[distancemax2res]];
	Print[""];
	disres
]
ptvd[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_] := Module[
	{tvdres := tvd[p,q,epscons,discretevars]
	},
	Print["TVD"];
	printCheckExp[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    printPrecision12[Maximize[{tvdres,epscons && varscons},Prepend[vars,eps]]];
        Print["Is Linear?"];
        Print[islinear2[tvdres]]];
	Print[""]
]
pkl[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_] := Module[
	{klres = kl[p,q,epscons,discretevars]
	},
	Print["KL Divergence"];
	printCheckExp[klres];
    If[!flageps,
	    Print["KL Divergence Max"];
	    printPrecision12[Maximize[{klres,epscons && varscons},Prepend[vars,eps]]];
        Print["Is Linear?"];
        Print[islinear2[klres]]];
	Print[""]
]

ptvdcont[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
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
	    Print["TVD Bounds(lower, upper):"];
	    bmax = Max[table - k*xsample];
	    bmin = Min[table - k*xsample];
	    printCheckExp[{k*eps+bmin,k*eps+bmax}];
	    Print["TVD Max"];
	    maxSample = Max[table];
	    Print["{",ToString[SetPrecision[maxSample,12]],", ","{eps -> ",ToString[SetPrecision[xsample[[Position[table, maxSample][[1]][[1]]]],12]],"}}"];
	    Print["Is Linear?"];
	    Print["NA"],
    Print[tvdvaluecont[p,q,epscons,varscons,vars]]];
    Print[""]
]
pklcont[flageps_,p_,q_,epscons_,varscons_,vars_] := Module[
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
	    Print["KL Divergence Bounds(lower, upper):"];
	    bmax = Max[table - k*xsample];
	    bmin = Min[table - k*xsample];
	    printCheckExp[{k*eps+bmin,k*eps+bmax}];
	    Print["KL Divergence Max"];
	    maxSample = Max[table];
	    Print["{",ToString[SetPrecision[maxSample,12]],", ","{eps -> ",ToString[SetPrecision[xsample[[Position[table, maxSample][[1]][[1]]]],12]],"}}"];
	    Print["Is Linear?"];
	    Print["NA"],
	Print[klvaluecont[p,q,epscons,varscons,vars]]];
        Print[""]
]
	



