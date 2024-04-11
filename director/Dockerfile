# 1. Test setup:
# docker run -it --rm --gpus all tensorflow/tensorflow:2.8.0-gpu nvidia-smi
#
# 2. Start training:
# docker build -f  agents/director/Dockerfile -t img . && \
# docker run -it --rm --gpus all -v ~/logdir:/logdir img \
#   sh xvfb_run.sh python3 agents/director/train.py \
#   --logdir "/logdir/$(date +%Y%m%d-%H%M%S)" \
#   --configs dmc_vision --task dmc_walker_walk
#
# 3. See results:
# tensorboard --logdir ~/logdir

# System
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONUNBUFFERED 1
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git xvfb curl \
    libglu1-mesa libglu1-mesa-dev libgl1-mesa-dev libosmesa6-dev mesa-utils freeglut3 freeglut3-dev \
    libglew2.1 libglfw3 libglfw3-dev libegl-dev zlib1g zlib1g-dev libsdl2-dev libjpeg-dev lua5.1 liblua5.
-0-dev libffi-dev \
    build-essential cmake g++ build-essential pkg-config software-properties-common gettext \
    ffmpeg patchelf swig unrar unzip zip curl wget tmux \
    && rm -rf /var/lib/apt/lists/*
#RUN rm /etc/apt/sources.list.d/cuda.list
#RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-get update && apt-get install -y \
  apt ffmpeg git python3-pip vim wget unrar \
  && apt-get clean

# Envs
RUN pip3 install --no-cache-dir crafter
RUN pip3 install --no-cache-dir robodesk
RUN pip3 install --no-cache-dir dm_control
COPY scripts scripts

RUN pip3 install \
        atari-py==0.2.9 \
        opencv-python==4.8.0.74 \
        gym==0.19.0
RUN wget -L -nv http://www.atarimania.com/roms/Roms.rar && \
    unrar x -y Roms.rar && \
    python3 -m atari_py.import_roms ROMS && \
    rm -rf Roms.rar ROMS.zip ROMS


ENV MUJOCO_GL egl

# Agent
RUN pip3 install --no-cache-dir dm-sonnet
#RUN pip3 install --no-cache-dir tensorflow_probability
RUN pip3 install \
    tensorflow_probability==0.20.1 \
    yacs==0.1.8 \
    tensorflow[and-cuda]==2.12.0

ENV TF_FUNCTION_JIT_COMPILE_DEFAULT 1
ENV XLA_PYTHON_CLIENT_MEM_FRACTION 0.8

# Embodied
RUN pip3 install --no-cache-dir numpy cloudpickle ruamel.yaml rich
COPY . /embodied
RUN chown -R 1000:root /embodied && chmod -R 775 /embodied
WORKDIR /embodied

CMD [ \
    "python3", "agents/director/train.py" \
    "--logdir=/logdir/$(date +%Y%m%d-%H%M%S)" \
    "--configs=dmc_vision", \
    "--task=dmc_walker_walk" \
]
