(* Package *)

(* Input *)
MyDiracDelta[x_] := Boole[x == 0]

runall[mathepath_,p_,pdf_,np_,flageps_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_:0,e_:1,ne_:1,epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),file_:Null] := Module[{},
    filecsv = True;
    If[filecsv, 
	$stream = OpenAppend["~/results_time.csv",BinaryFormat->True];
	WriteString[$stream,$ScriptCommandLine[[1]]];
	WriteString[$stream,","]
    ];
    newepscons=If[!flageps,If[Maximize[{eps,epscons},eps][[1]]==0,(-0.01<=eps<=0.01),epscons],True];
    newvars=DeleteCases[DeleteDuplicates@Cases[pdf, _Symbol, Infinity], eps];
    pReplace := pdf /. DiracDelta -> MyDiracDelta;
    newvarscons := FullSimplify[FunctionDomain[1/Boole[0 != pReplace], newvars]];
    discretevars := Quiet[Solve[newvarscons, newvars]];
    If[filecsv,
	Get[mathepath<>"/develop/base_runall_type_time_csv.m"],
    	Get[mathepath<>"/base_runall_disc.m"]
    ];
    continuous := TrueQ[newvarscons]||MatchQ[newvarscons,__Inequality];
    Print["Function Type:"];
    If[continuous, Print["Continuous"],Print["Discrete"]];
    If[filecsv && continuous, addquote[Continuous],addquote[Discrete]];
    Print[""];
    Print["Start All Metrics:"];

    If[flagexpdist,
	If[(Length[newvars]==1),
		timeexpdist = Timing[pedist[flageps,e,ne,newepscons,newvarscons,newvars]];
		If[filecsv,WriteString[$stream, timeexpdist[[1]]];WriteString[$stream,","]],
		If[filecsv,WriteString[$stream,",,,,"]]
	]
    ];
    If[flagks,
	timeks = Timing[pks[flageps,p,np,newepscons,newvarscons,newvars]];
	If[filecsv,WriteString[$stream, timeks[[1]]];WriteString[$stream,","]]
	(*revkseps[ksres,newvars];*) 
    ];
    If[flagtvd,
	If[continuous,
		timetvd = Timing[ptvdcont[flageps,p,np,newepscons,newvarscons,newvars]],
		timetvd = Timing[ptvd[flageps,p,np,newepscons,newvarscons,newvars,discretevars]]
	];
	If[filecsv,WriteString[$stream, timetvd[[1]]];WriteString[$stream,","]]
    ];
    If[flagkl,
	If[continuous,
		timekl = Timing[pklcont[flageps,p,np,newepscons,newvarscons,newvars]],
		timekl = Timing[pkl[flageps,p,np,newepscons,newvarscons,newvars,discretevars]]
	];
	If[filecsv,WriteString[$stream, timekl[[1]]];WriteString[$stream,","]]
    ];
    If[flagcustom, 
        pcus[flageps,p,np,newepscons,newvarscons,newvars,discretevars,customfun]
    ];
    If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
    Print[""];
    Print["Finish All Metrics"];
    Print[""];
    Print[""];
    Print[""]
]

