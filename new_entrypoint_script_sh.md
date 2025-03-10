#!/bin/bash

# Ensure ComfyUI is available
if [ ! -d "/app/ComfyUI" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI
fi

# Install/update dependencies
pip install --no-cache-dir --upgrade pip
if [ -f "/app/ComfyUI/requirements.txt" ]; then
    pip install --no-cache-dir -r /app/ComfyUI/requirements.txt
fi

# Install additional Python packages for custom nodes (if needed)
if [ -f "/app/custom_nodes/requirements.txt" ]; then
    pip install --no-cache-dir -r /app/custom_nodes/requirements.txt
fi

# Run ComfyUI
cd /app/ComfyUI
python3 main.py
