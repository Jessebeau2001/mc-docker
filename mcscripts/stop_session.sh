#!/bin/bash

# Places and executes command in minecraft screen session
run_in_session() {
   screen -S $MC_SESSION_NAME -X stuff "$1^M"
}

# Exit out out of script if no active server session found
if ! screen -list | grep -q "$MC_SESSION_NAME"; then
   echo "Cannot stop session \"$MC_SESSION_NAME\", no currenly active sessions found"
   return 0 # Return if sourced script
   exit 0 # else exit
fi

echo "Attempting to stop minecraft server session \"$MC_SESSION_NAME\""

# Stops the server
run_in_session stop

# Waits for screen to close
bool=true
while $bool; do
   if ! screen -list | grep -q "$MC_SESSION_NAME"; then
      bool=false
   fi
   sleep .2 # Stalls loop to prevent spam
done

echo "Succesfully stopped server session $MC_SESSION_NAME"