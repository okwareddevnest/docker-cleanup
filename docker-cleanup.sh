#!/bin/bash

# docker-cleanup.sh
# This script stops and prunes Docker containers based on user configuration
# It is designed to be run as a systemd service to maintain system cleanliness

set -e

# Log function for consistent output
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Load configuration
if [ -f /etc/docker-cleanup.conf ]; then
    source /etc/docker-cleanup.conf
else
    CLEANUP_MODE="all"
fi

# Function to stop containers based on mode
stop_containers() {
    case $CLEANUP_MODE in
        "all")
            log "Stopping all running containers..."
            docker stop $(docker ps -q) 2>/dev/null || true
            ;;
        "stopped")
            log "Skipping running containers..."
            ;;
        "older:"*)
            days=${CLEANUP_MODE#older:}
            log "Stopping containers older than $days days..."
            docker stop $(docker ps -q --filter "until=${days}d") 2>/dev/null || true
            ;;
        *)
            log "Invalid cleanup mode: $CLEANUP_MODE"
            exit 1
            ;;
    esac
}

# Function to remove containers based on mode
remove_containers() {
    case $CLEANUP_MODE in
        "all")
            log "Removing all stopped containers..."
            docker rm $(docker ps -aq) 2>/dev/null || true
            ;;
        "stopped")
            log "Removing all stopped containers..."
            docker rm $(docker ps -aq) 2>/dev/null || true
            ;;
        "older:"*)
            days=${CLEANUP_MODE#older:}
            log "Removing containers older than $days days..."
            docker rm $(docker ps -aq --filter "until=${days}d") 2>/dev/null || true
            ;;
        *)
            log "Invalid cleanup mode: $CLEANUP_MODE"
            exit 1
            ;;
    esac
}

# Main cleanup process
stop_containers
remove_containers

# Prune unused data
log "Pruning unused Docker resources..."
docker system prune -f

log "Docker cleanup completed successfully" 