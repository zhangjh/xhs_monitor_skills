#!/bin/bash
# XHS Monitor Install Script (for OpenClaw)
# ----------------------------------------
# 1. Check dependencies
# 2. Setup symlinks to ~/.openclaw/workspace/scripts/
# 3. Create placeholder for XHS_COOKIE

echo "🚀 Installing 小红书负面舆情监控 (XHS Negative Sentiment Monitor)..."

# Ensure script is executable
chmod +x scripts/run_xhs_monitor.sh

# Link to main workspace scripts directory
mkdir -p ../../scripts/
ln -sf "$(pwd)/scripts/run_xhs_monitor.sh" "../../scripts/run_xhs_monitor.sh"

echo "✅ Installed to $(cd ../../scripts/ && pwd)/run_xhs_monitor.sh"
echo "⚠️  Important: Set your XHS_COOKIE in the run_xhs_monitor.sh script before use."
