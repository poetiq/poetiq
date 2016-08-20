\d .po

h:{.servers.gethandlebytype[`oms;`roundrobin]}

.po.order:{[syms;sizes]
	.lg.o[`order;"sending order"];
	o::(delete from .schema.orders) upsert `sym`size!(syms;sizes);
	(neg h[])(`upd;`order;enlist o);
 };

\
h[]
.po.order[`AAPL;100]
o
{show x} . enlist o
