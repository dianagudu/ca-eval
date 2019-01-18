#!/bin/bash

## validate script arguments:
## $1: base directory where dataset (generated instances) will be saved
## $2, ...: scripts to set search space for parameter sweep; will be sourced sequentially

if [[ $# -lt 2 ]]; then
    echo 'Please provide at least 2 arguments: dataset directory and script(s) containing lists of values for parameter sweep'
    exit
fi

## source ca-ingen python env
source ~/anaconda3.x/bin/activate ca-ingen

### command to create auction instance
CAGECLI=../ca-ingen/cagecli.py

## base directory where data is saved (create if it doesn't exist)
BASE=$1
if [ ! -d $BASE ]; then
    mkdir $BASE
fi
## directory where models are located
MODELS_DIR=models

## number of instances to generate for each set of params 
COUNT=4
## temporary file to save input params for cagecli tool
INPUT=/tmp/asp
## prefix for instance names
OUTPUT=$BASE/instance

## instance uid
i=0

for PARAM_SPACE in ${@:2}; do

echo "Sweeping $PARAM_SPACE ..."

## space for parameter sweep
source $PARAM_SPACE

echo "$V_BIDS_N,$V_BIDS_MODEL,$V_BIDS_BINNING_TYPE,$V_BIDS_BINNING_COUNTS,$V_BIDS_DOMAIN,$V_ASKS_N,$V_ASKS_MODEL,$V_ASKS_BINNING_TYPE,$V_ASKS_BINNING_COUNTS,$V_ASKS_DOMAIN,$V_SLOPE,$V_FIXED,$V_DIST_MEANS,$V_A_SIGMA,$V_B_SIGMA
"
echo "=========="

## set placeholders in template_auction_set_params
for BIDS_N in $V_BIDS_N; do
for BIDS_MODEL in $V_BIDS_MODEL; do
for BIDS_BINNING_TYPE in $V_BIDS_BINNING_TYPE; do
for BIDS_BINNING_COUNTS in $V_BIDS_BINNING_COUNTS; do
for BIDS_DOMAIN in $V_BIDS_DOMAIN; do
for ASKS_N in $V_ASKS_N; do
for ASKS_MODEL in $V_ASKS_MODEL; do
for ASKS_BINNING_TYPE in $V_ASKS_BINNING_TYPE; do
for ASKS_BINNING_COUNTS in $V_ASKS_BINNING_COUNTS; do
for ASKS_DOMAIN in $V_ASKS_DOMAIN; do
for SLOPE in $V_SLOPE; do
for FIXED in $V_FIXED; do
for DIST_MEANS in $V_DIST_MEANS; do
for A_SIGMA in $V_A_SIGMA; do
for B_SIGMA in $V_B_SIGMA; do

echo "[$BIDS_N,$BIDS_MODEL,$BIDS_BINNING_TYPE,$BIDS_BINNING_COUNTS,$BIDS_DOMAIN,$ASKS_N,$ASKS_MODEL,$ASKS_BINNING_TYPE,$ASKS_BINNING_COUNTS,$ASKS_DOMAIN,$SLOPE,$FIXED,$DIST_MEANS,$A_SIGMA,$B_SIGMA
]"

cat > $INPUT << EOF
bids:
    amount: ${BIDS_N}
    model: ${BIDS_MODEL}
    binning_type: ${BIDS_BINNING_TYPE}
    binning_counts: ${BIDS_BINNING_COUNTS}
    domain: ${BIDS_DOMAIN}
asks:
    amount: ${ASKS_N}
    model: ${ASKS_MODEL}
    binning_type: ${ASKS_BINNING_TYPE}
    binning_counts: ${ASKS_BINNING_COUNTS}
    domain: ${ASKS_DOMAIN}
cost_model:
    slope: ${SLOPE}
    fixed: ${FIXED}
valuations:
    dist_means: ${DIST_MEANS}
    a_sigma: ${A_SIGMA}
    b_sigma: ${B_SIGMA}
EOF

python $CAGECLI create --count $COUNT $INPUT ${OUTPUT}.${i}

echo "Created ${OUTPUT}.${i}"
echo "..."

((i++))

done
done
done
done
done
done
done
done
done
done
done
done
done
done
done

echo "=========="

done