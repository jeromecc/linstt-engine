# linstt-engine

This is the repository for the linstt-engine project.

## Installation
You can easily compile and run the whole project by using only the linstt-engine. Follow the instruction bellow to understand the process.

### Install Docker and Docker Compose

You will need to have Docker and Docker Compose installed on your machine. If they are already installed, you can skip this part.
Otherwise, you can install them referring to [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/ "Install Docker"), and to [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/ "Install Docker Compose").

The version we use :
 
 -  `docker-compose version 1.16.1, build 6d1ac21`
 - `Docker version 17.12.0-ce, build c97c6d6`

___
## Configuration and Building all the docker images

### 1 - Download and build linstt-engine

If you use an windows it is recommanded to clone the project with this command the command bellow, it will format the shell file for an unix system. 
Run `git config --global core.autocrlf input` 
Otherwise use he command bellow :
Run `git clone https://github.com/linto-ai/linstt-engine.git`
You can build all docker image by using `docker-compose build` from the `linstt-engine` folder. It will automatically build all other docker.
You can also check the configuration of the submodule `linstt-controller` just bellow.

### 2 - Configure linstt-controller

The configuration of the controller maybe need to be updated, depending on the names of the containers that will be deployed in docker. Check in `linstt-engine/linstt-controller/config.json` that the indicated hosts match the ones of your docker containers: 
 - gstreamer : `linsttengine_kaldi_1`
 - speechEnhancement : `linsttengine_speech-enhencement_1`
 - offline : `linsttengine_offline-server_1`

Two decoding modes are offered in the latest version of linstt-engine: offline and online. 

 1. 'Offline' is a new decoding mode provided by a new component developped by LINAGORA. It provides better transcription success rates (average +20% success rate) at the expense of being slightly slower and computing intensive than the usual 'online' mode.
 2. 'Online' is the usual decoding mode which is faster (approximatively 5 second faster per decoding task) and less CPU intensive. But it is also less robust, offering lower transcription success. This mode is provided by the Kaldi GStreamer software component that is bundled with linstt-engine.

We offer the possibily to cold-switch between  Offline and Online transcription modes. By default Online mode is used. You can toggle between the 2 using the following parameter in `linstt-engine/.env`:
 - `IS_OFFLINE` : `true` or `false`

### 3 - Check environment variables of linstt-engine

The `linstt-engine/.env` file contains the description of the most usefull environment variables to run the project. Most notably, the location of the model file to be used. The `.env` file is now preconfigured and should work directly in most configurations without adaptations.

 - `MODEL_PATH` points to your current model folder. By default `linstt-engine/models/current_model`.
 - `NB_WORKERS`  the number of parrallel workers deployed in the selected decoding module (either online or offline). This parameters helps dealing with scalabily and conccurent requests: 2 workers can deal with 2 concurrent transcription requests.
 - `NORM` is the normalization parameter used by the the enhancer module of linstt-engine.
 - `OFFLINE_PORT` will be used by the offline server and the worker for communication
 - `IS_OFFLINE` allow to toggle between online and offline

### 4 - Launch and test linstt-engine

After configuration. Launch linstt-engine transcription modules and docker containers by using `docker-compose up` from the `linstt-engine` folder. Check the trace in the console for any error message.

Also it is possible to launch multiple worker for the offline mode : `docker-compose up --scale offline-worker=N`  where `N` is the number of worker that will be launch

You are now ready to use the API!

You can also use the provided tests and audio files from `linstt-engine/script` folder.

___
## Model
The current transcription model should be in the form of a subfolder in `linstt-engine/models`

###Structure

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

___
## Windows User

For windows user, it is recommanded for the builing to clone the project with this command : `git config --global core.autocrlf input`
