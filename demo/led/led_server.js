var http = require('http');
var url = require('url');
var qs=require('querystring');
var rest=require('restler');

http.createServer(function (req, res) {
req.on('end',function(){
	console.log(req.url);
	console.log(url.parse(req.url));

	var req_url=url.parse(req.url);
	if(req_url.pathname=='/receive'){
		var msg=qs.parse(req_url.query).msg;

		rest.post('http://localhost:3000/ptl/receive',{message: msg}).on('complete',function(data,response){
	    console.log(response.statusCode);
        console.log(data);
	});

	    res.end(msg);
	}else{
	 res.writeHead(404);
	 res.end();
	}
});
	  //res.writeHead(200, {'Content-Type': 'text/plain'});
		//res.end('Hello World\n');
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');
