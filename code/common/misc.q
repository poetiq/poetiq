\d .misc

pivot:{[t;c;b;val]
  S:asc ?[t;();();(?:;c)];
  ?[t;();b!b;(#;`S;(!;c;val))]}

getprices:{[c] pivot[`bars;`sym;`date`time;c]}
history:{[i;c] pivot[;`sym;enlist`time;c] ungroup (neg i)#`time xgroup ?[`quotes;();0b;x!x:distinct `time`sym,c]}
history2:{[i;c] ungroup (neg i)#`time xgroup ?[`quotes;();0b;c!c:distinct `time`sym,c]}

mid:.5*+ / mid point
spread:.5*- / half spread
chg:-1+% / % change
bps:1e4* / basis points
ppm:1e6* / parts-per-million
ret:{-1+ratios x} / return
dir:{signum deltas[first x;x]} / price direction
up:(>)prior / up ticks
down:(<)prior / down ticks
scratch:(=)prior / flat

flatten:raze over / flattens lists and enlists atoms

fillempty:{@[x;where 0=count each x;:;y]} / hack to remove empty lists ()
dropzero:{k!x k:where not 0=x} / drops zero values from dict

fifo:{deltas y&sums x};
lifo:{reverse deltas y&sums reverse x}

/- Checks which dates a given list of symbols appears in
getDates:{[table;syms;begin;end]
	symsByDate:select distinct sym by date from table[]where date within(begin;end);
	firstSymList:exec first sym from symsByDate;
	val:(@[type[firstSymList]$;;`badCast]each(),syms)except`badCast;
	exec date from(select date,val{(x in y)|/}/:sym from symsByDate)where sym=1b}

bollingerBands:{[k;n;data]
  md:sqrt mavg[n;data*data]-movingAvg*movingAvg:mavg[n;data];
  movingAvg+/:(k*-1 0 1)*\:md}

rid:{`$string first 1?0Ng} / random id

\
vals: 20 + (100?5.0)
bollingerBands[2;20] vals
history[200;`askclose]