#!/bin/bash

# param1 : ip server
# param2 : dossier qui contient les audios a transcrire
# param3 : path du fichier de comparaison sous le format "nomDuFichier nom prenom"

IP_SERVER=$1
AUDIO_FOLDER=$2
NAME_FILE=$3
MODEL=$4

destDir=result/
destFile=result/concatTranscript.txt
resultFile=result/resultTranscript.txt

minPalier=1
totalAudio=0
totalResult=0

if [ -d "$destdir"]; then
	rm $destFile
 rm $resultFile
	rm -r $destDir
fi

mkdir $destDir
touch $destFile
touch $resultFile

for filename in ${AUDIO_FOLDER}/*.wav; do 
	transcript=$(curl -X POST http://${IP_SERVER}:3000/api/transcript/${MODEL} -H "Content-type: audio/wave" --data-binary "@$filename")

	res=$(echo $transcript | grep -o "\[.*\]" | sed "s/\}\]//g" | sed "s/\[{//g" | sed "s/\"//g" | sed "s/\utterance://g" | sed "s/acousticScore.*//g" | sed "s/,//g")
	echo ${filename##*/}:${res} >> $destFile
	totalAudio=$((totalAudio + 1))
done

while read -r lineName
do
	find=""
	palier=100
	result=0
	desired=""

	while read -r lineTranscript
	do
		arrName=($lineName)
		size=`expr ${#arrName[@]} - 1`

		if [ "$size" -eq "0" ]; then
		   size=1
		fi

		palier=`expr 100 / $size`

		if [[ $lineTranscript == *"${arrName[0]}"* ]]; then
			for i in `seq 1 $size`; do
				if [[ $lineTranscript == *"${arrName[$i]}"* ]]; then
					result=`expr $result + $palier`
					find="$find ${arrName[$i]}"
				fi
				desired="$desired ${arrName[$i]}"
			done
		fi
	done < "$destFile"
	totalResult=$((totalResult + result))
	echo -e "Result for : ${arrName[0]} with a ${result}% succes.\n\t Output desired :${desired} \n\t Output find : ${find} " >> $resultFile
done < "$NAME_FILE"

succesRate=`expr $totalResult / $totalAudio`
echo "The success rate is : $succesRate%" >> $resultFile
