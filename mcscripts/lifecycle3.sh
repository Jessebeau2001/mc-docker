#!/bin/bash

# Function to stop the Minecraft server gracefully
function stop_server() {
    echo "Stopping Minecraft server gracefully..."

    # Send the "stop" command to the server via the FIFO pipe
    echo "stop" > /tmp/minecraft_input_pipe

    # Ensure the server stops by waiting for the Java process to finish
    wait $JAVA_PID

    echo "Minecraft server stopped."
}

# Trap signals for graceful shutdown
trap stop_server SIGINT SIGQUIT SIGTERM

# Export necessary variables
export MC_SERVER_DIR="/path/to/minecraft"

# Navigate to the server directory
cd "$MC_SERVER_DIR" || { echo "Failed to navigate to \"$MC_SERVER_DIR\""; exit 1; }

# Create a named pipe (FIFO) for sending commands to the server
mkfifo /tmp/minecraft_input_pipe

# Start the Minecraft server in the foreground
echo "Starting Minecraft server..."
java -Xmx6G -jar fabric-server.jar nogui < /tmp/minecraft_input_pipe &

# Get the Java process ID
JAVA_PID=$!

# Wait for the Minecraft server process to complete (this will allow Docker to keep the container running)
wait $JAVA_PID

# Clean up the FIFO after the server stops
rm /tmp/minecraft_input_pipe

echo "EOF"
