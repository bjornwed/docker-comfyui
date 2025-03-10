FROM python:3.12-slim as builder

# Set environment variables in a single layer
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_INPUT=/comfy_in_out/input \
    COMFYUI_OUTPUT=/comfy_in_out/output \
    TINI_VERSION=v0.19.0 \
    # path for tensorrt
    # LD_LIBRARY_PATH=/comfyui/venv/lib/python3.11/site-packages/tensorrt_libs \
    NUMEXPR_MAX_THREADS=16

WORKDIR /comfyui

# Install system dependencies and clean up in one layer
RUN apt-get update && apt-get install -y --no-install-recommends build-essential wget git ffmpeg libsm6 libxext6 cmake && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip, install Python packages in one layer
RUN pip install --upgrade pip && \
    pip install --upgrade setuptools wheel  && \                     
    pip install protobuf coloredlogs flatbuffers tensorrt 
# NOTE: May need to manually remove site-packages from venv/lib/python3.11 to clean up if getting conflicts with various versions of xformers and pytorch

# Install PyTorch based on the value of USE_XFORMERS, because otherwise xformers overrides the PyTorch version.
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126

# RUN venv/bin/python -m pip install xformers torch==2.2.1+cu121 torchvision torchaudio --upgrade --force-reinstall --index-url https://download.pytorch.org/whl/cu121

# install tensorflow
# RUN venv/bin/python -m pip install tensorflow[and-cuda]    

# upgrade xformers, torch, torchvision and torchaudio to latest version 
# venv/bin/python -m pip install torch==2.2.1+cu121 torchvision torchaudio -f https://download.pytorch.org/whl/torch_stable.html --extra-index-url https://download.pytorch.org/whl/cu121
# venv/bin/python -m pip install xformers==0.0.25
# venv/bin/python -m pip install torchvision==0.17.1
# RUN venv/bin/python -m pip install --upgrade xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 

# install apex
# RUN venv/bin/python -m pip install apex

ENTRYPOINT ["/tini", "--"]

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8188
CMD ["/init.sh"]
