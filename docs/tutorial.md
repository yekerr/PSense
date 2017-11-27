#### Build Models in PSI

[PSI](http://psisolver.org) is a solver that does exact probabilistic inference. Here is a bernoulli distibution modeled in the source language of PSI.

```d
def main(){
        x := bernoulli(0.1);
        return x;
}
```

The code snippet can be found [here](https://github.com/yekerr/PSense/blob/master/bernoulli_example1.psi).

#### Find Sensitivity of the Probabilistic Program with PSense

To find the sensitivity of this probabilistic program, run `python3 run.py -f bernoulli_example1.psi` in terminal.
You'll the following outputs:

```
Function Type:
Discrete

Start All Metrics:
edistance
Abs[1/10 + (-1 - 10*eps)/10]
edistanceMax
{0.010000000000000002, {eps -> 0.010000000000000002, r1 -> 6.4624724516972485}}

distance
Abs[eps - eps*Boole[r1 >= 1]]

tvd
Abs[eps]/2
tvdMax
{0.005000000000000001, {eps -> -0.010000000000000002, r1 -> 0}}

kl
((9 - 10*eps)*Log[1 - (10*eps)/9])/(2*Log[1024])
klMax
{0.007253402460404782, {eps -> -0.010000000000000002, r1 -> 0}}
```