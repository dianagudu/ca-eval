#!/bin/bash

## this script assumes all models have 3 resource types

V_BIDS_N=1000
V_BIDS_MODEL="models/model-uniform3* models/model-hotspots3* models/model-part-0000*"
V_BIDS_BINNING_TYPE='regular g2progression'
V_BIDS_BINNING_COUNTS='16 8'
V_BIDS_DOMAIN='[128,128,128]'
V_ASKS_N=1000
V_ASKS_MODEL="models/model-uniform3* models/model-hotspots3* models/model-part-0000*"
V_ASKS_BINNING_TYPE='regular'
V_ASKS_BINNING_COUNTS='8'
V_ASKS_DOMAIN='[128,128,128]'
V_SLOPE='[1,1,1] [1,0.9,0.5] [1.1,1,0.9]'
V_FIXED='[0,0,0] [0,0,0.1]'
V_DIST_MEANS='0.0 0.1 0.5'
V_A_SIGMA='0.05 0.1 0.25'
V_B_SIGMA='0.05 0.1 0.25'