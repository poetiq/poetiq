# POETIQ - Platform O' Electronic Trading In Q

Poetiq is a backtesting and algorithmic trading engine built in kdb+/Q.

See the [flowchart](https://www.lucidchart.com/documents/view/470ba64c-d651-4fca-95a8-b1bec2ce62de) for an overview of the architecture.

## Requirements ##
For testing and simulation use the [`buildhdb.q`](http://code.kx.com/wsvn/code/cookbook_code/start/buildhdb.q) script to create a HDB `equitysim` with simulated equity data.
````
cd hdb
q buildhdb.q -S 104831        # seed random numbers generator for reproducible results
````