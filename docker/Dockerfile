# Use multi-stage build to minimize final image size
# Stage 1: Build stage for installing dependencies and setting up the environment
FROM python:3.11-slim as builder

# Set environment variables in a single layer
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    USE_XFORMERS=false \
    OUTPUT_DIR="/stable_diffusion/output" \
    TINI_VERSION=v0.19.0 \
    LD_LIBRARY_PATH=/comfyui/venv/lib/python3.11/site-packages/tensorrt_lean_libs \
    # trying to set path for tensorrt
    GEMINI_API_KEY=


WORKDIR /comfyui

# Install system dependencies and clean up in one layer
RUN apt-get update && apt-get install -y --no-install-recommends build-essential wget && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment and upgrade pip, install Python packages in one layer
RUN python3 -m venv venv && \
    venv/bin/python -m pip install --upgrade pip && \
    venv/bin/python -m pip install --upgrade setuptools wheel
 
# Install PyTorch based on the value of USE_XFORMERS, because otherwise xformers overrides the PyTorch version.
RUN    if [ "$USE_XFORMERS" = "true" ]; then venv/bin/pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; else venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; fi 
    # install tensorRT - test
# RUN venv/bin/python -m pip install --upgrade tensorrt_lean

# Clone the necessary GitHub repositories and checkout the specified commits
# RUN if [ ! -d "/comfyui/.git" ]; then \
#     git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui; \
#     fi && \
#     cd /comfyui && \
#     git fetch && \
#     git checkout ${COMFYUI_COMMIT} 
    # && \
    # if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager/.git" ]; then \
    # git clone https://github.com/ltdrdata/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager; \
    # fi && \
    # git -C /comfyui/custom_nodes/ComfyUI-Manager checkout ${COMFYUI_MANAGER_COMMIT} && \
    # if [ ! -d "/comfyui/custom_nodes/ComfyUI-InstantID/.git" ]; then \
    # git clone https://github.com/huxiuhan/ComfyUI-InstantID.git /comfyui/custom_nodes/ComfyUI-InstantID; \
    # fi && \
    # git -C /comfyui/custom_nodes/ComfyUI-InstantID checkout ${COMFYUI_INSTANTID_COMMIT}

# Install Python dependencies assuming requirements.txt is part of the cloned repos
# RUN venv/bin/pip install -r requirements.txt

# Stage 2: Runtime stage to create the final slim image
FROM python:3.11-slim

# Copy Tini from the builder stage
COPY --from=builder /tini /tini

# Install git in the final image
RUN apt-get update && apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV OUTPUT_DIR="/stable_diffusion/output"

WORKDIR /comfyui

# Copy the virtual environment from the builder stage
COPY --from=builder /comfyui /comfyui

ENTRYPOINT ["/tini", "--"]

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8188
CMD ["/init.sh"]
