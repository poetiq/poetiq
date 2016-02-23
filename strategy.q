\l ../q/pricehistorydata/googlefinance.q

h: hopen 5005; 

\l common/require.q

require "common/util.q"
require "qx/member.q"
require "qx/seq.q"
require "qx/player.q"


ohlcv: goog[10000;`AAPL`GOOG`AMZN];
ohlcv: `tstamp xasc update tstamp: ((count ohlcv)?.z.N) + "p"$(date+1) from ohlcv; /tstamps are in the historical database.

bt: 2000.03.29 /backtest start
bt: 0Np
lb: 5 /lookback

db: ohlcv /access input data
`timestamp$bt 

bt:`timestamp$bt

db: select from ohlcv where tstamp>=bt


alpha: select tstamp, sym, sig: (count db)?-1 0 1 from db

cnt:1; nrows: count alpha


rslt: exec last sym,last sig, last tstamp from select[cnt] from alpha;
$[cnt<nrows; cnt:: cnt + 1; cnt::count];

w : `AAPL`AMZN!()
w[rslt[`sym]]:rslt[`sig]

eq: 10000

w * eq 

p: `AAPL`AMZN!(`price`units!(5 0); `price`units!(70 0))

p[`AAPL;`price]



send(`long, args, tstamp)

@[neg h; (`send; `cancel; x); "failed to send signal"];

h (`echo;1)

	
h: @[hopen; value .util.args `qx; 0]
