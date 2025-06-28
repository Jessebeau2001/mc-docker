#!/bin/bash
FIFO_FILE="/tmp/fifo_pipe"

# Function to stop the Minecraft server gracefully
function stop_server() {
    echo "Attempting to quit minecraft process..."

    # Send "stop" command to the Minecraft server
    echo "stop" > "$FIFO_FILE"

    # Wait for the server to shut down
    wait $JAVA_PID

    echo "Minecraft server stopped."
}

# Navigate to the server directory
cd "$MC_SERVER_DIR" || { echo "Failed to navigate to \"$MC_SERVER_DIR\""; exit 1; }
# Check whether server jar exists
[ -f "$SERVER_JAR" ] || { echo "Could not find server jar \"$SERVER_JAR\" does not exist."; exit 1; }

# Trap signals for graceful shutdown
trap stop_server SIGINT SIGQUIT SIGTERM

# Create a named pipe (FIFO) for passing commands to the server
mkfifo "$FIFO_FILE"

# Start the Minecraft server and attach stdin to the named pipe
# This will keep the output of the Minecraft server visible in Docker container's terminal
exec 3<> "$FIFO_FILE"
java -Xmx6G -jar fabric-server.jar nogui <&3 2>&1 < "$FIFO_FILE" &
JAVA_PID=$!

# Wait until a termination signal is received
wait $JAVA_PID

# Clean up the FIFO after the server stops
rm "$FIFO_FILE"

echo "Server shutdown finished..."
