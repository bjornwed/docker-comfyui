FROM nvidia/cuda:12.5.1-cudnn-runtime-ubuntu22.04
# Make sure nvidia drivers are v555+ and cuda 12.5.1 installed 
# Download nvidia base image
# update
# install system dependencies, not ComfyUI specifics
# install tini
# install python 3.12 + pip
## pytorch? recompile flash attention? https://www.reddit.com/r/comfyui/comments/1cylmbs/pytorch_nightly_24_with_cuda_124_speeds_up/


# Set environment variables in a single layer
ENV TZ=Europe/Stockholm \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_OUTPUT=/stable_diffusion/output \
    TINI_VERSION=v0.19.0 \
    PIP_ROOT_USER_ACTION=ignore

WORKDIR /comfyui

RUN apt update -y
RUN apt upgrade -y

# Install system dependencies and clean up in one layer
RUN apt install -y --no-install-recommends build-essential wget git ffmpeg libsm6 libxext6 cmake && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# add repository for python 3.12
RUN apt install -y software-properties-common 
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
# install python and pip
RUN apt install -y python3.12 python3.12-dev python3.12-venv python3.12-distutils
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.12 get-pip.py

# clean up
RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel                     
# RUN pip install protobuf coloredlogs flatbuffers onnx onnxruntime-gpu==1.18.0 opencv-python torchvision kornia xformers

# NOTE: May need to manually remove site-packages from venv/lib/python3.11 to clean up if getting conflicts with various versions of xformers and pytorch

# Install PyTorch based on the value of USE_XFORMERS, because otherwise xformers overrides the PyTorch version.
# RUN venv/bin/python -m pip install torch==2.2.1+cu121 torchvision torchaudio --upgrade --force-reinstall --index-url https://download.pytorch.org/whl/cu121

# install tensorflow
# RUN venv/bin/python -m pip install tensorflow[and-cuda]    

# upgrade xformers, torch, torchvision and torchaudio to latest version 
# venv/bin/python -m pip install torch==2.2.1+cu121 torchvision torchaudio -f https://download.pytorch.org/whl/torch_stable.html --extra-index-url https://download.pytorch.org/whl/cu121
# venv/bin/python -m pip install xformers==0.0.25
# venv/bin/python -m pip install torchvision==0.17.1
# RUN venv/bin/python -m pip install --upgrade xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 

# install apex
# RUN venv/bin/python -m pip install apex

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8188
# CMD ["sleep", "infinity"]

CMD ["/init.sh"]
