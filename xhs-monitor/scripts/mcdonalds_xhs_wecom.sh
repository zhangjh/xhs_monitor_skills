#!/bin/bash
set -euo pipefail

# TARGET_CHAT_ID: Since the user is talking to me via WeCom, I should send to this channel.
# From the untrusted metadata: "chat_id": "wecom:15928291"
export TARGET_ID="wecom:15928291"
export CHANNEL="wecom"
BRAND="麦当劳"
WORKDIR="/root/.openclaw/workspace"

cd "$WORKDIR"

# Run XHS monitor. It will handle analysis and delivery via openclaw agent --deliver.
/root/.openclaw/workspace/scripts/run_xhs_monitor.sh "$BRAND"
