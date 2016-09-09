function KDB(host, port) {
	console.assert("WebSocket" in window, "WebSockets are not supported in your browser");
	if (typeof host === 'undefined') {
		console.warn("'host' is not defined, using 'localhost'");
		host = "localhost";
	}
	if (typeof port === 'undefined') {
		console.warn("'port' is not defined, using '1234'");
		port = 1234;
	}
	this.host = host;
	this.port = port;
}

KDB.prototype.query = function(cmd, handler) {
	console.log(cmd);
	var ws = new WebSocket("ws://" + this.host + ":" + this.port + "/");
	ws.binaryType = "arraybuffer";
	ws.onopen = function(e) {
		console.log("connected");
		ws.send(serialize(cmd));
	}
	ws.onclose = function(e) {
		console.log("disconnected");
	}
	ws.onmessage = function(e) {
		var arrayBuffer = e.data;
		if (arrayBuffer) {
			var data = deserialize(arrayBuffer);
			handler(data);
		}
		ws.close();
	};
	ws.onerror = function(e) {
		console.error(e.data);
	}
	window.addEventListener("onbeforeunload", function() {
		ws.onclose = {};
		ws.close();
	}, false);
}


Date.prototype.formatQ = function() {
	var yyyy = this.getFullYear().toString();
	var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
	var dd = this.getDate().toString();
	return yyyy + "." + (mm[1] ? mm : "0" + mm[0]) + "." + (dd[1] ? dd : "0" + dd[0]); // padding
};

KDB.prototype.listen = function() {
	var ws = new WebSocket("ws://" + this.host + ":" + this.port + "/");
	ws.binaryType = "arraybuffer";
	ws.onopen = function(e) {
		console.log("connected");
	}
	ws.onclose = function(e) {
		console.log("disconnected");
	}
	ws.onmessage = function(e) {
		var d =  deserialize(e.data);
        // messages should have format [‘function’,params]
        // call the function name with the parameters
        window[d.shift()](d[0]);
    };
	ws.onerror = function(e) {
		console.error(e.data);
	};
	return ws;
}