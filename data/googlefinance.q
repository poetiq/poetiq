/ source: http://code.kx.com/wsvn/code/contrib/simon/googlefinance/googlefinance.q

/ grab googlefinance stock OHLCV history
/ http://finance.google.com

goog0:{[site;offset;stocks] / goog[100;`GOOG`AMZN], start q with slaves to take advantage of peach
    zs:(ze:`date$.z.z)-offset;
    m:`Jan`Feb`Mar`Apr`May`Jun`Jul`Aug`Sep`Oct`Nov`Dec;
    parms:"&startdate=",(string m -1+`mm$zs),"+",(string`dd$zs),"%2C+",(string`year$zs),"&enddate=",(string m -1+`mm$ze),"+",(string`dd$ze),"%2C+",(string`year$ze),"&output=csv";
    tbl:flip`Date`Open`High`Low`Close`Volume`Sym!("DEEEEIS";" ")0:();
    tbl,:raze{$["200"~3#9_r:httpget["finance.google.com"]"/finance/historical?q=",(string x),y;update Sym:x from select from("DEEEEI ";enlist",")0:{(x ss"Date,Open")_ x}r;z]}[;parms;tbl]peach distinct upper stocks,();
    (lower cols tbl)xcol`Date`Sym xasc select from tbl where not null Volume}

goog:googus:goog0"finance.google.com"   
googca:goog0"finance.google.ca" 
googuk:goog0"finance.google.co.uk"
googcn:goog0"finance.google.cn"

/ fetch nasdaqdaily report
/ http://www.nasdaqtrader.com/Trader.aspx?id=DailyMarketFiles
/ http://www.nasdaqtrader.com/Trader.aspx?id=DailyMarketSummaryDefs

nasdaqdaily:{fmts:"*EEEEEEEEEEEEEEEFFFFEEE";
    hdrs:`Date`N100`Financial100`Composite`CompositeHi`CompositeLow`N100Hi`N100Low`Industrial`Bank`Insurance`Financial`Transportation`Telecom`Biotech`Computer`NasdaqTrades`Volume`DolVol`MktVal`Advances`Declines`Unchanged;
    t:hdrs xcol(fmts;enlist",")0:(1_r ss"Date")_r:httpget["www.nasdaqtrader.com";"/dynamic/dailyfiles/daily2008.csv"];
    / correct wacko date format
    asc update Date:"D"${-8_x}each Date from t}

/ http://www.cboe.com/micro/vix/historical.aspx
/ CBOE Volatility Index - VIX
/ CBOE DJIA Volatility Index - VXD
/ CBOE NASDAQ-100 Volatility Index - VXN 
/ CBOE Russell 2000 Volatility Index - RVX
/ CBOE S&P 100 Volatility Index - VXO

cboe:{fmts:"DEEEE";
    syms:string`rvxdailyprices`vixcurrent`vxdohlcprices`vxncurrent`vxocurrent;
    sd:({`$3#x}each syms)!syms; hdrs:`date`open`high`low`close;
    r:httpget["www.cboe.com";"/publish/ScheduledTask/MktData/datahouse/",(sd@lower x),".csv"];
    if[count(20#r)ss"404 Not";'"404 not found"];
    t:hdrs xcol(fmts;enlist",")0:(r ss"Date[, ]")_r;
    delete from t where null date}
    
vix::cboe`vix

httpget:{[host;location] (`$":http://",host)"GET ",location," HTTP/1.1\r\nHost:",host,"\r\n\r\n"} 
/sp500:asc first flip` vs/: `$read0`:tick/sp500.txt