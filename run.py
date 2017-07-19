import os, sys
import subprocess as sp
import re
import argparse

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

def create_dirs_from_file(file):
    file_dir = os.path.dirname(file)
    if file_dir and not os.path.exists(file_dir):
        try:
            os.makedirs(os.path.dirname(file))
        except :
            raise

def create_dirs_from_path(path):
    if path and not os.path.exists(path):
        try:
            os.makedirs(path)
        except:
            raise

def main():
    parser = argparse.ArgumentParser(description='PSI Epsilon Generator')
    parser.add_argument('-f', required=True, help='PSI file')
    parser.add_argument('-o', nargs='?', help='Optional output file')
    argv = parser.parse_args(sys.argv[1:])
    if not os.path.exists(argv.f):
        print('PSI file doesn\'t exist')
        return 0
    output_file = argv.o
    psi_file = argv.f
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file)

    psi_eps_file_dir = psi_file_dir + 'eps'
    psi_eps_file_name = ''.join(psi_file_name.split('.')[:-1]) + '_eps.psi'
    psi_eps_file = psi_eps_file_dir + '/' + psi_eps_file_name

    math_file_dir = psi_file_dir + '_math'
    math_file_name = ''.join(psi_file_name.split('.')[:-1]) + '_math.m'    
    math_file = math_file_dir + '/' + math_file_name

    # print(psi_file, psi_file_name, psi_file_dir)
    # print(psi_eps_file, psi_eps_file_name, psi_eps_file_dir)

    psi_out = sp.run(['psi', psi_file, '--cdf', '--mathematica'], stdout=sp.PIPE)
    psi_out = parse_psi_output(psi_out.stdout.decode('utf-8'))
    founction_pre = psi_out.split(':=')[0].strip().replace('_', '')

    with open(psi_file, 'r') as f:
        codes = f.read()
        codes = re.sub(re.compile(r'bernoulli\((.+)\)') , 'bernoulli('+r'\g<1>' +'+?eps)', codes)
    create_dirs_from_path(psi_eps_file_dir)
    with open(psi_eps_file, 'w') as f:
        f.write(codes)

    psi_eps_out = sp.run(['psi', psi_eps_file, '--cdf', '--mathematica'], stdout=sp.PIPE)
    psi_eps_out = parse_psi_output(psi_eps_out.stdout.decode('utf-8'))
    psi_eps_out = psi_eps_out.split(':=')
    founction_eps_pre = 'Eps['.join(psi_eps_out[0].split('['))
    psi_eps_out = founction_eps_pre + ':=' + psi_eps_out[-1]
    founction_eps_pre = founction_eps_pre.strip().replace('_', '')

    create_dirs_from_path(math_file_dir)
    with open(math_file, 'w') as f:
        f.write(psi_out + '\n')
        f.write(psi_eps_out + '\n')
        math_max = 'Print[Maximize[{Abs[' + founction_pre + '-' + founction_eps_pre + '], (-1<eps<1 && (x==0 || x==1))}, {x, eps}]]'
        f.write(math_max + '\n')

    math_out = sp.run(['MathematicaScript', '-script', math_file], stdout=sp.PIPE)
    math_out = math_out.stdout.decode('utf-8').strip()

    if output_file:
        create_dirs_from_file(output_file)
        with open(output_file, "w") as f:
            f.write(math_out)
    else:
        print('psi_out', psi_out)
        print('psi_eps_out', psi_eps_out)
        print('max_out', math_out)

if __name__ == "__main__":
    main()
