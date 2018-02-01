

PSense is a system that evaluates sensitivity of probabilistic programs. It takes programs written in the source language of PSI as input and automatically evaluates how the noise in the prior distributions affects the posterior probabilities. PSense measures the posterior change via statistical distances including expectation distance, Kolmogorov-Smirnov statistic, total variation distance, and Kullback-Leibler divergence.

# Artifact folder contents

- PSense system source code ('source').
- Benchmarks (.psi files in 'benchmarks') and the reference results (.txt files in 'benchmarks').
- Detailed examples and explanations ('examples').

The scripts are designed to work on GNU/Linux systems.


## Benchmark reference results

The reference results for program benchmarks/\*/xxx.psi are stored in benchmarks/\*/xxx.txt. 

Run `cat xxx.txt` to see the well formatted results in terminal.

Only results for the programs that do not run out of time is presented. The corresponding xxx.txt missing indicates the evaluation of xxx.psi did not complete within the timeout.


## Installation

This section is only relevant if you intend to build PSense from sourse on other machines.

### Dependencies:
- PSI
- Python 3.5
- Mathematica 11.1

IMPORTANT:  PSense requires Mathematica to be installed on the system. Please install Mathematica separately as we cannot distribute the copyrighted software. Please note that all results of our runs are available in benchmarks/\*/\*.txt.

#### Install PSI

PSI is an exact probabilistic inference system. You can find the instruction of PSI [here](https://github.com/eth-srl/psi).
To install PSI, you can run the following at your shell prompt:
    
```{shell}
  cd source/psi
  chmod +x dependencies.sh
  ./dependencies.sh && ./build.sh
  export PATH=$PATH:`pwd`
  cd .. 
```

#### Configuring PSense

If Mathematica is already installed, you may add psense and MathematicaScript to your system by running the following:

```{shell}
chmod +x build.sh
./build.sh
```

## Source Code Guide

This section gives a quick overview over the source code. 

psense.py:
  Contains the system entry point, interprets the command line arguments, gets psi results and generates .m files to call the Mathematica modules.

terminaltables/*:
  Renders the plain output given by Mathematica to table-like format. The author is @Robpol86.

modules/base_runall_support.m:
  Detects the distribution support and calls different functions and metrics defined in base.m.

modules/base.m:
  Defines the metrics and the support functions.


## Reproducing the results for all the metrics

In this section we describe how to reproduce the results.
The reference results for program benchmarks/\*/xxx.psi are stored in benchmarks/\*/xxx.txt. 

Run the following code to produce all results:

```{shell}
python3 source/benchmark.py benchmarks [output_directory]
```

where `[output_directory]` is the directory to store all the running results.
(Warning: As we have increased the timeout to 10 minutes, this will take a very significant amount of time.)
 
## Using PSI on your own models

run `psense -f example.psi`,
 where `example.psi` is a program written in the source language of PSI.


### Additional command-line options

-h, --help       
show this help message and exit


-f F             
PSI file


-r R             
Directory containing PSI files


-o [O]           
Output file


-e [E]           
Explicit numerical interfrance in all prior distribution


-p [P]           
Noise percentage (p=(0,1), Defualt=0.1)


-metric [METRIC]  
Metrics for sensitivity analysis (support ExpDist,KS,TVD,KL,Custom). Please enclose metrics with double quotation marks e.g. "ExpDist,KL,Custom:FilePath" "KS,TVD" Note: function name of custom metric should be identical as the file name
            
                  
-tp [TP]          
PSI timeout (second)


-tm [TM]          
Mathematica timeout (second)


-plain            
Print raw outputs


-verbose          
Print outputs of PSI


-log              
Keep the generated files


### Examples

More examples and explanation are available in 'examples/'. 

See our website for more information:  http://psense.info
