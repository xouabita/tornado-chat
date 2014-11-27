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
curl -XPOST "localhost:8888/chatrooms" -d '{"title":"test"}'
```

#### Get the chatrooms list
```bash
curl "localhost:8888/chatrooms"
```
