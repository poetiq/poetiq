mtm:: select time: 0D24- 0D00:00:01, date, sym, close from daily
signal:: update time: 0D24- 0D00:00:01 from ungroup select date, signal: signum deltas close by sym from daily