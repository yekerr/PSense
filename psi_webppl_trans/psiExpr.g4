grammar psiExpr;

WS : [ \n\t\r]+ -> channel(HIDDEN) ;
TYPE : 'Z' ('[' ']')* | 'R' ('[' ']')* ;
BOP : '+' | '-' | '/' | '*' | '^' | '%' ;
ASOP : '+=' | '-=' | '*=' | '/=' | '~=' ;
UOP : '-' | '!' | '+' ;
INT : [0-9]+ ;
DOUBLE :  ([0-9]? '.' [0-9]+) | ([1-9][0-9]* '.' [0-9]+) ;
COMMENT : ('//' ~[\r\n]* | '/+' .*? '+/')  -> channel(HIDDEN);
STRING : '"' ~["]* '"' ;
LOP :  '&&' | '||' | '|' | '&' ;
COP :  '==' | '!=' | '<' | '>' | '<=' | '>=' ;
PRELUDE :  'exp' | 'log' | 'sin' | 'cos' | 'abs' | 'min' | 'max' | 'floor' | 'ceil' | 'gauss' | 'chiSquared' | 'rayleigh' | 'truncatedGauss' | 'pareto' | 'uniform' | 'flip' | 'bernoulli' | 'uniformInt' | 'binomial' | 'negBinomial' | 'geometric' | 'poisson' | 'beta' | 'gamma' | 'laplace' | 'cauchy' | 'exponential' | 'studentT' | 'weibull' | 'categorical' | 'dirac' | 'dirichlet' | 'multiGauss' ;
BUILTIN :  'readCSV' | 'Marginal' | 'sampleFrom' | 'Expectation' ;
ID : [a-zA-Z]+[a-zA-Z0-9_]* ;

prog: (stmt ';'?)? func+ ;
func: 'def' ID '(' (ID (type_anno)?)? (',' ID (type_anno)? )* ')' '{' stmt '}' ;
type_anno: ':' TYPE ;
comp_op: BOP | LOP | COP ;
ifcond: 'if' expr '{' stmt '}'; 
elsecond: 'else' '{' stmt '}';
elifcond: 'else if' expr '{' stmt '}';
number: DOUBLE | INT;
   
expr: expr comp_op expr                             # calc
    | PRELUDE '(' expr (',' expr )* ')'             # math
    | BUILTIN '(' expr ')'                          # builtin
    | ID '('  (expr (',' expr )*)? ')'              # fcall
    | UOP expr                                      # ucalc
    | ID '[' expr ']'('[' expr ']')*                # arrget
    | '(' expr (',' expr)* ')'                      # tuple
    | STRING                                        # str
    | number                                        # lnumber
    | arre                                          # larre
    | ID '.length'                                  # length
    | ID                                            # id
    ;

arre: '(' ('[' ']')+ type_anno ')'                  # aempty
    | arre '~' arre                                 # acat
    | '[' expr (',' expr )* ']'                     # abcons
    | 'array' '(' expr (',' expr)?  ')'                # aarray
    | ID '[' expr '..' expr ']'                     # aslice
    ;
 
stmt: ID ':=' expr                                  # init
    | ID ASOP expr                                  # arithassign
    | ID ':=' arre                                  # ainit
    | ID '=' expr                                   # assign
    | ID '[' expr ']' '=' expr                      # aassign
    | 'observe' '(' expr ')'                        # observe
    | 'cobserve' '(' expr ',' expr ')'              # cobserve
    | stmt stmt                                     # stmtcat
    | stmt ';'                                      # addsemicolon
    | 'return' expr ';'?                            # return
    | ifcond elifcond* elsecond?                    # if
    | 'repeat' expr '{' stmt  '}'                    # repeat
    | 'for' ID 'in' '[' expr '..' expr ')' '{' stmt '}' # for
    | 'while' expr '{' stmt '}'                       # while
    | 'assert' '(' expr ')'                         # assert
    | func                                          # funcdef
    | 'skip'                                        # skip
    ;
