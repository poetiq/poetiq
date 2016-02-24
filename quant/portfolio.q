require "common/quant.q"

\d .portfolio

/ Return the sparse covariance matrix for the given table of prices.
/ Columns of x must include `sym`prx
/ Returned table has columns `sym1`sym2`cv

R: () ! ()

covariance: {
	x: 0 ! select r: log prx % prx ^ prev prx by sym from x;
	R:: x [`sym] ! x [`r];
	p: distinct asc each x [`sym] cross x [`sym];
	([] sym1: first each p; sym2: last each p; cv: {cov [R first x; R last x]} each p)
	}


/ Return the weightings of a minimum variance portfolio for the given sparse covariance matrix.
/ x may be the matrix or a list comprising the matrix and a list of symbols
/ Returned table has columns `sym`wt

M: ()

minvariance: {
	s: $[0 = type x; [M:: first x; last x]; [M:: x; distinct x `sym1]];
	([] sym: s; wt: .quant.w {exec reciprocal sum cv from M where (sym1 = x) or (sym2 = x)} each s)
	}


/ Return the target quantities (qt) and delta quantities (qd) for a portfolio x transitioning to
/ the weights in table z such that holdings never increase.
/ Columns of x must include `sym`qty
/ Columns of y must include `sym`prx
/ Columns of z must include `sym`wt
/ Returned table has columns `sym`qty`prx`w`wt`qt`qd

reweight: {
	x: update w: .quant.w v from update v: prx * qty from (`sym xkey x) lj `sym xkey y;
	x: update sumv: v % wt from x lj `sym xkey z;
	minsumv: exec first sumv from x where sumv = min sumv;
	select sym, qty, prx, w, wt, qt, qd: qty - qt from update qt: `int$ (minsumv * wt) % prx from x
	}

\d .
