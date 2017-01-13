\d .lg
lt:([]ltype:"s"$();llevel:"s"$();syststamp:"p"$();tstamp:"p"$(); etstamp:"p"$(); ecounter: "i"$();message:())

ll:`d`i`w`e`n;
level:`e;
l:{[l;t;m] if[(ll?l)>=ll?level; `.lg.lt insert (t;l; .z.p;.clock.then[]; .bt.e `etstamp ; .bt.ecounter;-3!m)];}
dump:{(`$":log/", ssr[string .z.p; ":"; "."] ,"/lt.xls") 0:.h.tx[`xls;lt];} /dump

tm:([] tspan:"n"$(); fun:"s"$())

tic:{zp::.z.p}
toc:{`.lg.tm insert (.z.p - zp;x)}