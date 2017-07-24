import os, sys
import subprocess as sp
import re
import argparse

def parse_psi_output(output, output_file):
    result = ''
    for valid_output in output.split('\n'):
        if valid_output:
            if valid_output[0] == 'p':
                result = valid_output.strip()
                break;
    else:
        if output_file:
            with open(output_file, "a") as f:
                f.write('Error in parsing PSI output: ' + result + '\n')
        else:
            print('Error in parsing PSI output: ' + result)
    return result

def create_dirs_from_path(path):
    if path and not os.path.exists(path):
        try:
            os.makedirs(path)
        except:
            raise

def rename_func(function_pre):
    num = len(function_pre.split(','))
    newname = ''
    function_name = function_pre.split('[')[0] + '['
    for i in range(num):
        if i == 0: 
            function_name += 'r' + str(i+1)
        else:
            function_name += ',r'+str(i+1)
    return function_name + ']'

def generate_math_exp(f_name, f_eps_name, f_exp_name, f_exp_eps_name, f_num_param):
    var_minmax = '{'
    condition = ''
    for i in range(1, f_num_param + 1):
        if i == f_num_param:
            var_minmax += '{r' + str(i) + ', 0, 1}'
            condition += '(r' + str(i) + '== 0' + ' || ' + 'r' + str(i) + '== 1)'
        else:
            var_minmax += '{r' + str(i) + ', 0, 1}, '
            condition += ' (r' + str(i) + '== 0' + ' || ' + 'r' + str(i) + '== 1) && '
    var_minmax += '}'
    if f_exp_name and f_exp_eps_name:
        exp = ','.join([f_name, f_eps_name, f_exp_name, f_exp_eps_name, var_minmax, '(-0.1<=eps<=0.1)', condition])
    else:
        exp = ','.join([f_name, f_eps_name, ' ', ' ', var_minmax, '(-0.1<=eps<=0.1)', condition])
    runall = 'runall[' + exp + ']'
    return runall

def generate_psi_expectation(psi_file):
    supported = True
    def replace(match):
        nonlocal supported
        if match.group('result').strip().startswith('('):
            supported = False
        result = 'main' + match.group('code') + 'return Expectation(' + match.group('result').strip() + ');'
        return result

    parse_psi = re.compile(r'main(?P<code>.+?)return(?P<result>.+?);', re.S)

    with open(psi_file, 'r') as f:
        code = f.read()
        code_exp = parse_psi.sub(replace, code)
    return code_exp if supported else None
    
def generate_psi_epsilon(psi_file):
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

def extend_n_files_name(base_dir, base_name, extend_name, extension, n):
    extend_dir = base_dir + extend_name
    extend_file_basename = ''.join(base_name.split('.')[:-1]) + extend_name
    create_dirs_from_path(extend_dir)
    extend_files = []
    for i in range(n):
        extend_files.append(os.path.join(extend_dir, extend_file_basename + str(i+1) + '.' + extension))
    return extend_files

def extend_file_name(base_dir, base_name, extend_name, extension):
    extend_dir = base_dir + extend_name
    extend_file_basename = ''.join(base_name.split('.')[:-1]) + extend_name
    create_dirs_from_path(extend_dir)
    file = os.path.join(extend_dir, extend_file_basename + '.' + extension)
    return file

def store_codes_to_files(codes, files):
    for i in range(len(codes)):
        with open(files[i], 'w') as f:
            f.write(codes[i])

def run_psi(file, output_file, option):
    if option:
        psi_out = sp.run(['psi', file, option, '--mathematica'], stdout=sp.PIPE)
    else:
        psi_out = sp.run(['psi', file, '--mathematica'], stdout=sp.PIPE)    
    return parse_psi_output(psi_out.stdout.decode('utf-8'), output_file)

def run_math(file):
    math_out = sp.run(['MathematicaScript', '-script', file], stdout=sp.PIPE)
    return math_out.stdout.decode('utf-8').strip()

def rename_psi_out(exp, extend_name):
    parts = exp.split(':=')
    newname = parts[0].replace('[', extend_name + '[')
    return newname + ':=' + parts[-1]

def run_file(file, output_file):
    psi_file = file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file) 


    psi_out = run_psi(psi_file, output_file, '--cdf')
    psi_func_name = rename_func(psi_out.split(':=')[0].strip())
    psi_func_num_param = len(psi_func_name.split(','))

    codes_eps = generate_psi_epsilon(psi_file)
    psi_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, '_eps', 'psi', len(codes_eps))
    math_files = extend_n_files_name(psi_file_dir, psi_file_name, '_math', 'm', len(codes_eps))
    store_codes_to_files(codes_eps, psi_eps_files)

    code_exp = generate_psi_expectation(psi_file)

    if code_exp:
        psi_exp_file = extend_file_name(psi_file_dir, psi_file_name, '_exp', 'psi')    
        store_codes_to_files([code_exp],[psi_exp_file])
        psi_exp_out = run_psi(psi_exp_file, output_file, '')
        psi_exp_out = rename_psi_out(psi_exp_out, 'Exp')
        psi_exp_func_name = rename_func(psi_exp_out.split(':=')[0].strip())

        codes_exp_eps = generate_psi_epsilon(psi_exp_file)
        psi_exp_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, '_exp_eps', 'psi', len(codes_exp_eps))
        store_codes_to_files(codes_exp_eps, psi_exp_eps_files)
    elif output_file:
        with open(output_file, "a") as f:
            f.write('Expectation is not supported' + '\n')
    else:
        print('Expectation is not supported')

    for i in range(len(psi_eps_files)):

        psi_eps_out = run_psi(psi_eps_files[i], output_file, '--cdf')
        psi_eps_out = rename_psi_out(psi_eps_out, 'Eps')
        psi_eps_func_name = rename_func(psi_eps_out.split(':=')[0].strip())

        if code_exp:
            psi_exp_eps_out = run_psi(psi_exp_eps_files[i], output_file, '')
            psi_exp_eps_out = rename_psi_out(psi_exp_eps_out, 'ExpEps')
            psi_exp_eps_func_name = rename_func(psi_exp_eps_out.split(':=')[0].strip())
        
        with open(math_files[i], 'w') as f:
            base_file = os.path.join(os.getcwd(), 'mathematica', 'base_runall.m')
            f.write('Get[\"' + base_file + '\"]\n')
            f.write(psi_out + '\n')
            f.write(psi_eps_out + '\n')
            if code_exp:
                f.write(psi_exp_out + '\n')
                f.write(psi_exp_eps_out + '\n')
                math_run = generate_math_exp(psi_func_name, psi_eps_func_name, psi_exp_func_name, psi_exp_eps_func_name, psi_func_num_param)
            else:
                math_run = generate_math_exp(psi_func_name, psi_eps_func_name, '1', '1', psi_func_num_param)
            f.write(math_run + '\n')

        math_out = run_math(math_files[i])
        if output_file:
            with open(output_file, "a") as f:
                f.write('Changed parameter' + str(i+1) + ':\n' + math_out + '\n')
        else:
            print('Changed parameter', i+1, ':\n', math_out)

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
