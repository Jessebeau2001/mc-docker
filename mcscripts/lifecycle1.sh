#!/bin/bash

# Function to send commands to the Minecraft server screen session
function run_in_session() {
    screen -S $MC_SESSION_NAME -X stuff "$1^M"
}

# Function to stop the Minecraft server
function stop_server() {
    echo "Stopping Minecraft server session \"$MC_SESSION_NAME\"..."

    # Exit if no active server session found
    if ! screen -list | grep -q "$MC_SESSION_NAME"; then
        echo "No active session \"$MC_SESSION_NAME\" found."
        exit 0
    fi

    # Send stop command to the server
    run_in_session stop

    # Wait for the screen session to close
    while screen -list | grep -q "$MC_SESSION_NAME"; do
        sleep 0.2
    done

    echo "Minecraft server session \"$MC_SESSION_NAME\" stopped successfully."
}

# Function to start the Minecraft server session
function start_session() {
    # Check if a session already exists
    if screen -list | grep -q "$MC_SESSION_NAME"; then
        echo "Session \"$MC_SESSION_NAME\" already exists. Cannot start a new session."
        exit 1
    fi

    echo "Starting new Minecraft server session \"$MC_SESSION_NAME\"..."

    # Navigate to the server directory
    cd "$MC_SERVER_DIR" || { echo "Failed to navigate to \"$MC_SERVER_DIR\""; exit 1; }

    # Start the Minecraft server in a screen session (detached mode)
    screen -dmS "$MC_SESSION_NAME" java -Xmx6G -jar fabric-server.jar nogui

    # Attach to the screen session (brings output to the foreground)
    screen -r "$MC_SESSION_NAME"
}

# Trap signals for graceful shutdown
trap stop_server SIGINT SIGQUIT SIGTERM

# Start the server session
start_session
echo EOF
