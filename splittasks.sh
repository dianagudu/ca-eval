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
##
ls -d $DATASET/* > /tmp/tasks
split -n l/$N_Q --numeric-suffixes=1 /tmp/tasks $Q_PREFIX.
rm /tmp/tasks


## in case the jobs crashed/were interrupted before the task queues were emptied,
## comment the splitting code (the 3 lines above) and uncomment the code below, which:
## erases last processed instance from the stats file (most likely incompletely processed),
## and adds it back to the beginning of the task queue
##
#for task in `ls ${Q_PREFIX}.*`
#do
#    job="${task##*.}"
#    statf=$OUT_PREFIX.${job}
#    instance=`tail -n 1 $statf | awk -F, '{print $1}'`
#    binstance=`echo $instance | awk -F/ '{print $8}'`
#    echo $statf '====>' $instance '====>' $binstance
#    sed -i "/$binstance/d" $statf
#    echo $instance $'\n'"$(cat $task)" > $task
#done

for task in `ls ${Q_PREFIX}.*`
do
    job="${task##*.}"
    echo msub -q singlenode job.sh $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}
    msub -q singlenode job.sh $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}

   ## alternatively, run locally and sequentially
   ## ./runportfolio.sh ../ca-portfolio/bin/main $MODE $Q_PREFIX.${job} $OUT_PREFIX.${job}
done

