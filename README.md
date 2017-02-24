# POETIQ - Platform O' Electronic Trading In Q

Poetiq is a backtesting and algorithmic trading engine built in kdb+/Q.

## Requirements ##

1. [`qutil`](https://github.com/nugend/qutil) - command line parsing utility

2. For testing and simulation use the [`buildhdb.q`](http://code.kx.com/wsvn/code/cookbook_code/start/buildhdb.q) script to create a HDB `equitysim` with simulated equity data.
````
cd hdb
q buildhdb.q -S 104831        # seed random numbers generator for reproducible results
````

## Installation ##

````
$ export POETIQ=usr/bin/poetiq/
$ export QPATH="path/to/qutil; $POETIQ"
$ alias bt='q $POETIQ/init.q -p 5000 --backtest'
$ cd $POETIQ
````

## Run ##

````
$ bt src strategy/strategy1.q
````
Interactively:
````
q init.q
q) env.cfg.paths: getenv[`POETIQ],/: ("src/";"strategy/strategy1.q") / or write your own strategy
q) backtest[env]
