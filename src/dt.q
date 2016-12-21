\d .dt

inittables:{select from `dt};  / prepares set of tables to be recreated in internal environment, its primarily designed to take all tables in .dt namespace, but may be overriden
prepschema:{
	.sdt,: (1_key `dt)!{delete from x} each 1_value inittables[];
 	.schema,: (1_key `dt)!{delete from x} each 1_value inittables[];
 } / prepares schema for internal data storage

/ function processes the data, distributes event content to internal tables prepared by prepschema function
upd:{
	.sdt[.bt.e`event],: .bt.data;
 }

/ align x to y, fill missing with z. treat `sym!`val
/align:{if[not (kx:key[x])~ky:key[y]; x[ky except kx]: z[]; y[kx except ky]:z[]];(asc x;asc y)}