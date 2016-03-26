\l common/require.q
require "common/process.q"
require "qx/schema.q"

.process.upd [`quotes]:		{`quotes upsert x;}
.process.upd [`trades]:		{0N!"trades:";show x;}
.process.upd [`fills]:		{0N!"fills:";show x;}
.process.upd [`cancels]:	{show x;}


quotes: delete from .schema.quotes;
`quotes insert h (`quotes);

\d .oms

order: (
	[sym:		`symbol$	()]
	size:		`int$		()
	)

add: {}

\d .

