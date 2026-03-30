#!/bin/bash
# XHS Monitor Cron Wrapper
# ------------------------
# 1. Runs the node script
# 2. Captures the report output
# 3. Pipes the output to OpenClaw LLM for "Z总管" style analysis
# 4. Sends final report to WeCom

export XHS_COOKIE="gid=yjq4q4KjD4vyyjq4q4Kj8F6MfYE4IudATjkiDkAxylDdI228y41jA6888qJ8Y2y8J2fK8qdD; x-user-id-creator.xiaohongshu.com=5e63d23500000000010076b2; a1=19aa055a705k4jwmoal4dnl0yar32p095yll83shb50000224279; webId=61ec3108ca8814556f5d6f2624f51304; abRequestId=61ec3108ca8814556f5d6f2624f51304; xsecappid=xhs-pc-web; acw_tc=0a00dadb17743201606897482ee6454198a247bbf9c25b8cde6fd191088251; webBuild=61.2; web_session=0400698f17917d5626e43ab2f43b4bfefb378d; id_token=VjEAAJI5B/5y3AqT8zSsqfYZVLtf+dfCqWlLolr41kJQKyjvPvmfYWWzBx1Y5zhNjFpE5gpd+pC6jp2OfOO8GZ1q5v/tEqNrCpj44xODJK7iapkNKVMfWp5ko7jZ6+Ex7yeCNXbq; loadts=1774320221502; unread={%22ub%22:%2269bbedc1000000001b020f0c%22%2C%22ue%22:%2269a927b1000000000e00f324%22%2C%22uc%22:30}; websectiga=10f9a40ba454a07755a08f27ef8194c53637eba4551cf9751c009d9afb564467; sec_poison_id=8023920d-3ad4-4bf4-a0ef-3bf7522b02a9"
export NODE_PATH=/usr/lib/node_modules
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome
TARGET_ID="${TARGET_ID:-wecom:15928291}"
CHANNEL="${CHANNEL:-wecom}"
KEYWORD="${1:-麦当劳}"
ASSISTANT_NAME="${ASSISTANT_NAME:-Z总管}"
LOG_FILE="$HOME/logs/xhs_cron.log"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date)] Starting XHS Monitoring for: $KEYWORD (Persona: $ASSISTANT_NAME)" >> $LOG_FILE

# 1. Execute Node.js script to get RAW DATA
RAW_DATA=$(/usr/bin/node "$SCRIPT_DIR/monitor.js" "$KEYWORD" 2>>$LOG_FILE)

if [ $? -eq 0 ] && [ ! -z "$RAW_DATA" ]; then
    # 2. Use OpenClaw agent to ANALYZE the data
    # We use --deliver to send the final result to the target
    /usr/bin/openclaw agent \
        --to "$TARGET_ID" \
        --channel "$CHANNEL" \
        --message "这是刚刚抓取的 $KEYWORD 小红书负面舆情原始数据：\n\n$RAW_DATA\n\n请作为 $ASSISTANT_NAME，按照以下格式生成最终日报：\n1. 原始列表（必须包含标题、时间和 Markdown 链接，格式如：[标题] (时间) - [链接](URL)）\n2. 【核心风险洞察】（犀利分析）\n3. 【$ASSISTANT_NAME 策略建议】（具体动作）\n要求：严禁在正文之外添加任何寒暄废话，必须包含原始数据中的时间信息（如：2天前），保持高信息密度。" \
        --deliver >> $LOG_FILE 2>&1
    
    echo "[$(date)] Analysis and report delivered to $TARGET_ID via $CHANNEL" >> $LOG_FILE
else
    echo "[$(date)] Error: Script failed or empty data" >> $LOG_FILE
fi
