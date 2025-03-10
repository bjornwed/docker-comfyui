FROM python:3.11-slim
# Set environment variables in a single layer
ENV TZ=Europe/Stockholm \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    COMFYUI_COMMIT=master \
    COMFYUI_MANAGER_COMMIT=main \
    COMFYUI_INSTANTID_COMMIT=main \
    COMFYUI_OUTPUT=/stable_diffusion/output \
    TINI_VERSION=v0.19.0 \
    PIP_ROOT_USER_ACTION=ignore \
    # path for tensorrt
    LD_LIBRARY_PATH=/comfyui/venv/lib/python3.11/site-packages/tensorrt_libs \
    NO_ALBUMENTATIONS_UPDATE=1

WORKDIR /comfyui

# Install dependencies.
# Install system dependencies and clean up in one layer
RUN apt-get update && apt-get upgrade && apt-get install -y --no-install-recommends build-essential wget git ffmpeg libsm6 libxext6 cmake && \
    wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /tini && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/tini", "--"]

RUN python -m pip install --upgrade pip

# Copy in the init script.
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 8188
# CMD ["sleep", "infinity"]
CMD ["/init.sh"]

## Test on including ComfyUI into container
## Does NOT work as custom nodes will require new python modules, eg they need to be compiled into docker image.
## Need to deploy ComfyUI through init.sh using venv

# # Clone ComfyUI if it doesn't exist.
# RUN if [ ! -d "/comfyui/.git" ]; then \
#      git clone --no-checkout https://github.com/comfyanonymous/ComfyUI.git /comfyui/.tmp && \ 
#      mv /comfyui/.tmp/.git /comfyui; \
# fi 
# # Checkout the specified commit.
# RUN git fetch && \
# git checkout $COMFYUI_COMMIT

# # Install other dependencies.
# RUN pip install -r requirements.txt

