#!/bin/bash

# Function to write arguments to the minecraft FIFO pipe
mc() {
    # Check if the FIFO pipe exists
    if [ ! -p /tmp/fifo_pipe ]; then
        echo "Error: /tmp/fifo_pipe does not exist. (mc server not running?)"
        return 1  # Return non-zero to indicate failure
    fi

    # Concatenate all arguments into a single string and write to the pipe
    echo "$@" > /tmp/fifo_pipe
}