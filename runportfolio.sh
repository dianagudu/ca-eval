#!/bin/bash

## script arguments:
## $1: path to executable portfolio (absolute path)
## $2: mode to run portfolio in: heuristics, all (i.e. including CPLEX) and samples
## $3: task queue (task = auction instances to run portfolio on) (absolute path)
## $4: output file prefix (absolute path)

if [[ $# -ne 4 ]]; then
    echo 'Please provide 4 arguments:'
    echo '  1. path to executable portfolio (absolute path)'
    echo '  2. run mode (heuristics/all/samples)'
    echo '  3. task queue (task = list of auction instances) (absolute path)'
    echo '  4. output file (absolute path)'
    exit
fi

PORTFOLIO=$1
MODE=$2
TASK_QUEUE=$3
OUTFILE=$4

## validate mode
if [[ ! $MODE =~ ^(all|heuristics|samples)$ ]]; then
    echo "Mode '$MODE' invalid. Valid modes: all, heuristics, samples."
    exit
fi

## verify existence of task queue
if [ ! -f $TASK_QUEUE ]; then
    echo "Task queue '$TASK_QUEUE' not found."
    exit
fi

## function that pops a task from file
## i.e. reads the first line, erases is and returns it
function pop {
    QUEUE=$1
    echo `head -1 $QUEUE`
    sed -i 1d $QUEUE
}

## loop to pop task containing list of instances from queue 
while [ -s $TASK_QUEUE ]; do
    INSTANCES=`pop $TASK_QUEUE`
    #echo ${PORTFOLIO} -m $MODE -o $OUTFILE $INSTANCES
    ${PORTFOLIO} -m $MODE -o $OUTFILE $INSTANCES
done
