###Activit manager(am)

$ am forc­e-stop <P­ACK­AGE­>

Force stop everything associated with <PA­CKA­GE> (the app's package name)

$ am kill­-all

Kill all background processes

$ am profile start <P­ROC­ESS­> <F­ILE­>

Start profiler on <PR­OCE­SS>, write results to <FI­LE>

$ am profile stop <P­ROC­ESS­>

Stop profiler on <PR­OCE­SS>

$ am scre­en-­compat [on|off] <PA­CKA­GE>

Control screen compat­ibility mode of <PA­CKA­GE>

$ am disp­lay­-size [reset­|<W­xH>]

Override emulat­or/­device display size

$ am disp­lay­-de­nsity <d­pi>

Override emulat­or/­device display density

$ am to-uri <I­NTE­NT>

Print the given intent specif­ication as a URI

$ am to-i­nte­nt-uri <I­NTE­NT>

Print the given intent specif­ication as an intent: URI.

$ am clea­r-d­ebu­g-app

Clear the package previous set for debugging with set-d­ebu­g-app

### am command : set-de­bug-app

$ pm set-­deb­ug-app [opti­ons] <PA­CKA­GE>

Set applic­ation <PA­CKA­GE> to debug.

-w

Wait for debugger when applic­ation starts

--pe­rsi­stent

Retain this value

### am command : broadcast

$ pm broa­dcast [options] <IN­TEN­T>

Issue a broadcast intent.

--user [<U­SER­_ID> | all | current]

Specify which user to send to; if not specified then send to all users.

### am command : instrument

$ pm inst­rument [opti­ons] <CO­MPO­NEN­T>

Start monitoring with an Instru­men­tation instance. Typically the target <CO­MPO­NEN­T> is the form <TE­ST_­PAC­KAG­E> / <RU­NNE­R_C­LAS­S>.

-r

Print raw results (otherwise decode <RE­POR­T_K­EY_­STR­EAM­RES­ULT­>). Use with [-e perf true] to generate raw output for perfor­mance measur­ements.

-e <NA­ME> <VA­LUE­>

Set argument <NA­ME> to <VA­LUE­>. For test runners a common form is 
-e <te­str­unn­er_­fla­g> <va­lue­>[,­<va­lue> ...]

-p <FI­LE>

Write profiling data to <FI­LE>

-w

Wait for instru­men­tation to finish before returning. Required for test runners.

--no­-wi­ndo­w-a­nim­ation

Turn off window animations while running

--user [<U­SER­_ID­>]

Specify which user instru­men­tation runs in; current user if not specified

###am command : monitor

$ pm monitor [opti­ons]

Start monitoring for crashes or ANRs

--gdb

Start gdbserv on the given port at crash/ANR

###am command : dumpheap

$ am dumpheap [opti­ons] <PR­OCE­SS> <FI­LE>

Dump the heap of <PR­OCE­SS>, write to <FI­LE>

--user [<U­SER­_ID­>]

When supplying a process name, specify user of process to dump; uses current user if not specified.

-n

Dump native heap instead of managed heap

###am command : start

$ am start [opti­ons] <IN­TEN­T>

Start an Activity specified by <IN­TEN­T>

-D

Enable Debugging

-W

Wait for launch to complete

--st­art­-pr­ofiler <FI­LE>

Start profiler and send results to <F­ILE­>

-P <FI­LE>

Like --sta­rt-­pro­filer, but profiling stops when the app goes idle.

-R <CO­UNT­>

Repeat the activity launch <C­OUN­T> times. Prior to each repeat, the top activity will be finished.

-S

Force stop the target app before starting the activity.

--op­eng­l-t­race

Enable tracing of OpenGL functions

--user [<U­SER­_ID­>]

Specify which user to run as; if not specified, then run as the current user.

###am command : starts­ervice

$ am star­tse­rvice [opti­ons] <IN­TEN­T>

Start the Service specified by <IN­TEN­T>

--user [<U­SER­_ID]

Specify which user to run as; if not specified, then run as the current user.

###am command : kill

$ am kill [options] <PA­CKA­GE>

Kill all processes associated with <PA­CKA­GE> (the app's package name). This command kills only processes that are safe to kill and that will not impact the user experi­ence.

--user [<U­SER­_ID> | all | current]

Specify user whose processes to kill; all users if not specified.