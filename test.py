from functools import partial
import redis
import threading
import tornado.web
import tornado.websocket
import tornado.ioloop
import tornado.httpserver

TEMPLATE = """
<!DOCTYPE>
<html>
<head>
    <title>Sample test</title>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.4.2.min.js"></script>
</head>
<body>
    <h1>Hello world</h1>
    <form method='POST' action="./">
        <textarea name='data' id="data"></textarea>
        <div><input type="submit"></div>
    </form>
    <div id="log"></div>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function(){
            $('form').submit(function(event){
                var value = $('#data').val();
                $.post("./", { data: value }, function(data){
                    $("#data").val('');
                });
                return false;
            });
            if ("WebSocket in window") {
                var ws = new WebSocket("ws://localhost:8888/realtime/");
                ws.onopen = function() {};
                ws.onmessage = function (evt) {
                    var received_msg = evt.data;
                    var html = $("#log").html();
                    html += "<p>"+received_msg+"</p>";
                    $('#log').html(html);
                };
                ws.onclose = function () {};
            } else {
                alert("WebSocket not supported");
            }
        });
    </script>
</body>
</html>
"""

# The listener are the list of WebSocketHandler
LISTENERS = []

def redis_listener():
    r = redis.Redis()
    ps = r.pubsub()
    ps.subscribe('test_realtime')
    io_loop = tornado.ioloop.IOLoop.instance()
    for message in ps.listen():
        for element in LISTENERS:
            io_loop.add_callback(partial(element.on_message, message))

class NewMsgHandler(tornado.web.RequestHandler):
    def get(self):
        self.write(TEMPLATE)

    def post(self):
        data = self.get_argument('data')
        r = redis.Redis()
        r.publish('test_realtime', data)

class RealtimeHandler(tornado.websocket.WebSocketHandler):
    def open(self):
        LISTENERS.append(self)

    def on_message(self, message):
        self.write_message(message['data'])

    def on_close(self):
        LISTENERS.remove(self)

settings = {
        'auto_reload': True,
}

application = tornado.web.Application([
    (r'/', NewMsgHandler),
    (r'/realtime/', RealtimeHandler),
], **settings)

if __name__ == "__main__":
    threading.Thread(target=redis_listener).start()
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
