(*Packages*)

(*Match Brackets*)
ClearAll[balancedBracesQ]
balancedBracesQ[str_String] := 
 StringCount[str, "["] === StringCount[str, "]"]

(*Find distribution variables from expression, remove integrate vars xi*)
findVar[toFindVar_] := (vars = 
   DeleteCases[DeleteDuplicates@Cases[toFindVar, _Symbol, Infinity], 
    eps]; vars = 
   DeleteCases[vars, Alternatives @@ Select[vars, NumericQ]]; 
  vars = DeleteCases[vars, Infinity]; 
  vars = DeleteCases[vars, 
    a_ /; StringMatchQ[ToString@a, RegularExpression["xi[0-9]+"]]];
  vars)

(*Find distribution variables from string*)
findAllVarFromStr[exprString_] := (
  toFindVar = ToExpression["Hold[" <> exprString <> "]"];
  vars = DeleteDuplicates@Cases[toFindVar, _Symbol, Infinity]; 
  vars = DeleteCases[vars, Alternatives @@ Select[vars, NumericQ]]; 
  vars = DeleteCases[vars, Infinity];
  vars = Fold[DeleteCases[#1, Symbol[#2]] &, vars, 
    StringCases[exprString, Shortest["{" ~~ x__ ~~ ","] -> x]];
  vars)

(*Generate function args with the NumericQ constraints, return the exp in String*)
setNumericQ[exprString_] := (
  vars = findAllVarFromStr[exprString];
  If[vars === {}, "", 
   StringReplace[
    ToString[vars], {"," -> "_?NumericQ,", "{" -> "[", 
     "}" -> "_?NumericQ]"}]])

(*Generate the function args, return the exp in String*)
setParam[exprString_] := (vars = findAllVarFromStr[exprString]; 
  If[vars === {}, "", 
   StringReplace[ToString[vars], {"{" -> "[", "}" -> "]"}]])

(*Get the numerical integral function definictions at certain level*)
tLevel[level_, intExp_] := (
  	Select[t, StringContainsQ[#, intExp <> ToString[level]] &])


(*Replace the integrals in int_ with predefined numerical integrals*)
simplify1t[int_, i_, intExp_] := (
  	intToSimplify = int;
  	For[k = 1, 
   k <= Length[Evaluate[Symbol[intExp <> ToString[i + 1]]]] && 
    StringContainsQ[intToSimplify, "xi" <> ToString[i]] , k++,
   funExpr = Evaluate[Symbol[intExp <> ToString[i + 1]]][[k]];
    		intToSimplify = StringReplace[intToSimplify, 
        		
     funExpr -> (intExp <> ToString[i + 1] <> ToString[k] <> 
        setParam[funExpr])]
    	];
  	intToSimplify)

(*Set the precisionGoal to 8 in NIntegrate*)
nIntPrecision[str_] := (
  	strReplaced = str;
  	nInts = DeleteDuplicates@StringCases[strReplaced, 
     		Shortest[
      "NIntegrate[" ~~ (arg1__ /; balancedBracesQ[arg1]) ~~ "]"]];
      nIntsReplace = 
   Map[StringDrop[#, -1] <> ",PrecisionGoal->8]" &, nInts];
      For[k = 1, k <= Length[nInts], k++,
    	strReplaced = 
    StringReplace[strReplaced, nInts[[k]] -> nIntsReplace[[k]]]
    	];
  	strReplaced
  )

(*Try to solve the integrals in dstrIn_. 
Use intExpPrefix_ as the prefix of function names
when defining helper functions for numerical integration*)
numInt[dstrIn_, intExpPrefix_] := (
  intExp = intExpPrefix <> "int";
  dstr = dstrIn;
  dstr = StringReplace[dstr, "Integrate" -> "NIntegrate"];
  dstr = StringReplace[dstr, "Sum" -> "NSum"];
  dstr = StringReplace[dstr, "Maximize" -> "NMaximize"];

  (*At most how many levels of nested integrals*)
  intLevels = 
   Length[DeleteDuplicates@
      StringCases[dstr, RegularExpression["xi[0-9]+"]]] + 1;

  (*Extract all level of integralas, define them as individual helper functions,
  add to set t*)
  Do[If[i == 1,
     	Evaluate[Symbol[intExp <> ToString[i]]] = StringCases[dstr, 
       		Shortest[{"NIntegrate[", "NSum[", 
          "NMaximize["} ~~ (arg1__ /; balancedBracesQ[arg1]) ~~ 
         "]"]];
     	t = {};
     	,(*Else*)
     
     exprSetToEval = Select[ Map[StringCases[StringDrop[#, 1], 
              		Shortest[
                		{"NIntegrate[", "NSum[", 
             "NMaximize["} ~~ (arg1__ /; balancedBracesQ[arg1]) ~~ 
                  		"]"]] &, 
        Evaluate[Symbol[intExp <> ToString[i - 1]]]], 
       UnsameQ[#, {}] &];
     		If[UnsameQ[exprSetToEval, {}], 
      Evaluate[Symbol[intExp <> ToString[i]]] = exprSetToEval[[1]]];
             t = Join[t, Table[
        funExpr = Evaluate[Symbol[intExp <> ToString[i]]][[j]];
         		 
        intExp <> ToString[i] <> ToString[j] <> setNumericQ[funExpr] <>
          ":=" <> intExp <> ToString[i] <> ToString[j] <> 
           		 setParam[funExpr] <> "=" <> funExpr, {j, 1, 
         Length[Evaluate[Symbol[intExp <> ToString[i]]]], 1}]];
     	];
   , {i, intLevels}];

  (*Recursively replace the nested integrals in the input expression
    and in each individual helper function
    with defined helper functions,
    Generate the function definition for all level of integrals*)
  tSimplified = {};
  Do[If[i == 1,
     	For[k = 1, 
       k <= Length[Evaluate[Symbol[intExp <> ToString[i + 1]]]] && 
        StringContainsQ[dstr, "xi" <> ToString[i]] , k++,
       funExpr = Evaluate[Symbol[intExp <> ToString[i + 1]]][[k]];
        		dstr = StringReplace[dstr, 
            		
         funExpr -> (intExp <> ToString[i + 1] <> ToString[k] <> 
            setParam[funExpr])];
          	];
     	,(*Else*)
     	tToSimplify = tLevel[i, intExp];
     	tSimplified = 
      Join[Map[simplify1t[#, i, intExp] &, tToSimplify], 
       tSimplified];
     	];
   , {i, intLevels}];

  (*Activate all the defined helper functions*)
  Activate[Evaluate[ToExpression[tSimplified]]];
  (*Set Precision Goal*)
  (*dstr = nIntPrecision[
  dstr];*)

  (*Try to do numerical integrate on the original expression*)
  dexp = TimeConstrained[Catch[ToExpression[dstr]], 6];

  (*If fails, recover the unsolved part to original expression.
    Return the result*)
  If[NumberQ[dexp], dexp,
   dstrRecover = dstr;
   For[k = 1, 
    k <= Length[t] && StringContainsQ[dstrRecover, intExp] , k++,
    toRecover = 
     StringCases[t[[k]], Shortest[":=" ~~ x__ ~~ "="] -> x][[1]];
    toRecoverExp = StringSplit[t[[k]], toRecover <> "="][[-1]];
    dstrRecover = 
     StringReplace[dstrRecover, toRecover -> toRecoverExp];
    ];
   dstrRecover = 
    StringReplace[dstrRecover, "NIntegrate" -> "Integrate"];
   dstrRecover = StringReplace[dstrRecover, "NSum" -> "Sum"];
   dstrRecover = StringReplace[dstrRecover, "NMaximize" -> "Maximize"];
   dstrRecover] )
