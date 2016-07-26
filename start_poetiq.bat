REM Set up environment variables

set POETIQ=%cd%
set KDBCODE=%POETIQ%\code
set KDBCONFIG=%POETIQ%\config
set KDBLOG=%POETIQ%\logs
set KDBHDB=%POETIQ%\hdb
set KDBLIB=%POETIQ%\lib
set KDBTESTS=%POETIQ%\tests
set KDBHTML=%POETIQ%\html

set KDBBASEPORT=5000

set KDBSTACKID=-stackid %KDBBASEPORT%

REM Starting discovery service
start "discovery" q torq.q -load %KDBCODE%/processes/discovery.q %KDBSTACKID% -proctype discovery -procname discovery1 -localtime

timeout 2

REM Starting remaining processes
start "housekeeping" q torq.q -load %KDBCODE%/processes/housekeeping.q %KDBSTACKID% -proctype housekeeping -procname housekeeping1 -localtime
start "equitysim" q torq.q -load %KDBHDB%/equitysim %KDBSTACKID% -proctype hdb -procname equitysim -localtime -g 1 -T 60 -w 4000
