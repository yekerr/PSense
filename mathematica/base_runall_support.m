(* Package *)

(* Input *)
MyDiracDelta[x_] := Boole[x == 0]
runall[pdf_,p_,np_,e_:1,ne_:1,varsminmax_:{{r1,0,1}},epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:"ch0x.csv"] := Module[
	{
	},
	pReplace := pdf /. DiracDelta -> MyDiracDelta;
	newvarscons := FunctionDomain[1/Boole[0 != pReplace], Map[First,varsminmax][[1]]];
	continuous := TrueQ[newvarscons];
	If[continuous, Print["Continuous"],Print["Discrete"]];
	Print[file];
	If[continuous, Get[Directory[]<>"/../../../../../mathe/pSensitivity/mathematica/base_runall_cont.m"], Get[Directory[]<>"/../../../../../mathe/pSensitivity/mathematica/base_runall_print.m"]];
	Print["start run all"];
	inrunall[p,np,e,ne,varsminmax,epscons,newvarscons,file];
	Print["finish run all"]
]

