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
klsingle[p_,q_,cons_,varscons_] := (Sum@@{FullSimplify[entropy[p,q],cons],{(Variables@Level[varscons,{-1}])[[1]],Map[First,Map[Values,Solve[varscons,(Variables@Level[varscons,{-1}])[[1]]]]]}})
gtd[p_] := D[FullSimplify[ComplexExpand[p],eps>0],eps]
ltd[p_] := D[FullSimplify[ComplexExpand[p],eps<0],eps]
islinear[p_] := ((NumberQ[gtd[p]])&&(NumberQ[ltd[p]]))
(*islinear2[p_] := Module[
		{islinearlist := {}},
		Do[AppendTo[islinearlist,D[FullSimplify[p[i],eps>0],eps]];AppendTo[islinearlist,D[FullSimplify[p[i],eps<0],eps]],{i,-5,5}];
		Print[islinearlist];
		AllTrue[islinearlist, NumberQ]
  ]*)
addquote[expr_] := (
	WriteString[$stream,"\""];
	WriteString[$stream,InputForm[expr]];
    WriteString[$stream,"\""];
    WriteString[$stream,","];
)

inrunall[flageps_,p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0r.csv"] := Module[
	{
    vars := Map[First,varsminmax]
	},
    $stream = OpenAppend["ch0r.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","];
	single = (Length[vars]==1);
    If[!flageps,vars=Prepend[vars,eps]];
	If[single, runsingle[flageps,p,np,e,ne,epscons,varscons,vars,varsminmax],runmulti[flageps,p,np,epscons,vars,varsminmax]];
    WriteString[$stream,"\n"];
    Close[$stream];
	Print[""]
]

runsingle[flageps_,p_,np_,e_,ne_,epscons_,varscons_,vars_,varsminmax_] := Module[
	{
	},
    If[!flageps,cons=epscons&&varscons,cons=varscons];
    varsnoeps = Map[First,varsminmax];
	pedist[flageps,e,ne,epscons,cons,vars];
	pks[flageps,p,np,cons,vars];
	(*revkseps[ksres,varsnoeps];*) 
	(*ptvd[p,np,cons,vars,varsminmax];
	pkl[p,np,cons,vars,varsminmax];*)
	ptvdsingle[flageps,p,np,cons,vars,varscons];
	pklsingle[flageps,p,np,cons,vars,varscons];
]

runmulti[flageps_,p_,np_,cons_,vars_,varsminmax_] := Module[
	{},
	WriteString[$stream,",,,"];
	varsnoeps = Map[First,varsminmax];
	pks[flageps,p,np,cons,vars];
	(*revkseps[ksres,varsnoeps];*)
	ptvd[flageps,p,np,cons,vars,varsminmax];
	pkl[flageps,p,np,cons,vars,varsminmax];
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
    addquote[edistanceres];
    (*Print[edistance2[p,q,epscons][[1]]];*)
    If[!flageps,
	    Print["Expectation Distance Max"];
        (*Print[cons];*)
	    (*Print[FindMaximum[{edistanceres,cons},vars]];*)
        expmax = Maximize[{edistanceres,cons},vars];
	    Print[expmax];
        addquote[expmax];
        Print["Is Linear?"];
        explinear = islinear2[edistanceres];
        Print[explinear];
        addquote[explinear]];
	Print[""]
]

pks[flageps_,p_,q_,cons_,vars_] := Module[
	{},
	disres = FullSimplify[distance[p,q,cons],cons];
    If[!flageps,
	    Print["Distance"];
	    Print[disres];
        addquote[disres];
	    Print["KS Distance Max"];
	    (*distancemaxres = distancemax[p,q,cons,vars];*)
        (*Print[distancemaxres];*)
	    distancemax2res := distancemax2[p,q,cons,vars];
	    Print[distancemax2res];
        addquote[distancemax2res];
        Print["Is Linear?"];
        disresr2[r2_] = (disres /. r1->r2);
        kslinear = islinear2[disresr2[r2]];
	    Print[kslinear];
        addquote[kslinear],
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
    addquote[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    (*Print[FindMaximum[{tvdres,cons},vars]];*)
        tvdmax = Maximize[{tvdres,cons},vars];
	    Print[tvdmax];
	    addquote[tvdmax];
        Print["Is Linear?"];
        tvdlinear = islinear2[tvdres];
        Print[tvdlinear];
        addquote[tvdlinear]];
	Print[""]
]
ptvd[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
	{tvdres := tvd[p,q,cons,varsminmax]
	},
	Print["TVD"];
	Print[tvdres];
    addquote[tvdres];
    If[!flageps,
	    Print["TVD Max"];
	    (*Print[FindMaximum[{tvdres,cons},vars]];*)
        tvdmax = Maximize[{tvdres,cons},vars];
	    Print[tvdmax];
	    addquote[tvdmax];
        Print["Is Linear?"];
        tvdlinear = islinear2[tvdres];
        Print[tvdlinear];
        addquote[tvdlinear]];
	Print[""]
]
pkl[flageps_,p_,q_,cons_,vars_,varsminmax_] := Module[
	{klres := kl[p,q,cons,varsminmax]
	},
	Print["KL Divergence"];
	Print[klres];
    addquote[klres];
    If[!flageps,
	    Print["KL Max"];
	    (*Print[FindMaximum[{klres,cons},vars]];*)
        klmax = Maximize[{klres,cons},vars];
	    Print[klmax];
	    addquote[klmax];
        Print["Is Linear?"];
        kllinear = islinear2[klres];
        Print[kllinear];
        addquote[kllinear]];
	Print[""]
]
pklsingle[flageps_,p_,q_,cons_,vars_,varscons_] := Module[
	{klres := klsingle[p,q,cons,varscons]
	},
	Print["KL Divergence"];
	Print[klres];
    addquote[klres];
    If[!flageps,
	    Print["KL Max"];
	    (*Print[FindMaximum[{klres,cons},vars]];*)
        klmax = Maximize[{klres,cons},vars];
	    Print[klmax];
        addquote[klmax];
        Print["Is Linear?"];
        kllinear = islinear2[klres];
        Print[kllinear];
        addquote[kllinear]];
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

