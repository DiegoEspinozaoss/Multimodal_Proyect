#!/usr/bin/env bash
set -euo pipefail

# Launch one model from Universal_Lightning_Trainer on GPU.
# Usage:
# bash Multimodal_Proyect/scripts/run_train.sh <model_key> [run_name]
# model_key: images|spectra|spectra_gray|lightcurves|lightcurves_gray|multimodal_contrastive|multimodal_vicreg|multimodal_moddrop|multimodal_gmu|multimodal_joint|bimodal_img_spec

MODEL="${1:-}"
RUN_NAME="${2:-}"

if [[ -z "${MODEL}" ]]; then
  echo "[ERROR] Missing model key"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ULT_DIR="${ROOT_DIR}/Repositorio_Daniel_Moreno/Universal_Lightning_Trainer"

cd "${ULT_DIR}"

BASE_ARGS=(
  --base configs/base.yaml
  --override data.global_sample_csv=Universal_Lightning_Trainer/Global_Sample.csv
  --override data.preprocessed_dir=Preprocessed
  --override trainer.accelerator=gpu
  --override trainer.devices=1
)

case "${MODEL}" in
  images)
    EXP="configs/experiments/mae_images.yaml"
    PART_COL="Unimodal_Unsupervised_Images_All"
    ;;
  spectra)
    EXP="configs/experiments/mae_spectra.yaml"
    PART_COL="Unimodal_Unsupervised_Spectra_All"
    ;;
  spectra_gray)
    EXP="configs/experiments/mae_spectra_context_gray.yaml"
    PART_COL="Unimodal_Unsupervised_Spectra_All"
    ;;
  lightcurves)
    EXP="configs/experiments/mae_lightcurves.yaml"
    PART_COL="Unimodal_Unsupervised_Lightcurve_All"
    ;;
  lightcurves_gray)
    EXP="configs/experiments/mae_lightcurves_context_gray.yaml"
    PART_COL="Unimodal_Unsupervised_Lightcurve_All"
    ;;
  multimodal_contrastive)
    EXP="configs/experiments/mae_multimodal_contrastive_intersection.yaml"
    PART_COL="Unimodal_Unsupervised_Three_Modalities_Intersection"
    ;;
  multimodal_vicreg)
    EXP="configs/experiments/mae_multimodal_vicreg_intersection.yaml"
    PART_COL="Unimodal_Unsupervised_Three_Modalities_Intersection"
    ;;
  multimodal_moddrop)
    EXP="configs/experiments/mae_multimodal_modality_dropout_intersection.yaml"
    PART_COL="Unimodal_Unsupervised_Three_Modalities_Intersection"
    ;;
  multimodal_gmu)
    EXP="configs/experiments/multimodal_gmu_classifier_fold.yaml"
    ;;
  multimodal_joint)
    EXP="configs/experiments/multimodal_joint_mae_contrastive_gmu_fold.yaml"
    ;;
  bimodal_img_spec)
    EXP="configs/experiments/mae_bimodal_img_spec_contrastive_intersection_smallspec.yaml"
    PART_COL="Unimodal_Unsupervised_Three_Modalities_Intersection"
    ;;
  *)
    echo "[ERROR] Unknown model key: ${MODEL}"
    exit 1
    ;;
esac

CMD=(python train.py "${BASE_ARGS[@]}" --experiment "${EXP}")

if [[ "${MODEL}" == "multimodal_gmu" || "${MODEL}" == "multimodal_joint" ]]; then
  CMD+=(--override data.fold_column=Supervised_Fold)
else
  CMD+=(
    --override data.partition_column="${PART_COL}"
    --override data.train_value=train
    --override data.test_value=test
  )
fi

if [[ -n "${RUN_NAME}" ]]; then
  CMD+=(--override run.name="${RUN_NAME}")
fi

echo "[INFO] Running: ${CMD[*]}"
"${CMD[@]}"
