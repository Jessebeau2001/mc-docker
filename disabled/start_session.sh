#!/bin/bash

# Exit if there already exits an active server session
if screen -list | grep -q "$MC_SESSION_NAME"; then
   echo "Cannot start new minecraft server under \"$MC_SESSION_NAME\", session already exists"
   exit 1
fi

echo "Start new minecraft server session as $MC_SESSION_NAME"

# Navigate to server dir
cd $MC_SERVER_DIR

# Initialize new detatched screen with name and run command in it
screen -dmS $MC_SESSION_NAME sh start.sh