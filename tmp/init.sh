FROM python:3.8-slim

# Set environment variables for repository commits
ARG COMFYUI_COMMIT=master
ARG COMFYUI_MANAGER_COMMIT=main
ARG COMFYUI_INSTANTID_COMMIT=main
ENV USE_XFORMERS=false

# Create app directory
WORKDIR /comfyui

# Create a virtual environment and upgrade pip
RUN python3 -m venv venv && \
    /comfyui/venv/bin/python -m pip install --upgrade pip

# Pre-install PyTorch and ONNX runtime dependencies to leverage caching
RUN if [ "$USE_XFORMERS" = "true" ]; then \
        /comfyui/venv/bin/pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; \
    else \
        /comfyui/venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121; \
    fi && \
    /comfyui/venv/bin/pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

# Clone the necessary GitHub repositories and checkout the specified commits
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui && \
    git -C /comfyui checkout $COMFYUI_COMMIT && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager && \
    git -C /comfyui/custom_nodes/ComfyUI-Manager checkout $COMFYUI_MANAGER_COMMIT && \
    git clone https://github.com/huxiuhan/ComfyUI-InstantID.git /comfyui/custom_nodes/ComfyUI-InstantID && \
    git -C /comfyui/custom_nodes/ComfyUI-InstantID checkout $COMFYUI_INSTANTID_COMMIT

# Install Python dependencies (assuming requirements.txt is part of the cloned repos)
# Note: This assumes the requirements file is in the root of the ComfyUI repo.
RUN /comfyui/venv/bin/pip install -r /comfyui/requirements.txt

# install oonxruntime-gpu for controlnet
RUN /comfyui/venv/bin/pip install onnxruntime-gpu --upgrade --no-deps --force-reinstall --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ 
 

# Set the command to start ComfyUI
CMD ["/comfyui/venv/bin/python", "main.py", "--listen", "0.0.0.0", "--preview-method", "auto", "--output-directory", "/stable_diffusion/output"]