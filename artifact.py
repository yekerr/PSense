import os
import subprocess as sp

input_root_dir = "123"
output_root_dir = "artifact"
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

for next_dir, _, file_list in os.walk(input_root_dir):
    if any([key in next_dir for key in black_list]):
        continue
    print("\n", next_dir)
    for file_name in file_list:
        if not file_name.endswith(".psi"):
            continue
        input_file = os.path.join(next_dir, file_name)
        output_dir = os.path.join(output_root_dir, next_dir[len(input_root_dir):].lstrip("/"))
        make_dirs(output_dir)
        output_file_name = file_name.replace(".psi", ".txt")
        output_file = os.path.join(output_dir, output_file_name)
        run_psense(input_file, output_file)
        
