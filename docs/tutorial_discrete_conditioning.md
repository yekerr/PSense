{% include head.html %}
## Tutorial 1: Modeling Conditional Distribution

### Build Models in PSI

[PSI](http://psisolver.org) is a solver that does exact probabilistic inference. Here is a conditional probabilistic distribution modeled with the source language of PSI.
```{d}
def main(){
    A:=flip(0.5);
    B:=flip(0.5);
    C:=flip(0.5);
    D:=A+B+C;
    observe(D>=2);
    return A;
}
```
Here is what the program does:
  
* The first three lines in the main function simulate the process of tossing three coins (encoded as `1` for head and `0` for tail).
```{d}
A:=flip(0.5);
B:=flip(0.5);
C:=flip(0.5);
```
    `flip(0.5)` samples from a Bernoulli distribution with 0.5 probability to be `1` or `0`. `A`, `B`, and `C` are three independent samples each with the prior distribution of `flip(0.5)`. Currently the parameter `0.5` is a constant value; different values of the parameter will give different distributions.
* Adding the sampled numbers from the Bernoulli distribution:
```{d}
D:=A+B+C;
```
* Suppose we have observed the sum `D` is greater or equal to 2 (which means at least two coints are heads), we can add the condition as:
```{d}
observe(D>=2);
```
* Under the condition that at least two heads are observed, we want to know what is the posterior distribution of `A`, so:
```{d}
return A;
```

* The result given by PSI in Wolfram Language should be:
```
p[A_] := (1/2*Boole[-A+1<=0]+1/4*Boole[-A+2<=0]+1/4*Boole[-A<=0])*(DiracDelta[-A+1]+DiracDelta[A])
```
which is the probability density function of the posterior distribution of `A`.

The code snippet can be found [here](https://github.com/yekerr/PSense/blob/master/examples/conditioning.psi).



### Find Sensitivity 

#### *Sensitivity* Definition

The result of probabilistic inference depends on the distribution parameters. In our example above, the prior `flip(0.5)`(Bernoulli distribution with $p = 0.5$) depends on the constant parameter `0.5`. 
We are interested in the question: what happens to the distribution output if we perturb the parameter of the prior distibution?
Notice that our example has 3 constant parameters:
```{d}
A:=flip(0.5);
B:=flip(0.5);
C:=flip(0.5);
```
To estimate the change in the output distribution, we can add disturbance `?eps` to each of our prior `flip(0.5)`. Conceptually, we may have:
```{d}
A:=flip(0.5+?eps);
B:=flip(0.5);      //Or, B:=flip(0.5+?eps2);
C:=flip(0.5);      //    C:=flip(0.5+?eps3);
```

#### PSense for Sensitivity Analysis
To automatically find the sensitivity of this probabilistic program, run the following in shell prompt:
```{shell}
psense -f examples/conditioning.psi
```
PSense changes each parameter and gets the results for different metrics:

* Expectation Distance
    
    It is defined as $D_{Exp}=|\mathbb{E}[p_{eps}(r)]-\mathbb{E}[p(r)]|$, where
$\mathbb{E}[p_{eps}(r)]$ and $\mathbb{E}[p(r)]$ are expectations of the output distributions with and without disturbance. After changing the first parameter, PSense genterates the symbolic expression for Expectation Distance as:
```
┌Analyzed parameter 1──────────────────────────────────────────┐
│            │ Expectation Distance                            │
├────────────┼─────────────────────────────────────────────────┤
│ Expression │ (3*Abs[eps])/(4*(1 + eps))                      │
└────────────┴─────────────────────────────────────────────────┘
```
PSense finds the maximum value of the Expectation Distance with respect to the disturbance `eps` within $\pm 10\%$ of the original parameter: 
```
┌Analyzed parameter 1──────────────────────────────────────────┐
│            │ Expectation Distance                            │
├────────────┼─────────────────────────────────────────────────┤
│ ...        │ ...                                             │
│ Maximum    │ 0.0394736842105 eps -> -0.0500000000000 r1 -> 0 │
└────────────┴─────────────────────────────────────────────────┘
```
The result above shows that the maximum value `0.0395` is obtained when `eps` $= -0.05$.
PSense further analyzes whether the distance grows linearly when the disturbance |`eps`| increases:
```
┌Analyzed parameter 1──────────────────────────────────────────┐
│            │ Expectation Distance                            │
├────────────┼─────────────────────────────────────────────────┤
│ ...        │ ...                                             │
│ Linear     │ False                                           │
└────────────┴─────────────────────────────────────────────────┘
```
In this example the Expectation Distance does not grow linearly so PSense outputs `False`.

* Kolmogorov–Smirnov Statistic

    It is defined as $D_{KS}=\sup_{r\in support}|p_{eps}(r)-p(r)|$, where p_{eps}(r) and p(r) are cumulative density functions, and $\sup_{r\in support}$ represents the supremum of the distance over the support of $r$. PSense gives the distance $|p_{eps}(r)-p(r)|$ and the maximum value of $D_{KS}$, and then analyzes the linearity of $D_{KS}$.
```
┌Analyzed parameter 1───────────────────────────────────────────┐
│            │ KS Distance                                      │
├────────────┼──────────────────────────────────────────────────┤
│ Expression │ (3*Abs[(eps*(-1 + Boole[r1 >= 1]))/(1 + eps)])/4 │
│ Maximum    │ 0.0394736842105 eps -> -0.0500000000000 r1 -> 0  │
│ Linear     │ False                                            │
└────────────┴──────────────────────────────────────────────────┘
```

* Total Variation Distance
    
    It is defined as $D_{TVD}=\frac{1}{2}\Sigma_{r\in support}|p_{eps}(r)-p(r)|$ for discrete distributions and $D_{TVD}=\frac{1}{2}\int_{r\in support}|p_{eps}(r)-p(r)|$ for continuous ones. PSense outputs:
```
Discrete
┌Analyzed parameter 1──────────────────────────────────────────┐
│            │ TVD                                             │
├────────────┼─────────────────────────────────────────────────┤
│ Expression │ (3*Abs[eps/(1 + eps)])/8                        │
│ Maximum    │ 0.0197368421053 eps -> -0.0500000000000 r1 -> 0 │
│ Linear     │ False                                           │
└────────────┴─────────────────────────────────────────────────┘
```

* Kullback–Leibler Divergence
    
    Defined as 
    $D_{KL}=\Sigma_{r\in support} p_{eps}(r) \log \frac{p_{eps}(r)}{p(r)}$ for discrete distributions and $D_{KL}=\int_{r\in support} p_{eps}(r) \log \frac{p_{eps}(r)}{p(r)}$ for continuous ones.  For this example, it outputs:
```
┌Analyzed parameter 1──────────────────────────────────────────┐
│            │ KL                                              │
├────────────┼─────────────────────────────────────────────────┤
│ Expression │ ((1 - 2*eps)*Log[-2 + 3/(1 + eps)])/(4*(1 +     │
│            │ eps)*Log[2])                                    │
│ Maximum    │ 0.0612248725508 eps -> -0.0499999999962 r1 -> 0 │
│ Linear     │ False                                           │
└────────────┴─────────────────────────────────────────────────┘
```
    
***
[Return to Tutorials](tutorial.html)