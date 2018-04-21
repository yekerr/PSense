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
discreteNegConv[pPDF_, pEpsPDF_, y_, discretevars_] := (
 Total[Map[
   ReplaceAll[pPDF[xConvolveParam - y]*pEpsPDF[xConvolveParam], #] &, 
   discretevars /. (DeleteDuplicates@
        Cases[discretevars, _Symbol, Infinity])[[1]] -> 
     xConvolveParam]]
)
edistanceConvNew[pPDF_, pEpsPDF_, discretevars_, vars_, cons_] := (
   Total[Map[
      ReplaceAll[
        FullSimplify[
         yConvolveResult*
          Abs[discreteNegConv[pPDF, pEpsPDF, yConvolveResult, 
            discretevars]], cons], #] &, (discretevars /. 
        vars[[1]] -> yConvolveResult)]] /. DiracDelta[0] -> 1
  )
continuousNegConv[pPDF_, pEpsPDF_, y_, vars_, varscons_] := (
      varLower = Minimize[{vars[[1]], varscons}, vars[[1]]][[1]];
  varUpper = Maximize[{vars[[1]], varscons}, vars[[1]]][[1]];
  Integrate[pPDF[x - y]*pEpsPDF[x], {x, varLower, varUpper}]
  )
edistanceConvNewCont[pPDF_, pEpsPDF_, epscons_, varscons_, vars_] := (
      FullSimplify[
       Integrate[
        Abs[yConvolveResult]*
     continuousNegConv[pPDF, pEpsPDF, yConvolveResult, vars, varscons], {yConvolveResult, -Infinity, Infinity}], epscons]
  )
(*Print formatting*)
numPrecision12[num_] := (
    ret = ToString[FortranForm[SetPrecision[num,12]]]
)
Printerror[exp_] := If[StringContainsQ[exp, "error"],Print["error"],Print[exp]]
printPrecision12[num_] := (
    maxValue = ToString[numPrecision12[num[[1]]]];
    If[StringCases[maxValue,{"List","Indeterminate",".eq."}] === {},
        maxArgeps = "eps -> " <> ToString[(numPrecision12 /@ Association[num[[2]]])[eps]],
        maxValue = ToString[num[[1]],InputForm];
        maxArgeps = "eps -> " <> "Indeterminate"];
    maximizeResult = ToString[Append[{maxValue}, maxArgeps]];
    If[StringFreeQ[maximizeResult, "error"],Print[maximizeResult]; maximizeResult, Print["error"];"error"]
)
printCheckExp[exp_] := Print[If[Not[StringQ[exp]],exp,"error"]]

addquote[expr_] := (
	If[!StringQ[expr], WriteString[$stream,"\""]];
	WriteString[$stream,InputForm[expr]];
	If[!StringQ[expr], WriteString[$stream,"\""]];
    WriteString[$stream,","];
)

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
	edistanceres = edistance[p,q,epscons][[1]];
	Print["Expectation Distance 1 (|E[X]-E[X_eps]|)"];
	printCheckExp[edistanceres];
	addquote[edistanceres];
    If[!flageps,
	    Print["Expectation Distance 1 Max"];
	    expmax = Maximize[{edistanceres,epscons && varscons},Prepend[vars,eps]];
	    addquote[printPrecision12[expmax]];
    (*addquote[expmax];*)
        Print["Is Linear?"];
	    explinear = islinear2[edistanceres];
        Print[explinear];
	    addquote[explinear]
    ];
	Print[""]
]
pedistNew[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_] := Module[
    (* Find expectation distance E[|X-X_eps|] for discrete distribution,
        where X~p and X_eps~q, p and q are PDFs.  *)
    {},
    edistNewRes = If[discretevars === Null,
        edistanceConvNewCont[p,q,epscons,varscons,vars],
        edistanceConvNew[p,q,discretevars,vars,epscons]
    ];
    Print["Expectation Distance 2 (E[|X-X_eps|])"];
    printCheckExp[edistNewRes];
	addquote[edistNewRes];
    If[!flageps,
        Print["Expectation Distance 2 Max"];
        exp2max = Maximize[{edistNewRes,epscons && varscons}, Prepend[vars, eps]];
        addquote[printPrecision12[exp2max]];
        Print["Is Linear?"];
        explinearNew = islinear2[edistNewRes];
        Print[explinearNew];
        addquote[explinearNew]
    ]
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
	disres = FullSimplify[distance[p,q,epscons && varscons],epscons && varscons];
    If[!flageps,
	    Print["KS Distance"];
	    Print[disres];
	    addquote[disres];
	    Print["KS Distance Max"];
	    distancemax2res := distancemax2[p,q,epscons && varscons,Prepend[vars,eps]];
	    addquote[printPrecision12[distancemax2res]];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
	    kslinear = islinear2[disresr2[r2]];
	    Print[kslinear];
	    addquote[kslinear],
    Print["KS Distance"];
        distancemax2res = distancemax2[p,q,varscons,vars];
        printPrecision12[distancemax2res]
    ];
	Print[""];
	disres
]

ptvd[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_] := Module[
	{tvdres := tvd[p,q,epscons,discretevars]
	},
	Print["TVD"];
	printCheckExp[tvdres];
	addquote[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    tvdmax = Maximize[{tvdres,epscons && varscons},Prepend[vars,eps]];
	    addquote[printPrecision12[tvdmax]];
        Print["Is Linear?"];
	tvdlinear = islinear2[tvdres];
        Print[tvdlinear];
	    addquote[tvdlinear]
    ];
	Print[""]
]

pkl[flageps_,p_,q_,epscons_,varscons_,vars_,discretevars_] := Module[
	{klres = kl[p,q,epscons,discretevars]
	},
	Print["KL Divergence"];
	printCheckExp[klres];
	addquote[klres];
    If[!flageps,
	    Print["KL Divergence Max"];
	    klmax = Maximize[{klres,epscons && varscons},Prepend[vars,eps]];
	    addquote[printPrecision12[klmax]];
        Print["Is Linear?"];
	    kllinear = islinear2[klres];
        Print[kllinear];
	    addquote[kllinear]
    ];
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
	    lowerbound = k*eps+bmin;
            upperbound = k*eps+bmax;
	    Print[lowerbound];
	    Print[upperbound];
            addquote[{lowerbound,upperbound}];
	    Print["TVD Max"];
	    maxSample := Max[table];
	    Print["{",maxSample,", ","{eps -> ",xsample[[Position[table, maxSample][[1]][[1]]]],"}}"];
	    WriteString[$stream,"\""];
            WriteString[$stream,"{"];
            WriteString[$stream,InputForm[maxSample]];
            WriteString[$stream,", {eps -> "];
            WriteString[$stream,InputForm[xsample[[Position[table, maxSample][[1]][[1]]]]]];
            WriteString[$stream,"}}"];
            WriteString[$stream,"\""];
	    WriteString[$stream,","];
	    WriteString[$stream,","],
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
	    Print[" KL Divergence Bounds(lower, upper):"];
	    bmax = Max[table - k*xsample];
	    bmin = Min[table - k*xsample];
            lowerbound = k*eps+bmin;
            upperbound = k*eps+bmax;
	    Print[lowerbound];
	    Print[upperbound];
            addquote[{lowerbound,upperbound}];
	    Print["KL Divergence Max"];
	    maxSample := Max[table];
	    Print["{",maxSample,", ","{eps -> ",xsample[[Position[table, maxSample][[1]][[1]]]],"}}"];
	    WriteString[$stream,"\""];
            WriteString[$stream,"{"];
            WriteString[$stream,InputForm[maxSample]];
            WriteString[$stream,", {eps -> "];
            WriteString[$stream,InputForm[xsample[[Position[table, maxSample][[1]][[1]]]]]];
            WriteString[$stream,"}}"];
            WriteString[$stream,"\""];
	    WriteString[$stream,","];
	    WriteString[$stream,","],
	Print[klvaluecont[p,q,epscons,varscons,vars]]];
        Print[""]
]
	



