#!/bin/bash

## this script assumes all models have 4 resource types
## total number of instances to be generated: 11664

V_BIDS_N=1000
V_BIDS_MODEL="models/model-uniform4* models/model-hotspots4_16* models/model-bitbrains*clustered*"
V_BIDS_BINNING_TYPE='regular'
V_BIDS_BINNING_COUNTS='16 8'
V_BIDS_DOMAIN='[128,128,128,128]'
V_ASKS_N=1000
V_ASKS_MODEL="models/model-uniform4* models/model-hotspots4_16* models/model-bitbrains*clustered*"
V_ASKS_BINNING_TYPE='regular'
V_ASKS_BINNING_COUNTS='8'
V_ASKS_DOMAIN='[128,128,128,128]'
V_SLOPE='[1,1,1,1] [1,0.9,0.5,1] [1.1,1,0.9,1]'
V_FIXED='[0,0,0,0] [0,0,0.1,0]'
V_DIST_MEANS='0.0 0.1 0.5'
V_A_SIGMA='0.05 0.1 0.25'
V_B_SIGMA='0.05 0.1 0.25'