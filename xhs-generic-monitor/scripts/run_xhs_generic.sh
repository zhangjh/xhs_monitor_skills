#!/bin/bash
# XHS Generic Monitor Runner
# --------------------------
# 1. Runs the node script for a custom keyword
# 2. Captures the report output
# 3. Sends it to specified TARGET via openclaw agent (Direct)

# [Required] Configure your Cookie in SKILL.md guide
export XHS_COOKIE="YOUR_XHS_COOKIE_HERE"
export NODE_PATH=/usr/lib/node_modules

# [Optional] Configure delivery targets
# Supported channels: wecom, telegram, etc.
# Format: <channel>:<target_id>
TARGET_ID="${TARGET_ID:-wecom:YOUR_WECOM_ID_HERE}"
CHANNEL="${CHANNEL:-wecom}"

QUERY="${1}"
LOG_FILE="/data/root/xhs_generic_cron.log"

if [ -z "$QUERY" ]; then
    echo "Usage: ./run_xhs_generic.sh <query>"
    exit 1
fi

echo "[$(date)] Starting XHS Generic Search: $QUERY" >> $LOG_FILE

# Execute Node.js script and capture output
# Note: Ensure generic_monitor.js is in the skills/xhs-generic-monitor/scripts/ directory
REPORT=$(/usr/bin/node /root/.openclaw/workspace/skills/xhs-generic-monitor/scripts/generic_monitor.js "$QUERY" 2>>$LOG_FILE)

if [ $? -eq 0 ] && [ ! -z "$REPORT" ]; then
    # Send report via openclaw agent
    /usr/bin/openclaw agent \
        --to "$TARGET_ID" \
        --channel "$CHANNEL" \
        --message "$REPORT" \
        --deliver >> $LOG_FILE 2>&1
    echo "[$(date)] Generic Search delivered to $TARGET_ID via $CHANNEL" >> $LOG_FILE
else
    echo "[$(date)] Error: Script failed or empty report" >> $LOG_FILE
fi
