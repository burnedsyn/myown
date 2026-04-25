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

# Install accelerate
echo "Installing vllm package..." | tee -a $LOG_FILE
if pip install vllm; then
    echo "vllm package installed successfully" | tee -a $LOG_FILE
    pip show vllm | tee -a $LOG_FILE
else
    echo "Failed to install vllm package" | tee -a $LOG_FILE
    exit 1
fi

echo "Installation completed at $(date)" | tee -a $LOG_FILE

echo "start vllm server" | tee -a $LOG_FILE

vllm serve Qwen/Qwen3.6-35B-A3B \
  --host 0.0.0.0 \
  --port 8000 \
  --dtype bfloat16 \
  --max-model-len 131072 \
  --gpu-memory-utilization 0.90 \
  --max-num-seqs 2 \
  --max-num-batched-tokens 6144 \
  --block-size 128 \
  --kv-cache-dtype turboquant \
  --enable-chunked-prefill \
  --disable-log-stats

  
