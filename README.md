Chat With Tornado
=================

Simple chat with tornado, websockets, elasticsearch and angularjs.

Usage
-----

### Installation

#### Requirements

- Elasticsearch
- nodejs
- bower
- pip packages:
  - elasticsearch-py
  - tornado

#### To install dependencies:

```bash
bower install
npm install
```

### Run the app

```
gulp (serve)    # run the tornado app and watch for styles & scripts
gulp build      # build scripts & styles
gulp runserver  # run the tornado server
gulp watch      # watch styles & scripts
```

API
---

### Chatrooms

#### Create a new chatroom
```bash
POST /chatrooms
{
  "title":"test"
}
```

#### Get the chatrooms list
```bash
GET /chatrooms
```

#### Delete a chatroom
```bash
DELETE /chatrooms/:room_id
```

### Messages

#### Post a message
```bash
POST /chatrooms/:room_id
{
  "username":"user",
  "message":"foobarlol"
}
```
