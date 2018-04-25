import os
import sys
import shutil
import argparse
import subprocess as sp

input_root_dir = "probmods_webppl_to_psi"
output_root_dir = "benchmarks"
black_list = ["eps", "exp", "math"]
#        , "popl_examples"]
file_black_list = []
                    #["clinicalTrial.psi","sum.psi","max.psi",\
#                   "gaussian_infer.psi","true_obs_error.psi",\
#                   "medical_diagnosis.psi","tug_of_war.psi",\
#                   "explain_away.psi","polyas_urn.psi",\
#                   "temperature_high_low.psi","temperature_high_low.psi",\
#                   "communication_between_teacher_listener.psi",\
#                   "goal_inference.psi","preferences.psi",\
#                   "scalar_implicature.psi","estimating_causal_power.psi",\
#                   "learning_a_continuous_parameter.psi",\
#                   "learning_about_coins.psi",\
#                   "fair_or_unfair_coin.psi",\
#                   "the_rectangle_game_with_weak_sampling.psi",\
#                   "sampling_from_a_discrete_distribution.psi",\
#                   "the_dirichlet_processes.psi",\
#                   "bda_of_tug_of_war_model.psi",\
#                   "peoples_models_of_coins_expectation.psi",\
#                   "peoples_models_of_coins.psi",\
#                   "posterior_prediction.psi",\
#                   "single_regression.psi",\
#                   "true_obs.psi",\
#                   "unknown_numbers_of_categories.psi",\
#                   "savage_dickey_method.psi"]
cwd_dir = os.getcwd()


def make_dirs(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

def run_psense(input_file, output_file, flag_optim):
    cmd = ["python3","psense.py", "-tp", "600", "-f", input_file,"-log","-plain",flag_optim,">", output_file]
    cmd = " ".join(cmd)
    print("Running", "psense", "-tp", "600", "-f", input_file, "-log","-plain",flag_optim,">", output_file)
    sp.run(cmd, shell=True)

def exit_message(message):
    print(message)
    exit(0)

def tool_installed(cmd):
    return shutil.which(cmd) is not None

def check_cmd():
    if not tool_installed("psi"):
        exit_message("Please include \"psi\" into your PATH.")
    if not tool_installed("wolfram") and not tool_installed("wolframscript"):
        exit_message("Please include \"wolfram\" or \"wolframscript\" into your PATH.")

def main():
    if len(sys.argv) != 3 and len(sys.argv) != 4 :
        exit_message("Usage: python3 benchmark.py input_directory output_directory [-s]\n\
                optional argument: -s   Run PSense with '-s'")
    if (sys.version_info < (3, 5)): 
        exit_message("Python vesrion should be 3.5 or greater.")
    check_cmd()
    input_root_dir = sys.argv[1]
    output_root_dir = sys.argv[2]
    if len(sys.argv) >= 4 and sys.argv[3] == "-s":
        flag_optim = "-s"
    else:
        flag_optim = ""
    if not os.path.isdir(input_root_dir):
        print("The input directory \"" + input_root_dir + "\" is not existed.")
    for next_dir, _, file_list in os.walk(input_root_dir):
        if any([key in next_dir for key in black_list]):
            continue
        print("\nDIR:", next_dir)
        for file_name in file_list:
            if not file_name.endswith(".psi") or (file_name in file_black_list):
                continue
            input_file = os.path.join(next_dir, file_name)
            output_dir = os.path.join(output_root_dir, next_dir[len(input_root_dir):].lstrip("/"))
            make_dirs(output_dir)
            output_file_name = file_name.replace(".psi", ".txt")
            output_file = os.path.join(output_dir, output_file_name)
            run_psense(input_file, output_file, flag_optim)
            sp.run("cat " + output_file,shell=True)

if __name__ == "__main__":
    main()
