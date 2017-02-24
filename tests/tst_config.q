.tst.desc["Service"]{
  should["support requests of type: screen/checklist/calculate/backtest/(trade)"]{};
  should["be testable using qspec framework from CLI"]{}; / $ testq init.q /path/to/strat/file.q
 };

.tst.desc["Strategy Algorithm"]{
  should["be loadable from paths to q scripts provided via CLI"]{}; /$ bt src /path/to/strat/file.q
  should["be parsable from JSON"]{};
 };
.tst.desc["Strategy Parameters"]{
  should["be parsable from JSON via CLI"]{};
  should["be parsable from JSON via IPC"]{};
  should["be parsable from CLI options"]{};
 };

.tst.desc["Backtest"]{
  should["be configurable & executable from REPL"]{}; / cfg.paths: blah; backtest[cfg]
  should["be configurable & executable from CLI"]{};  /$ bt src /path/to/strat/file.q --prm.1 foo --prm.2 42 --barparam "10 20 30"
  should["be configurable & executable from JSON"]{}; /$ q init.q -p xxxx; :h JSON
  should["be configurable & executable via q-to-q IPC"]{}; / h (`backtest; arglist)
 };

.tst.desc["Backtest Result"]{
        should["be valid JSON response"]{};
        should["be valid q process state plus generated events"]{};
        should["be sent via websockets"]{};
        should["be sent via IPC message"]{};
 };