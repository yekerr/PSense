
## Dependencies

Install the following softwares on your machine:
```
PSI
Python 3.6
Mathematica 11
```

* [PSI](http://psisolver.org) is an exact probabilistic inference system. You can find the instruction of PSI [here](https://github.com/eth-srl/psi).
* To install PSI, you can run the following at your shell prompt:

```{shell}
git clone https://github.com/eth-srl/psi.git
cd psi
chmod +x dependencies.sh
./dependencies.sh && ./build.sh
cd ..
```

## Downloading PSense

You can install PSense by running the following:
```{shell}
git clone https://github.com/yekerr/PSense.git
cd PSense
```


## Configuring PSense

Add the directory containing `MathematicaScript` to your system `PATH` with:
```{shell}
./add_mathscript.sh
cd ..
```

Add the directory containing `psi` with: 
```{shell}
cd psi #if you named the directory containing psi differently, replace 'psi' with your path to psi
export PATH=$PATH:`pwd`
```

## Running PSense

Run the following commend to analyze the probabilistic program `coins.psi`:
```{shell}
psense -f examples/coins.psi
```

Detailed options can be found in the [Manual](manual.html).

***
[Return to Homepage](index.html)
