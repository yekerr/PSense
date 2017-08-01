import numpy as np
import numpy.polynomial.chebyshev as chebyshev
from scipy import special

def cheb_nodes(a, b, n):
    return [1/2*(a+b)+1/2*(b-a)*np.cos((2*k-1)/(2*n)*np.pi) for k in range(1, n+1)]

def format_poly(coef):
    res = ''
    for i in range(len(coef)):
        if i == 0:
            res += str(coef[0])
        elif  i == 1:
            res += '+' + str(coef[i]) + '*x'
        else:
            res += '+' + str(coef[i]) + '*x^' + str(i)
    return res
x = cheb_nodes(-4, 4, 1000)
y = special.erf(x)
print(x[0],x[-1])
print(y)
y[0] = 1
y[-1] = -1
cheb_coef = chebyshev.chebfit(x, y, 10)
coef = np.polynomial.chebyshev.cheb2poly(cheb_coef)
poly = np.polynomial.Polynomial(coef)
print(format_poly(coef))