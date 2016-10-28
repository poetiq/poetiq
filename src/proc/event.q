\d .event

quote:flip`time`sym`bid`ask`bsize`asize`mode`ex!"tsffjjcc"$\:()
trade:flip`time`sym`price`size`stop`cond`ex!"tsfjbcc"$\:()
mtm:flip`time`date`sym`close!"ndsf"$\:()
signal:flip`sym`date`signal`time!"sdin"$\:()
targetsz:flip`sym`date`sz`time!"sdin"$\:()
targetw:flip`sym`date`w`time!"sdfn"$\:()
order:flip`sym`size!"sj"$\:() / aim towards flip `sym`dir`size`price`tif`id!"siffs"$\:()		`symbol$	();
fill:flip`sym`size`price!"sfj"$\:() / flip`date`sym`time`price`size`stop`cond`ex!"dstfjbcc"$:\()
