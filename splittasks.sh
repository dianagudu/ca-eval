#!/bin/bash

## script arguments:
## $1: folder where dataset (auction instances) is stored (absolute path)
## $2: number of task queues to create
## $3: task queue file prefix (absolute path)
## $4: mode to run portfolio in: heuristics, all (i.e. including CPLEX) and samples
## #5: stats output file prefix (absolute path)

if [[ $# -ne 5 ]]; then
    echo 'Please provide 5 arguments:'
    echo '  1. dataset folder containing auction instances (absolute path)'
    echo '  2. number of task queues to create'
    echo '  3. prefix name for task queue files (absolute path)'
    echo '  4. run mode (heuristics/all/samples)'
    echo '  5. stats output file prefix (absolute path)'
    exit
fi

DATASET=$1
N_Q=$2
Q_PREFIX=$3
MODE=$4
OUT_PREFIX=$5

## verify existence of dataset folder
if [ ! -d $DATASET ]; then
    echo "Dataset '$DATASET' not found."
    exit
fi

## verify integer NQUEUES
if ! [[ $N_Q =~ ^[0-9]+$ ]]; then
    echo "Number of queues '$N_Q' is not an integer."
    exit
fi

## split instances in dataset into task queues
## submit jobs to run portfolio on each task queue

ls -d $DATASET/* > /tmp/tasks
split -n l/$N_Q --numeric-suffixes=1 /tmp/tasks $Q_PREFIX.
rm /tmp/tasks


for task in `ls ${Q_PREFIX}.*`
do
    job="${task##*.}"
    echo msub -q singlenode job.sh $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}
    msub -q singlenode job.sh $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}

   ## alternatively, run locally and sequentially
   ## ./runportfolio.sh ../ca-portfolio/bin/main $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}
done

