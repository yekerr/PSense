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

def create_psi_expectation():
    pass

def create_psi_epsilon(psi_file):
    bernoulli = r'(bernoulli\((?P<bernoulli>.+?)\))'
    gauss = r'(gauss\((?P<gauss1>.+?),(?P<gauss2>.+?)\))'
    parse_dis = re.compile(bernoulli + r'|' + gauss)
    def replace(nth):
        count = 0
        def check_eps():
            nonlocal count
            count += 1
            return '+?eps' if count == nth else ''
        def replace_counter(match):
            if match.group('bernoulli'):
                result = 'bernoulli(' + match.group('bernoulli') + check_eps()
            elif match.group('gauss1'):
                result = 'gauss(' + match.group('gauss1') + check_eps() + ',' + match.group('gauss2') + check_eps()
            result += ')'
            return result
        return replace_counter
    
    def get_num_eps(matches):
        extra = 0
        for match in matches:
            for group in match:
                if group.startswith('gauss'):
                    extra += 1
                    break
        return len(matches) + extra

    codes_eps = []
    with open(psi_file, 'r') as f:
        code = f.read()
        num_eps = get_num_eps(parse_dis.findall(code))
        for i in range(1, num_eps + 1):
            codes_eps.append(parse_dis.sub(replace(nth=i), code))
    return codes_eps

def name_extend_file(base_dir, base_name, extend_name, extension, n):
    extend_dir = base_dir + extend_name
    extend_file_basename = ''.join(base_name.split('.')[:-1]) + extend_name
    create_dirs_from_path(extend_dir)
    extend_files = []
    for i in range(n):
        extend_files.append(os.path.join(extend_dir, extend_file_basename + str(i+1) + '.' + extension))
    return extend_files

def store_files_to_disk(files, codes):
    for i in range(len(codes)):
        with open(files[i], 'w') as f:
            f.write(codes[i])

def run_file(file, output_file):
    working_dir = os.getcwd()

    psi_file = file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file) 

    psi_out = sp.run(['psi', psi_file, '--cdf', '--mathematica'], stdout=sp.PIPE)
    psi_out = parse_psi_output(psi_out.stdout.decode('utf-8'))
    founction_newname = get_newname(psi_out.split(':=')[0].strip())
    founction_num_param = len(founction_newname.split(','))
    
    codes_eps = create_psi_epsilon(psi_file)
    
    psi_eps_files = name_extend_file(psi_file_dir, psi_file_name, '_eps', 'psi', len(codes_eps))
    math_files = name_extend_file(psi_file_dir, psi_file_name, '_eps', 'm', len(codes_eps))
    store_files_to_disk(psi_eps_files, codes_eps)

    for i in range(len(psi_eps_files)):

        psi_eps_out = sp.run(['psi', psi_eps_files[i], '--cdf', '--mathematica'], stdout=sp.PIPE)
        psi_eps_out = parse_psi_output(psi_eps_out.stdout.decode('utf-8'))
        psi_eps_out = psi_eps_out.split(':=')
        founction_eps_pre = 'Eps['.join(psi_eps_out[0].split('['))
        psi_eps_out = founction_eps_pre + ':=' + psi_eps_out[-1]
        founction_eps_newname = get_newname(founction_eps_pre.strip())

        
        with open(math_files[i], 'w') as f:
            f.write(psi_out + '\n')
            f.write(psi_eps_out + '\n')
            math_max = get_math_exp(founction_newname, founction_eps_newname, founction_num_param)
            f.write(math_max + '\n')

        math_out = sp.run(['MathematicaScript', '-script', math_files[i]], stdout=sp.PIPE)
        math_out = math_out.stdout.decode('utf-8').strip()

        if output_file:
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
    if output_file:
        if os.path.exists(output_file):
            os.remove(output_file)
        else:
            create_dirs_from_path(os.path.dirname(output_file))
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
