#!/bin/bash
set -euo pipefail

TARGET_CHAT_ID="1557143577"
BRAND="麦当劳"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RAW_OUTPUT="$(mktemp)"
trap 'rm -f "$RAW_OUTPUT"' EXIT

cd "$SCRIPT_DIR"

# Run XHS monitor and capture full output.
if ! timeout 180s "./run_xhs_monitor.sh" "$BRAND" >"$RAW_OUTPUT" 2>&1; then
  ERR_MSG="$(tail -n 30 "$RAW_OUTPUT" | sed 's/"/'"'"'/g')"
  /usr/bin/openclaw message send \
    --channel telegram \
    --target "$TARGET_CHAT_ID" \
    --message "⚠️ ${BRAND}小红书舆情监控失败\n时间: $(TZ=Asia/Shanghai date '+%F %T')\n错误摘要:\n${ERR_MSG}"
  exit 1
fi

REPORT_BODY="$(cat "$RAW_OUTPUT")"
MATCH_COUNT="$(grep -E '^[0-9]+\.' "$RAW_OUTPUT" | wc -l | tr -d ' ')"
TOP_ITEMS="$(awk '
  /^[0-9]+\. / {item=$0; getline; meta=$0; getline; link=$0; print item "\n" meta "\n" link "\n"; count++; if (count>=8) exit}
' "$RAW_OUTPUT")"

if grep -q 'No recent negative sentiment matching criteria found' "$RAW_OUTPUT"; then
  MESSAGE="🍟 ${BRAND}小红书负面舆情监控\n时间: $(TZ=Asia/Shanghai date '+%F %T')\n结果: 近7天未发现命中条件的新增负面舆情。"
else
  MESSAGE="🍟 ${BRAND}小红书负面舆情监控\n时间: $(TZ=Asia/Shanghai date '+%F %T')\n命中数量: ${MATCH_COUNT}\n\n${TOP_ITEMS}"
fi

# Telegram message size safety margin.
MESSAGE="$(printf '%s' "$MESSAGE" | head -c 3500)"

/usr/bin/openclaw message send \
  --channel telegram \
  --target "$TARGET_CHAT_ID" \
  --message "$MESSAGE"
