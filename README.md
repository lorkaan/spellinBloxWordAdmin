#SpellinBlox Word Admin Content Management System

## Overview
This system manages 3-ples consisting of (Tag, Word, Description/Details) that is used by the [SpellinBox word game](https://spellinblox.info) and implementing a persistent cache using a remote database that
pull syncs with the SpellinBlox database on successful logins, and push syncs with a manual UI action (was not able to fully test the integration)

Instead of creating a separate username and password, this system forwards the credentials through https with csrf tokens to SpellinBlox to login.
Once SpellinBlox authenticates the credentials, the user's IP address is stored in the server-side session data for a maximum of 20 minutes to handle continued verification.
Additionally, the current database of customized 3-ples is synced to the system's server database and stored. 

These synced 3-ples can then be interacted with by the user for as long as they are verified in the system using some CRUD operations.
several CRUD operations were disabled as they did not contribute to the system's functionality and could be used maliciously to input bad data
into the system. Note: there is a 4th piece of data, domain, but in this demo has been set to be static to
ensure that all testing occurs within the scope of testing data.

## API 

The API has 2 endpoints that are usable: api/tags and api/words. 

CRUD operations are performed on these endpoints using the following request methods, with the data that can be affected by the operation marked in brackets on the right:
`GET api/words/id?` => Retrieve   (All Data)
`POST api/words` => Create        (Tags, Words, Details)
`PUT api/words/id` => Update      (Details)
`DELETE api/words/id` => Delete    (Words)

in the above examples, `api/words` can be replaced with `api/tags`

Tags can be created and retrieved, but never updated or deleted, as it would potentially also effect many words that depend on that tag.

Tag Creation Request
```
POST /api/tags
domain_id:1
text:"French"
```
Response
```
{
    "id": 2,
    "text": "French",
    "domain": {
        "id": 1,
        "url": "https://www-spellinblox-info.filesusr.com/"
    }
}
```

Words can be created, deleted and retireved, but never updated, as that might render its Description void. However, the description/details for words
can be created, retreived and updated, but never deleted as a deletion is equivalent to setting a description to an empty string, which is a valid operation.

Word Retreival Request  (Retreive Detail & Tag at the same time)
```
GET /api/words/
```

Word Retrieval Response
```
[
    {
        "id": 1,
        "text": "nada",
        "details": "English: Nothing\n[More Info](https://www.spanishdict.com/translate/nada)",
        "tag": {
            "id": 1,
            "text": "spanish",
            "domain": {
                "id": 1,
                "url": "https://www-spellinblox-info.filesusr.com/"
            }
        }
    },
    {
        "id": 2,
        "text": "mucho",
        "details": "English: A lot of (Male)\n[More Info](https://www.spanishdict.com/translate/mucho)",
        "tag": {
            "id": 1,
            "text": "spanish",
            "domain": {
                "id": 1,
                "url": "https://www-spellinblox-info.filesusr.com/"
            }
        }
    },
  ...
]
```

Word Creation Request (Creates Detail as the same time)
```
POST api/words/
{
  "text": "Neuvo",
  "details": "New",
  "tag_id": 1
}
```
Word Creation Response
```
{
    "id": 16,
    "text": "Neuvo",
    "details": "New",
    "tag": {
        "id": 1,
        "text": "spanish",
        "domain": {
            "id": 1,
            "url": "https://www-spellinblox-info.filesusr.com/"
        }
    }
}
```

Word Deletion Request
```
DELETE api/words/1/
```
There is no response for Deletes, expect a status code of 204


Detail Update Request
```
PUT api/words/1/
details: "English: Not a thing\n\n[More Info](https://www.spanishdict.com/translate/nada)"
tag_id: 1
text:"nada"
```
Detail Update Response
```
{
    "id": 1,
    "text": "nada",
    "details": "English: Not a thing\n\n[More Info](https://www.spanishdict.com/translate/nada)",
    "tag": {
        "id": 1,
        "text": "spanish",
        "domain": {
            "id": 1,
            "url": "https://www-spellinblox-info.filesusr.com/"
        }
    }
}
```

After every request and response, the UI updates itself to mirror the current database on cache server to provide the user with
a current live view of the cache.

##Setup

The system was developed using Docker with nginx so that it could be deployed with ease and versitility. 

The commands to run the code are as follows:
```
git submodule update --remote
docker-compose -f docker-compose-dev.yml up --build
```

Unfortunately, only the dev build was completed on time, with the production nginx config being the first step in scalability, as there were security concerns about passing self-signed
between React and Django. Ideally, I would have liked to thrown in an encryption protocol with Asynchronous Signing, in additon to the HTTPS protocol. However, HTTPS is used in all outgoing
communication.
Additionally, there are a few refactors that would need to be done to make the frontend more elegant (such as the duplicated login forms that
could be generalized together with a few parameters to maintain their distinct usage cases), but the biggest issue of security between the React and Django
components for security. Lastly, I believe there are some edge cases still, and a few UI things that probably don't line up perfectly.

As the user accounts do not exist on the server, but on the SpellinBlox server, I will e-mail a temporary password to access the testing data along with the link to this repo to you.
That password will be valid for 10 days before it expires.

## Libraries Used

Django
React + TypeScript
Material UI
Django Rest Framework
Personal code snippets from other projects
