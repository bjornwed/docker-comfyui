# tmp
#!/bin/bash
set -e

COMFYUI_COMMIT=${COMFYUI_COMMIT:-master}
COMFYUI_MANAGER_COMMIT=${COMFYUI_MANAGER_COMMIT:-main}
USE_XFORMERS=${USE_XFORMERS:-false}
COMFYUI_OUTPUT=${COMFYUI_OUTPUT:-/comfyui/output}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

# Clone ComfyUI if it doesn't exist.
if [ ! -d "/comfyui/.git" ]; then
    # need to clone to a temp dir as /comfyui isn't empty at this point
    git clone --no-checkout https://github.com/comfyanonymous/ComfyUI.git /comfyui/.tmp
    # then move the .git folder 
    mv /comfyui/.tmp/.git /comfyui
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
/comfyui/venv/bin/python -m pip install -r requirements.txt

# install tensorrt
/comfyui/venv/bin/python -m pip install --upgrade tensorrt_lean

# install oonxruntime-gpu for controlnet
# as this may be overwritten by custom nodes
/comfyui/venv/bin/python -m pip install onnxruntime-gpu --upgrade --no-deps --force-reinstall --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ 
 
# Reinstall Trasformers with this command line "python.exe -m pip install transformers"

# Install CMake, required to compile dlib used by custom node FaceAnalysis
# http://dlib.net/compile.html


# Start ComfyUI.
# FP8 support, https://blog.comfyui.ca/comfyui/update/2023/12/19/Update.html
# --fp8_e4m3fn-text-enc --fp8_e4m3fn-unet
# 130 s
# 125 s without

exec /comfyui/venv/bin/python main.py --listen 0.0.0.0 --preview-method auto --output-directory $COMFYUI_OUTPUT 
