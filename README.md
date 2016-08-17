# POETIQ - Platform O' Electronic Trading In Q
## Overview ##

See the [flowchart](https://www.lucidchart.com/documents/view/470ba64c-d651-4fca-95a8-b1bec2ce62de).

## Use ##

Test mark-to-market method of calculating P&L. This test can also be found in the `tests/ec.q` directory.

        \l p.q

Create test data:

    txns: ([] dt: 1 2 3 4; sym: 4#`AAPL; sz: 100 200 -200 -50; px: 50 52 53 53.5)
    prices: ([] sym: 4#`AAPL; dt: 1 2 3 4; cl: 50.5 52 53 54)

Run fill events that update positions (inventory), equity and pnl:

    {upd[`fill;x]} each txns
    upd[`mtm; prices]

Inspect states:

    equity
    / 100575f

    positions
    sym | sz cost dt
    ----| ----------
    AAPL| 50 54   4 

    pnl
    sym  dt pnl
    -----------
    AAPL 2  200
    AAPL 3  300
    AAPL 4  50 
    AAPL 4  25 

Alternatively, batch calculation should yield equivalent result:

    pnlCalc[txns;prices]
    dt sym  sz   px   cl   pnl
    --------------------------
    1  AAPL 100  50   50.5 50 
    2  AAPL 200  52   52   150
    3  AAPL -200 53   53   300
    4  AAPL -50  53.5 54   75 

### HDB:
Create a HDB `equitysim` with simulated equity data for development purposes:
````
cd hdb
q buildhdb.q
````

