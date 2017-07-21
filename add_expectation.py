import os, sys
import subprocess as sp
import re
import argparse

def create_dirs_from_path(path):
    if path and not os.path.exists(path):
        try:
            os.makedirs(path)
        except:
            raise

def run_file(file):
    psi_file = file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file)

    psi_exp_dir = psi_file_dir + '_exp'
    psi_exp_file_name = ''.join(psi_file_name.split('.')[:-1]) + '_exp.psi'
    psi_exp_file = os.path.join(psi_exp_dir, psi_exp_file_name)

    flag = False
    def replace(match):
        nonlocal flag
        if match.group('result').strip().startswith('('):
            flag = True
        result = 'main' + match.group('code') + 'return Expectation[' + match.group('result').strip() + '];'
        return result

    parse_psi = re.compile(r'main(?P<code>.+?)return(?P<result>.+?);', re.S)
    
    with open(psi_file, 'r') as f:
        code = f.read()
        code_exp = parse_psi.sub(replace, code)

    if flag:
        print(psi_file + ': tuple is not supported')
        return
    create_dirs_from_path(psi_exp_dir)
    with open(psi_exp_file, 'w') as f:
        f.write(code_exp)
    print(psi_file + ': added')

def main():
    parser = argparse.ArgumentParser(description='PSI Epectation Generator')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-f', help='PSI file')
    group.add_argument('-r', help='Directory containing PSI files')
    argv = parser.parse_args(sys.argv[1:])
    if argv.f and not os.path.isfile(argv.f):
        print('PSI file doesn\'t exist')
        return 0
    if argv.r and not os.path.isdir(argv.r):
        print('Directory doesn\'t exist')
        return 0

    if argv.f:
        run_file(argv.f)
    else:
        for filename in os.listdir(argv.r):
            if filename.endswith(".psi"):
                file = os.path.join(argv.r, filename)
                run_file(file)

if __name__ == "__main__":
    main()
