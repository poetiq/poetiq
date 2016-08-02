i:0
data:()

/ end of feed
eof:{not i<n and n:count data}

loaddata:{[bgn;end;syms;mns]
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`ohlc;bgn;end;syms;minutes);`hdb);
	data::h[];
 };

reset:{i::0;}

init:{[bgn;end;syms;mns]
	reset[];
	loaddata[bgn;end;syms;mns];
	@[neg .z.w;(`upd;`init;"Backtester initialized");"failed to send ready signal to ",string .z.w];
 };

/ handle, time, quotes
send:{[h;t;x] i+::1; @[neg h;(`upd;`quote;(t;x));"failed to send data to ",string h];}

done:{@[neg x;(`upd;`done;enlist`);"failed to send completion signal to ",string x];}

stepnext:{$[not eof[];send[.z.w] . bar i;done .z.w]}

/ get ith bar
bar:{(first over key@;ungroup value@)@\:1!select from data where i=x}

schema:{0!delete from data}

who:{.z.w}

.servers.startup[]

\
bgn:2016.05.01
end:2016.06.01
syms:`AAPL`MSFT
minutes:5

loaddata[bgn;end;syms;minutes]
data
