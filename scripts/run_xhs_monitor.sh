#!/bin/bash
# XHS Monitor Cron Wrapper
# ------------------------
# 1. Runs the node script
# 2. Captures the report output
# 3. Pipes the output to OpenClaw LLM for "Z总管" style analysis
# 4. Sends final report to Telegram

export XHS_COOKIE="YOUR_XHS_COOKIE_HERE"
export NODE_PATH=/usr/lib/node_modules
TARGET_ID="telegram:YOUR_CHAT_ID_HERE"
KEYWORD="${1:-麦当劳}"
LOG_FILE="/data/root/xhs_cron.log"

echo "[$(date)] Starting XHS Monitoring for: $KEYWORD" >> $LOG_FILE

# 1. Execute Node.js script to get RAW DATA
RAW_DATA=$(/usr/bin/node /root/.openclaw/workspace/skills/xhs-monitor/scripts/monitor.js "$KEYWORD" 2>>$LOG_FILE)

if [ $? -eq 0 ] && [ ! -z "$RAW_DATA" ]; then
    # 2. Use OpenClaw agent to ANALYZE the data
    # We use --deliver to send the final result to the target
    /usr/bin/openclaw agent \
        --to "$TARGET_ID" \
        --channel "telegram" \
        --message "这是刚刚抓取的 $KEYWORD 小红书负面舆情原始数据：\n\n$RAW_DATA\n\n请作为 Z总管，按照以下格式生成最终日报：\n1. 原始列表（保留链接）\n2. 【核心风险洞察】（犀利分析）\n3. 【Z总管策略建议】（具体动作）\n要求：保持高信息密度，拒绝废话。" \
        --deliver >> $LOG_FILE 2>&1
    
    echo "[$(date)] Analysis and report delivered to $TARGET_ID" >> $LOG_FILE
else
    echo "[$(date)] Error: Script failed or empty data" >> $LOG_FILE
fi
