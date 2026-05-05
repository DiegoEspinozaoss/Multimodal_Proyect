#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] nvidia-smi"
nvidia-smi || { echo "[ERROR] No GPU visible"; exit 1; }

echo "[INFO] python torch cuda check"
python - << 'PY'
import torch
print('torch:', torch.__version__)
print('cuda_available:', torch.cuda.is_available())
print('device_count:', torch.cuda.device_count())
if torch.cuda.is_available():
    print('device_name:', torch.cuda.get_device_name(0))
PY
