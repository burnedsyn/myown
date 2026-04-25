#!/bin/bash
# Cause the script to exit on failure.
set -eo pipefail
# Log file setup
LOG_FILE="installation_log.txt"
echo "Installation started at $(date)" > $LOG_FILE

# Activate virtual environment
echo "Activating virtual environment..." | tee -a $LOG_FILE
if . /venv/main/bin/activate; then
    echo "Virtual environment activated successfully" | tee -a $LOG_FILE
else
    echo "Failed to activate virtual environment" | tee -a $LOG_FILE
    exit 1
fi

# Change directory
echo "Changing to workspace directory..." | tee -a $LOG_FILE
if cd /workspace/; then
    echo "Changed to workspace directory successfully" | tee -a $LOG_FILE
    pwd | tee -a $LOG_FILE
else
    echo "Failed to change directory to /workspace/" | tee -a $LOG_FILE
    exit 1
fi

