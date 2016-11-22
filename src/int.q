\d .int
itables:select from .dt; / prepares set of tables to be recreated in internal environment, its primarily designed to take all tables in .dt namespace, but may be overriden
prepschema:{`.sdt set (1_key `.dt)!{delete from x} each 1_value .int.itables} / prepares schema for internal data storage
appendsdt:{[e] if[((key `.sdt) ? e[`event]) <> count key `.sdt; .sdt[e[`event]],: flip e[`data]; :1b]; :0b} / function processes the data, distributes event content to internal tables prepared by prepschema function

procsig:{.int.portcon[.alpha.calc.fun[]];::}
portcon:{[alpha] .[.int.oms; .portcon.calc.fun[alpha] ];::} / .int.oms[pc`target][pc]
oms:{[target;data] .[.oms.calc.fun; (target;data)];::}
proctime:{.int.tstamp + .z.p - .int.pstart}

/procsig: {.oms.calc.fun . .portcon.calc.fun .alpha.calc.fun []}
