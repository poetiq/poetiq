# POETIQ - Platform O' Electronic Trading In Q

## Overview ##
Poetiq is an algorithmic trading engine built in kdb+/Q. It uses the [TorQ](https://github.com/AquaQAnalytics/TorQ) framework as its foundation.

See the [flowchart](https://www.lucidchart.com/invitations/accept/fa9324ad-321c-4871-abeb-24b040068009) for an overview the architecture.

## Requirements ##
For testing and simulation use the [`buildhdb.q`](http://code.kx.com/wsvn/code/cookbook_code/start/buildhdb.q) script to create a HDB `equitysim` with simulated equity data.
````
cd hdb
q buildhdb.q
````

## Usage ##
Linux/OSX users should run `start_poetiq.sh` to start the system and `stop_poetiq.sh` to stop the system. Windows users should use the equivalent `.bat` files.

To debug a process and run it in the foreground, run e.g.
````
q torq.q -load ${KDBCODE}/processes/backtestfeed.q ${KDBSTACKID} -proctype backtestfeed -procname backtestfeed1 -localtime -debug
````
Remember to run `setenv.sh` in any new shell session to set environment variables.

## Testing ##
Poetiq uses the [qspec](https://github.com/nugend/qspec) framework for testing and behavior-driven development. To run a test, run
````
testq tests/test_p.q
````
