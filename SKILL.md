# 🏮 小红书负面舆情监控 (XHS Negative Sentiment Monitor)

基于 Puppeteer 的小红书实时舆情抓取工具，集成 Z总管 (AI Manager) 深度分析。

## 核心功能
- **自动化抓取**：自动组合 [品牌 + 负面词] 进行渗透式扫描。
- **智能过滤**：严格过滤非 7 天内的陈旧信息，确保时效性。
- **Z总管分析**：集成 LLM 对原始吐槽进行风险评估与策略建议（需配置 OpenClaw LLM）。
- **直达链接**：生成永久 Note 链接，方便一键回溯。

## 安装要求
- 操作系统：Linux (Ubuntu/Debian 推荐)
- 依赖：`chromium-browser` 或 `chromium`, `nodejs`, `puppeteer-core`
- 环境：OpenClaw 运行环境

## 使用说明
### 1. 配置 Cookie
在使用前，需将小红书网页版的 Cookie 设置到环境变量 `XHS_COOKIE` 中。

### 2. 命令行执行
```bash
# 监控指定品牌（默认：麦当劳）
./scripts/run_xhs_monitor.sh "品牌名"
```

### 3. 定时任务 (Cron)
建议设置每日早晨运行：
```cron
30 09 * * * /root/.openclaw/workspace/scripts/run_xhs_monitor.sh "麦当劳" >> /data/root/xhs_cron.log 2>&1
```

## 注意事项
- 本工具仅供品牌合规监控使用，请遵守小红书平台相关协议。
- Cookie 具有有效期，如抓取失败请及时更新。
