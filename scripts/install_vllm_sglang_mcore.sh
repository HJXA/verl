#!/bin/bash
export PATH="/ruilab/jxhe/miniconda3/envs/verl/bin:$PATH"
which python 
USE_MEGATRON=${USE_MEGATRON:-1}
USE_SGLANG=${USE_SGLANG:-1}

export MAX_JOBS=1

echo "###################1. install inference frameworks and pytorch they need"
# 先不sglang 主要用vllm
# if [ $USE_SGLANG -eq 1 ]; then
#     pip install "sglang[all]==0.5.2" --no-cache-dir && pip install torch-memory-saver --no-cache-dir
# fi
# A100本机用
pip install vllm==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu126
# pip install --no-cache-dir "vllm==0.11.0"

echo "###################2. install basic packages" # vllm doesn't support v5 yet.
pip install "transformers[hf_xet]==4.57.6" accelerate datasets peft hf-transfer \
    "numpy<2.0.0" "pyarrow>=15.0.0" pandas "tensordict>=0.8.0,<=0.10.0,!=0.9.0" torchdata \
    ray[default] codetiming hydra-core pylatexenc qwen-vl-utils wandb dill pybind11 liger-kernel mathruler \
    pytest py-spy pre-commit ruff tensorboard 
pip install numpy==2.2.6

echo "pyext is lack of maintainace and cannot work with python 3.12."
echo "if you need it for prime code rewarding, please install using patched fork:"
echo "pip install git+https://github.com/ShaohonChen/PyExt.git@py311support"

pip install "nvidia-ml-py>=12.560.30" "fastapi[standard]>=0.115.0" "optree>=0.13.0" "pydantic>=2.9" "grpcio>=1.62.1"


# echo "3. install FlashAttention and FlashInfer"
# # Install flash-attn-2.8.1 (cxx11abi=False)
# wget -nv https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl && \
#     pip install --no-cache-dir flash_attn-2.8.1+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl

# 本机A100
pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl

pip install --no-cache-dir flashinfer-python==0.3.1

# 应该在前面
# if [ $USE_MEGATRON -eq 1 ]; then
#     echo "#######################6. Install cudnn python package (avoid being overridden)"
#     pip install nvidia-cudnn-cu12==9.10.2.21
# fi
# 没有128卡不用Megatron
# conda install -c nvidia libcufft-dev libcurand-dev libcusolver-dev libcusparse-dev libcudnn-dev -y # 没有cudnn.h导致TransformerEngine失败的情况
# if [ $USE_MEGATRON -eq 1 ]; then
#     echo "##########################4. install TransformerEngine and Megatron"
#     echo "Notice that TransformerEngine installation can take very long time, please be patient"
#     pip install "onnxscript==0.3.1"
#     NVTE_FRAMEWORK=pytorch pip3 install --no-deps git+https://github.com/NVIDIA/TransformerEngine.git@v2.6
#     pip3 install --no-deps git+https://github.com/NVIDIA/Megatron-LM.git@core_v0.13.1
# fi


echo "################################5. May need to fix opencv"
pip install opencv-python
pip install opencv-fixer && \
    python -c "from opencv_fixer import AutoFix; AutoFix()"

pip uninstall pynvml -y && pip install "nvidia-ml-py"
pip install httpx[socks]

echo "Successfully installed all packages"

# Exception ignored in: <function ResourceTracker.__del__ at 0x7fa67c4b79c0>
# Traceback (most recent call last):
#   File "/ruilab/jxhe/miniconda3/envs/verl/lib/python3.12/site-packages/multiprocess/resource_tracker.py", line 80, in __del__
#   File "/ruilab/jxhe/miniconda3/envs/verl/lib/python3.12/site-packages/multiprocess/resource_tracker.py", line 89, in _stop
#   File "/ruilab/jxhe/miniconda3/envs/verl/lib/python3.12/site-packages/multiprocess/resource_tracker.py", line 102, in _stop_locked
# AttributeError: '_thread.RLock' object has no attribute '_recursion_count'
# 要降版本 pip install 'multiprocess==0.70.11'
