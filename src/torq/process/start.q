/define init, config methods
.proc.init: {
  system "l ",x
 }
/init
/pass process config here

/cfg
/pass strategy config here


.proc.init["src/torq/process/cfg.q"]
.proc.init["src/torq/process/fun.q"]
.proc.init["src/torq/process/run.q"]

if[count cfgpath:raze .Q.opt[.z.x]`cfg;
   .proc.init[cfgpath];
   system "p ",string .proc.port;]

/

-----------
process/cfg
process/fun						/ consider merging into /cfg
process/run
	(common)
	(handlers)

-----------
cfg + fun
run
	.servers.startup[]

/ ######
/ consider merging (process)/fun into (process)/cfg