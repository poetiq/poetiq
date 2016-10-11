/ incorporating (r)eturn and (r)isk information into portfolio weights
/ sig: ([sym:`$()] w: `float$())

equal: {c#1%c:sum not 0=signum x}

noshort: { x*x>0 }

units: {[n;x]
	n * `long$signum x
	}