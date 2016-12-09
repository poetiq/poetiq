\d .ext
groupbytstamp: {?[x;();(enlist `etstamp)!enlist `tstamp; allc!allc:cols[x]]} / except `tstamp
transfev:{select event:x, etstamp, data:flip value flip value grpd from grpd:groupbytstamp `dt[x]}
queue: {`etstamp xasc (,/){transfev[x]} each 1_key `dt}
