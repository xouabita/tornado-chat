Chat With Tornado
=================

Simple chat with tornado, websockets, elasticsearch and angularjs.

To launch: `python app.py`

API
---

### Chatrooms

#### Create a new chatroom
```bash
curl -XPOST "localhost:8888/chatrooms" -d 'data={"title":"test"}'
```

#### Get the chatrooms list
```bash
curl "localhost:8888/chatrooms"
```
