# compose.yaml
- use existing named disk volume "comfyui_wsl" and mount to /comfyui. 
- use existing named disk volume "comfyui_models" and mount to /comfyui_models. Models will be stored here
- use existing disk volume "stable_diffusion" and mount to /stable_diffusion. Only for output, might change in the future

# extra_model_paths.yaml
- point comfyui to external model storage, renamed example. file located in /comfyui

# init.sh file 
- On Windows: set to End Of Line=LF and not CRLF or it can't be executed on start
- add ComfyUI-Manager
- upgrade pip
- install requirements for comfyui
- install onnxruntime-gpu for cuda12. --upgrade --no-deps --force-reinstall as some custom nodes might break onnxruntime dependencies
- install tensorrt for instantId
- change output folder using start param: --output-directory /stable_diffusion/output. 
- rebuild image using "docker compose build" to copy the updated init.sh into the image

# installing oonxruntime-gpu for cuda12 (manual)
- (shell): activate env: . /comfyui/venv/bin/activate
- pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

# controlnet aux config.yaml 
comfyui\custom_nodes\comfyui_controlnet_aux\config.example.yaml
- rename to config.xml
- change annotator_ckpts_path: "/comfyui_models/models/controlnet". 
