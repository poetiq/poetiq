/ bt2 src C:/lib/Stockopedia/Q/strategy/stockranks.q --exgrp EU --mktcap.sel 5 --mktcap.bins "0 1 10 50 100 350" --qnth 10
/ bt2 src C:/lib/Stockopedia/Q/strategy/stockranks.q --exgrp EU --mktcap.sel 5 --mktcap.bins "0 1 10 50 100 3501" --mktcap.op >= --qnth 9
/ bt2  "[\">=\",\"MktCapGBP\",350]"
.utl.require "qutil"
.util.loadpath: {cd:system "cd"; system "l ", $[10h=type x; x; ":"= first string x; 1_string x; string x]; system "cd ", cd;} / cd:system "cd"; system "cd ", cd
.utl.addArg["S"; enlist `:src; (),0; (`cfg;{ hsym each x}) ]; 
args: #[;.utl.arg.args] i:first where .utl.arg.args like "--*"
opts: i _.utl.arg.args; .utl.arg.args: args; / assumption: options start after first "--", filepaths before
.utl.parseArgs[];
/.utl.arg.posArgs:();

/.utl.addArg["*"; 0; (),1; (`x;{.j.k raze x}) ]

.prm.upd:{
	/.utl.addOpt["json";"*";(`.prm.json;{.j.k raze x})];
	.utl.arg.args: opts;
	/qopt:.Q.opt .z.x;
	/listargs: (where 1<count each qopt)#qopt;
 	/argdict: .Q.def[1_ get[`.prm] ] (`strat`cfg,key listargs) _ qopt;
 	/ty:.Q.t type each argdict[key listargs];
 	/argdict[key listargs]:value upper[ty]$listargs; / attempt to parse q list passed via command line
 	/@[`.; key argdict;: ; value argdict];
 	.utl.addOptDef["qnth"; "I";10;`qnth];
 	.utl.addOptDef["freq"; "S";`quarterly;`freq];	
	.utl.addOptDef["quantiles"; "S";`deciles;`quantiles];
	.utl.addOptDef["mktcap.sel"; "I";5;`mktcap.sel];
	/.utl.addOptDef["mktcapbins"; "";0 1 10 50 100 350f;(`mktcapbins;{"f"$value x}) ]
	.utl.addOptDef["mktcap.bins"; (),"F";0 1 10 50 100 350f;`mktcap.bins ]; /{"f"$value x}
	.utl.addOptDef["mktcap.op"; "*"; ">="; (`mktcap.op; {value x})];
	.utl.addOptDef["exgrp"; "S"; `UK; `exgrp];
	break;
	.utl.parseArgs[];
 }

parsePar:{ $[`=key 1#value x; parsePar[x] ; .utl.addOptDef/: [string key value x; .Q.ty v; v;`qnth]; }
razeEnv: { x,y}
#[;x] each key x
(key;value)@\: x
,/[(1 2;3 4)]
x: value `.prm
{0N!x}each x;
.util.loadpath each cfg;
a:
{[x;y] $[99h=type y; (x;x);(x,y)]} .' flip (key;value)@\: x

(raze/) 
{if[-11h=type key x;key x]}/[x]
({enlist key x}/) x

type `
/
load cfg, load par
addOpts (from prm context)
parseArgs from CLI
load strat
