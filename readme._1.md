# compose.yaml
- use existing disk volume "comfyui" and mount to /comfyui, comfyui:/comfyui
- use existing disk volume "stable_diffusion" and mount to /stable_diffusion, stable_diffusion:/stable_diffusion
- models and output to be stored in volume "stable_diffusion" to keep separate from comfyui

# extra_model_paths.yaml
- renamed example, file located on external volume "comfyui"

# init.sh file 
- On Windows: needs to be set to End Of Line=LF and not CRLF or it can't be executed on start
- added ComfyUI-Manager
- upgrading pip
- installed onnxruntime-gpu for cuda12
- changed output folder using start param: --output-directory /stable_difussion/output
-- "stable_diffusion" is a mounted volume 

Image needs to be rebuilt using "docker compose build" to copy the updated init.sh into the image

# installing oonxruntime-gpu for cuda12 (manual)
- (shell): activate env: . /comfyui/venv/bin/activate
- run pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

# config.yaml controlnet aux
comfyui\custom_nodes\comfyui_controlnet_aux\config.example.yaml
- rename to config.xml
- change annotator_ckpts_path: "/stable_diffusion/models/controlnet"
"stable_diffusion" is a mounted external volume
