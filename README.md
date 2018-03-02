# LinSTT-poc

This is the repository for the LinSTT-poc project.

## Installation
You can easily compile and run the whole project by using only the LinSTT-poc. Follow the instruction bellow to understand the process.

### Install Docker and Docker Compose

You will need to have Docker and Docker Compose installed on your machine. If they are already installed, you can skip this part.
Otherwise, you can install them referring to [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/ "Install Docker"), and to [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/ "Install Docker Compose").

The version we use :
 
 -  `docker-compose version 1.16.1, build 6d1ac21`
 - `Docker version 17.12.0-ce, build c97c6d6`

___
## Configuration and Building all the docker images

### 1 - Download and build LinSTT-poc

If you use an windows it is recommended to clone the project with this command the command bellow, it will format the shell file for an unix system. 
Run `git config --global core.autocrlf input` 
Otherwise use he command bellow :
Run `git clone --recurse-submodules https://ci.linagora.com/linagora/lgs/labs/linstt-poc.git`

You will probably need to pull all submodule : `git pull --recurse-submodules origin master`

You can build all docker image by using `docker-compose build` from the `linstt-poc` folder. It will automatically build all other docker.
You can also check the configuration of the submodule `linstt-controller` just bellow.

### 2 - Configure linstt-controller

The configuration of the controller maybe need to be updated, depending on the names of the containers that will be deployed in docker. Check in `linstt-poc/linstt-controller/config.json` that the indicated hosts match the ones of your docker containers: 

 - gstreamer : 
	 - `host : linsttpoc_kaldi_1`
	 -  `port : 80`
 - speechEnhancement : 
	 - `host : linsttpoc_speech-enhencement_1`
	 -  `port : 5000`
 - offline : 
	 - `host : linsttpoc_offline-server_1`
	 - `port : 8888`

Two decoding modes are offered in LinSTT: offline and online. 

 1. 'Offline' is a new decoding mode provided by a new component developed by LINAGORA. It provides better transcription success rates (average +25% success rate) at the expense of being slightly slower and computing intensive than the usual 'online' mode.
 2. 'Online' is the usual decoding mode which is faster (approximatively 5 second faster per decoding task) and less CPU intensive. But it is also less robust, offering lower transcription success. This mode is provided by the Kaldi GStreamer software component that is bundled with LinSTT.

We offer the possibly to cold-switch between  Offline and Online transcription modes. By default Online mode is used. You can toggle between the 2 using the following parameter in `linstt-poc/linstt-controller/config.json`:
 - `isOffline` : `true` or `false` (This value will only be used if the system don't have the environment variable define in the `.env` from the linstt-poc)
 - 

### 3 - Configure linstt-offline-decoding

You will find all instruction considering the LinSTT-offline-decoding configuration here : [ReadMe](https://ci.linagora.com/linagora/lgs/labs/linstt-offline-decoding/blob/master/README.md)

### 4 - Configure linstt-poc

The `linstt-poc/.env` file contains the description of the most useful environment variables to run the project. Most notably, the location of the model file to be used. The `.env` file is now preconfigured and should work directly in most configurations without adaptations.

 - `MODEL_PATH` points to your current model folder. By default `linstt-poc/models/current_model`.
 - `NB_WORKERS`  the number of parallel workers deployed in the selected decoding module (either online or offline). This parameters helps dealing with scalability and concurrent requests: 2 workers can deal with 2 concurrent transcription requests.
 - `NORM` is the normalization parameter used by the the enhancer module of LinSTT (You can have more information by reading the [sox](http://sox.sourceforge.net/Docs/Documentation) documentation).
 - `OFFLINE_PORT` will be used by the offline server and the worker for communication
 - `IS_OFFLINE` allow to toggle between online and offline (`true` will use the **offline** and `false` will use the **online**)

### 5 - Launch and test LinSTT (P2)

After all the configuration you can rebuild the all docker `docker-compose build`, it will used a cache system, so it will be faster than the first time. Launch LinSTT transcription modules and docker containers by using `docker-compose up` from the `linstt-poc` folder. Check the trace in the console for any error message.

Also it is possible to launch multiple worker for the offline mode : `docker-compose up --scale offline-worker=N`  where `N` is the number of worker that will be launch

You are now ready to use the API!

You can also use the provided tests and audio files from `linstt-poc/script` folder.

___
## Model
The current model should be in the form of a subfolder in `linstt-poc/models`
You can find a way to download model [ReadMe.md getModel.sh](https://ci.linagora.com/linagora/lgs/labs/linstt-poc/blob/master/models/ReadMe.md)

### Structure Model switcher

We allow any worker (from the offline-decoding) to work with one or N different model. The aspect is that the structure will only work with a specific tree that we will describe bellow :

- Name_Model_1
	- Structure Model describe bellow
- Name_Model_2
	- Structure Model describe bellow
- ...
- Name_Model_N
	- Structure Model describe bellow


### Structure model

 - gmm_hmm3.yaml
 - model/
	 - final.alimdl
	 - final.mat
	 - final.mdl
	 - splice_opts
	 - tree
	 - Graph/
		 - disambig_tid.int
		 - HCLG.fst
		 - disambig_tid.int
		 - phones.txt
		 - words.txt
		 - phones/
			 - align_lexicon.int
			 - align_lexicon.txt
			 - disambig.int
			 - disambig.txt
			 - optional_silence.csl
			 - optional_silence.int
			 - optional_silence.txt
			 - silence.csl
			 - word_boundary.int
			 - word_boundary.txt

### Download Model
We have create a script to allow an easy way to install any model. It's located in the folder `getModel.sh`. You just need to follow the instruction of the script ( 3 step )

 - Give the tag of the model to download
 - User name
 - User password

___
## Windows User

For windows user, it is recommanded for the builing to clone the project with this command : `git config --global core.autocrlf input`

___
## API

### POST /api/transcript/:model*?'

Create a transcript text from an audio file

**URL Parameter:**

- model : Will use the specific model given for the model decoding
	- Is optional, default value : `uc1`

**Request Headers:**

- Accept: application/json

**Request Body**

This endpoint expects the request body to be a wav file
	- Rate 16KHz
	- Canal 1
	- Binary 16
	- Encoding little endian 

**Status Codes:**
  
- 200 Ok
- 400 Body is empty
- 406 No content-type
- 500 Internal server error

**Response Headers:**

- Content-Type: application/json

**Response JSON Object:**

- message: contain an information
- transcript: contain the transcription (only on succes)
- status: contain the state of the answser (only on error)
- err: contain the error description (only on error)


**Request:**

    POST /api/transcript'
    Accept: application/json
    Host: localhost:8080
    
	A wav File

**Response:**

    ```HTTP/1.1 200 Ok
    {
      "message": "Transcript done",
      "transcript": {
        "status": 0,
        "hypotheses": [
          {
            "utterance": "mon utterance un",
            "acousticScore": 0.40,
            "languageScore": 0.6
          },
          {
            "utterance": "mon utterance de",
            "acousticScore": 0.42,
            "languageScore": 0.5
          },
          {
            "utterance": "mon utterance <unk>,
            "acousticScore": 0.50,
            "languageScore": 0.52
          }
        ],
        "id": "6a1c1cd0-109c-11e8-a931-3fd870b05226"
      }
    }
		
**Request:**

    POST /api/transcript/uc2'
    Accept: application/json
    Host: localhost:8080
    
	No content


**Response:**

    HTTP/1.1 500 ERROR
    {
      status : X , err : 'here the error'
    }

**Info:**
  Lower is better for the value acousticScore. The lower is, the more accurate will be the utterance
