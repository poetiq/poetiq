/ incorporating (r)eturn and (r)isk information into portfolio weights
/ sig: ([sym:`$()] w: `float$())

eqw:{x*1%sum x}

long:{x*x>0}

units:{[n;x] n*`long$signum x}

/ wtype:`equal / Long only equal weights.

/ if[wtype=`equal; wfun:{select sym, date, w:eqw long signal, time from x}; args:enlist alphas;]
/ wfun:{select sym, date, w:eqw long signal, time from x};
/ args:enlist alphas;

/ if[wtype=`unit; wfun:{select sym, date, sz:units[1] signal, time from x}; args: enlist alphas;]

/ x:1!flip`sym`date`signal`time!(`aapl`baapl`caapl;(2016.05.02;2016.05.02;2016.05.02);(1i;-1i;0i);(23:59:59.002854000;23:59:59.002854000;23:59:59.002854000))
/ wtest:{select sym, date, w:eqw long signal, time from x}
/ wtest . enlist x
