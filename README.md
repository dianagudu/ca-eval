# ca-eval
Collection of scripts to generate combinatorial auctions datasets and evaluate ca-portfolio on these datasets.

### list of scripts

* createdb.sh: processes cloud traces to create datasources, then creates several models for input generation
* gendataset.sh: generates arbitrary datasets from given parameter spaces
* dataset-ca-compare-params-{3,4}dims.sh: parameter spaces used to generate a dataset for algorithm comparison
* runportfolio.sh: runs the algorithm portfolio in a given mode and on a given task queue (list of instances)
* splittasks.sh: creates a number of tasks queues for a given dataset and submits a job per worker/task queue

### usage

    ./createdb.sh
    # ./gendataset.sh DATASET_DIR DATASET_PARAM_SPACE(S) ...
    ./gendataset.sh dataset-ca-compare dataset-ca-compare-params-3dims.sh dataset-ca-compare-params-4dims.sh
    ./runportfolio.sh MODE TASK_QUEUE OUTFILE
    ./splittasks.sh DATASET NUM_WORKERS TASK_QUEUE_PREFIX MODE OUTFILE_PREFIX
    # run algorithm comparison jobs on bwunicluster
    ./splittasks.sh $WORK/ca-datasets/ca-compare-3dims 50 $WORK/ca-tasks/ca-compare-3dims all $WORK/ca-stats/ca-compare-3dims
