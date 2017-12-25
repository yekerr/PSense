(* Package *)

(* Input *)
MyDiracDelta[x_] := Boole[x == 0]
runall[mathepath_,p_,pdf_,np_,flageps_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x.csv"] := Module[
	{
	},
    newepscons=True;
	If[!flageps,If[Maximize[{eps,epscons},eps][[1]]==0,newepscons=(-0.01<=eps<=0.01),newepscons=epscons]];
	pReplace := pdf /. DiracDelta -> MyDiracDelta;
	newvarscons := FunctionDomain[1/Boole[0 != pReplace], Map[First,varsminmax][[1]]];
	continuous := TrueQ[newvarscons]||MatchQ[newvarscons, Inequality_];
	Print[""];
	Print["Start Mathematica"];
	Print[""];
	Print["Function Type:"];
	If[continuous, Print["Continuous"],Print["Discrete"]];
	Print[""];
	If[continuous, Get[mathepath<>"/base_runall_cont.m"], Get[mathepath<>"/base_runall_disc.m"]];
	Print["Start All Metrics:"];
	inrunall[flageps,p,np,e,ne,varsminmax,newepscons,newvarscons,file];
	Print["Finish All Metrics"];
	Print[""];
	Print[""];
	Print[""]
]

