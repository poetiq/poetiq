/q tick.q SRC [DST] [-p 5010] [-o h]
system"l tick/",(src:first .z.x,enlist"sym"),".q"

/ add date column to schemas
{if[not `date in cols get x; x set `date`sym`time xcols update date:() from get x]}each tables[];

\l tick/u.q
\d .u

b: `int$();
tick:{[x;y] init[];};
hswitch:.servers.gethandlebytype[`btswitch;`any];

/ callback when subscriber is done. Removes the handle from (b)acklog
done:{
	if[0=cb:-1 + count b; (neg hswitch) "pause:0b"];
	/0N!"removing a job at ", (string .z.N) , " from handle ", (string .z.w) , "; remaining jobs: ", string cb; 
	b::b _b?.z.w;};

/ variation of (pub)lish with callback tracking. Maintains (b)acklog of jobs for which no callback has yet been received
pub_aware:{[t;x]
	{[t;x;w]
		if[count x:sel[x]w 1; 
		   b,::first w; 
		   /{0N!.z.N}();
		   (neg first w)(`.m.marshal;`upd;(t;x);`.u.done)] / example 3 from http://code.kx.com/wiki/Cookbook/Callbacks
	}[t;x]each w t
	};

upd:{[t;x]
	f:key flip value t;
		pub_aware[t;$[0>type first x;enlist f!x;flip f!x]];
 };

\d .
.u.tick[src;ssr[.z.x 1;"\\";"/"]];
