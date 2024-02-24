# tmp
#!/bin/bash
set -e

COMFYUI_COMMIT=${COMFYUI_COMMIT:-master}
COMFYUI_MANAGER_COMMIT=${COMFYUI_MANAGER_COMMIT:-main}
USE_XFORMERS=${USE_XFORMERS:-false}

# Create a virtualenv if one doesn't exist.
if [ ! -d "./venv" ]; then
    python3 -m venv venv
fi

# Upgrade pip
/comfyui/venv/bin/python -m pip install --upgrade pip

# Clone ComfyUI if it doesn't exist.
if [ ! -d "/comfyui/.git" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui
fi

# Checkout the specified commit.
cd /comfyui
git fetch
git checkout $COMFYUI_COMMIT

# Install ComfyUI Manager
if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager/.git" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
fi
cd /comfyui/custom_nodes/ComfyUI-Manager
git fetch
git checkout $COMFYUI_MANAGER_COMMIT

# Install InstantID
if [ ! -d "/comfyui/custom_nodes/ComfyUI-InstantID/.git" ]; then
    git clone https://github.com/huxiuhan/ComfyUI-InstantID.git /comfyui/custom_nodes/ComfyUI-InstantID
fi
cd /comfyui/custom_nodes/ComfyUI-InstantID
git fetch
git checkout main

# /comfyui/venv/bin/pip install -r requirements.txt
# download required models
# exec /comfyui/venv/bin/python download_models.py

cd /comfyui

# Install PyTorch based on the value of USE_XFORMERS, because otherwise xformers overrides the PyTorch version.
if [ "$USE_XFORMERS" = true ]; then
    /comfyui/venv/bin/pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
else
    /comfyui/venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
fi

# Install other dependencies.
/comfyui/venv/bin/pip install -r requirements.txt

# install oonxruntime-gpu for controlnet
/comfyui/venv/bin/pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

# Start ComfyUI.
exec /comfyui/venv/bin/python main.py --listen 0.0.0.0 --preview-method auto --output-directory /stable_diffusion/output