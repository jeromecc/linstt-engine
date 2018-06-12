#!/bin/bash
lvcsrRootDir=/opt/speech-to-text

curentFile=$1

wavdir=$lvcsrRootDir/wavs
file="$wavdir/$curentFile"


sox $file -r 48000 -c 1 --bits 16 --encoding signed-integer --endian little $file.raw
./tools/rnnoise_demo $file.raw $file.pcm
./tools/ffmpeg -f s16le -ar 48k -ac 1 -i $file.pcm $file.wav 2>/dev/null
sox $file.wav -t wav -r 16000 $file
rm $file.pcm $file.raw $file.wav
echo "End Noise cancelling using RNNoise"
