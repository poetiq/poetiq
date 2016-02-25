/ http://www.kdbfaq.com/kdb-faq/how-do-i-use-the-functional-form-of-at-apply.html

w:  `AAPL`AMZN ! (enlist 0; enlist 1);

taq: ([sym:`AAPL`AMZN] qty: 5 70);
trades: ([sym:`AAPL`AMZN] qty: 2 5);

/ mtm: `AAPL`AMZN:! (enlist 5; enlist 70)

mtm: exec last qty by sym from taq;
pos: exec sum qty by sym from trades;

eq:: sum pos * mtm;
delta:: floor (pos - w * eq % mtm) +.5;
os: (where (key delta)!raze value delta>0)#delta; / order size

{0N!x} each os 

h: hopen 5009;

-22!os
\ts os

h (`upd; `new; ([] sym: 2 # `AAA; dir: 2 # `BUY; qty: 2 # 2000; prx: 99.0 98.0; id: `001`002; tif: 2 # `DAY));