{% include head.html %}
## Tutorial 4: Sampling Based Sensitivity Analysis

### PSense Sampling Backend

Since exact probabilistic inference is computationally hard, we've implemented a sampling backend as an approximate alternative to the exact symbolic analysis. Our sampling backend translates program in PSI to [WebPPL](http://webppl.org/), one of the popular probabilistic programming languages that supports Markov Chain Monte Carlo (MCMC) sampling-based inference.

Run the following command to translate `examples/conditioning.psi` to WebPPL:
```{shell}
java -jar psi2webppl/psi2webppl.jar examples/conditioning.psi

```
It prints the WebPPL code to standard output. 
```
var main = function(){
    globalStore.A = flip(0.5)
    globalStore.B = flip(0.5)
    globalStore.C = flip(0.5)
    globalStore.D = globalStore.A + globalStore.B + globalStore.C
    condition(globalStore.D >= 2)
    return globalStore.A;
}
Infer({method: 'MCMC', samples: 1000},main)
```

Copy it and run it with WebPPL's online editing tool: [http://webppl.org](http://webppl.org). 
Or install WebPPL with `npm install -g webppl`, redirect the WebPPL code above to `conditioning.wppl`, and run with `webppl conditioning.wppl`.

Usage:
```
java -jar psi2webppl/psi2webppl.jar <PSI file to translate>
```

Notice that because WebPPL applies the functional programming paradigm, which the doesn't allow us to overwrite a variable. To allow overwriting as we did in PSI, we use the globalStore rather than conventional var. Also since WebPPL doesn't support for loop or while loop, we translate loops in PSI to recursions in WebPPL.

### Sampling Based Sensitivity Analysis

We can also try the sensitivity analysis with metric Expectation Distance 2(ED2). The following code finds the approximate ED2 for the first parameter in file `examples/conditioning.psi`.

```{shell}
./psi2webppl/sampling_ED2.sh -f examples/conditioning.psi -p 1
```

Usage:
```
./psi2webppl/sampling_ED2.sh -f <PSI file to translate and analyze> -p <index of parameter to analyze>
```

To analyze the first parameter in file `examples/conditioning.psi`, it generates the following WebPPL program:

```
//Total        4 parameters
//Sampling ED2 for parameter 2
//========WebPPL Code for conditioning_ED2_eps2.wppl========
var main_acc = function(){
globalStore.A = flip(0.5)
globalStore.B = flip(0.5)
globalStore.C = flip(0.5)
globalStore.D = globalStore.A + globalStore.B + globalStore.C
condition(globalStore.D >= 2)
return globalStore.A;
}

var main_eps = function(){
var main_in = function(){
globalStore.A = flip(0.5)
globalStore.B = flip(0.5 + globalStore.eps)
globalStore.C = flip(0.5)
globalStore.D = globalStore.A + globalStore.B + globalStore.C
condition(globalStore.D >= 2)
return globalStore.A;
}

return main_in();
}

var abs = function(v){return v>0?v:-v}
var main = function(){
return abs(main_acc() - main_eps());
}
map(function(eps){globalStore.eps=eps; return expectation(Infer({method: 'MCMC', samples: 1000},main))},[-0.05,-0.03888888888888889,-0.02777777777777778,-0.01666666666666667,-0.005555555555555557,0.005555555555555557,0.016666666666666663,0.027777777777777776,0.03888888888888889,0.05])
```

Run the code above in WebPPL and get the results:
```
[0.40508,0.38377,0.38731,0.38505,0.38397,0.38326,0.37403,0.37085,0.4528,0.45441]
```

With sampling inference, we need to give concrete value to the variable eps. Here PSense chooses 10 values uniformly from negative 10% of the original value to positive 10% of the original value, i.e., $eps\in[-0.05,0.05]$. PSense also ensures the value of eps is within a legal range. For example, in statement flip(0.95), it will choose values for eps in the range $[-0.095, 0.05]$.

The sampling based sensitivity analysis is not so accurate. 

One can also apply other metrics, e.g. Expectation Distance 1, on the samples generated from WebPPL. To do so, first run the translated code in WebPPL(using `java -jar psi2webppl/psi2webppl.jar <PSI file to translate>`), and save the samples. Then modified the parame by adding a small perturbation to the parameters, and run the program again to save the samples. Then one can use different metrics to calculate the distance between the two copies of samples.




<!---First run PSense with the `-log` option. Notice that PSense will keep the all source code used to 
```{shell}
psense -f examples/conditioning.psi -m ExpDist2 -log
Then translate the code to find approximate Expectation Distance 2 with WebPPL:
```
-->



