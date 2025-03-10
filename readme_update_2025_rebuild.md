- no env required
- volume to persist installed python packages


version: '3.8'

services:
  comfyui:
    image: comfyui-container
    build: .
    container_name: comfyui
    ports:
      - "8188:8188"
    volumes:
      - comfyui_data:/app/ComfyUI
      - custom_nodes_data:/app/custom_nodes
      - models_data:/app/models
      - python_packages:/usr/local/lib/python3.10/site-packages
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    restart: unless-stopped

volumes:
  comfyui_data:
  custom_nodes_data:
  models_data:
  python_packages:

