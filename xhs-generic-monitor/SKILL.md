# 🔍 小红书通用关键词监控 (XHS Generic Monitor)

一个通用的、不带预设倾向的小红书关键词抓取工具。

## 核心功能
- **自定义关键词**：支持抓取任何你感兴趣的内容（不仅仅是负面）。
- **多渠道推送**：支持企业微信 (WeCom) 和 Telegram 两大主流推送渠道。
- **实时同步**：获取最新 7 天内的笔记动态。
- **结构化输出**：直接输出包含作者、点赞数和直达链接的报告。
- **极简集成**：支持通过 Cron 进行定时监控。

## 安装与配置
1. 将本技能包放置在 `/root/.openclaw/workspace/skills/xhs-generic-monitor/`。
2. **获取与注入 Cookie**：
   - 在电脑浏览器打开 [小红书网页版](https://www.xiaohongshu.com) 并登录。
   - 按 `F12` 进入开发者模式，点击 **Network (网络)**。
   - 刷新页面，点击任一 `search_result` 请求，在 **Request Headers (请求标头)** 中找到 `cookie` 字段。
   - 复制其完整值，填写到 `scripts/run_xhs_generic.sh` 的 `XHS_COOKIE="..."` 变量中。

3. **配置推送渠道 (WeCom / Telegram)**：
   编辑 `scripts/run_xhs_generic.sh` 中的环境变量：

   - **WeCom (默认)**：
     ```bash
     export CHANNEL="wecom"
     export TARGET_ID="YOUR_ID" # 填写你的企业微信 ID
     ```
   - **Telegram**：
     ```bash
     export CHANNEL="telegram"
     export TARGET_ID="YOUR_ID" # 填写你的 Telegram Chat ID
     ```

4. 赋予执行权限：`chmod +x scripts/*.sh`。

---

## 使用示例
### 1. 手动搜索
```bash
# 抓取关于 "Vision Pro" 的最新笔记
./scripts/run_xhs_generic.sh "Vision Pro"
```

### 2. 定时监控
在 Crontab 中添加，每日监控某个特定话题：
```cron
0 10 * * * /root/.openclaw/workspace/scripts/run_xhs_generic.sh "AI 创业" >> /data/root/xhs_generic.log 2>&1
```

## 注意事项
- 本工具为通用抓取器，不包含针对特定品牌的 AI 助理风险分析逻辑，输出为原始抓取报告。
- 请遵守小红书平台相关协议，勿用于恶意爬取。
