
function connect(){
	if ("WebSocket" in window) {
		ws = new WebSocket("ws://localhost:5001");
ws.binaryType = 'arraybuffer'; // using serialisation
ws.onopen=function(e){
 // on successful connection, we want to create an initial subscription to load all the data into the page
 ws.send(serialize(['loadPage',[]]));
};
ws.onclose=function(e){console.log("disconnected");};
ws.onmessage=function(e){
 // deserialise incoming messages
 var d = deserialize(e.data);
 // messages should have format [‘function’,params]
 // call the function name with the parameters
 window[d.shift()](d[0]);
};
ws.onerror=function(e){console.log(e.data);};
} else alert("WebSockets not supported on your browser.");
}
function filterSyms() {
 // get the values of checkboxes that are ticked and convert into an array of strings
 var t = [], s = syms.children;
 for (var i = 0; i < s.length ; i++) {
 	if (s[i].checked) { t.push(s[i].value); };
 };
 // call the filterSyms function over the WebSocket
 ws.send(serialize(['filterSyms',t]));
}
function getSyms(data) {
 // parse an array of strings into checkboxes
 syms.innerHTML = '';
 for (var i = 0 ; i<data.length ; i++) {
 	syms.innerHTML += '<input type="checkbox" name="sym" value="' +
 	data[i] + '">' + data[i] + '</input>';
 };
}
function getQuotes(data) { quotes.innerHTML = tableBuilder(data); }
function getTrades(data) { trades.innerHTML = tableBuilder(data); }
function tableBuilder(data) {
 // parse array of objects into HTML table
 var t = '<tr>'
 for (var x in data[0]) {
 	t += '<th>' + x + '</th>';
 }
 t += '</tr>';
 for (var i = 0; i < data.length; i++) {
 	t += '<tr>';
 	for (var x in data[0]) {
 		t += '<td>' + (("time" === x) ?
 			data[i][x].toLocaleTimeString().slice(0,-3) : ("number" == typeof
 				data[i][x]) ? data[i][x].toFixed(2) : data[i][x]) + '</td>';
 	}
 	t += '</tr>';
 }
 return t ;
}