#!/bin/bash
. ${WM_PROJECT_DIR:?}/bin/tools/RunFunctions

foamCleanTutorials

cd wing

cd constant
cd triSurface
surfaceTransformPoints -scale '(1 1 1)' wingShape.stl wing.stl
cd ..
cd ..

runApplication surfaceFeatureExtract
runApplication blockMesh
cp -f ../decomposeParDict system/decomposeParDict
decomposePar

cp -f system/snappyHexMeshDict.csnap system/snappyHexMeshDict
runParallel snappyHexMesh -overwrite

mv log.snappyHexMesh log.snappyHexMesh.csnap
cp -f system/snappyHexMeshDict.addlayers system/snappyHexMeshDict
runParallel snappyHexMesh -overwrite

runApplication reconstructParMesh -constant -latestTime -mergeTol 1e-6
runApplication transformPoints -rollPitchYaw '(0 38.44536356783964 0)'
cd ..

cd backGround
runApplication blockMesh
runApplication mergeMeshes . ../wing -overwrite
runApplication createPatch -overwrite
topoSet
topoSet -dict system/topoSetDict_movingZone

restore0Dir
runApplication checkMesh

touch open.foam
cd ..

cd backGround
cp -f ../decomposeParDict system/decomposeParDict
runApplication decomposePar
runParallel pimpleFoam
cd ..
