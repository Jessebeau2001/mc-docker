#!/bin/bash

# Function to stop the Minecraft server gracefully
function stop_server() {
    echo "Stopping Minecraft server gracefully..."

    # Send "stop" command to the Minecraft server
    echo "stop" > fifo_input

    # Wait for the server to shut down
    wait $JAVA_PID

    echo "Minecraft server stopped."
}

# Trap signals for graceful shutdown
trap stop_server SIGINT SIGQUIT SIGTERM

# Navigate to the server directory
cd "$MC_SERVER_DIR" || { echo "Failed to navigate to \"$MC_SERVER_DIR\""; exit 1; }

# Create a named pipe (FIFO) for passing commands to the server
mkfifo fifo_input

# Start the Minecraft server and attach stdin to the named pipe
# This will keep the output of the Minecraft server visible in Docker container's terminal
java -Xmx6G -jar fabric-server.jar nogui < fifo_input | tee /dev/stderr &
JAVA_PID=$!

# Wait for the Java process to complete
wait $JAVA_PID

# Clean up the FIFO
rm fifo_input

echo "EOF"

# THIS IS THAT VERSION THAT ONLY RUNS AFTER EXIT