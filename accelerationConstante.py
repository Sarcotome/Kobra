#=========================================================================
# Newport Proprietary and Confidential    Newport Corporation 2010
#
# No part of this file in any format, with or without modification 
# shall be used, copied or distributed without the express written 
# consent of Newport Corporation.
# 
# Description: This is a sample Python Script to illustrate how to execute following 
# Cyclic Motion.
# This script run only when Controller state is "Ready"
#==========================================================================

#==========================================================================
#Initialization Start

#The script within Initialization Start and Initialization End is needed for properly 
#initializing IOPortClientLib and Command Interface DLL for Conex-CCT instrument.
#The user should copy this code as is and specify correct paths here.
import sys
import time
#IOPortClientLib and Command Interface DLL can be found here.
print "Adding location of IOPortClientLib.dll & Newport.CONEXCC.CommandInterface.dll to sys.path"
sys.path.append(r'C:\Program Files\Newport\Instrument Manager\NStruct\Instruments\CONEX-CC\Bin')

# The CLR module provide functions for interacting with the underlying 
# .NET runtime
import clr
# Add reference to assembly and import names from namespace
clr.AddReferenceToFile("Newport.CONEXCC.CommandInterface.dll")
from CommandInterfaceConexCC import *

import System
#==========================================================================

#*************************************************
# Procedure to get the current position
#*************************************************
def GetCurrentPosition (componentID, address, flag):
	result, currentPosition, errStringPosition = CCT.TP(componentID,address)
	if result == 0 :
		if (flag == 1):
			print 'Current Position =>', currentPosition
	return result, currentPosition

#*************************************************
# Procedure to get the current controller status
#*************************************************
def GetControllerStatus (componentID, address, flag):
	result, errorCode, controllerState, errString = CCT.TS(componentID,address)
	if result == 0 :
		if (flag == 1):
			print 'Current controller status =>', controllerState
	return result, controllerState

#*************************************************
# Procedure to perform an absolute motion
#*************************************************
def AbsoluteMove (componentID, address, targetPosition, flag):
	if (flag == 1):
		print 'Moving to position ' , targetPosition
		
	# Execute an absolute motion	
	result, errStringMove = CCT.PA_Set(componentID,address,targetPosition)	
	
	# Wait the end of motion
	WaitEndOfMotion(componentID,address)
	return result	
	
#*************************************************
# Procedure to wait the end of current motion
#*************************************************
def WaitEndOfMotion (componentID, address):
	print "WaitEndOfMotion ..."

	# Get controller status
	result, errorCode, ControllerState, errString = CCT.TS(componentID, address) 
	if result != 0 :
		print 'TS Error=>',errString
		
	# while MOVING state, get the controller state
	while ControllerState == "28":
		# Get controller status
		result, errorCode, ControllerState, errString = CCT.TS(componentID, address) 
		if result != 0 :
			print 'TS Error=>',errString

#*************************************************
# Procedure to wait the end of current motion
#*************************************************
def WaitEndOfHomeSearch (componentID, address):
	print "WaitEndOfHomeSearch ..."
	
	# Get controller status
	result, errorCode, ControllerState, errString = CCT.TS(componentID, address) 
	if result != 0 :
		print 'TS Error=>',errString
	else:		
		while ControllerState == "1E":
			# Get controller status
			result, errorCode, ControllerState, errString = CCT.TS(componentID, address) 
			if result != 0 :
				print 'TS Error=>',errString	
		
#*************************************************
# Procedure to check if the controller is READY
#  1 = Controller is "Not Referenced"
# -1 = Controller is not in "Not Referenced" state
#*************************************************
def IsNotReferenced (componentID, address):
	# Get controller state
	result, errorCode, controllerState, errString = CCT.TS(componentID, address) 
	print "controllerState = ", controllerState
	if result == 0 :
		if  (controllerState == "0A") | \
			(controllerState == "0B") | \
			(controllerState == "0C") | \
			(controllerState == "0D") | \
			(controllerState == "0E") | \
			(controllerState == "0F") | \
			(controllerState == "10"):
			return 1
		else:
			return -1

#*************************************************
# Procedure to check if the controller is READY
#  1 = Controller is ready
# -1 = Controller is not Ready
#*************************************************
def IsReady (componentID, address):
	# Get controller state
	result, errorCode, controllerState, errString = CCT.TS(componentID, address) 
	if result == 0 :
		if  (controllerState == "32") | \
			(controllerState == "33") | \
			(controllerState == "34") | \
			(controllerState == "36") | \
			(controllerState == "37") | \
			(controllerState == "38"):
			return 1
		else:
			return -1
			
#*************************************************
# Procedure to execute motion cycle(s)
#*************************************************
def deplacement(componentID, address, step, Vmin, Vmax, stepV):
	# Initialization
	result = 0
	displayFlag = 1
	# Home search if needed
	if ((IsReady(componentID,address) == -1) & (IsNotReferenced(componentID,address) == 1)):
		result, errString = CCT.OR(componentID,address)	
		if result == 0 :
			# Wait the end of home search
			WaitEndOfHomeSearch(componentID,address)
		
	# Controller must be READY
	if (IsReady(componentID,address) == 1):
		v = Vmin
		while v<Vmax :
			print 'Current velocity =>', v
			result, errStringVelocity = CCT.VA_Set(componentID,address,v)
			# Get current position = first position
			result, position1 = GetCurrentPosition(componentID, address, displayFlag)	
			v = v + stepV
			if result == 0:		
			
				# Calculate the second position
				position2 = (float)(position1) + step
							
				# Displacement 1 : go to position #2
				result = AbsoluteMove(componentID,address,position2,displayFlag)			
			
				# Get current position
				result, currentPosition = GetCurrentPosition(componentID, address, displayFlag)			
			else:
				print 'Error while getting position=>',errStringPosition
	else:
		print 'Controller is not in READY state ...'
			
#*************************************************
#*                                               *
#*                Main script	                 *		
#*                                               *
#*************************************************
# Instrument Initialization
instrument="CONEX-CC (A6UCP20G)"
print 'Instrument Key=>', instrument

CCT = ConexCC()
#componentID needs to be used in all commands
componentID = CCT.RegisterComponent(instrument);
print 'Instrument ID=>', componentID

address = 1

motionStep = 0.01 #mm
Vmin = 0.001 #mm/s
Vmax = 0.1 #mm/s
stepV = 0.001 #mm/s

deplacement (componentID, address, motionStep, Vmin, Vmax, stepV)	

# Unregister Component
CCT.UnregisterComponent(componentID);
print 'End of script'