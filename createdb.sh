#!/bin/bash

### source inputgen python env
source ~/anaconda3.x/bin/activate inputgen

### base directory where data is saved
BASE=`pwd`
### command to create datasource
ingencli=../inputgen/ingencli.py

### preprocess cloud traces and create datasources
# python ${ingencli} create datasource bitbrains ${BASE}/db/bitbrains_fastStorage ${BASE}/cloud_traces/bitbrains/fastStorage/2013-8/
#
# python ${ingencli} create datasource uniform ${BASE}/db/uniform3 3
# python ${ingencli} create datasource uniform ${BASE}/db/uniform4 4
# python ${ingencli} create datasource uniform ${BASE}/db/uniform5 5
#
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots3_4 3 4
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots3_8 3 8
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots3_16 3 16
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots3_32 3 32
#
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots4_4 4 4
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots4_8 4 8
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots4_16 4 16
# python ${ingencli} create datasource hotspots ${BASE}/db/hotspots4_32 4 32
#
## for file in ${BASE}/cloud_traces/google/task_usage/*.csv; do
##   basef=${f##*/}  # this gets rid of path prefix
##   basef=${basef%%.csv*}; basef=${basef%%.*}  # this gets rid of csv.gz or csv
##   python ${ingencli} create datasource google $basef $file
## done
#

## function to create model for given datasource using binning of given type and amounts
## params: datasource prefix, type, nbins
function create_models {
    prefix=$1
    type=$2
    nbins=$3
    for f in ${BASE}/db/${prefix}*.csv; do
        file=${f%%.*}
        basef=${file##*/}
        python ${ingencli} create binning --datasource $file $type $nbins /tmp/binning
        python ${ingencli} create model $file /tmp/binning ${BASE}/models/model-${basef}-${type}${nbins}
    done
}

### create 2 models for each datasource: one with regular binning of 8, another one with clustered binning of 16
### use 4 bins per dimension for larger number of dimensions
# uniform dataset
create_models uniform3 regular 8
create_models uniform4 regular 4
create_models uniform5 regular 4
# hotspots datasets
create_models hotspots3 regular 8
create_models hotspots3 clustered 16
create_models hotspots4 regular 4
# bitbrains dataset
create_models bitbrains regular 8
create_models bitbrains clustered 16
# google datasets
create_models part regular 8
create_models part clustered 16