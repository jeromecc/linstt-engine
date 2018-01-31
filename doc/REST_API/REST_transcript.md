# POST /api/transcript

Create a transcript text from an audio file

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
- 500 Internal server error

**Response Headers:**

- Content-Type: application/json

**Response JSON Object:**

- text: contain the transcription (only on succes)
- status: contain the state of the answser (only on error)
- err: contain the error description (only on error)


**Request:**

    POST /api/transcript
    Accept: application/json
    Host: localhost:8080
    
	A wav File

**Response:**

    HTTP/1.1 200 Ok
    {
      text : 'here the transcript'
    }

    HTTP/1.1 500 Ok
    {
      status : X , err : 'here the error'
    }
