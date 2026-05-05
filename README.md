# Multimodal_Proyect (RunPod Ready)

Esta carpeta deja tu proyecto listo para entrenar en RunPod con PyTorch Lightning y GPU CUDA, reutilizando todos los experimentos de `Repositorio_Daniel_Moreno/Universal_Lightning_Trainer`.

## 1) Que incluye

- `requirements.txt`: librerias necesarias para entrenamiento.
- `Dockerfile`: imagen opcional para construir entorno reproducible.
- `scripts/check_gpu.sh`: valida CUDA visible en el pod.
- `scripts/bootstrap_runpod.sh`: clona/actualiza repo e instala dependencias.
- `scripts/run_train.sh`: corre un modelo especifico con `trainer.accelerator=gpu`.
- `scripts/run_all_models.sh`: corre toda la bateria de modelos en secuencia.

## 2) Flujo rapido (< 1 hora)

1. Sube este repo a GitHub/GitLab.
2. En RunPod: `Pods` -> `Deploy` -> elige GPU (ejemplo: RTX 4090, L4, A5000).
3. Usa un template PyTorch/CUDA (o imagen `runpod/pytorch` equivalente).
4. Abre terminal del pod y ejecuta:

```bash
cd /workspace
bash Multimodal_Proyect/scripts/bootstrap_runpod.sh <REPO_URL> <BRANCH>
export WANDB_API_KEY=<TU_KEY>
bash /workspace/Classification_of_Transients_with_Bimodal_Approach/Multimodal_Proyect/scripts/check_gpu.sh
```

5. Correr un modelo:

```bash
cd /workspace/Classification_of_Transients_with_Bimodal_Approach
bash Multimodal_Proyect/scripts/run_train.sh bimodal_img_spec runpod_bimodal_test
```

6. Correr todos:

```bash
cd /workspace/Classification_of_Transients_with_Bimodal_Approach
bash Multimodal_Proyect/scripts/run_all_models.sh
```

## 3) Modelos soportados en el launcher

- `images`
- `spectra`
- `spectra_gray`
- `lightcurves`
- `lightcurves_gray`
- `multimodal_contrastive`
- `multimodal_vicreg`
- `multimodal_moddrop`
- `multimodal_gmu`
- `multimodal_joint`
- `bimodal_img_spec`

## 4) Notas de datos y rutas

Este setup asume que, dentro del repo clonado en RunPod, existen:

- `Repositorio_Daniel_Moreno/Universal_Lightning_Trainer`
- `Repositorio_Multimodal/Preprocessed`
- `Universal_Lightning_Trainer/Global_Sample.csv`

Si algun dataset no esta versionado en git, debes copiarlo al pod (o montar volumen persistente) antes de entrenar.

## 5) Costos/pago en RunPod (resumen)

- Para entrenar necesitas **Pods con GPU** (no Drive).
- Modalidades de cobro comunes:
  - `On-demand`: no interrumpible (recomendado para entrenar).
  - `Spot`: mas barato pero interrumpible.
  - `Savings plan`: prepago con descuento.
- Tambien se cobra almacenamiento (container/volume/network storage).

Referencia oficial:
- https://www.runpod.io/pricing/
- https://docs.runpod.io/pods/pricing

## 6) Seccion exacta para clonar y ejecutar

- En RunPod web: `Pods` -> `Deploy` (crear pod con GPU).
- Luego abre `Connect` -> `Web Terminal` (o SSH).
- Ahí haces `git clone` y ejecutas scripts.

## 7) Recomendacion minima para tus corridas

- GPU: RTX 4090 / L4 o superior.
- vCPU: 8+
- RAM: 32 GB+
- Storage: 100 GB+ si guardas checkpoints + logs + datos locales.

