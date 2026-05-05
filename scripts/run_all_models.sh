#!/usr/bin/env bash
set -euo pipefail

# Runs all major model families sequentially.
# Adjust list if you need to skip expensive runs.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RUN_SCRIPT="${ROOT_DIR}/Multimodal_Proyect/scripts/run_train.sh"

MODELS=(
  images
  spectra
  spectra_gray
  lightcurves
  lightcurves_gray
  multimodal_contrastive
  multimodal_vicreg
  multimodal_moddrop
  multimodal_gmu
  multimodal_joint
  bimodal_img_spec
)

TS="$(date +%Y%m%d_%H%M%S)"

for m in "${MODELS[@]}"; do
  echo "[INFO] ===== Running ${m} ====="
  bash "${RUN_SCRIPT}" "${m}" "runpod_${m}_${TS}"
done

echo "[OK] All requested models finished"
