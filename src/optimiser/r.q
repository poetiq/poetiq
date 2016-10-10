/ incorporating (r)eturn and (r)isk information into portfolio weights
/ sig: ([sym:`$()] w: `float$())

equal: {c#1%c:sum not 0=signum x}

noshort: { x*x>0 }

units: {[n;x]
	n * `long$signum x
	}

pweights: {[w]
	/ Returns an empty weights table of the correct types if current weights table is null.
	$[not null w;w;([sym:`$()]sz:`float$())]
	}

/ Generates a target weight event.
twevent:{[s;d;w;t] 
	([]sym:enlist s;date:enlist d;w:enlist w;time:enlist t)
	}