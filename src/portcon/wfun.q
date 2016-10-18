/ incorporating (r)eturn and (r)isk information into portfolio weights

eqw:{x*1%sum x}

long:{x*x>0}

units:{[n;x] n*`long$signum x}

/ Equal weight strategy
wfun:{select sym, date, w:eqw long signal, time from x}; eventtype:`targetw 

/ Single unit strategy
/ wfun:{select sym, date, sz:units[1] signal, time from x}; eventtype:`targetsz