The "Tuneable Frequency Generator" Demo

Herbert Jaeger, July 30, 2007

This repository of Matlab functions and scripts is a copy of the ESN toolbox (Version from July 2007), which standardly is obtainable at http://www.faculty.jacobs-university.de/hjaeger/esn_research.html. There are two additional files which are not contained in the standard toolbox:

masterScriptScholarpediaExample: a script that reproduces the "tuneable frequency generator" example from the "Echo State Networks" article at http://www.scholarpedia.org/article/Echo_State_Network. Just executing this file will (or should) do the job.

generate_freqGen_sequence.m: a helper function which creates training data. 

A synopsis of the other functions is in DOCUMENTATION.txt. 

Note added September 2015: 

This code was produced and tested with an old Matlab version - I can't even reconstruct which one. More recent versions use a different algorithm for matrix inversion (matlab function call "inv") than that old version. The old version of "inv" was, in fact, better -- much more numerically stable. If you run these demos with a recent version of Matlab, you might experience that demos don't work out like documented in techreports. Then try replacing calls to "inv" by calls to "pinv" (pseudoinverse) -- that should work (at the cost of longer runtime).  

*************** Terms of Use ******************************

This software is free for non-commercial use. If commercial use is
intended, contact Fraunhofer IAIS (www.iais.fraunhofer.de) who have
claimed international patents on ESN algorithms (pending).

This software is intended for research use by experienced Matlab users
and includes no warranties or services.  Bug reports are gratefully
received by Herbert Jaeger (h.jaeger [at] jacobs-university.de)