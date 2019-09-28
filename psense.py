#! /usr/bin/env python3
import os, sys
import re
import argparse
import shutil
import subprocess as sp
import numpy as np

from terminaltables import SingleTable
from textwrap import wrap
from collections import defaultdict

file_dirs = []

def tool_installed(cmd):
    return shutil.which(cmd) is not None

def parse_psi_output(output):
    result = ""
    for valid_output in output.split("\n"):
        if valid_output:
            if valid_output[0] == "p":
                result = valid_output.strip()
                break;
    else:
        result = None
    return result

def create_dirs_from_path(path):
    global file_dirs
    if path and not os.path.exists(path):
        try:
            os.makedirs(path)
            file_dirs.append(path)
        except:
            raise

def rename_func(function_pre):
    num = len(function_pre.split(","))
    function_name = function_pre.split("[")[0] + "["
    for i in range(num):
        if i == 0: 
            function_name += "r" + str(i+1)
        else:
            function_name += ",r"+str(i+1)
    return function_name + "]"

def generate_eps_param(f_eps_param, noise_percentage):
    REAL = 0
    INT = 1
    distribution_range = {}
    distribution_range["flip"] = (0, 1, REAL)
    distribution_range["bernoulli"] = (0, 1, REAL)
    distribution_range["geometric"] = (0, 1, REAL)
    distribution_range["poisson"] = (0, None, REAL)
    distribution_range["exponential"] = (0, None, REAL)
    distribution_range["studentT"] = (0, None, REAL)
    distribution_range["rayleigh"] = (0, None, REAL)
    distribution_range["gauss1"] = (None, None, REAL)
    distribution_range["gauss2"] = (None, None, REAL)
    distribution_range["uniform1"] = (None, None, REAL)
    distribution_range["uniform2"] = (None, None, REAL)
    distribution_range["uniformInt1"] = (None, None, INT)
    distribution_range["uniformInt2"] = (None, None, INT)
    distribution_range["beta1"] = (0, None, REAL)
    distribution_range["beta2"] = (0, None, REAL)
    distribution_range["gamma1"] = (0, None, REAL)
    distribution_range["gamma2"] = (0, None, REAL)
    distribution_range["laplace1"] = (None, None, REAL)
    distribution_range["laplace2"] = (0, None, REAL)
    distribution_range["cauchy1"] = (None, None, REAL)
    distribution_range["cauchy2"] = (0, None, REAL)
    distribution_range["pareto1"] = (0, None, REAL)
    distribution_range["pareto2"] = (0, None, REAL)
    distribution_range["weibull1"] = (0, None, REAL)
    distribution_range["weibull2"] = (0, None, REAL)
    distribution_range["binomial1"] = (1, None, INT)
    distribution_range["binomial2"] = (0, 1, REAL)
    distribution_range["negBinomial1"] = (1, None, INT)
    distribution_range["negBinomial2"] = (0, 1, REAL)
    distribution_range["observe"] = (None, None, REAL)
    distribution_range["cobserve"] = (None, None, REAL)
    param_lower, param_upper, param_type = distribution_range[f_eps_param["type"]]
    try:
        value = float(f_eps_param["value"])
        noise_value = value*noise_percentage
        eps_lower = max(param_lower - value, -noise_value) if param_lower else -noise_value
        eps_upper = min(param_upper - value, noise_value) if param_upper else noise_value
        eps_range = "(" + "{:.16f}".format(eps_lower) + "<=eps<=" + "{:.16f}".format(eps_upper) + ")"
    except ValueError:
        eps_range = "(-0.1<=eps<=0.1)"
    return eps_range, str(param_type)

def generate_math_exp(args):
    log_file = args["log_file"]
    f_name = args["f_name"]
    f_pdf_name = args["f_pdf_name"]
    f_eps_name = args["f_eps_name"]
    f_eps_name_pdf = args["f_eps_name_pdf"]
    f_exp_name = args["f_exp_name"]
    f_exp_eps_name = args["f_exp_eps_name"]
    f_ED2_eps_name = args["f_ED2_eps_name"]
    f_param_dict = args["f_param_dict"]
    f_eps_param = args["f_eps_param"]
    f_eps_type = args["f_eps_type"]
    explict_eps = args["explict_eps"]
    noise_percentage = args["noise_percentage"]
    metrics = args["metrics"]
    numeric = args["numeric"]
    optimization = args["optimization"]
    custom_metric_name = args["custom_metric_name"]

    file = "\"" + log_file + "\""
    eps_range, eps_type = generate_eps_param(f_eps_param, noise_percentage)
    if not f_exp_name or not f_exp_eps_name:
        f_exp_name = "Null"
        f_exp_eps_name = "Null"
        f_ED2_eps_name = "Null"
    flag_eps = "True" if explict_eps else "False"
    flag_numeric = "True" if numeric else "False"
    flag_optimization = "True" if optimization else "False"
    flag_metrics = [str(v) for v in metrics]
    custom_metric_name = custom_metric_name if custom_metric_name else "None"
    modules_dir = "\"" + os.path.join(os.path.dirname(os.path.realpath(__file__)), "modules") + "\""
    exp = (",".join([modules_dir, f_name, f_pdf_name, f_eps_name, f_eps_name_pdf, flag_eps, *flag_metrics, "{" + ", ".join(f_param_dict.keys()) + "}", custom_metric_name, f_exp_name, f_exp_eps_name, f_ED2_eps_name, eps_range, eps_type, flag_numeric, file, f_eps_type, flag_optimization]))
    runall = "runall[" + exp + "]"
    return runall

def generate_psi_expectation(psi_file):
    supported = True
    def replace(match):
        nonlocal supported
        if match.group("result").strip().startswith("("):
            supported = False
        result = "main" + match.group("code") + "return Expectation(" + match.group("result").strip() + ");"
        return result

    parse_psi = re.compile(r"main(?P<code>.+?)return(?P<result>.+?);", re.S)

    with open(psi_file, "r", encoding="utf-8") as f:
        code = f.read()
        code_exp = parse_psi.sub(replace, code)
    return code_exp if supported else None
    
def generate_psi_epsilon(psi_file, explict_eps):
    distribution_1p = {}
    distribution_1p["flip"] = r"(flip\s*\((?P<flip>.+?)\))"
    distribution_1p["bernoulli"] = r"(bernoulli\s*\((?P<bernoulli>.+?)\))"
    distribution_1p["geometric"] = r"(geometric\s*\((?P<geometric>.+?)\))"
    distribution_1p["poisson"] = r"(poisson\s*\((?P<poisson>.+?)\))"
    # distribution_1p["categorical"] = r"(categorical\((?P<categorical>.+?)\))"
    distribution_1p["exponential"] = r"(exponential\s*\((?P<exponential>.+?)\))"
    distribution_1p["studentT"] = r"(studentT\s*\((?P<studentT>.+?)\))"
    distribution_1p["rayleigh"] = r"(rayleigh\s*\((?P<rayleigh>.+?)\))"
    #distribution_1p["observe"] = r"(observe\s*\(.*==\s*(?P<observe>.+?)\))"
    #distribution_1p["cobserve"] = r"(cobserve\s*\(.*,\s*(?P<cobserve>.+?)\))"

    distribution_2p = {}
    distribution_2p["gauss"] = r"(gauss\s*\((?P<gauss1>.+?),(?P<gauss2>.+?)\))"
    distribution_2p["uniform"] = r"(uniform\s*\((?P<uniform1>.+?),(?P<uniform2>.+?)\))"
    distribution_2p["uniformInt"] = r"(uniformInt\s*\((?P<uniformInt1>.+?),(?P<uniformInt2>.+?)\))"
    distribution_2p["beta"] = r"(beta\s*\((?P<beta1>.+?),(?P<beta2>.+?)\))"
    distribution_2p["gamma"] = r"(gamma\s*\((?P<gamma1>.+?),(?P<gamma2>.+?)\))"
    distribution_2p["laplace"] = r"(laplace\s*\((?P<laplace1>.+?),(?P<laplace2>.+?)\))"
    distribution_2p["cauchy"] = r"(cauchy\s*\((?P<cauchy1>.+?),(?P<cauchy2>.+?)\))"
    distribution_2p["pareto"] = r"(pareto\s*\((?P<pareto1>.+?),(?P<pareto2>.+?)\))"
    distribution_2p["weibull"] = r"(weibull\s*\((?P<weibull1>.+?),(?P<weibull2>.+?)\))"
    distribution_2p["binomial"] = r"(binomial\s*\((?P<binomial1>.+?),(?P<binomial2>.+?)\))"
    distribution_2p["negBinomial"] = r"(negBinomial\s*\((?P<negBinomial1>.+?),(?P<negBinomial2>.+?)\))"
    
    #distribution_group_p = {}
    #distribution_group_p["observe"] = r"(observe\s*\(.*==\s*(?P<observe>.+?)\))"
    #distribution_group_p["cobserve"] = r"(cobserve\s*\(.*,\s*(?P<cobserve>.+?)\))"
    
    reg = ""
    for dist in distribution_1p.values():
        reg += dist + r"|"
    for dist in distribution_2p.values():
        reg += dist + r"|"
    reg = reg.strip("|")
    parse_dis = re.compile(reg)
    codes_eps_params = []
    codes_line_change = []
    def add_eps():
        if explict_eps:
            rt_add =  "+"+explict_eps
        else:
            rt_add = "+?eps"
        return rt_add
    def replace(nth):
        count = 0
        def check_eps():
            nonlocal count
            count += 1
            if count == nth:
                rt = add_eps()
            else:
                rt = ""
            return rt
            
        def replace_counter(match):
            for dist_name_1p in distribution_1p.keys():
                if match.group(dist_name_1p):
                    result = dist_name_1p + "(" + match.group(dist_name_1p) + check_eps() + ")"
                    if '?eps' in result:
                        codes_line_change.append(result)
                    if nth == 1:
                        codes_eps_params.append({"type": dist_name_1p, "value": match.group(dist_name_1p)})
                    break
            for dist_name_2p in distribution_2p.keys():
                if match.group(dist_name_2p + "1"):
                    result = dist_name_2p + "(" + match.group(dist_name_2p+"1") + check_eps() + "," + match.group(dist_name_2p+"2") + check_eps() + ")"
                    if '?eps' in result:
                        codes_line_change.append(result)
                    if nth == 1:
                        codes_eps_params.extend([{"type": dist_name_2p+"1", "value": match.group(dist_name_2p+"1")}, {"type": dist_name_2p+"2", "value": match.group(dist_name_2p+"2")}])
                    break
            return result
        return replace_counter
    
    def get_num_eps(matches):
        match_count = len(matches)
        extra = sum([1 for match in matches 
                 if any(any(group.startswith(dist_name_2p) for dist_name_2p in distribution_2p.keys()) for group in match) ])
        return match_count + extra
        #extra = 0
        #for match in matches:
        #    for group in match:
        #        flag_2p = False
        #        for dist_name_2p in distribution_2p.keys():
        #            if group.startswith(dist_name_2p):
        #                extra += 1
        #                flag_2p = True
        #                break
        #        if flag_2p:
        #            break
        #return len(matches) + extra
    def replace_cobs(obs, compare_sym, match):
        result = obs + match.group("to_compare") + compare_sym + match.group(3) + add_eps() + ")"
        return result
    def convert_float(string_to_convert):
        try:
            return float(string_to_convert)
        except ValueError:
            return 0
    def replace_obs(match):
        result = "observe(" + match.group("observe") + add_eps() + ")"
        return result

    codes_eps = []
    with open(psi_file, "r", encoding="utf-8") as f:
        code = f.read()
        code_findall = parse_dis.findall(code) 
        num_eps = get_num_eps(code_findall)
        for i in range(1, num_eps + 1):
            codes_eps.append(parse_dis.sub(replace(nth=i), code))
    #add eps to observe
    parse_obs = re.compile(r"((?<!c)observe\s*\(\s*(?P<observe>.+?)\))")
    if parse_obs.findall(code) != []: 
        codes_eps.append(parse_obs.sub(replace_obs, code))
        codes_eps_params.append({'type': 'observe','value': str(max(map(lambda x: convert_float(x[1].split('=')[-1]),parse_obs.findall(code)),key=abs))})
        codes_line_change.append("observe( _ == _ +?eps)")
    #add eps to cobserve
    parse_cobs = re.compile(r"(cobserve\s*\((?P<to_compare>.+?),\s*(?P<cobserve>.+?)\))")
    if parse_cobs.findall(code) != []: 
        codes_eps.append(parse_cobs.sub(lambda x: replace_cobs("cobserve(",",", x), code))
        codes_eps_params.append({'type': 'cobserve','value': str(max(map(lambda x: convert_float(x[2]),parse_cobs.findall(code)), key=abs))})
        codes_line_change.append("cobserve( _ , _ +?eps)")
    return codes_eps, codes_eps_params, codes_line_change

def extend_n_files_name(base_dir, base_name, extend_name, extension, n):
    extend_dir = base_dir + extend_name
    extend_file_basename = "".join(base_name.split(".")[:-1]) + extend_name
    create_dirs_from_path(extend_dir)
    extend_files = []
    for i in range(n):
        extend_files.append(os.path.join(extend_dir, extend_file_basename + str(i+1) + "." + extension))
    return extend_files

def extend_file_name(base_dir, base_name, extend_name, extension):
    extend_dir = base_dir + extend_name
    extend_file_basename = "".join(base_name.split(".")[:-1]) + extend_name
    create_dirs_from_path(extend_dir)
    file = os.path.join(extend_dir, extend_file_basename + "." + extension)
    return file

def store_codes_to_files(codes, files):
    for i in range(len(codes)):
        with open(files[i], "w", encoding="utf-8") as f:
            f.write(codes[i])

def run_psi(file_psi, option, timeout, verbose, psi_log_file):
    if timeout:
        timeout = int(timeout)
    cmd = ["psi", file_psi, "--mathematica", option] if option else ["psi", file_psi, "--mathematica"]
    try:
        psi_out = sp.run(cmd, stdout=sp.PIPE, stderr=sp.PIPE, timeout=timeout)
    except sp.TimeoutExpired:
        with open(psi_log_file, "a", encoding="utf-8") as psi_log_f:
            psi_log_f.write(file_psi + " timeout\n\n")
        return None
    if verbose:
        print(psi_out.stdout.decode("utf-8"))
    result = parse_psi_output(psi_out.stdout.decode("utf-8"))
    if result is None:
        with open(psi_log_file, "a", encoding="utf-8") as psi_log_f:
            psi_log_f.write("Fail to parse " + file_psi + " :\n" + psi_out.stderr.decode("utf-8") + "\n" + psi_out.stdout.decode("utf-8") + "\n")
    return result



def run_math(file, timeout, mathematica):
    if timeout:
        timeout = int(timeout)
    try:
        math_out = sp.run([mathematica, "-script", file], stdout=sp.PIPE, timeout=timeout)
    except sp.TimeoutExpired:
        return None
    return math_out.stdout.decode("utf-8").strip()

def check_psi_out(file, output_file, result):
    if not result:
        if output_file:
            with open(output_file, "a", encoding="utf-8") as f:
                f.write("PSI program error or timeout: " + file + "\n" + "Run with `-log` and check _log/ for detail\n")
        else:
            print("PSI program error or timeout: " + file + "\n" + "Run with `-log` and check _log/ for detail\n")
        return False
    else:
        return True

def rename_psi_out(exp, extend_name):
    parts = exp.split(":=")
    newname = parts[0].replace("[", extend_name + "[")
    return newname + ":=" + parts[-1]

def print_plain_results(message, output_file):
    if output_file:
        with open(output_file, "a", encoding="utf-8") as f:
            f.write(message + "\n")
    else:
        print(message)

def print_table_results(title, data, output_file):
    table = SingleTable(data, title)
    max_width = int(shutil.get_terminal_size()[0] / len(data[0]) - 5)
    for i in range(1, len(data)):
        for j in range(1, len(data[0])):
            table.table_data[i][j] = '\n'.join(wrap(data[i][j], max_width))
    print_plain_results(table.table, output_file)

def parse_math_expr(exp):
    if "error" in exp:
        return "error"
    else:
        return "\n".join(exp.replace("{", "").replace("}", "").split(", "))
def parse_math_bounds(exp):
    exps = exp.strip("{}").split(", ")
    if len(exps) > 1:
        return "lower: " + exps[0] + "\n" + "upper: " + exps[-1]
    else:
        return exps[0]

def parse_math_content(lines, explict_eps):
    MATH_TITLE = 0
    TABLE_TITLE = 1
    table_dict = defaultdict(list)
    func_type = "Discrete"
    prompt_func_type = "Function Type:"
    prompt_metrics = {"Discrete": set(["Expectation Distance 1 (|E[X]-E[X_eps]|)", "Expectation Distance 2 (E[|X-X_eps|])", "KS Distance", "TVD", "KL Divergence"]),
            "Continuous": set(["Expectation Distance 1 (|E[X]-E[X_eps]|)",  "KS Distance", "TVD Bounds(lower, upper):", "KL Divergence Bounds(lower, upper):"])}
    translate_metrics = {"Expectation Distance 1 (|E[X]-E[X_eps]|)": "ED1 |E[X]-E[X_eps]|",  "Expectation Distance 2 (E[|X-X_eps|])":"ED2 E[|X-X_eps|]", "KS Distance": "KS Distance",
        "TVD": "TVD", "KL Divergence": "KL", "TVD Bounds(lower, upper):": "TVD Bounds", "KL Divergence Bounds(lower, upper):": "KL Bounds"}
    errors = set(["::", "error"])
    if explict_eps:
        i = 0
        while i < len(lines):
            if lines[i] == "Finish All Metrics":
                break
            if lines[i] == prompt_func_type:
                if i+1 < len(lines):
                    func_type = lines[i+1]
                    i += 2
            elif lines[i] in prompt_metrics["Discrete"]:
                if i+1 < len(lines):
                    table_dict[translate_metrics[lines[i]]].append(parse_math_expr(lines[i+1]))
                    i += 2
            else:
                i += 1
    else:
        i = 0
        while i < len(lines):
            if lines[i] == "Finish All Metrics":
                break
            if lines[i] == prompt_func_type:
                if i+1 < len(lines):
                    func_type = lines[i+1]
                    i += 2
            elif lines[i] in prompt_metrics[func_type]:
                metric = lines[i]
                abbr_metric = translate_metrics[lines[i]]
                if i+1 < len(lines):
                    expr = parse_math_bounds(lines[i+1]) if func_type == "Continuous" else lines[i+1]
                    table_dict[abbr_metric].append(expr)
                    i += 2
                while i < len(lines):
                    if lines[i] == metric + " Max" or lines[i] == metric[:-len(" Bounds(lower, upper):")] + " Max"\
                            or lines[i] == metric[:-len(" (|E[X]-E[X_eps]|)")] + " Max"\
                            or lines[i] == metric[:-len(" (E[|X-X_eps|])")] + " Max":
                        if i+1 < len(lines):
                            table_dict[abbr_metric].append(parse_math_expr(lines[i+1]))
                            i += 2
                    elif lines[i] == "eps Bounds for " + metric + " <= 0.1"\
                            or lines[i] == "eps Bounds for " + metric[:-len(" (|E[X]-E[X_eps]|)")] + " <= 0.1"\
                            or lines[i] == "eps Bounds for " + metric[:-len(" (E[|X-X_eps|])")] + " <= 0.1":
                        if i+1 < len(lines):
                            table_dict[abbr_metric].append(parse_math_bounds(lines[i+1]))
                            i += 2
                    elif lines[i] == "Is Linear?":
                        if i+1 < len(lines):
                            table_dict[abbr_metric].append(lines[i+1])
                            i += 2
                        break
                    else:
                        i += 1 
            else:
                i += 1
    return table_dict, func_type

def parse_math_out(math_out, explict_eps):
    if explict_eps:
        prompt_info = {"Discrete": ["Maximum"],
            "Continuous": ["Maximum"]}
    elif "eps Bounds for" in math_out:
        prompt_info = {"Discrete": ["Expression", "eps Bounds", "Linear"],
                            "Continuous": ["Expression \nor Bounds", "eps Bounds", "Linear"]}
    else:
        prompt_info = {"Discrete": ["Expression", "Maximum", "Linear"],
            "Continuous": ["Expression \nor Bounds", "Maximum", "Linear"]}
    lines = math_out.split("\n")
    lines = [line.strip() for line in lines if line]
    table_dict, func_type = parse_math_content(lines, explict_eps)
    metrics = list(table_dict.keys())
    table_data = [[""] + metrics]
    for i in range(len(prompt_info[func_type])):
        row = [prompt_info[func_type][i]]
        for key in metrics:
            if i < len(table_dict[key]):
                row.append(table_dict[key][i])
        table_data.append(row)
    return table_data, func_type

def print_results(index, math_file, math_out, output_file, plain, explict_eps, codes_line_change_i):
    if not math_out:
        failure_message = "\nMathematica error or timeout: " + math_file + "\n" + "Run with `-log` and check _log/ for detail\n" + "\n" + math_out
        print_plain_results(failure_message, output_file)
    elif plain:
        success_message = "\nAnalyzed parameter " + str(index+1) + ": " + codes_line_change_i + "\n" + math_out
        print_plain_results(success_message, output_file)
    else:
        table_math_out, func_type = parse_math_out(math_out, explict_eps)
        message = "\nFunction Type:\n" + func_type
        print_plain_results(message, output_file)
        print_table_results("Analyzed parameter " + str(index+1) + ": " + codes_line_change_i, table_math_out, output_file)

def get_param_dict(fun_param):
    ret = {}
    for param_i in fun_param.split(","):
        param_i_strip = param_i.strip()
        if param_i_strip.endswith("_"):
            param_name = param_i_strip[:-1]
            ret.update({param_name.replace("_","Z") : param_name})
    return ret

def replace_underscore(fun_def):
    fun_name_part = fun_def.split("[")[0] + "["
    fun_param_part = (fun_def.split("[")[1]).split("]")[0]
    fun_param_replace_dict = get_param_dict(fun_param_part)
    fun_param_part = "_, ".join(fun_param_replace_dict.keys()) + "_"
    fun_body_part = "] :=" + fun_def.split(":=")[1].replace("_","Z")
    return fun_name_part + fun_param_part + fun_body_part


def run_file(args):
    global file_dirs
    input_file = args["input_file"]
    output_file = args["output_file"]
    explict_eps = args["explict_eps"]
    metrics = args["metrics"]
    custom_metric_file = args["custom_metric_file"]
    psi_timeout = args["psi_timeout"]
    math_timeout = args["math_timeout"]
    verbose = args["verbose"]
    plain = args["plain"]
    mathematica = args["mathematica"]
    numeric = args["numeric"]
    skip_run = args["skip_run"]
    
    
    psi_file = input_file
    psi_file_name = os.path.basename(psi_file)
    psi_file_dir = os.path.dirname(psi_file) 

    psi_file_org_log = extend_file_name(psi_file_dir, psi_file_name, "_log", "log")

    custom_metric_name = None
    if metrics[5]:
        custom_metric_file_name = os.path.basename(custom_metric_file)
        custom_metric_name_index = custom_metric_file_name.index(".")
        custom_metric_name = custom_metric_file_name[:custom_metric_name_index]

    if not skip_run: 
        psi_out = run_psi(psi_file, "--cdf", psi_timeout, verbose, psi_file_org_log)
        if not check_psi_out(psi_file, output_file, psi_out):
            return 1
        psi_func_param_dict = get_param_dict((psi_out.split("[")[1]).split("]")[0])
        psi_func_name = psi_out.split("[")[0]
        psi_out = replace_underscore(psi_out)

        psi_pdf_out = run_psi(psi_file, None, psi_timeout, verbose, psi_file_org_log)
        if not check_psi_out(psi_file, output_file, psi_pdf_out):
            return 1
        psi_pdf_out = rename_psi_out(psi_pdf_out, "PDF")
        psi_pdf_out = replace_underscore(psi_pdf_out)
        psi_pdf_func_name = psi_pdf_out.split("[")[0]

    codes_eps, code_eps_params, codes_line_change = generate_psi_epsilon(psi_file, explict_eps)
    psi_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, "_eps", "psi", len(codes_eps))
    math_files = extend_n_files_name(psi_file_dir, psi_file_name, "_math", "m", len(codes_eps))
    store_codes_to_files(codes_eps, psi_eps_files)
    log_files = extend_n_files_name(psi_file_dir, psi_file_name, "_log", "log", len(codes_eps))


    code_exp = generate_psi_expectation(psi_file)

    if code_exp:
        psi_exp_file = extend_file_name(psi_file_dir, psi_file_name, "_exp", "psi")    
        store_codes_to_files([code_exp],[psi_exp_file])
        if not skip_run: 
            psi_exp_out = run_psi(psi_exp_file, None, psi_timeout, verbose, psi_file_org_log)
            if not check_psi_out(psi_exp_file, output_file, psi_exp_out):
                return 1
            psi_exp_out = rename_psi_out(psi_exp_out, "Exp")
            psi_exp_func_name = psi_exp_out.split("[")[0].strip()
            psi_exp_out = replace_underscore(psi_exp_out)


        codes_exp_eps, _, _ = generate_psi_epsilon(psi_exp_file, explict_eps)
        psi_exp_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, "_exp_eps", "psi", len(codes_exp_eps))
        store_codes_to_files(codes_exp_eps, psi_exp_eps_files)
        psi_ED2_eps_files = extend_n_files_name(psi_file_dir, psi_file_name, "_ED2_eps", "psi", len(codes_exp_eps))
        with open(psi_file, "r", encoding="utf-8") as f:
            code = f.read()
            codes_ED2_acc = code.replace("main(", "main_acc(")
            codes_ED2_eps = [codes_ED2_acc + "def main_eps(){\n" \
                + codes_eps_i.replace("main(", "main_in(") \
                + "return main_in();\n}\n" \
                + "def main(){return Expectation(abs(main_acc() -  main_eps()));}\n" \
                        for codes_eps_i in codes_eps]
            store_codes_to_files(codes_ED2_eps, psi_ED2_eps_files)
        if skip_run: 
            for i in range(len(psi_eps_files)):
                eps_range, eps_type = generate_eps_param(code_eps_params[i], args["noise_percentage"])
                eps_lu = eps_range[1:-1].split("<=")
                with open(log_files[i], "w", encoding="utf-8") as f:
                    f.write(",".join([str(xx) for xx in np.linspace(float(eps_lu[0]),float(eps_lu[2]), 10)]) + '\n')
            return
    elif output_file:
        with open(output_file, "a", encoding="utf-8") as f:
            f.write("Expectation is not supported" + "\n")
    else:
        print("Expectation is not supported")

    for i in range(len(psi_eps_files)):
        psi_eps_out = run_psi(psi_eps_files[i], "--cdf", psi_timeout, verbose, log_files[i])
        if not check_psi_out(psi_eps_files[i], output_file, psi_eps_out):
            continue
        psi_eps_out_pdf = run_psi(psi_eps_files[i], None, psi_timeout, verbose, log_files[i])
        if not check_psi_out(psi_eps_files[i], output_file, psi_eps_out_pdf):
            continue
        #if not check_psi_out(psi_ED2_files[i], output_file, psi_ED2_out_pdf):
        #    continue
        psi_eps_out = rename_psi_out(psi_eps_out, "Eps")
        psi_eps_out_pdf = rename_psi_out(psi_eps_out_pdf, "EpsPDF")
        #psi_ED2_out_pdf = rename_psi_out(psi_ED2_out_pdf, "ED2PDF")
        psi_eps_out = replace_underscore(psi_eps_out)
        psi_eps_out_pdf = replace_underscore(psi_eps_out_pdf)
        #psi_ED2_out_pdf = replace_underscore(psi_ED2_out_pdf)
        psi_eps_func_name_pdf = psi_eps_out_pdf.split("[")[0].strip()
        psi_eps_func_name = psi_eps_out.split("[")[0].strip()
        #psi_ED2_func_name = psi_ED2_out_pdf.split("[")[0].strip()

        if code_exp:
            psi_exp_eps_out = run_psi(psi_exp_eps_files[i], None, psi_timeout, verbose, log_files[i])
            if not check_psi_out(psi_exp_eps_files[i], output_file, psi_exp_eps_out):
                continue
            psi_exp_eps_out = rename_psi_out(psi_exp_eps_out, "ExpEps")
            psi_exp_eps_out = replace_underscore(psi_exp_eps_out)
            psi_exp_eps_func_name = psi_exp_eps_out.split("[")[0].strip()
        
            psi_ED2_eps_out = run_psi(psi_ED2_eps_files[i], None, psi_timeout, verbose, log_files[i])
            if not check_psi_out(psi_ED2_eps_files[i], output_file, psi_ED2_eps_out):
                continue
            psi_ED2_eps_out = rename_psi_out(psi_ED2_eps_out, "ED2Eps")
            psi_ED2_eps_out = replace_underscore(psi_ED2_eps_out)
            psi_ED2_eps_func_name = psi_ED2_eps_out.split("[")[0].strip()
        with open(math_files[i], "w", encoding="utf-8") as f:
            base_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), "modules", "base_runall_support.m")
            f.write("Get[\"" + base_file + "\"]\n")
            if metrics[5]:
                f.write("Get[\"" + custom_metric_file + "\"]\n")
            f.write(psi_out + "\n")
            f.write(psi_pdf_out + "\n")
            f.write(psi_eps_out + "\n")
            #f.write(psi_ED2_out_pdf + "\n")
            
            args["log_file"] = log_files[i]
            args["f_name"] = psi_func_name
            args["f_pdf_name"] = psi_pdf_func_name
            args["f_eps_name"] = psi_eps_func_name
            args["f_eps_name_pdf"] = psi_eps_func_name_pdf

            args["f_param_dict"] = psi_func_param_dict
            args["f_eps_param"] = code_eps_params[i]
            args["f_eps_type"] = code_eps_params[i]["type"]
            args["custom_metric_name"] = custom_metric_name
            if code_exp:
                f.write(psi_exp_out + "\n")
                f.write(psi_exp_eps_out + "\n")
                args["f_exp_name"] = psi_exp_func_name
                args["f_exp_eps_name"] = psi_exp_eps_func_name
                f.write(psi_ED2_eps_out + "\n")
                args["f_ED2_eps_name"] = psi_ED2_eps_func_name
                math_run = generate_math_exp(args)
            else:
                args["f_exp_name"] = None
                args["f_exp_eps_name"] = None
                math_run = generate_math_exp(args)
            f.write(math_run + "\n")
    for i in range(len(psi_eps_files)):
        math_out = run_math(math_files[i], math_timeout, mathematica)
        for changed_, origin_ in args["f_param_dict"].items():
            math_out = math_out.replace(changed_,origin_)
        print_results(i, math_files[i], math_out, output_file, plain, explict_eps, codes_line_change[i])
    if not args["log"]:
        for path in file_dirs:
            shutil.rmtree(path)

def exit_message(message):
    print(message)
    exit(0)

def init_args():
    if (sys.version_info < (3, 5)):
        exit_message("Python vesrion should be 3.5 or greater.")
    parser = argparse.ArgumentParser(description="PSI")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-f", help="PSI file")
    group.add_argument("-r", help="Directory containing PSI files")
    parser.add_argument("-o", nargs="?", help="Output file")
    parser.add_argument("-e", nargs="?", help="Explicit numerical interference in all prior distribution")
    parser.add_argument("-p", nargs="?", help="Noise percentage (p=(0,1), Defualt=0.1)")
    help_metric = "Metrics for sensitivity analysis (support ExpDist1,ExpDist2,KS,TVD,KL,Custom). \
    Please enclose metrics with double quotation marks e.g. \"ExpDist1,ExpDist2,KL,Custom:FilePath\" \"KS,TVD\" \
    Note: function name of custom metric should be identical as the file name"
    parser.add_argument("-metric", nargs="?", help=help_metric)
    parser.add_argument("-tp", nargs="?", help="PSI timeout (second)")
    parser.add_argument("-tm", nargs="?", help="Mathematica timeout (second)")
    parser.add_argument("-plain", action="store_true", help="Print raw outputs")
    parser.add_argument("-verbose", action="store_true", help="Print outputs of PSI")
    parser.add_argument("-n", action="store_true", help="Apply numerical integration and maximization")
    parser.add_argument("-s", action="store_true", help="Search for the bounds of noise when the distance is constrainted to <= 0.1. (support ExpDist1,ExpDist2,KS,TVD,KL,Custom).")
    parser.add_argument("-k", action="store_true", help="Only generate files with eps param without running")
    parser.add_argument("-log", action="store_true", help="Keep the generated files")
    argv = parser.parse_args(sys.argv[1:])
    if argv.f and not os.path.isfile(argv.f):
        exit_message("PSI file doesn\'t exist")
    if argv.r and not os.path.isdir(argv.r):
        exit_message("Directory doesn\'t exist")
    if argv.tm and not argv.tm.isdigit():
        exit_message("Timeout parameter is invalid")
    if argv.tp and not argv.tp.isdigit():
        exit_message("Timeout parameter is invalid")
    if argv.e:
        try:
            float(argv.e)
        except:
            exit_message("Explicit numerical interfrance is invalid")
    if argv.p:
        try:
            if float(argv.p) >= 1 or float(argv.p) <= 0:
                exit_message("Noise percentage is invalid")
        except:
            exit_message("Noise percentage is invalid")
    # metric0 = ExpDist, metric1 = KS, metric2 = TVD, metric3 = KL
    metrics = [True]*5 + [False]
    custom_metric_file = None
    if argv.metric:
        argv_metrics = argv.metric.lower()
        metrics[0] = True if "expdist1" in argv_metrics else False
        metrics[1] = True if "expdist2" in argv_metrics else False
        metrics[2] = True if "ks" in argv_metrics else False
        metrics[3] = True if "tvd" in argv_metrics else False
        metrics[4] = True if "kl" in argv_metrics else False
        metrics[5] = True if "custom" in argv_metrics else False
        if not any(metrics):
            exit_message("No metric is selected")
        if metrics[5]:
            sp_metrics = argv_metrics.split(",")
            custom_index = ["custom" in metric for metric in sp_metrics].index(True)
            custom_metric = sp_metrics[custom_index]
            custom_path_index = custom_metric.index(":")+1
            custom_metric_file = custom_metric[custom_path_index:].strip()
            if not os.path.isfile(custom_metric_file):
                exit_message("Custom metric file doesn\"t exist")
    if argv.o:
        if os.path.exists(argv.o):
            os.remove(argv.o)
        else:
            create_dirs_from_path(os.path.dirname(argv.o))
    mathematica = "wolfram" if tool_installed("wolfram") else "wolframscript"
    args = {
        "input_file": argv.f,
        "directory": argv.r,
        "output_file": argv.o,
        "explict_eps": argv.e,
        "noise_percentage": float(argv.p) if argv.p else 0.1,
        "metrics": metrics,
        "custom_metric_file": custom_metric_file,
        "math_timeout": argv.tm,
        "psi_timeout": argv.tp,
        "verbose": argv.verbose,
        "plain": argv.plain,
        "log": argv.log,
        "numeric": argv.n,
        "optimization": argv.s,
        "mathematica": mathematica,
        "skip_run": argv.k
    }
    return args

def check_cmd():
    if not tool_installed("psi"):
         exit_message("Please include \"psi\" into your PATH.")
    if not tool_installed("wolfram") and not tool_installed("wolframscript"):
        exit_message("Please include \"wolfram\" or \"wolframscript\" into your PATH.")

def main():
    args = init_args()
    if not args["skip_run"]:
        check_cmd()
    if args["input_file"]:
        run_file(args)
    else:
        directory = args["directory"]
        for filename in os.listdir(directory):
            if filename.endswith(".psi"):
                args["input_file"] = os.path.join(directory, filename)
                if args["output_file"]:
                    print("Processing: "+ args["input_file"] + "\n")
                print_plain_results("\n" + args["input_file"] + ":", args["output_file"])
                run_file(args)

if __name__ == "__main__":
    main()
