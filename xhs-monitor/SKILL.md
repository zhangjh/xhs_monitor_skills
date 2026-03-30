---
name: xhs-monitor
description: 小红书实时负面舆情监控与深度分析技能。自动组合关键词执行渗透式扫描，过滤近7天内容，并由 Z总管 (AI Manager) 生成犀利的风险评估报告。适用于品牌合规监控、负面预警及社交媒体公关应对。支持企业微信/Telegram 通道推送。
---

# 小红书负面舆情监控 (XHS Negative Sentiment Monitor)

基于 Puppeteer 的小红书实时舆情抓取工具，专门用于扫描特定品牌或关键词的负面讨论。

## 执行

```bash
# 监控指定关键词/品牌（默认：麦当劳）
{baseDir}/scripts/run_xhs_monitor.sh "<关键词>"
```

## 读结果

- 原始舆情摘要：包含标题、作者、点赞、日期及原文链接。
- 【核心风险洞察】：由 Z总管生成的犀利深度分析。
- 【Z总管策略建议】：针对当前舆情趋势的实战动作建议。

## 配置与部署

由于此技能包含推送逻辑，安装后需在 `{baseDir}/scripts/run_xhs_monitor.sh` 中完成以下配置：

### 1. 登录态 (XHS_COOKIE)
获取方式：
1. 电脑浏览器登录 [小红书网页版](https://www.xiaohongshu.com)。
2. 按 `F12` 打开开发者工具 -> Network 选项卡 -> 刷新。
3. 复制任意搜索请求标头中的 `cookie` 完整值。
4. 写入脚本中的 `export XHS_COOKIE="..."` 字段。

### 2. 推送配置
修改脚本中的 `TARGET_ID` 和 `CHANNEL` 以适配你的 OpenClaw 接收通道。
```bash
export TARGET_ID="15928291" # 你的企业微信/Telegram ID
export CHANNEL="wecom"      # 接收通道 (wecom/telegram)
```

## 核心特性
- **渗透扫描**：自动组合“难吃”、“避雷”、“吐槽”、“投诉”、“差评”等负面后缀。
- **动态过滤**：严格剔除 7 天前的陈旧贴，确保报告全是新鲜事。
- **分析深度**：由 AI 扮演“Z总管”角色，拒绝复读废话，直击舆情本质。

## 注意
- 定时执行：建议在 crontab 中配置每日自动巡检。
- 风控提示：频繁抓取可能会触发验证码，建议合理设置抓取频率。
- 仅供内部监控使用，请务必更新私有 Cookie。
