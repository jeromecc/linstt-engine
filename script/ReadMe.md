# SuccessTranscript

Here is an explication on how to use the script `script/successTranscript.sh`


## Execution

./successTranscript.sh localhost audio comparaisonFile.txt
./successTranscript.sh localhost audio comparaisonFile.txt uc2

## Parameter
 

./succesTranscript.sh IP_SERVER AUDIO_FOLDER FILE MODEL

`IP_SERVER` : Address IP of the server
`AUDIO_FOLDER` :  The audio folder to test all audio
`FILE` : The comparison file that describe the output wanted from the audio (nameFile.wav output_1 output_2 ... output_N)
`MODEL` : The model name to use (Optional and by default UC1 will be used by the server) 


## Output

The script will generate two file on the current folder execution 

 - result/concatTranscript.txt : Will contains all output from the transcription server
 - result/resultTranscript.txt : Will contains an % success rate


