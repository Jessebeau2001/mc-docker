#!/bin/bash
# Function to write arguments to the minecraft FIFO pipe

# Check if the FIFO pipe exists
if [ ! -p /tmp/fifo_pipe ]; then
    echo "Error: /tmp/fifo_pipe does not exist. (mc server not running?)"
    return 1
fi

# Concatenate all and write to pipe
echo "$@" > /tmp/fifo_pipe