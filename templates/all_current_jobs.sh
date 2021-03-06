#!/bin/bash --login

#$ -cwd
#$ -pe smp.pe 32

#$ -t 1-24
mkdir ./SIM_RESULTS
readarray -t JOB_DIRS < <(find . -mindepth 1 -maxdepth 1 -name '*Re*' -printf '%P\n')

module load apps/gcc/openfoam/v2012
module load apps/binapps/paraview/5.7.0
source $foamDotFile

. ${WM_PROJECT_DIR:?}/bin/tools/RunFunctions

TID=$[SGE_TASK_ID-1]
JOBDIR=${JOB_DIRS[$TID]}

cd $JOBDIR
echo "Running SGE_TASK_ID $SGE_TASK_ID in directory $JOBDIR"
sh run_all.sh
cd ..
cp $JOBDIR/backGround/postProcessing/forceCoeffs_object/0/coefficient.dat ./SIM_RESULTS/$JOBDIR
