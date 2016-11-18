\d .ps
/ changed handles to context calls

/w: dictionary of eventtype -> (context;syms). To know what subscriber to call

priority:@[value;`priority;`] / priority of subscribers as ordered list of their symbol names

init:{w::t!(count t::x)#()}

del:{w[x]_:w[x;;0]?y}

sel:{$[`~y;x;select from x where sym in y]}

pub:{[t;x]{[t;x;w]if[count x:sel[x]w 1; value (` sv `,first[w],`upd;t;x)]}[t;x]each w t}

add:{$[(cwx:count wx:w x)>i:w[x;;0]?z; 	/if subscriber already subscribed
		.[`.ps.w;(x;i;1);union;y]; 		/ amend subscribed symbol list
		/cwx>0;                      / if subscriptions exist for the given eventtypes
		/.[`.ps.w; enlist x;:;addtopos[wx;enlist (z;y);priority?z]];	/ add subscription to the prioritised position
		(w[x],:enlist(z;y); w[x]: w[x;iasc "i"$`.ps.priority$w[x;;0];])];			/ else add subscription to the end and resort by priority
	(x;$[99=type v:value x;
		sel[v]y;
		0#v])
 }

addtopos:{[lst;ele;ind] 
	break;
	(ind#lst),ele,(ind _ lst)
 } / add element to index position of the list

sub:{if[x~`;:sub[;y]each t];
	if[not x in t;'x];
	del[x]z;
	add[x;y;z]}

prepschema:{`.sdt set (1_key `.dt)!{delete from x} each 1_value inittables[]} 
prepschema:{{x set delete from value ` sv `.dt,x} each x; x}
/
\e 1
init[`trades`fundamental]
sub[`trades;`AAPL`GOOG]`market
del[`trades;`market]

add[`trades;`AAPL`GOOG;`alpha]
`trades in t
0N!w [`trades;0]
.z.w
w
value `trades

order: `market`alpha
l: enlist (`alpha;`A`B)
order?`market
l[order?`market;]:(`market;`C`D)

addtopos:{[lst;ele;ind] (ind#lst),ele,(ind _ lst)}
l: 
addtopos[l;enlist (`market;`C`D); 0]
1 3 4?2

l

priority: `market`alpha`sdt
v:`enum$`alpha`sdt
enum asc "i"$v
v
x:`trades
.ps.w[x],:enlist(`alpha;`)
`priority$`.ps.w[x]
.[`.ps.w;(x;;); $ ; `priority]
@[`.ps.w;(x;;);get]
-3!.ps.w[x;asc "i"$`priority$.ps.w[x;;0];]
.ps.w[0;0;1]
?
TS:.ps.w[x;;0]
TS TS?priority asc 
iasc "i"$`priority$TS
asc `priority$TS
