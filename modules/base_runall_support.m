(* Package *)
(* Input *)
MyDiracDelta[x_] := Boole[x == 0]

runall[mathepath_,p_,pdf_,np_,npdf_,flageps_,flagexpdist_,flagexpdistNew_,flagks_,flagtvd_,flagkl_,flagcustom_,customfun_:0,e_:1,ne_:1,epscons_:(-0.01<=eps<=0.01),varscons_:(r1==0||r1==1),flagnumeric_:False, logfile_:Null, epsType_:""] := Module[{},
    If[flagnumeric, 
        Print["Use numeric"]; 
        Get[mathepath<>"/numeric_approx.m"];
        Quit[]
    ];
    logstream = OpenAppend[logfile];
    $Messages = {logstream};
    totalTime = TimeConstrained[
    filecsv = True;
    If[filecsv, 
	    $stream = OpenAppend[mathepath<>"/results_time.csv",BinaryFormat->True];
	    WriteString[$stream,$CommandLine[[3]]];
	    WriteString[$stream,","];
	    WriteString[$stream,epsType];
	    WriteString[$stream,","]
    ];
    Write[logstream, "Solving Support..."]; 
    supportTime = TimeConstrained[
    newepscons=If[!flageps,If[Maximize[{eps,epscons},eps][[1]]==0,(-0.01<=eps<=0.01),epscons],True];
    pdfR = pPDF[r1];
    newvars = DeleteCases[DeleteDuplicates@Cases[pdfR, _Symbol, Infinity], eps];
    newvars = DeleteCases[newvars, Alternatives @@ Select[newvars, NumericQ]];
    newvars = DeleteCases[newvars, Infinity];
    newvars = DeleteCases[newvars, a_ /; StringMatchQ[ToString@a, RegularExpression["xi[0-9]+"]]];
    pReplace = pdfR /. DiracDelta -> MyDiracDelta;
    TimeConstrained[newvarscons = FullSimplify[FunctionDomain[1/Boole[0 != pReplace],newvars]],10];
    If[!ValueQ[newvarscons],
        pReplace = (pdfR /. Boole[x_] -> 1) /. DiracDelta -> MyDiracDelta;
	    newvarscons = FullSimplify[FunctionDomain[1/Boole[0 != pReplace],newvars]]
    ];
    evalresolve = ToExpression["Resolve[ForAll["<>ToString[newvars]<>","<>ToString[newvarscons,InputForm]<>"]]"];
    If[TrueQ[evalresolve], newvarscons = True];
    Quiet[discretevars = Solve[newvarscons, newvars]];
    (*If[discretevars === {}, newvarscons = True]*)
    If[filecsv,
	    Get[mathepath<>"/develop/base_runall_type_time_csv.m"],
    	Get[mathepath<>"/base.m"]
    ];
    continuous = TrueQ[newvarscons]||MatchQ[newvarscons,__Inequality];
    , 6];
    If[supportTime===$Aborted,
        Print["Solving support time out"];
        If[filecsv, WriteString[$stream, "SupportT/O,,,,,,,,,,,,,,,,,"]];
        If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
        Write[logstream, "Solving support time out"];Close[logstream]; 
        Quit[],
        Write[logstream, "Support solved: "]; 
        Write[logstream, newvarscons]; 
        Write[logstream, newvars];
        Write[logstream, discretevars]; 
    ];
    Print["Function Type:"];
    If[continuous, Print["Continuous"],Print["Discrete"]];
    If[filecsv && continuous, addquote[Continuous],addquote[Discrete]];
    Print[""];
    Print["Start All Metrics:"];

    If[flagexpdist,
        Write[logstream, "Finding Expectation Distance 1..."]; 
	    If[(Length[newvars]==1),
	    	timeexpdist = Timing[TimeConstrained[pedist[flageps,e,ne,newepscons,newvarscons,newvars],600]];
            If[timeexpdist[[2]]===$Aborted,
                Print["Finding Expectation Distance 1 time out"];
                Write[logstream, "Finding Expectation Distance 1 time out"]; 
	    	    If[filecsv,WriteString[$stream,"T/O,,,,"]],
	    	    If[filecsv,WriteString[$stream, timeexpdist[[1]]];WriteString[$stream,","]];
                Write[logstream, "Done."]; 
            ],
            Write[logstream, "Expectation is not supported"]; 
	    	If[filecsv,WriteString[$stream,"N/A,,,,"]]
	    ]
    ];
    If[flagexpdistNew,
        Write[logstream, "Finding Expectation Distance 2..."];
        If[(Length[newvars]==1),
            timeexpdistNew = If[continuous,
                 Timing[TimeConstrained[pedistNew[flageps,pdf,npdf,newepscons,newvarscons,newvars,Null],600]],
                 Timing[TimeConstrained[pedistNew[flageps,pdf,npdf,newepscons,newvarscons,newvars,discretevars],600]]
            ];
            If[timeexpdistNew[[2]]===$Aborted,
                Print["Finding Expectation Distance 2 time out"];
                Write[logstream, "Finding Expectation Distance 2 time out"];
                If[filecsv,WriteString[$stream,"T/O,,,,"]],
                If[filecsv,WriteString[$stream,timeexpdistNew[[1]]];WriteString[$stream,","]];
                Write[logstream, "Done."];
            ],
            Write[logstream, "Expectation is not supported"];
            If[filecsv,WriteString[$stream,"N/A,,,,"]]
        ]
    ];
    If[flagks,
        Write[logstream, "Finding KS Distance..."]; 
	    timeks = Timing[TimeConstrained[pks[flageps,p,np,newepscons,newvarscons,newvars],600]];
        If[timeks[[2]]===$Aborted,
            Print["Finding KS Distance time out"];
            Write[logstream,"Finding KS Distance time out"];
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timeks[[1]]];WriteString[$stream,","]];
            Write[logstream, "Done."]; 
        ];
	    (*revkseps[ksres,newvars];*) 
    ];
    If[flagtvd,
        Write[logstream, "Finding TVD..."]; 
	    If[continuous,
	    	timetvd = Timing[TimeConstrained[ptvdcont[flageps,p,np,newepscons,newvarscons,newvars],600]],
	    	timetvd = Timing[TimeConstrained[ptvd[flageps,p,np,newepscons,newvarscons,newvars,discretevars],600]]
	    ];
        If[timetvd[[2]]===$Aborted,
            Print["Finding TVD time out"];
            Write[logstream,"Finding TVD time out"];
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timetvd[[1]]];WriteString[$stream,","]];
            Write[logstream, "Done"]; 
        ];
    ];
    If[flagkl,
        Write[logstream, "Finding KL Divergence..."]; 
	    If[continuous,
	    	timekl = Timing[TimeConstrained[pklcont[flageps,p,np,newepscons,newvarscons,newvars],600]],
	    	timekl = Timing[TimeConstrained[pkl[flageps,p,np,newepscons,newvarscons,newvars,discretevars],600]]
	    ];
        If[timekl[[2]]===$Aborted,
            Print["Finding KL Divergence time out"];
            Write[logstream, "Finding KL Divergence time out"]; 
	        If[filecsv,WriteString[$stream,"T/O,,,,"]],
	        If[filecsv,WriteString[$stream, timekl[[1]]];WriteString[$stream,","]];
            Write[logstream, "Done."]; 
        ];
    ];
    If[flagcustom, 
        Write[logstream, "Finding custromized metrics..."]; 
        pcus[flageps,p,np,newepscons,newvarscons,newvars,discretevars,customfun]
        Write[logstream, "Done"]; 
    ];
    If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
    Print[""];
    Print["Finish All Metrics"];
    Print[""];
    Print[""];
    Print[""],
    3600];
    If[totalTime===$Aborted,
        (*Print["Total Time Out"];*)
	    If[filecsv, WriteString[$stream,"AllT/O,,,,,,,,,,,,,,,,,"]];
        If[filecsv, WriteString[$stream,"\n"];Close[$stream]];
    ];
    $Messages = $Messages[[{1}]];
    Close[logstream];
]
