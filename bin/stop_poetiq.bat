REM Set up environment variables

set POETIQ=%cd%
set KDBCODE=%POETIQ%\src
set KDBCONFIG=%POETIQ%\config
set KDBLOG=%POETIQ%\logs
set KDBHDB=%POETIQ%\hdb
set KDBLIB=%POETIQ%\lib
set KDBTESTS=%POETIQ%\tests
set KDBHTML=%POETIQ%\html

set KDBBASEPORT=5000

set KDBSTACKID=-stackid %KDBBASEPORT%

REM Kill Poetiq
start "kill" q torq.q -load %KDBCODE%/processes/kill.q -proctype kill -procname killpoetiq -.servers.CONNECTIONS housekeeping hdb p discovery