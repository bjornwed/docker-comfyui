# Stage 1: Build Python 3.12.3 from source
FROM ubuntu:24.04 AS python-builder

ARG PYTHON_VERSION=3.12.3

RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential wget libssl-dev zlib1g-dev libncurses5-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev \
    libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev uuid-dev \
    libffi-dev ca-certificates

WORKDIR /tmp

# Use Docker build cache for source builds
RUN --mount=type=cache,target=/root/.cache \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j"$(nproc)" && \
    make altinstall && \
    rm -rf /tmp/*

# Stage 2: Final runtime image
FROM nvcr.io/nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

COPY --from=ghcr.io/astral-sh/uv@sha256:57da96c4557243fc0a732817854084e81af9393f64dc7d172f39c16465b5e2ba /uv /uvx /bin/
COPY --from=python-builder /usr/local/bin/python3.12 /usr/local/bin/
COPY --from=python-builder /usr/local/bin/pip3.12 /usr/local/bin/
COPY --from=python-builder /usr/local/lib/python3.12 /usr/local/lib/python3.12

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_INPUT=/comfyui_in_out/input \
    COMFYUI_OUTPUT=/comfyui_in_out/output \
    TINI_VERSION=v0.19.0 \
    NUMEXPR_MAX_THREADS=16 \
    PIP_ROOT_USER_ACTION=ignore \
    PATH="/root/.local/bin/:$PATH" \
    COMPOSE_BAKE=true \
    UV_LINK_MODE=copy

WORKDIR /comfyui

# Install system dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
    wget git ffmpeg libsm6 libxext6 cmake && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini

# Use Python 3.12 by default
RUN ln -s /usr/local/bin/python3.12 /usr/bin/python3 && \
    ln -s /usr/local/bin/pip3.12 /usr/bin/pip3 && \
    python3 -m ensurepip && \
    python3 -m pip install --upgrade pip

# Install Python packages with uv
RUN uv pip install --upgrade pip setuptools wheel protobuf coloredlogs flatbuffers \
    onnxruntime-gpu torch torchvision torchaudio triton \
    --system --no-cache-dir --force-reinstall \
    --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
    --extra-index-url https://download.pytorch.org/whl/cu128 \
    --index-strategy unsafe-best-match


# Install Sage Attention 2 https://github.com/thu-ml/SageAttention

# RUN git clone https://github.com/thu-ml/sageattention.git && \
#     cd sageattention && \
#     uv pip install -e . --system --no-build-isolation    

# Clean up apt cache to reduce image size
RUN apt clean && rm -rf /var/lib/apt/lists/* /root/.cache /tmp/*

# Copy entrypoint script
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/tini", "--"]
EXPOSE 8188

CMD ["/init.sh"]

