FROM python:3.12-slim 
COPY --from=ghcr.io/astral-sh/uv:0.6.10 /uv /uvx /bin/

# Set environment variables in a single layer
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_INPUT=/comfyui_in_out/input \
    COMFYUI_OUTPUT=/comfyui_in_out/output \
    TINI_VERSION=v0.19.0 \
    # path for tensorrt
    # LD_LIBRARY_PATH=/comfyui/venv/lib/python3.11/site-packages/tensorrt_libs \
    NUMEXPR_MAX_THREADS=16 \
    PIP_ROOT_USER_ACTION=ignore \
    PATH="/root/.local/bin/:$PATH" \
    COMPOSE_BAKE=true
WORKDIR /comfyui

COPY ./init.sh /init.sh

# Install system dependencies and clean up in one layer
RUN apt-get update && apt-get install -y --no-install-recommends build-essential wget git ffmpeg libsm6 libxext6 cmake && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini && \
    chmod +x /init.sh && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip, install Python packages in one layer
# protobuf, coloredlogs
RUN uv pip install --upgrade pip setuptools wheel protobuf coloredlogs flatbuffers \
    onnxruntime-gpu torch torchvision torchaudio triton sageattention \
    --system --no-cache-dir --force-reinstall \
    --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
    --extra-index-url https://download.pytorch.org/whl/cu126 \
    --index-strategy unsafe-best-match

ENTRYPOINT ["/tini", "--"] 
EXPOSE 8188
CMD ["/init.sh"]