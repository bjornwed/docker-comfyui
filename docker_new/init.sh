#!/bin/bash
set -e

COMFYUI_COMMIT=${COMFYUI_COMMIT:-master}
COMFYUI_MANAGER_COMMIT=${COMFYUI_MANAGER_COMMIT:-main}
COMFYUI_INPUT=${COMFYUI_INPUT:-/comfyui_in_out/input}
COMFYUI_OUTPUT=${COMFYUI_OUTPUT:-/comfyui_in_out/output}

cd /comfyui
# create virtual env if not exists
# required to persist container restart

# upgrade pip
pip install --upgrade pip

# Clone ComfyUI if it doesn't exist.
if [ ! -d "/comfyui/.git" ]; then
    # need to clone to a temp dir as /comfyui isn't empty at this point
    git clone --no-checkout https://github.com/comfyanonymous/ComfyUI.git /comfyui/.tmp
    # then move the .git folder 
    mv /comfyui/.tmp/.git /comfyui
fi
# Checkout the specified commit.
git fetch
git checkout $COMFYUI_COMMIT

# Install ComfyUI Manager
if [ ! -d "/comfyui/custom_nodes/ComfyUI-Manager/.git" ]; then
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /comfyui/custom_nodes/ComfyUI-Manager
fi
cd /comfyui/custom_nodes/ComfyUI-Manager
git fetch
git checkout $COMFYUI_MANAGER_COMMIT

cd /comfyui

# Install dependencies.
# As this might change on new commits, it cannot be done during image build
pip install -r requirements.txt

# Install xformers
/comfyui/venv/bin/python -m pip install xformers

# install oonxruntime-gpu for controlnet
# as this may be overwritten by custom nodes
pip install onnxruntime-gpu --upgrade --no-deps --force-reinstall --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ 


# Run ComfyUI
exec /comfyui/venv/bin/python main.py --listen 0.0.0.0 --preview-method auto --output-directory $COMFYUI_OUTPUT --input-directory $COMFYUI_INPUT
