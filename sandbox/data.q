\l ../hdb/equitysim
\S 104831
bgn: -0W; end: 0W;
end:syms: 0; / optional global feeder parameters
src: `trade`quote;
`symbol$()
select from `trade where (date + time) within (bgn; end) and sym in 
update tstamp:date + time from `trade;
update tstamp:date + time from `quote;
select date + time from `trade 