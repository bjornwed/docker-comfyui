- python 3.12
- no environment, eg clone to /comfyui
- mount "comfyui_models" volume to /models
- mount "comfyui" volume to /comfyui
- mount "site-packages" volume to /usr/local/lib/python3.12/site-packages (to persist python packages installed)
- mount "comfyui_in_out" to /comfy_in_out
- install pytorch:
  pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126
- install oonxruntime-gpu:
  pip install onnxruntime-gpu --upgrade --no-deps --force-reinstall --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ 
 

