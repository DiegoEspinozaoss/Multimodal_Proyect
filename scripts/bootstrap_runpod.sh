#!/usr/bin/env bash
set -euo pipefail

# Usage:
# bash Multimodal_Proyect/scripts/bootstrap_runpod.sh <REPO_URL> [BRANCH]
# Example:
# bash Multimodal_Proyect/scripts/bootstrap_runpod.sh https://github.com/you/Classification_of_Transients_with_Bimodal_Approach.git main

REPO_URL="${1:-}"
BRANCH="${2:-main}"

if [[ -z "${REPO_URL}" ]]; then
  echo "[ERROR] Missing REPO_URL"
  exit 1
fi

WORKDIR="/workspace"
PROJECT_DIR="${WORKDIR}/Classification_of_Transients_with_Bimodal_Approach"
ULT_DIR="${PROJECT_DIR}/Repositorio_Daniel_Moreno/Universal_Lightning_Trainer"

cd "${WORKDIR}"

if [[ ! -d "${PROJECT_DIR}" ]]; then
  git clone --branch "${BRANCH}" "${REPO_URL}" "${PROJECT_DIR}"
else
  echo "[INFO] Project already exists, pulling latest"
  cd "${PROJECT_DIR}"
  git fetch origin
  git checkout "${BRANCH}"
  git pull --ff-only origin "${BRANCH}"
fi

cd "${PROJECT_DIR}"
pip install -r Multimodal_Proyect/requirements.txt

cd "${ULT_DIR}"
mkdir -p nlhpc_logs outputs

echo "[OK] Bootstrap finished"
echo "[NEXT] export WANDB_API_KEY=..."
echo "[NEXT] bash ${PROJECT_DIR}/Multimodal_Proyect/scripts/check_gpu.sh"
