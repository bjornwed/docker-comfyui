# oonxruntime
May break due to depencencies. To try and fix:
- . /comfyui/venv/bin/activate
- pip uninstall onnxruntime onnxruntime-gpu
- pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

## verify onnxruntime
- (venv) Python
- >> import onnxruntime as rt
- >> rt.get_device()

# Tensor RT
EP Error /onnxruntime_src/onnxruntime/python/onnxruntime_pybind_state.cc:456 void onnxruntime::python::RegisterTensorRTPluginsAsCustomOps(onnxruntime::python::PySessionOptions&, const ProviderOptions&) Please install TensorRT libraries as mentioned in the GPU requirements page, make sure they're in the PATH or LD_LIBRARY_PATH, and that your GPU is supported.   

- in (venv)
- pip install --upgrade wheel setuptools
- pip install --upgrade tensorrt_lean

https://sebhastian.com/python-error-subprocess-exited-with-error/
https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html





