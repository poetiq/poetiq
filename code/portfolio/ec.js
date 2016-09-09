var serverurl = "//localhost:5016/",
	ws,
	c = connect();

function connect() {
	if ("WebSocket" in window) {
		ws=new WebSocket("ws:" + serverurl);
		ws.binaryType="arraybuffer";
		ws.onopen=function(e){ 
			ws.send(serialize(['loadPage',[]]));
		};
		ws.onclose=function(e){ 
		};
		ws.onmessage=function(e){
				var d = deserialize(e.data);
				return recreateChart(d);
		};
		ws.onerror=function(e) {window.alert("WS Error") };
	} else alert("WebSockets not supported on your browser.");
}

function toUTC(x) {
	var y = new Date(x); 
	y.setMinutes(y.getMinutes() + y.getTimezoneOffset()); 
	return y.getTime();
}
function recreateChart(data) {
	// var d = [ [420000000,1],[420000005, 5]];
	$('#container').highcharts('StockChart', {
		chart : {
			events : {
				load : function () {
					var series = this.series[0];
					//series.addPoint([x,y], true, true);
					series.setData(data.map(function(x){return [toUTC(x.time), x.ec]}))
				}
			}
		},
		rangeSelector : {
			selected : 1
		},
		title : {
			text :' Equity Curve'
		},		
		series : [{
			name : "ec",
			//data: data,
			data : data.map(function(x){return [toUTC(x.time), x.ec]}),
			// data: d,
			tooltip: {
				valueDecimals: 2
			}
		}]
	});
}