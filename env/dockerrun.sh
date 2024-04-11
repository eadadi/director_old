#!/bin/bash

docker run --rm -it --network host \
	-v $(pwd):/code \
	-v /home/ec2-user/drive/project/logdit:/logdir \
	-w /code \
	$1 bash
