import os, sys
import subprocess as sp
import re
import argparse

def parse_psi_output(output):
    result = ''
    for valid_output in output.split('\n'):
        if valid_output:
            if valid_output[0] == 'p':
                result = valid_output.strip()
                break;
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
    function_name = function_pre.split('[')[0] + '['
    for i in range(num):
        if i == 0: 
            function_name += 'r' + str(i+1)
        else:
            function_name += ',r'+str(i+1)
    return function_name + ']'

def generate_math_exp(file, f_name, f_pdf_name, f_eps_name, f_exp_name, f_exp_eps_name, f_num_param, f_eps_param, explict_eps, metrics):
    file = '\"' + file + '\"'
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
    try:
        eps_param = float(f_eps_param['value'])*0.1
        eps_range = '(' + f'{-eps_param:.16f}' + '<=eps<=' + f'{eps_param:.16f}' + ')'
    except ValueError:
         eps_range = '(-0.1<=eps<=0.1)'
    if not f_exp_name or not f_exp_eps_name:
        f_exp_name = "Null"
        f_exp_eps_name = "Null"
    flag_eps = "True" if explict_eps else "False"
    flag_metrics = [str(v) for v in metrics]
    modules_dir = "\"" + os.path.join(os.path.dirname(os.path.realpath(__file__)), 'modules') + "\""
    exp = ','.join([modules_dir, f_name, f_pdf_name, f_eps_name, flag_eps, *flag_metrics, f_exp_name, f_exp_eps_name, var_minmax, eps_range, condition, file])
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
    
def generate_psi_epsilon(psi_file, explict_eps):
    distribution_1p = {}
    distribution_1p['flip'] = r'(flip\s*\((?P<flip>.+?)\))'
    distribution_1p['bernoulli'] = r'(bernoulli\s*\((?P<bernoulli>.+?)\))'
    distribution_1p['geometric'] = r'(geometric\s*\((?P<geometric>.+?)\))'
    distribution_1p['poisson'] = r'(poisson\s*\((?P<poisson>.+?)\))'
    # distribution_1p['categorical'] = r'(categorical\((?P<categorical>.+?)\))'
    distribution_1p['exponential'] = r'(exponential\s*\((?P<exponential>.+?)\))'
    distribution_1p['studentT'] = r'(studentT\s*\((?P<studentT>.+?)\))'
    distribution_1p['rayleigh'] = r'(rayleigh\s*\((?P<rayleigh>.+?)\))'

    distribution_2p = {}
    distribution_2p['gauss'] = r'(gauss\s*\((?P<gauss1>.+?),(?P<gauss2>.+?)\))'
    distribution_2p['uniform'] = r'(uniform\s*\((?P<uniform1>.+?),(?P<uniform2>.+?)\))'
    distribution_2p['uniformInt'] = r'(uniformInt\s*\((?P<uniformInt1>.+?),(?P<uniformInt2>.+?)\))'
    distribution_2p['beta'] = r'(beta\s*\((?P<beta1>.+?),(?P<beta2>.+?)\))'
    distribution_2p['gamma'] = r'(gamma\s*\((?P<gamma1>.+?),(?P<gamma2>.+?)\))'
    distribution_2p['laplace'] = r'(laplace\s*\((?P<laplace1>.+?),(?P<laplace2>.+?)\))'
    distribution_2p['cauchy'] = r'(cauchy\s*\((?P<cauchy1>.+?),(?P<cauchy2>.+?)\))'
    distribution_2p['pareto'] = r'(pareto\s*\((?P<pareto1>.+?),(?P<pareto2>.+?)\))'
    distribution_2p['weibull'] = r'(weibull\s*\((?P<weibull1>.+?),(?P<weibull2>.+?)\))'
    distribution_2p['binomial'] = r'(binomial\s*\((?P<binomial1>.+?),(?P<binomial2>.+?)\))'
    distribution_2p['negBinomial'] = r'(negBinomial\s*\((?P<negBinomial1>.+?),(?P<negBinomial2>.+?)\))'
    
    reg = ''
    for dist in distribution_1p.values():
        reg += dist + r'|'
    for dist in distribution_2p.values():
        reg += dist + r'|'
    reg = reg.strip('|')
    parse_dis = re.compile(reg)
    codes_eps_params = []
    def replace(nth):
        count = 0
        def check_eps():
            nonlocal count
            count += 1
            if count == nth:
                if explict_eps:
                    rt =  "+"+explict_eps
                else:
                    rt = "+?eps"
            else:
                rt = ""
            return rt
        def replace_counter(match):
            for dist_name_1p in distribution_1p.keys():
                if match.group(dist_name_1p):
                    if nth == 1:
                        codes_eps_params.append({'type': dist_name_1p, 'value': match.group(dist_name_1p)})
                    result = dist_name_1p + '(' + match.group(dist_name_1p) + check_eps()
                    break
            else:
                for dist_name_2p in distribution_2p.keys():
                    if match.group(dist_name_2p + '1'):
                        if nth == 1:
                            codes_eps_params.extend([{'type': dist_name_2p, 'value': match.group(dist_name_2p+'1')}, {'type': dist_name_2p, 'value': match.group(dist_name_2p+'2')}])
                        result = dist_name_2p + '(' + match.group(dist_name_2p+'1') + check_eps() + ',' + match.group(dist_name_2p+'2') + check_eps()
            result += ')'
            return result
        return replace_counter
    
    def get_num_eps(matches):
        extra = 0
        for match in matches:
            for group in match:
                flag_2p = False
                for dist_name_2p in distribution_2p.keys():
                    if group.startswith(dist_name_2p):
                        extra += 1
                        flag_2p = True
                        break
                if flag_2p:
                    break
        return len(matches) + extra

    codes_eps = []
    with open(psi_file, 'r') as f:
        code = f.read()
        num_eps = get_num_eps(parse_dis.findall(code))
        for i in range(1, num_eps + 1):
            codes_eps.append(parse_dis.sub(replace(nth=i), code))
    return codes_eps, codes_eps_params

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

def run_psi(file, option, timeout, verbose):
    if timeout:
        timeout = int(timeout)
    cmd = ['psi', file, '--mathematica', option] if option else ['psi', file, '--mathematica']
    try:
        psi_out = sp.run(cmd, stdout=sp.PIPE, timeout=timeout)
    except sp.TimeoutExpired:
        return None
    if verbose:
        print(psi_out.stdout.decode('utf-8'))
    return parse_psi_output(psi_out.stdout.decode('utf-8'))

def run_math(file, timeout):
    if timeout:
        timeout = int(timeout)
    try:
        math_out = sp.run(['MathematicaScript', '-script', file], stdout=sp.PIPE, timeout=timeout)
    except sp.TimeoutExpired:
        return None
    return math_out.stdout.decode('utf-8').strip()

def check_psi_out(file, output_file, result):
    if not result:
        if output_file:
            with open(output_file, "a") as f:
                f.write('PSI runs out of time: ' + file + '\n')
        else:
            print('PSI runs out of time: ' + file)
        return False
    else:
        return True

def rename_psi_out(exp, extend_name):
    parts = exp.split(':=')
    newname = parts[0].replace('[', extend_name + '[')
    return newname + ':=' + parts[-1]

def run_file(file, output_file, explict_eps, metrics, psi_timeout, math_timeout, verbose):
    psi_file = file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file) 

    psi_out = run_psi(psi_file, "--cdf", psi_timeout, verbose)
    if not check_psi_out(psi_file, output_file, psi_out):
        return 1
    psi_func_name = rename_func(psi_out.split(':=')[0].strip())
    psi_func_num_param = len(psi_func_name.split(','))

    psi_pdf_out = run_psi(psi_file, None, psi_timeout, verbose)
    if not check_psi_out(psi_file, output_file, psi_pdf_out):
        return 1
    psi_pdf_out = rename_psi_out(psi_pdf_out, 'PDF')
    psi_pdf_func_name = rename_func(psi_pdf_out.split(':=')[0].strip())

    codes_eps, code_eps_params = generate_psi_epsilon(psi_file, explict_eps)
    psi_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, '_eps', 'psi', len(codes_eps))
    math_files = extend_n_files_name(psi_file_dir, psi_file_name, '_math', 'm', len(codes_eps))
    store_codes_to_files(codes_eps, psi_eps_files)

    math_output_files = extend_n_files_name(psi_file_dir, psi_file_name, '_math_out', 'csv', len(codes_eps))

    code_exp = generate_psi_expectation(psi_file)

    if code_exp:
        psi_exp_file = extend_file_name(psi_file_dir, psi_file_name, '_exp', 'psi')    
        store_codes_to_files([code_exp],[psi_exp_file])
        psi_exp_out = run_psi(psi_exp_file, None, psi_timeout, verbose)
        if not check_psi_out(psi_exp_file, output_file, psi_exp_out):
            return 1
        psi_exp_out = rename_psi_out(psi_exp_out, 'Exp')
        psi_exp_func_name = rename_func(psi_exp_out.split(':=')[0].strip())

        codes_exp_eps, _ = generate_psi_epsilon(psi_exp_file, explict_eps)
        psi_exp_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, '_exp_eps', 'psi', len(codes_exp_eps))
        store_codes_to_files(codes_exp_eps, psi_exp_eps_files)
    elif output_file:
        with open(output_file, "a") as f:
            f.write('Expectation is not supported' + '\n')
    else:
        print('Expectation is not supported')

    for i in range(len(psi_eps_files)):
        psi_eps_out = run_psi(psi_eps_files[i], "--cdf", psi_timeout, verbose)
        if not check_psi_out(psi_eps_files[i], output_file, psi_eps_out):
            continue
        psi_eps_out = rename_psi_out(psi_eps_out, 'Eps')
        psi_eps_func_name = rename_func(psi_eps_out.split(':=')[0].strip())

        if code_exp:
            psi_exp_eps_out = run_psi(psi_exp_eps_files[i], None, psi_timeout, verbose)
            if not check_psi_out(psi_exp_eps_files[i], output_file, psi_exp_eps_out):
                continue
            psi_exp_eps_out = rename_psi_out(psi_exp_eps_out, 'ExpEps')
            psi_exp_eps_func_name = rename_func(psi_exp_eps_out.split(':=')[0].strip())
        
        with open(math_files[i], 'w') as f:
            base_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'modules', 'base_runall_support.m')
            f.write('Get[\"' + base_file + '\"]\n')
            f.write(psi_out + '\n')
            f.write(psi_pdf_out + '\n')
            f.write(psi_eps_out + '\n')
            if code_exp:
                f.write(psi_exp_out + '\n')
                f.write(psi_exp_eps_out + '\n')
                math_run = generate_math_exp(math_output_files[i], psi_func_name, psi_pdf_func_name, psi_eps_func_name, psi_exp_func_name, psi_exp_eps_func_name, psi_func_num_param, code_eps_params[i], explict_eps, metrics)
            else:
                math_run = generate_math_exp(math_output_files[i], psi_func_name, psi_pdf_func_name, psi_eps_func_name, None, None, psi_func_num_param, code_eps_params[i], explict_eps, metrics)
            f.write(math_run + '\n')
        math_out = run_math(math_files[i], math_timeout)
        if output_file:
            with open(output_file, "a") as f:
                if math_out:
                    f.write('Changed parameter' + str(i+1) + ':\n' + math_out + '\n')
                else:
                    f.write('Mathematica runs out of time: ' + math_files[i] + '\n')
        else:
            if math_out:
                print('Changed parameter', i+1, ':\n', math_out)
            else:
                print('Mathematica runs out of time: ' + math_files[i])

def main():
    parser = argparse.ArgumentParser(description='PSI')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-f', help='PSI file')
    group.add_argument('-r', help='Directory containing PSI files')
    parser.add_argument('-o', nargs='?', help='Optional output file')
    parser.add_argument('-e', nargs='?', help='Explicit numerical interfrance in all prior distribution')
    parser.add_argument('-metric', nargs='?', help='Metrics for sensitivity analysis (support ExpDist,KS,TVD,KL). Please enclose metrics with double quotation marks e.g. \"ExpDist,KS,TVD,KL\" \"KS,TVD\"')
    parser.add_argument('-tp', nargs='?', help='Optional PSI timeout (second)')
    parser.add_argument('-tm', nargs='?', help='Optional Mathematica timeout (second)')
    parser.add_argument('-verbose', action='store_true', help='Print all outputs of PSI')
    argv = parser.parse_args(sys.argv[1:])
    if argv.f and not os.path.isfile(argv.f):
        print('PSI file doesn\'t exist')
        return 0
    if argv.r and not os.path.isdir(argv.r):
        print('Directory doesn\'t exist')
        return 0
    if argv.tm and not argv.tm.isdigit():
        print('Timeout parameter is invalid')
        return 0
    if argv.tp and not argv.tp.isdigit():
        print('Timeout parameter is invalid')
        return 0
    if argv.e:
        try:
            float(argv.e)
        except:
            print('Explicit numerical interfrance is invalid')
            return 0
    # metric0 = ExpDist, metric1 = KS, metric2 = TVD, metric3 = KL
    metrics = [True]*4
    if argv.metric:
        argv_metrics = argv.metric.lower()
        metrics[0] = True if "expdist" in argv_metrics else False
        metrics[1] = True if "ks" in argv_metrics else False
        metrics[2] = True if "tvd" in argv_metrics else False
        metrics[3] = True if "kl" in argv_metrics else False
    output_file = argv.o
    explict_eps = argv.e
    math_timeout = argv.tm
    psi_timeout = argv.tp
    verbose = argv.verbose
    if output_file:
        if os.path.exists(output_file):
            os.remove(output_file)
        else:
            create_dirs_from_path(os.path.dirname(output_file))
    if argv.f:
        run_file(argv.f, output_file, explict_eps, metrics, psi_timeout, math_timeout, verbose)
    else:
        for filename in os.listdir(argv.r):
            if filename.endswith(".psi"):
                file = os.path.join(argv.r, filename)
                if output_file:
                    print('Processing: '+ file + '\n')
                    with open(output_file, "a") as f:
                        f.write('\n' + file + ':\n')
                else:
                    print('\n' + file + ':')
                run_file(file, output_file, explict_eps, metrics, psi_timeout, math_timeout, verbose)

if __name__ == "__main__":
    main()
