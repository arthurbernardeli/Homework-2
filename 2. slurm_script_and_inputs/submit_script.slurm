#!/bin/bash -l
#SBATCH -D /work/unlsbp/arthurbern/Homework 2/slurm_script_and_inputs
#SBATCH -o /work/unlsbp/arthurbern/Homework 2/log/fst-stdout-%j.txt
#SBATCH -e /work/unlsbp/arthurbern/Homework 2/log/fst-stderr-%j.txt
#SBATCH -J my_fst
#SBATCH -t 24:00:00
#SBATCH --mail-user=arthurbernardeli@gmail.com
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

set -e
set -u

# Ensure the log directory exists
mkdir -p /work/unlsbp/arthurbern/Homework 2/log

# Run the script
bash /work/unlsbp/arthurbern/Homework 2/slurm_script_and_inputs/my_fst.sh