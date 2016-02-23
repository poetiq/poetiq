/ http://www.kdbfaq.com/kdb-faq/how-do-i-use-the-functional-form-of-at-apply.html

w:  `AAPL`AMZN ! (enlist 0; enlist 1)

taq: ([sym:`AAPL`AMZN] qty: 5 70)
trades: ([sym:`AAPL`AMZN] qty: 2 5)

/ mtm: `AAPL`AMZN:! (enlist 5; enlist 70)

mtm: exec last qty by sym from taq
pos: exec sum qty by sym from trades

eq:: sum pos * mtm
delta:: floor (pos - w * eq % mtm) +.5
os: (where (key delta)!raze value delta>0)#delta / order size
