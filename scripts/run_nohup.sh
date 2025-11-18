#!/bin/bash

PROGRAM="python3 path_to_main.py"
LOG_FILE="nohup.out"
PID_FILE="program.pid"

start() {
    if [ -f $PID_FILE ] && ps -p $(cat $PID_FILE) > /dev/null 2>&1; then
        echo "Process is already running. PID: $(cat $PID_FILE)"
        return
    fi

    echo "Starting program in background..."
    nohup $PROGRAM >> $LOG_FILE 2>&1 &
    echo $! > $PID_FILE
    echo "Program started. PID: $(cat $PID_FILE)"
    echo "Logs are being written to: $LOG_FILE"
}

stop() {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null 2>&1; then
            echo "Stopping process (PID: $PID)..."
            kill $PID
            sleep 2
            if ps -p $PID > /dev/null 2>&1; then
                echo "Process did not stop. Forcing termination..."
                kill -9 $PID
            fi
            echo "Process has been stopped."
        else
            echo "PID file exists, but the process is not running."
        fi
        rm -f $PID_FILE
    else
        echo "No PID file found. The program is probably not running."
    fi
}

status() {
    if [ -f $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null 2>&1; then
            echo "Program is running. PID: $PID"
        else
            echo "PID file found, but the process is not running. Removing PID file."
            rm -f $PID_FILE
        fi
    else
        echo "Program is not running."
    fi
}

# Main
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        echo "Restarting program..."
        stop
        sleep 2
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
