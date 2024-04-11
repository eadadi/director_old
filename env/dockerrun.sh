#!/bin/bash

# Launch from director main folder
docker run --rm -it --network host \
	-v $(pwd):/code \
	-v /home/ec2-user/drive/project/logdit:/logdir \
	-w /code \
	mydirector bash
