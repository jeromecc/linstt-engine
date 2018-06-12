#!/bin/bash

PATH_speaker_diarization=$1
PATH_rnnoise=$2
PATH_STT_Models=$3
PATH_STT_Model_Config=$4
PATH_FFMPEG=$5
PATH_KALDIS=$6

[ -d tools ] || mkdir -p tools
##### Speaker Diarization toolkit #######
ln -s $PATH_speaker_diarization $PWD/tools/
##### rnnoise toolkit #######
ln -s $PATH_rnnoise $PWD/tools/
##### STT Model dir #####
[ -d systems ] || mkdir -p systems
ln -s $PATH_STT_Models $PWD/systems/
##### STT Model config #####
ln -s $PATH_STT_Model_Config $PWD/worker.cfg
##### ffmpeg toolkit #######
ln -s $PATH_FFMPEG $PWD/tools/
##### Kaldis toolkit #######
ln -s $PATH_KALDIS $PWD/tools/

##### Create wavs & trans directory #####
mkdir wavs
mkdir trans
echo "Success..."
