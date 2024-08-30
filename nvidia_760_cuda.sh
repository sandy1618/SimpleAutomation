#!/bin/bash

# Install CUDA Toolkit
sudo apt install -y nvidia-cuda-toolkit

# Set up the environment variables for CUDA
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc

# Source the updated bashrc
source ~/.bashrc

# Verify the installation
nvidia-smi
nvcc --version

echo "CUDA installation completed!"