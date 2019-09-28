#!/usr/bin/env bash

function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }
script_dir=$(realpath $(dirname ${BASH_SOURCE[0]}))

while getopts f:p: option
do
    case "${option}"
        in
        f) rawfile=${OPTARG};;
        p) param=${OPTARG};;
        #e) eps=${OPTARG};;
    esac
done

rawfilepath=$(dirname $(realpath $rawfile))
rawfilename=$(basename $rawfile)
ed2file=${rawfilepath}_ED2_eps/${rawfilename%.*}_ED2_eps${param}.psi
# if [ ! -e $ed2file ]; then
    >&2 tput setaf 2
    >&2 python3 $script_dir/../psense.py -f $rawfile -m expdist2 -p 0.1 -log -k 
    >&2 tput sgr0
# fi

num_params=0
num_params=$(ls ${rawfilepath}_ED2_eps/${rawfilename%.*}_ED2_eps*.psi | wc -l)
>&2 tput setaf 1
>&2 echo "//Total ${num_params} parameters"
>&2 echo "//Sampling ED2 with eps=$eps for parameter $param"
>&2 echo "//========WebPPL Code for ${rawfilename%.*}_ED2_eps$param.wppl========"
>&2 tput sgr0

# sed "s/globalStore.eps/\\$eps/g" |
if [ $num_params -ge $param ]; then
    range=$(cat ${rawfilepath}_log/${rawfilename%.*}_log${param}.log)
    java -jar $script_dir/psi2webppl.jar $ed2file 2>/dev/null |  sed "s/Infer({.*},main)/map(function(eps){globalStore.eps=eps; return expectation(Infer({method: 'MCMC', samples: 1000},main))},[\\$range])/" | awk '/var main = function()/ && c == 0 {c = 1; print "var abs = function(v){return v>0?v:-v}"}; {print}' 
else
    echo "Error: no such parameter"
fi

rm -r ${rawfilepath}_ED2_eps
rm -r ${rawfilepath}_eps
rm -r ${rawfilepath}_exp_eps
rm -r ${rawfilepath}_exp
rm -r ${rawfilepath}_log
rm -r ${rawfilepath}_math
