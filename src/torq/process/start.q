/define init, config methods
.proc.init: {
  system "l ",x
 }
/init
/pass process config here

/cfg
/pass strategy config here

.proc.init["src/torq/process/cfg.q"]
.proc.init["src/torq/process/process.q"]
.proc.init["src/torq/process/run.q"]

if[count filepath:raze .Q.opt[.z.x]`cfg;
   .proc.init[filepath]]

system "p ",string .proc.port
