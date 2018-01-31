import os
import sys
import shutil
import argparse
import subprocess as sp

input_root_dir = "probmods_webppl_to_psi"
output_root_dir = "benchmarks"
black_list = ["eps", "exp", "math"]
cwd_dir = os.getcwd()


def make_dirs(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

def run_psense(input_file, output_file):
    cmd = ["python3", "psense.py", "-f", input_file, ">", output_file]
    cmd = " ".join(cmd)
    print("Running", cmd)
    sp.run(cmd, shell=True)

def exit_message(message):
    print(message)
    exit(0)

def tool_installed(cmd):
    return shutil.which(cmd) is not None

def check_cmd():
    if not tool_installed("psi"):
        exit_message("Please include \"psi\" into your path.")
    if not tool_installed("MathematicaScript"):
        exit_message("Please include \"MathematicaScript\" into your path.")

def main():
    if len(sys.argv) != 3:
        exit_message("Usage: python3 benchmark.py input_directory output_directory")
    input_root_dir = sys.argv[1]
    output_root_dir = sys.argv[2]
    if not os.path.isdir(input_root_dir):
        print("The input directory is not existed.")
    for next_dir, _, file_list in os.walk(input_root_dir):
        if any([key in next_dir for key in black_list]):
            continue
        print("\nDIR:", next_dir)
        for file_name in file_list:
            if not file_name.endswith(".psi"):
                continue
            input_file = os.path.join(next_dir, file_name)
            output_dir = os.path.join(output_root_dir, next_dir[len(input_root_dir):].lstrip("/"))
            make_dirs(output_dir)
            output_file_name = file_name.replace(".psi", ".txt")
            output_file = os.path.join(output_dir, output_file_name)
            run_psense(input_file, output_file)

if __name__ == "__main__":
    main()