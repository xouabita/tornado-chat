import tornado.ioloop
import tornado.web
import tornado.websocket
from elasticsearch import Elasticsearch
from datetime import datetime
from tornado.escape import json_encode
import json

ELASTIC_INDEX = "simple-chat-tornado"
es = Elasticsearch()

ROOMS = {}

dtjson = lambda obj: (
    obj.isoformat() if isinstance(obj, datetime) else None
)

class StaticFileHandler(tornado.web.StaticFileHandler):
    def set_extra_headers(self, path):
        self.set_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')

class IndexHandler(tornado.web.RequestHandler):
    def get(request):
        with open('index.html') as f:
            request.write(f.read())

class ChatroomsHandler(tornado.web.RequestHandler):

    def get(request):
        res = es.search(index=ELASTIC_INDEX, doc_type="chatroom", body={"query": {"match_all": {}}})
        answer = []
        for hit in res['hits']['hits']:
            room = {
                "_id": hit["_id"],
                "title": hit["_source"]['title'],
                "timestamp": hit["_source"]['timestamp'],
                "updated": hit["_source"]['timestamp']
            }
            answer.append(room)
        request.write(json_encode(answer))

    def post(self):
        data = json.loads(self.request.body)
        doc = {
            "title": data['title'],
            "timestamp": datetime.now(),
            "updated": datetime.now()
        }
        es.index(index=ELASTIC_INDEX, doc_type="chatroom", body=doc)

class ChatroomHandler(tornado.web.RequestHandler):

    def get(self, room):
        roo = es.get(index=ELASTIC_INDEX, doc_type="chatroom", id=room)
        msgs = es.search(index=ELASTIC_INDEX, doc_type="message", body={
            "query": {
                "match": {
                    "room":room
                }
            },
            "sort": [
                {"timestamp": { "order":"desc"} }
            ]
        })
        messages = []
        for hit in msgs['hits']['hits']:
            messages.insert(0, {
                "username": hit["_source"]["username"],
                "message": hit["_source"]["message"],
                "timestamp": hit["_source"]["timestamp"]
            })
        answer = {
            "_id": room,
            "title": roo['_source']['title'],
            "messages": messages
        }
        self.write(json_encode(answer))

    def post(self, room_id):
        data = json.loads(self.request.body)
        doc = {
            "username": data['username'],
            "message": data['message'],
            "room": room_id,
            "timestamp": datetime.now()
        }
        es.index(index=ELASTIC_INDEX, doc_type="message", body=doc)
        for item in ROOMS[room_id]:
            item.write_message(json.dumps(doc, default=dtjson))

class RoomSocket(tornado.websocket.WebSocketHandler):
    def open(self, room_id):
        self.room_id = room_id
        if not room_id in ROOMS:
            ROOMS[room_id] = []
        ROOMS[room_id].append(self)

    def on_close(self):
        ROOMS[self.room_id].remove(self)
        if len(ROOMS[self.room_id]) is 0:
            ROOMS.pop(self.room_id, None)

app = tornado.web.Application([
    (r'/', IndexHandler),
    (r'/chatroom/.*', IndexHandler),
    (r'/chatrooms', ChatroomsHandler),
    (r'/chatrooms/([a-zA-Z0-9-_]{22})', ChatroomHandler),
    (r'/assets/(.*)', StaticFileHandler, {'path': 'bower_components'}),
    (r'/styles/(.*)', StaticFileHandler, {'path': 'styles'}),
    (r'/scripts/(.*)', StaticFileHandler, {'path': 'scripts'}),
    (r'/angular_templates/(.*)', StaticFileHandler, {'path': 'angular_templates'}),
    (r'/roomsocket/(.*)', RoomSocket)
])
app.listen(8888)
tornado.ioloop.IOLoop.instance().start()
