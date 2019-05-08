# ca-eval
Collection of scripts to generate combinatorial auctions datasets and evaluate ca-portfolio on these datasets.

### prerequisites

* [CAGE](https://github.com/dianagudu/ca-ingen): input generator for combinatorial auctions
* [ca-portfolio](https://github.com/dianagudu/ca-portfolio): potfolio of algorithms for solving double combinatorial auctions 

### list of scripts

* [createdb.sh](createdb.sh): processes cloud traces to create datasources, then creates several models for input generation
* [gendataset.sh](gendataset.sh): generates arbitrary datasets from given parameter spaces
* params-ca-compare-{[3](params-ca-compare-3dims.sh),[4](params-ca-compare-4dims.sh)}dims.sh: parameter spaces used to generate a dataset for algorithm comparison
* [params-malaise.sh](params-malaise.sh): parameter space used to generate a dataset for ML-based algorithm selection
* [runportfolio.sh](runportfolio.sh): runs the algorithm portfolio in a given mode and on a given task queue (list of instances)
* [splittasks.sh](splittasks.sh): creates a number of tasks queues for a given dataset and submits a job per worker/task queue

### usage

    ./createdb.sh

    # generate datasets consisting of multiple auction instances
    # ./gendataset.sh DATASET_DIR DATASET_PARAM_SPACE(S) ...
    ./gendataset.sh $WORK/ca-datasets/ca-compare-3dims params-ca-compare-3dims.sh
    ./gendataset.sh $WORK/ca-datasets/ca-compare-4dims params-ca-compare-4dims.sh
    ./gendataset.sh $WORK/ca-datasets/malaise params-malaise.sh

    # run portfolio on a set of instances taken from a task queue
    # script typically used internally in splittasks
    ./runportfolio.sh MODE TASK_QUEUE OUTFILE

    # ./splittasks.sh DATASET NUM_WORKERS TASK_QUEUE_PREFIX MODE OUTFILE_PREFIX
    # submit jobs on bwunicluster
    ./splittasks.sh $WORK/ca-datasets/ca-compare-3dims 50 $WORK/ca-tasks/ca-compare-3dims all $WORK/ca-stats/ca-compare-3dims
    ./splittasks.sh $WORK/ca-datasets/ca-compare-4dims 50 $WORK/ca-tasks/ca-compare-4dims all $WORK/ca-stats/ca-compare-4dims
    ./splittasks.sh $WORK/ca-datasets/malaise 50 $WORK/ca-tasks/malaise heuristics $WORK/ca-stats/malaise
    ./splittasks.sh $WORK/ca-datasets/malaise 50 $WORK/ca-tasks/praise samples $WORK/ca-stats/praise

where $WORK is your work directory (examples were run on [bwUniCluster](https://www.scc.kit.edu/dienste/bwUniCluster.php))

### remarks

* The models used to generate the datasets are included in the repository [models](models/)
* New models can be created from the datasources (processed cloud traces) --> see commented lines in [createdb.sh](createdb.sh)
* Datasources were created by processing real cloud traces:
    * [Google Cluster data](https://github.com/google/cluster-data)
    * [Bitbrains fastStorage data](http://gwa.ewi.tudelft.nl/datasets/gwa-t-12-bitbrains)
