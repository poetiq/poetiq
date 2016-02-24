\l qx/member.q

h: hopen 2009;

h (`upd; `new; ([] sym: 2 # `AAA; dir: 2 # `BUY; qty: 2 # 2000; prx: 99.0 98.0; id: `001`002; tif: 2 # `DAY));
h (`upd; `new; ([] sym: 4 # `AAA; dir: 4 # `SELL; qty: 4 # 1000; prx: 100.0 101.0 102.0 103.0; id: `003`004`005`006; tif: 4 # `DAY));
h (`upd; `new; enlist `sym`dir`qty`prx`id`tif ! (`AAA; `BUY; 1750; 102.0; `007; `IOC));
h (`upd; `new; enlist `sym`dir`qty`prx`id`tif ! (`AAA; `SELL; 5000; 99.0; `008; `DAY));
h (`upd; `cancel; ([] id: enlist `006));