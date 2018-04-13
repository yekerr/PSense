(* Package *)
(* Input *)
MyDiracDelta[x_] := Boole[x == 0]

runall[mathepath_,p_,pdf_,np_,flageps_,flagexpdist_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_:0,e_:1,ne_:1,epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),logfile_:Null] := Module[{},
    logstream = OpenAppend[logfile];
    $Messages = {logstream};
    Write[logstream, "Mathematica Modules Called"]; 
    totalTime = TimeConstrained[
    filecsv = True;
    If[filecsv, 
	    $stream = OpenAppend["~/results_time.csv",BinaryFormat->True];
	    WriteString[$stream,$CommandLine[[3]]];
	    WriteString[$stream,","]
    ];
    supportTime = TimeConstrained[
    newepscons=If[!flageps,If[Maximize[{eps,epscons},eps][[1]]==0,(-0.01<=eps<=0.01),epscons],True];
    newvars = DeleteCases[DeleteDuplicates@Cases[pdf, _Symbol, Infinity], eps];
    newvars = DeleteCases[newvars, Alternatives @@ Select[newvars, NumericQ]];
    pReplace = pdf /. DiracDelta -> MyDiracDelta;
    TimeConstrained[newvarscons = FullSimplify[FunctionDomain[1/Boole[0 != pReplace],newvars]],10];
    If[!ValueQ[newvarscons],
        pReplace = (pdf /. Boole[x_] -> 1) /. DiracDelta -> MyDiracDelta;
	    newvarscons = FullSimplify[FunctionDomain[1/Boole[0 != pReplace],newvars]]
    ];
    Quiet[discretevars = Solve[newvarscons, newvars]];
    If[filecsv,
	    Get[mathepath<>"/develop/base_runall_type_time_csv.m"],
    	Get[mathepath<>"/base.m"]
    ];
    continuous = TrueQ[newvarscons]||MatchQ[newvarscons,__Inequality];
    , 600];
    If[supportTime===$Aborted,
        Print["Solving Support Time Out"];
        If[filecsv, WriteString[$stream, "SupportT/O,,,,,,,,,,,,,,,,,"]];
        If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
        Quit[]
    ];
    Print["Function Type:"];
    If[continuous, Print["Continuous"],Print["Discrete"]];
    If[filecsv && continuous, addquote[Continuous],addquote[Discrete]];
    Print[""];
    Print["Start All Metrics:"];

    If[flagexpdist,
	    If[(Length[newvars]==1),
	    	timeexpdist = Timing[TimeConstrained[pedist[flageps,e,ne,newepscons,newvarscons,newvars],600]];
            If[timeexpdist[[2]]===$Aborted,
                Print["Expectation Distance Time Out"];
	    	    If[filecsv,WriteString[$stream,"T/O,,,,"]],
	    	    If[filecsv,WriteString[$stream, timeexpdist[[1]]];WriteString[$stream,","]]
            ],
	    	If[filecsv,WriteString[$stream,"N/A,,,,"]]
	    ]
    ];
    If[flagks,
	    timeks = Timing[TimeConstrained[pks[flageps,p,np,newepscons,newvarscons,newvars],600]];
        If[timeks[[2]]===$Aborted,
            Print["KS Distance Time Out"];
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timeks[[1]]];WriteString[$stream,","]]
        ];
	    (*revkseps[ksres,newvars];*) 
    ];
    If[flagtvd,
	    If[continuous,
	    	timetvd = Timing[TimeConstrained[ptvdcont[flageps,p,np,newepscons,newvarscons,newvars],600]],
	    	timetvd = Timing[TimeConstrained[ptvd[flageps,p,np,newepscons,newvarscons,newvars,discretevars],600]]
	    ];
        If[timetvd[[2]]===$Aborted,
            Print["TVD Time Out"];
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timetvd[[1]]];WriteString[$stream,","]]
        ];
    ];
    If[flagkl,
	    If[continuous,
	    	timekl = Timing[TimeConstrained[pklcont[flageps,p,np,newepscons,newvarscons,newvars],600]],
	    	timekl = Timing[TimeConstrained[pkl[flageps,p,np,newepscons,newvarscons,newvars,discretevars],600]]
	    ];
        If[timekl[[2]]===$Aborted,
            Print["KL Divergence Time Out"];
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timekl[[1]]];WriteString[$stream,","]]
        ];
    ];
    If[flagcustom, 
        pcus[flageps,p,np,newepscons,newvarscons,newvars,discretevars,customfun]
    ];
    If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
    Print[""];
    Print["Finish All Metrics"];
    Print[""];
    Print[""];
    Print[""],
    6000];
    If[totalTime===$Aborted,
        Print["Total Time Out"];
	    If[filecsv, WriteString[$stream,"AllT/O,,,,,,,,,,,,,,,,,"]];
        If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
    ];
    $Messages = $Messages[[{1}]];
    Close[logstream];
]
