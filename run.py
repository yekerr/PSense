import subprocess as sp
import re

def parse_psi_output(output):
    output = output.split('\n')
    result = ''
    for valid_output in output:
        if valid_output:
            if valid_output[0] == 'p':
                result = valid_output.strip()
                break;
    else:
        print('error')
    return result

psi_out = sp.run(['psi', 'ch02/flip.psi', '--cdf', '--mathematica'], stdout=sp.PIPE)
psi_out = parse_psi_output(psi_out.stdout.decode('utf-8'))
cdf = psi_out.split(':=')[1]


with open('ch02/flip.psi', 'r') as infile:
    codes = infile.read()
    codes = re.sub(re.compile(r'bernoulli(.+);') , 'bernoulli('+r'\g<1>' +'+?eps)', codes)
with open('ch02_eps/flip_eps1.psi', 'w') as outfile:
    outfile.write(codes)


psi_eps_out = sp.run(['psi', 'ch02/flip_eps1.psi', '--cdf', '--mathematica'], stdout=sp.PIPE)
psi_eps_out = parse_psi_output(psi_eps_out.stdout.decode('utf-8'))
cdf_eps = psi_eps_out.split(':=')[1]

math_in = 'Maximize[{Abs[' + cdf + '-' + cdf_eps + '], (-1<eps<1 && (x==0 || x==1))}, {x, eps}]'

math_out = sp.run(['wolframscript', '-code', math_in], stdout=sp.PIPE)
math_out = math_out.stdout.decode('utf-8').strip()


print('psi_out', psi_out)
print('psi_eps_out', psi_eps_out)
print('max_out', math_out)
