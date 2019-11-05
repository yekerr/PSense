#!/usr/bin/env bash

function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }
script_dir=$(dirname ${BASH_SOURCE[0]})
script_dir=$([[ "$script_dir" = /* ]] && echo "$script_dir" || echo "$PWD/${script_dir#./}")

while getopts f:p:n: option
do
    case "${option}"
        in
        f) rawfile=${OPTARG};;
        p) param=${OPTARG};;
        n) perc=${OPTARG};;
        #e) eps=${OPTARG};;
    esac
done


rawfilepath=$(dirname $([[ "$rawfile" = /* ]] && echo "$rawfile" || echo "$PWD/${rawfile#./}"))
rawfilename=$(basename $rawfile)
ed2file=${rawfilepath}_ED2_eps/${rawfilename%.*}_ED2_eps${param}.psi
# if [ ! -e $ed2file ]; then
    >&2 tput setaf 2
    >&2 python3 $script_dir/../psense.py -f $rawfile -m expdist2 -p $perc -log -k 
    >&2 tput sgr0
# fi

if [ ! -e ${rawfilepath}_ED2_eps/${rawfilename%.*}_ED2_eps*.psi ] ; then exit 0 ; fi &> /dev/null

num_params=0
num_params=$(ls ${rawfilepath}_ED2_eps/${rawfilename%.*}_ED2_eps*.psi | wc -l)
>&2 tput setaf 1
>&2 echo "//Total ${num_params} parameters"
>&2 echo "//Sampling ED1 for parameter $param"
>&2 echo "//========WebPPL Code for ${rawfilename%.*}_ED1_eps$param.wppl========"
>&2 tput sgr0

# sed "s/globalStore.eps/\\$eps/g" |
if [ $num_params -ge $param ]; then
    range=$(cat ${rawfilepath}_log/${rawfilename%.*}_log${param}.log)
    java -jar $script_dir/psi2webppl.jar $ed2file 2>/dev/null | sed "s/abs(main_acc() - main_eps())/main_acc() - main_eps()/" |  sed "s/Infer({.*},main)/var eps_list = [\\$range]/" | sed "/^var eps_list =.*/a\\
var sample_size = 1000\\
var sen_list = map(function(eps){globalStore.eps=eps; return abs(expectation(Infer({method: 'MCMC', samples: sample_size},main)))},eps_list)" | sed "/^var main = function().*/i\\
var abs = function(v){return v>0?v:-v}\\
" | sed -e "\$a\\
sen_list\\
viz.scatter(eps_list, sen_list)" 
    # awk '/var main = function()/ && c == 0 {c = 1; print "var abs = function(v){return v>0?v:-v}"}; {print}'
else
    echo "Error: no such parameter"
fi

rm -r ${rawfilepath}_ED2_eps &> /dev/null
rm -r ${rawfilepath}_eps &> /dev/null
rm -r ${rawfilepath}_exp_eps &> /dev/null
rm -r ${rawfilepath}_exp &> /dev/null
rm -r ${rawfilepath}_log &> /dev/null
rm -r ${rawfilepath}_math &> /dev/null
