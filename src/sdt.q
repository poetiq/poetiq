\d .sdt
inittables:{select from `.dt};  / prepares set of tables to be recreated in internal environment, its primarily designed to take all tables in .dt namespace, but may be overriden
prepschema:{
	.sdt,: (1_key `.dt)!{delete from x} each 1_value inittables[];
 	.eschema,: (1_key `.dt)!{delete from x} each 1_value inittables[]
 } / prepares schema for internal data storage
appendsdt:{[e] .sdt[e[`event]],: e[`data]} / function processes the data, distributes event content to internal tables prepared by prepschema function
upd:{
	.sdt[.bt.e`event],: .bt.data;
 }