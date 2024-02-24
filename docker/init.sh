# tmp
#!/bin/bash
set -e

COMFYUI_COMMIT=${COMFYUI_COMMIT:-master}
COMFYUI_MANAGER_COMMIT=${COMFYUI_MANAGER_COMMIT:-main}
USE_XFORMERS=${USE_XFORMERS:-false}
COMFYUI_OUTPUT=${COMFYUI_OUTPUT}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

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

cd /comfyui
# Install dependencies.
# As this might change on new commits, it cannot be done during image build
/comfyui/venv/bin/pip install -r requirements.txt

# try installing tensorrt
/comfyui/venv/bin/pip install --upgrade tensorrt_lean

# install oonxruntime-gpu for controlnet
/comfyui/venv/bin/pip install onnxruntime-gpu --upgrade --no-deps --force-reinstall --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ 
 


# Start ComfyUI.
exec /comfyui/venv/bin/python main.py --listen 0.0.0.0 --preview-method auto --output-directory $COMFYUI_OUTPUT
