\d .schema

orders: (
	[]
	sym:		`symbol$	();
	dir:		`symbol$	();
	qty:		`int$		();
	prx:		`float$	();
	tif:		`symbol$	();
	id:		`symbol$	()
	)

quotes: (
	[sym:		`symbol$	()]
	bidqty:	`int$		();
	bidprx:	`float$	();
	askprx:	`float$	();
	askqty:	`int$		()
	)

holdings: (
	[sym:		`symbol$	()]
	qty:	       `int$		();
	prx:		`float$	()
	)

\d .

\

Common schema's for qx and its members. These tables are in a reserved context and should never have rows added
to them. The preferred method for copying a schema is, for example, quotes: delete from .schema.quotes.
