#!/bin/bash
#SBATCH --job-name=rfdiffusion_hp2
#SBATCH --mem=32GB
#SBATCH --time=00:15:00
#SBATCH --output=logs/out_%x_%j.log
#SBATCH --error=logs/err_%x_%j.log
#SBATCH --partition=testing
#SBATCH --gres=gpu:tesla_t4:1
#SBATCH --cpus-per-task=12

#---------------------------------------------
# One ppi generation takes around 6 minutes
#---------------------------------------------

# Loading the correct CUDA version
module load CUDA/11.8.0

# Forsed the CUDA path, to be sure that the script uses the right version
export CUDA_HOME=/cm/shared/easybuild/GenuineIntel/software/CUDAcore/11.8.0
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Echo to see that the set path is correct
#nvcc --version
#echo $CUDA_HOME
#echo $LD_LIBRARY_PATH

# Enabling the anaconda environment
source /data1/s4252691/anaconda3/etc/profile.d/conda.sh
conda activate /data1/projects/pi-vriesendorpb/condaEnvs/SE3nv

# Checks for loaded env and CUDA
#which python
#python --version
#python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

# Running the SLURM in the correct working directory
cd /data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked

# Updated scaffolded script 30-06-2025
python /data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/scripts/run_inference.py \
	scaffoldguided.target_path=/data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/inputs/2qud_B_renum.pdb \
	inference.output_prefix=/data1/projects/pi-vriesendorpb/shared/outputs/${SLURM_JOB_NAME}_output \
	scaffoldguided.scaffoldguided=True \
	'ppi.hotspot_res=[placeholder]' \
	scaffoldguided.target_pdb=True \
	scaffoldguided.target_ss=/data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/inputs/2qud_B_renum_ss.pt \
	scaffoldguided.target_adj=/data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/inputs/2qud_B_renum_adj.pt \
	scaffoldguided.scaffold_dir=/data1/projects/pi-vriesendorpb/shared/RFdiffusion_forked/examples/ppi_scaffolds/ \
	scaffoldguided.mask_loops=True \
	scaffoldguided.sampled_insertion=15 \
	scaffoldguided.sampled_N=5 \
	scaffoldguided.sampled_C=5 \
	inference.num_designs=4 \
	denoiser.noise_scale_ca=0.5 \
	denoiser.noise_scale_frame=0.5
