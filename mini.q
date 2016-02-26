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
trades: ( [sym:`AAPL`AMZN] qty: 2 5);

/ mtm: `AAPL`AMZN:! (enlist 5; enlist 70)

mtm: select last price by sym from taq;
pos: select sum qty by sym from trades;

eq:: sum pos * mtm

mtm pos

select  price, eq: 2# price wsum qty from w lj mtm lj pos 

data:([]y:1 8 27 64 125;x1:1 2 3 4 5;x2:1 4 9 16 25)

select enlist {sum x} x2 from data

select {[w;price;qty] w * eq;{eq: price wsum qty}}[w;price;qty] from w lj mtm lj pos 
select pct*eq, eq: value price wsum qty from 0!w lj mtm lj pos 


eq:: sum pos * mtm
delta:: "i" $ (neg pos) + w * eq % mtm
os: (where 0 = delta) _ delta

h (`upd; `new; ([] sym: key os; dir: value `BUY`SELL os < 0 ; qty: value os; prx: 99.0; id: `001; tif: `DAY));


