# init.sh file 
- On Windows: needs to be set to End Of Line=LF and not CRLF or it can't be executed on start
- added ComfyUI-Manager
- upgrading pip
- installed onnxruntime-gpu for cuda12

Image needs to be rebuilt using "docker compose build" to copy the updated init.sh into the image

# installing oonxruntime-gpu for cuda12 (manual)
- (shell): activate env: . /comfyui/venv/bin/activate
- run pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/


