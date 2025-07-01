#!/bin/bash
#SBATCH --job-name=afprediction_hp1
#SBATCH --partition=gpu-short
#SBATCH --ntasks=1
#SBATCH --mem=32GB
#SBATCH --gres=gpu:1
#SBATCH --constraint=A100.4g.40gb|A100.3g.40gb
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00
#SBATCH --error=%x_%j.log

#### Loading modules

#use this module for SLURM
module load alphafold/cc8_3-20250304

#when bash, using the T4 or 2080TI, load this module
#module load alphafold/cc7_3-20250304

#### Running alphafold

#set the variables
export AF3_RESOURCES_DIR=/data1/databases/AlphaFold3_resources
export AF3_INPUT_DIR=/home/s4252691/data1/workshop/binding-protein/alphafold3/binder_hp1.json
export AF3_OUTPUT_DIR=/home/s4252691/data1/workshop/binding-protein/alphafold3/workshop_outputs/
export AF3_MODEL_PARAMETERS_DIR=${AF3_RESOURCES_DIR}/weights
export AF3_DATABASES_DIR=${AF3_RESOURCES_DIR}/databases

#if you want to run only one JSON file, change the definition of AF_INPUT_DIR to point to a single file.
#use --json_path instead of --input_dir.

alphafold \
        --db_dir=${AF3_DATABASES_DIR} \
        --model_dir=${AF3_MODEL_PARAMETERS_DIR} \
        --json_path=${AF3_INPUT_DIR} \
        --output_dir=${AF3_OUTPUT_DIR}

#### Finished

