import tornado.ioloop
import tornado.web
import tornado.websocket
from elasticsearch import Elasticsearch
from datetime import datetime
from tornado.escape import json_encode
import json

ELASTIC_INDEX = "simple-chat-tornado"

es = Elasticsearch()
clients = []

class StaticFileHandler(tornado.web.StaticFileHandler):
    def set_extra_headers(self, path):
        self.set_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')

class IndexHandler(tornado.web.RequestHandler):
    def get(request):
        with open('index.html') as f:
            request.write(f.read())

class ChatroomsHandler(tornado.web.RequestHandler):
    def get(self):
        res = es.search(index=ELASTIC_INDEX, body={"query": {"match_all": {}}})
        answer = []
        for hit in res['hits']['hits']:
            room = {
                "_id": hit["_id"],
                "title": hit["_source"]['title'],
                "timestamp": hit["_source"]['timestamp'],
                "updated": hit["_source"]['timestamp']
            }
            answer.append(room)
        self.write(json_encode(answer))

    def post(self):
        data = json.loads(self.get_argument('data'))
        doc = {
            "title": data['title'],
            "timestamp": datetime.now(),
            "updated": datetime.now()
        }
        es.index(index=ELASTIC_INDEX, doc_type="chatroom", body=doc)

class WebSocketChatHandler(tornado.websocket.WebSocketHandler):
    def open(self, *args):
        print("open","WebSocketChatHandler")
        clients.append(self)

    def on_message(self, message):
        print message
        for client in clients:
            client.write_message(message)

    def on_close(self):
        clients.remove(self)

app = tornado.web.Application([
    (r'/', IndexHandler),
    (r'/chat', WebSocketChatHandler),
    (r'/chatrooms', ChatroomsHandler),
    (r'/assets/(.*)', StaticFileHandler, {'path': 'bower_components'}),
    (r'/styles/(.*)', StaticFileHandler, {'path': 'styles'}),
    (r'/scripts/(.*)', StaticFileHandler, {'path': 'scripts'}),
])
app.listen(8888)
tornado.ioloop.IOLoop.instance().start()
