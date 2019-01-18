# ca-eval
Collection of scripts to generate combinatorial auctions datasets and evaluate ca-portfolio on these datasets.

### list of scripts

* createdb.sh: processes cloud traces to create datasources, then creates several models for input generation
* gendataset.sh: generates arbitrary datasets from given parameter spaces
* dataset-ca-compare-params-{3,4}dims.sh: parameter spaces used to generate a dataset for algorithm comparison

### usage

    ./createdb.sh
    # ./gendataset.sh DATASET_DIR DATASET_PARAM_SPACE(S) ...
    ./gendataset.sh dataset-ca-compare dataset-ca-compare-params-3dims.sh dataset-ca-compare-params-4dims.sh
