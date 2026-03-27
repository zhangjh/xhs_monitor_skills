# 🏮 小红书负面舆情监控 (XHS Negative Sentiment Monitor)

基于 Puppeteer 的小红书实时舆情抓取工具，集成 AI 私人助理深度分析（默认称谓"Z总管"，可自定义）。

## 核心功能
- **自动化抓取**：自动组合 [品牌 + 负面词] 进行渗透式扫描。
- **智能过滤**：严格过滤非 7 天内的陈旧信息，确保时效性。
- **AI 助理分析**：集成 LLM 对原始吐槽进行风险评估与策略建议（需配置 OpenClaw LLM）。
- **直达链接**：生成永久 Note 链接，方便一键回溯。

## 安装要求
- 操作系统：Linux (Ubuntu/Debian 推荐)
- 依赖：`chromium-browser` 或 `chromium`, `nodejs`, `puppeteer-core`
- 环境：OpenClaw 运行环境

## 使用说明
### 1. 配置 Cookie (获取方式)
在使用前，需将小红书网页版的 Cookie 设置到环境变量 `XHS_COOKIE` 中。

**获取方法：**
1. 在电脑浏览器登录 [小红书网页版](https://www.xiaohongshu.com)。
2. 按 `F12` 打开开发者工具，进入 **Network (网络)** 选项卡。
3. 刷新页面，点击第一个请求（通常是 `home` 或 `search_result`）。
4. 在右侧 **Headers (标头)** -> **Request Headers (请求标头)** 中找到 `cookie` 字段。
5. 复制其完整值，粘贴到 `scripts/run_xhs_monitor.sh` 的 `XHS_COOKIE="..."` 中。

---

### 2. 注入方式
脚本支持两种注入方式：
- **静态注入**（推荐）：直接修改 `scripts/run_xhs_monitor.sh` 文件中的 `XHS_COOKIE` 变量。
- **环境注入**：在运行脚本前执行 `export XHS_COOKIE="你的Cookie值"`。

---

### 3. 自定义助理称谓
默认称谓为"Z总管"，可通过环境变量 `ASSISTANT_NAME` 自定义：
```bash
export ASSISTANT_NAME="你的称谓"
```
也可直接修改 `scripts/run_xhs_monitor.sh` 中的 `ASSISTANT_NAME` 变量。

### 4. 命令行执行
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
