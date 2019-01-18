#!/bin/bash

## script arguments:
## $1: mode to run portfolio in: heuristics, all (i.e. including CPLEX) and samples
## $2: folder where dataset (auction instances) is stored
## $3: output file prefix

## split instances in dataset into 50 task queues
## submit 50 jobs to run portfolio on each task queue