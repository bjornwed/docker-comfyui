FROM python:3.11-slim as builder

# Set environment variables in a single layer
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_OUTPUT=/stable_diffusion/output \
    USE_XFORMERS=false \
    TINI_VERSION=v0.19.0 \
    # path for tensorrt
    LD_LIBRARY_PATH=/comfyui/venv/lib/python3.11/site-packages/tensorrt_lean_libs \
    NUMEXPR_MAX_THREADS=16

WORKDIR /comfyui

# Install system dependencies and clean up in one layer
RUN apt-get update && apt-get install -y --no-install-recommends build-essential wget git && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment and upgrade pip, install Python packages in one layer
RUN python3 -m venv venv && \
    venv/bin/python -m pip install --upgrade pip && \
    venv/bin/python -m pip install --upgrade setuptools wheel
 
# Install PyTorch based on the value of USE_XFORMERS, because otherwise xformers overrides the PyTorch version.
RUN    if [ "$USE_XFORMERS" = "true" ]; then venv/bin/pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; else venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; fi 

ENTRYPOINT ["/tini", "--"]

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8188
CMD ["/init.sh"]
