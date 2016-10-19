\d .proc
typedir: 1!flip `proctype`dirname!flip (
 `dscvry`discovery;
 `hkp`housekeeping;
 `hdb`hdb;
 `kill`kill;
 `feed`feed;
 `gw`gateway;
 `oms`oms;
 `mkt`market;
 `tick`tickerplant;
 `pfolio`portfolio;
 `btctrl`backtest;
 `portcon`portcon)

update port: 5000+til count typedir from `typedir