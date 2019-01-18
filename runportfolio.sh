#!/bin/bash

## script arguments:
## $1: mode to run portfolio in: heuristics, all (i.e. including CPLEX) and samples
## $2: task queue (task = auction instances to run portfolio on)
## $3: output file prefix

if [[ $# -ne 3 ]]; then
    echo 'Please provide 3 arguments:'
    echo '  1. run mode (heuristic/all/samples)'
    echo '  2. task queue (task = list of auction instances)'
    echo '  3. output file'
    exit
fi

MODE=$1
TASK_QUEUE=$2
OUTFILE=$3

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

## executable for portfolio
PORTFOLIO=../ca-portfolio/bin/main

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
    echo ./${PORTFOLIO} -m $MODE -o $OUTFILE $INSTANCES
    #./${PORTFOLIO} -m $MODE -o $OUTFILE $INSTANCES
done