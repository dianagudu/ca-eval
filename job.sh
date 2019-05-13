#!/bin/bash
#MSUB -l nodes=1:ppn=16
#MSUB -l walltime=3:00:00:00
#MSUB -l mem=32000mb
#MSUB -v EXECUTABLE=$HOME/ca-portfolio/bin/main
#MSUB -N combinatorial_auctions_compare

## script arguments:
## $1: mode to run portfolio in: heuristics, all (i.e. including CPLEX) and samples
## $2: task queue (task = auction instances to run portfolio on) (absolute path)
## $3: output file prefix (absolute path)

if [[ $# -ne 3 ]]; then
    echo 'Please provide 3 arguments:'
    echo '  1. run mode (heuristics/all/samples)'
    echo '  2. task queue (task = list of auction instances) (absolute path)'
    echo '  3. output file (absolute path)'
    exit
fi

MODE=$1
TASK_QUEUE=$2
OUTFILE=$3

# prepare environment
module load compiler/gnu/8.2
export LD_LIBRARY_PATH=/home/kit/scc/rg7642/boost_1_69_0/stage/lib:/home/kit/scc/rg7642/yaml-cpp/build:$LD_LIBRARY_PATH

source ${HOME}/anaconda3/bin/activate ""

# paths to runportfolio script and 
export BASE=${HOME}/ca-eval
export PORTFOLIO=${HOME}/ca-portfolio/bin/main

echo "Starting python ..."
python ${BASE}/task_queue_processor.py "${TASK_QUEUE}" &
sleep 10
echo "Python running."


# run experiment
for nrun in `seq 1 16`; do
    ${BASE}/runportfolio.sh $PORTFOLIO $MODE $TASK_QUEUE ${OUTFILE}.${nrun} &
    pids[${nrun}]=$!
done

for pid in ${pids[*]}; do
    wait $pid
done
