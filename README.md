# Kobra
Silicon retina based interferential vibrometer

Camera used : DAVIS-240 from iniVation
Software used to record : jAER
Data file format : AER-DAT-2.0

More info :
https://inivation.com/support/software/jaer/

Folders :
 - processAEDAT-master, provided by iniVation, contains various scripts helpful for reading the data files. loadaerdat.m has been modified to work for our case, as well as displayDVSdataNew.m, various folders have been deleted to reduce the quantity of files.
 - Prototype, code used to prototype and test concepts
 
Files purposes :
 - loadData.m, load data from aerdat file using loadaerdat.m and convert it to frame coordinates using extractFrameCoordinates.m
 - dvsFlow.m, cleaned up version of opticalFlowPerso.m, used to calculate the flow for DVS events
 - intensityOverTime.m, returns the intensity for a given pixel per frame
 - speedAnalyser.m, returns the speed of the miror in our setup based on the DVS events
 
 - Prototype/processAPS.m, process APS (intensity based) events, display frames, and calculate flow.
 - Prototype/nbrEventsBien.m and Prototype/nombreEvents.m, calculates the number of events per second for a given acquisition, first one for our application, tries to remove the varying contrast problem, second one returns the number of events for the whole file
 - Prototype/opticalFlowPerso.m, calculate the flow for DVS events
 
 - processAERDAT-master/displayDVSdataNew.m, create a video and returns DVS events integrated over lapse of time
 
 - accelerationConstante.py, scripts used with NewPort NSTRUCT to move the miror with varying speed
