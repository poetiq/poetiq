upd: {[t; x] if [count x; .process.upd [t; x]];}
.process.upd: () ! ()

/

"upd" delegates to a dictionary of functions in the 'process' namespace. The parameters follow the same convention as
the upd function in the kdb+ tick product: t is the name of the table, a symbol; x is a table. The delegation only
happens if there are rows in the table. Indexing a dictionary on an absent key results in null, not an error.
