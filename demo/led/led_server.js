var http = require('http');
var url = require('url');
var qs = require('querystring');
var rest = require('restler');

http.createServer(function (req, res) {


    req.on('end', function () {
        console.log(url.parse(req.url));
        var req_url = url.parse(req.url);
        var path_name = req_url.pathname;

        console.log('-------------------params data');

        var msgObj = qs.parse(req_url.query);
        console.log(msgObj);
        //var msg=JSON.parse()
        if (path_name == '/receive') {
            var msg = msgObj.message;
            rest.post('http://localhost:3000/ptl/receive', {data:{message: msg}}).on('complete', function (data, response) {
                console.log(response.statusCode);
                console.log('-------------------data');
                console.log(data);
            });
            res.end(msg);
        } else if (path_name == '/api/control') {

            res.end('0');
        } else {
            res.writeHead(404);
            res.end();
        }
    });
    //res.writeHead(200, {'Content-Type': 'text/plain'});
    //res.end('Hello World\n');
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');
