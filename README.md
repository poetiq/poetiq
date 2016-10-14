# POETIQ - Platform O' Electronic Trading In Q
[![CircleCI](https://circleci.com/gh/poetiq/poetiq.svg?style=svg)](https://circleci.com/gh/poetiq/poetiq)

Poetiq is an algorithmic trading engine built in kdb+/Q. It uses the [TorQ](https://github.com/AquaQAnalytics/TorQ) framework as its foundation.

See the [flowchart](https://www.lucidchart.com/documents/view/470ba64c-d651-4fca-95a8-b1bec2ce62de) for an overview the architecture.

## Requirements ##
For testing and simulation use the [`buildhdb.q`](http://code.kx.com/wsvn/code/cookbook_code/start/buildhdb.q) script to create a HDB `equitysim` with simulated equity data.
````
cd hdb
q buildhdb.q
````

## Usage ##
Linux/OSX users should load the launch control with `source bin/control.sh`, which provides the following functions for controlling processes: `startp`, `stopp`, `restartp` and `queryp`.

Processes are defined in `/config/start.cfg` and can be controlled with e.g.
````
startp -p discovery discovery1 --debug
````
Specifying the `--debug` flag will run the process in the foreground (useful for debugging).

Windows users should run `start_poetiq.bat` to start the system and `stop_poetiq.bat` to stop the system. 

## Testing ##
Poetiq uses the [qspec](https://github.com/nugend/qspec) framework for testing and behavior-driven development. To run a test, run
````
testq tests/test_p.q
````
