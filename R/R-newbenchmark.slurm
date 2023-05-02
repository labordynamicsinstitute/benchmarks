#!/bin/bash



#!/bin/bash
#SBATCH -p small
#SBATCH -t 200:00:00
#SBATCH -n 1
#SBATCH --exclusive



module load R

Rscript --vanilla new-benchmark.R

