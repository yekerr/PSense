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

def get_newname(function_pre):
    num = len(function_pre.split(','))
    newname = ''
    function_name = function_pre.split('[')[0] + '['
    for i in range(num):
        if i == 0: 
            function_name += 'r' + str(i+1)
        else:
            function_name += ',r'+str(i+1)
    return function_name + ']'

def get_math_exp(f_name, f_eps_name, f_num_param):
    condition = '(-1<eps<1'
    var = ''
    for i in range(1, f_num_param + 1):
        condition += ' && (r' + str(i) + '==0' + ' || ' + 'r' + str(i) + '==1)'
        if i == 1:
            var += '{r' + str(i)
        else:
            var += ', r' + str(i)
    condition += ')'
    var += ', eps}'
    exp = '{Abs[' + f_name + '-' + f_eps_name + '],' + condition +'}'
    result = 'Print[Maximize[' + exp + ', '+ var + ']]'
    return result

def run_file(file, output_file):
    psi_file = file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file)

    psi_eps_dir = psi_file_dir + '_eps'
    math_dir = psi_file_dir + '_math'

    psi_eps_file_basename = ''.join(psi_file_name.split('.')[:-1]) + '_eps'
    math_file_basename = ''.join(psi_file_name.split('.')[:-1]) + '_math'    
    

    psi_out = sp.run(['psi', psi_file, '--cdf', '--mathematica'], stdout=sp.PIPE)
    psi_out = parse_psi_output(psi_out.stdout.decode('utf-8'))
    founction_newname = get_newname(psi_out.split(':=')[0].strip())
    founction_num_param = len(founction_newname.split(','))

    parse_dis = re.compile(r'bernoulli\((.+?)\)')
    def replace(nth):
        count = 0
        def replace_counter(match):
            nonlocal count
            count += 1
            if count == nth:
                return r'bernoulli('+ match.group(1) +'+?eps)'
            else:
                return r'bernoulli('+ match.group(1) +')'
        return replace_counter

    codes_eps = []
    with open(psi_file, 'r') as f:
        codes = f.read()
        num_eps = len(parse_dis.findall(codes))
        for i in range(1, num_eps + 1):
            codes_eps.append(parse_dis.sub(replace(nth=i), codes))
    

    create_dirs_from_path(psi_eps_dir)
    create_dirs_from_path(math_dir)
    for i in range(num_eps):
        psi_eps_file = os.path.join(psi_eps_dir, psi_eps_file_basename + str(i+1) + '.psi')
        math_file = os.path.join(math_dir, math_file_basename + str(i+1) + '.txt')
        
        with open(psi_eps_file, 'w') as f:
            f.write(codes_eps[i])

        psi_eps_out = sp.run(['psi', psi_eps_file, '--cdf', '--mathematica'], stdout=sp.PIPE)
        psi_eps_out = parse_psi_output(psi_eps_out.stdout.decode('utf-8'))
        psi_eps_out = psi_eps_out.split(':=')
        founction_eps_pre = 'Eps['.join(psi_eps_out[0].split('['))
        psi_eps_out = founction_eps_pre + ':=' + psi_eps_out[-1]
        founction_eps_newname = get_newname(founction_eps_pre.strip())

        
        with open(math_file, 'w') as f:
            f.write(psi_out + '\n')
            f.write(psi_eps_out + '\n')
            math_max = get_math_exp(founction_newname, founction_eps_newname, founction_num_param)
            f.write(math_max + '\n')

        math_out = sp.run(['MathematicaScript', '-script', math_file], stdout=sp.PIPE)
        math_out = math_out.stdout.decode('utf-8').strip()

        if output_file:
            create_dirs_from_file(output_file)
            with open(output_file, "a") as f:
                f.write('Changed parameter' + str(i+1) + ':' + math_out + '\n')
        else:
            print('Changed parameter', i+1, ':', math_out)

def main():
    parser = argparse.ArgumentParser(description='PSI Epsilon Generator')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-f', help='PSI file')
    group.add_argument('-r', help='Directory containing PSI files')
    parser.add_argument('-o', nargs='?', help='Optional output file')
    argv = parser.parse_args(sys.argv[1:])
    if argv.f and not os.path.isfile(argv.f):
        print('PSI file doesn\'t exist')
        return 0
    if argv.r and not os.path.isdir(argv.r):
        print('Directory doesn\'t exist')
        return 0

    output_file = argv.o
    if output_file and os.path.exists(output_file):
        os.remove(output_file)

    if argv.f:
        run_file(argv.f, output_file)
    else:
        for filename in os.listdir(argv.r):
            if filename.endswith(".psi"):
                file = os.path.join(argv.r, filename)
                if output_file:
                    with open(output_file, "a") as f:
                        f.write('\n' + file + ':\n')
                else:
                    print('\n' + file + ':')
                run_file(file, output_file)

if __name__ == "__main__":
    main()
