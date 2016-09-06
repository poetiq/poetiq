/q tick.q SRC [DST] [-p 5010] [-o h]
system"l tick/",(src:first .z.x,enlist"sym"),".q"

/ add date column to schemas
{if[not `date in cols get x; x set `date`sym`time xcols update date:() from get x]}each tables[];

\l tick/u.q
\d .u

tick:{[x;y] init[];};

upd:{[t;x]
	f:key flip value t;
	pub[t;$[0>type first x;enlist f!x;flip f!x]];
 };

\d .
.u.tick[src;ssr[.z.x 1;"\\";"/"]];
