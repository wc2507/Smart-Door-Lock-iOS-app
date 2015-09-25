############################################################
# IOT Poject
# GUI for Light Bulb
# This program is the core that loads other dependent
# programs.
############################################################

import subprocess
import os
import signal
import Tkinter as SecureSmartLock
import ImageTk
import Image
import socket
import select
import httplib
import json
from threading import Thread

# Constants
PORT_LOCALINFO = 50012
PORT_TIME = 50011
PORT_STATUS = 50013
HOST = "127.0.0.1"
baseUrl = "api.parse.com"

# Initializing variables and basic set up for lock GUI. All images for the lock are pulled from ../Images/ folder
lockRoot = SecureSmartLock.Tk() 
imgLocked = ImageTk.PhotoImage(Image.open("../Images/unlocked.png").resize((320,250), Image.ANTIALIAS))

lockRoot.geometry("320x525")
lockRoot.title("Secure Lock Emulator")

# Define variables
global username, password, authenticated
username = SecureSmartLock.StringVar()
password = SecureSmartLock.StringVar()
authentiated = 0

# Creating GUI image that will represent lock status
statusImg = SecureSmartLock.Label(lockRoot, text="hello", image = imgLocked)
statusImg.pack(side="bottom",padx=15,pady=5)

# Creating GUI labels and entry boxes
usernameLabel = SecureSmartLock.Label(lockRoot, text="Username")
usernameEntry = SecureSmartLock.Entry(lockRoot, exportselection='0')
passwordLabel = SecureSmartLock.Label(lockRoot, text="Password")
passwordEntry = SecureSmartLock.Entry(lockRoot, show="*", exportselection='0')

# Organizing GUI labels and entry boxes
usernameLabel.pack(side="top",pady=3,padx=5)
usernameEntry.pack(side="top",pady=3,padx=5)
passwordLabel.pack(side="top",pady=3,padx=5)
passwordEntry.pack(side="top",pady=3,padx=5)

# Login button is clicked - save contents into variables
def loginButtonClick():
        # Save username and password entries
        username = usernameEntry.get()
        password = passwordEntry.get()
        #print "%s" %username
        #print "%s" %password

        # Generate random number

        # Encrypt password (SHA w/ random number, password, secret key)

        # Send to Atmel for authentication


# Creating login button & interface
loginButton = SecureSmartLock.Button(lockRoot, text="Login", command=loginButtonClick)
loginButton.pack(side="top")

# Unlock button is pressed
def unlockButtonClick():
        print "Unlock Button Pressed"
        if authenticated:
                # Send unlock command to lock

                # Reset authenticated state
                authenticated = 0
        else:
                print "Error: User is not authorized. Please login."


# Lock button is pressed
def lockButtonClick():
        print "Lock Button Pressed"
        if authenticated:
                # Send lock command to lock

                # Reset authenticated state
                authenticated = 0
        else:
                print "Error: User is not authorized. Please login."

# Creating labels 
statusLabel  = SecureSmartLock.Label(lockRoot, text="Locked")
statusLabel.pack(side="bottom",pady=5)
unlockButton = SecureSmartLock.Button(lockRoot, text="Unlock", command=unlockButtonClick)
lockButton   = SecureSmartLock.Button(lockRoot, text="Lock", command=lockButtonClick)
unlockButton.pack(side="bottom",pady=5)
lockButton.pack(side="bottom")

lockStatus, currentTime = None, None

socketLock = 0
socketLocalInfo = 0
socketTime = 0
socketDict = {socketLock:True, socketTime:True, socketLocalInfo:True}

# Function to create a socket for server and listen on respective port. We invoke this from main()
def createServerSocket(port):
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	s.bind((HOST, port))
	s.listen(2)
	s.setblocking(0)
	return s

# We listen on sockets on PORTs defined above
def acceptSocketConnection(listOfSockets):
	global lockStatus, currentTime, username
	while(True):
		inputs = listOfSockets
		print listOfSockets
		outputs = []
		while inputs:
			readable, writeable, exceptional = select.select(inputs, outputs, inputs, 2)
			for s in readable:
				if s is socketTime:
					conn, addr = socketTime.accept()
					currentTime = conn.recv(10)
					conn.close()
				if s is socketLock:
					conn, addr = socketLock.accept()
					lockStatus = conn.recv(10)
					conn.close()
				if s is socketLocalInfo:
					conn, addr = socketLocalInfo.accept()
					data = conn.recv(1024)
					conn.close()

# This function is a callback after periodic interval. Called by lockRoot.after()
# We also update the GUI of lock here
def checkCondition():

	print "Lock status is", lockStatus , type(lockStatus)

	if lockStatus == "0":
		new_path = "locked.png"
	if lockStatus == "1":
		new_path = "unlocked.png"
        if lockStatus == "2":
                new_path = "alert.png"

	if lockStatus != None:
		# Update the new image and text when needed in GUI
		newImg = ImageTk.PhotoImage(Image.open("../Images/" + new_path).resize((320,250), Image.ANTIALIAS))
		panel.configure(image = newImg)
		panel.image = newImg

	lockRoot.after(5000, checkCondition)

# main()
if __name__=="__main__":

	# Create three 3 server sockets
	socketLock = createServerSocket(PORT_STATUS)
	socketTime = createServerSocket(PORT_TIME)
	socketLocalInfo = createServerSocket(PORT_LOCALINFO)
	socketList = [socketLock, socketTime, socketLocalInfo]
	thread1 = Thread(target = acceptSocketConnection, args = (socketList, ))
	thread1.daemon = True
	thread1.start()

	# Run lockRoot GUI process periodically
	lockRoot.after(5000, checkCondition)
	lockRoot.mainloop()
        
       
