#!/bin/bash
#SBATCH --job-name=Tohoku_infR10Kkm
#SBATCH --output=output_%j.out
#SBATCH --error=error_%j.err
#SBATCH --nodes=2
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --partition=ncpushort
#SBATCH --mem=200G


# Clean up and create directories
rm -rf partition output tmp
mkdir -p output partition tmp

# make sure we using newly installed specfemx


# Load OMPI
# module load openmpi/gcc-10.3.0/4.1.1
module unload openmpi
# module load openmpi/intel-19U5/4.1.1-ucx-1.10.1
module load openmpi/intel-20U4/4.1.1-ucx-1.10.1


# Run the preprocessing step. Mesh partitioning
./bin/partmesh input/inclined_strikeslip.psem

# Submit MPI job
mpirun ./bin/pspecfemx input/inclined_strikeslip.psem

