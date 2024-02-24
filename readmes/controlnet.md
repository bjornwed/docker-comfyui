# Different model files
The difference between .pth files and .safetensors files:

## .pth Files (PyTorch Model Format):
.pth files (sometimes also having the extension .pt) are saved in PyTorch’s model format.
They are based on pickle, which is used for storing arbitrary Python objects.
However, this format was not designed for safety and can execute arbitrary code.
Warning: The pickle module is not secure. Only unpickle data you trust2.
## .safetensors Files (Huggingface Format):
.safetensors is a newer format developed by Huggingface.
It addresses safety concerns associated with .pth files.
Advantages of .safetensors:
Zero-copy: Reading the file doesn’t require more memory than the original file.
Enhanced safety: It avoids executing arbitrary code.
It’s a safer and more efficient option for model storage2.