#!/bin/sh
# Try to run from installed location, otherwise run from current directory
if [ -d "/opt/brainworkshop" ]; then
    cd /opt/brainworkshop
fi

# Check for local venv3
if [ -f "venv3/bin/python" ]; then
    exec venv3/bin/python brainworkshop.pyw "$@"
elif [ -f "venv/bin/python3" ]; then
    exec venv/bin/python3 brainworkshop.pyw "$@"
else
    exec python3 brainworkshop.pyw "$@"
fi
