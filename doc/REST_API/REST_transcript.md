# POST /api/transcript/:model*?'

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