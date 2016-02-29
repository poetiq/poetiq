/ http://www.kdbfaq.com/kdb-faq/how-do-i-use-the-functional-form-of-at-apply.html

w:  `AAPL`AMZN ! (0; 1)

taq: ( [sym:`AAPL`AMZN] price: 5 70f);
trades: ( [sym:`AAPL`AMZN] qty: 2 5);

/ mtm: `AAPL`AMZN:! (enlist 5; enlist 70)

mtm: exec last price by sym from taq;
pos: exec sum qty by sym from trades;

eq:: sum pos * mtm
delta:: "i" $ (neg pos) + w * eq % mtm
os: (where 0 = delta) _ delta

h (`upd; `new; ([] sym: key os; dir: value `BUY`SELL os < 0 ; qty: value os; prx: 99.0; id: `001; tif: `DAY));


///////////////////


w:  ( [sym:`AAPL`AMZN] pct: 0 1)

taq: ( [sym:`AAPL`AMZN] price: 5 70f);
trades: ( [sym:`AAPL`AMZN; tstamp: 2 # 2015.01.01T00] qty: 2 5; prx: 5 70f);

// OPTIMIZER //
/ provides target portfolio view
target:  delete from .schema.holdings;

// PORTFOLIO STATE MACHINE //
holdings: delete from .schema.holdings;
`holdings upsert (select sum qty, last prx by sym from trades);

/ subscribes to price updates and marks positions to market
/ provides view: equity value
eq:: exec qty wsum prx from holdings


// ORDER MANAGEMENT SYSTEM //
h (`upd; `new; ([] sym: key os; dir: value `BUY`SELL os < 0 ; qty: value os; prx: 99.0; id: `001; tif: `DAY));


