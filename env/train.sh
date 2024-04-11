#!/bin/bash

python3 director/train.py \
	--logdir /logdir/$(date +%Y%m%d-%H%M%S) \
	--configs=$1 \
	--task=$2
