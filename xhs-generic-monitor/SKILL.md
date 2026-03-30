---
name: xhs-generic-monitor
description: 小红书通用关键词监控技能。提供极简、无预设倾向的实时抓取能力。自动获取指定关键词在近7天内的热门与最新笔记，并支持通过企业微信/Telegram/Signal 等多渠道推送原始抓取报告。适用于行业趋势跟踪、竞品动态观察及话题热度调研。
---

# 小红书通用关键词监控 (XHS Generic Monitor)

一个通用的、不带预设倾向的小红书关键词抓取工具，用于获取特定话题的实时笔记动态。

## 执行

```bash
# 抓取指定关键词（例如：Vision Pro, AI 创业）
{baseDir}/scripts/run_xhs_generic.sh "<关键词>"
```

## 读结果

- 实时笔记列表：包含标题、作者、点赞数及原文超链接。
- 数据范围：严格锁定在近 7 天内的公开笔记。
- 渠道报告：直接通过配置的 IM 渠道推送抓取快照。

## 配置与部署

由于此技能包含推送逻辑，安装后需在 `{baseDir}/scripts/run_xhs_generic.sh` 中完成以下配置：

### 1. 登录态 (XHS_COOKIE)
获取方式：
1. 电脑浏览器登录 [小红书网页版](https://www.xiaohongshu.com)。
2. 按 `F12` 打开开发者工具 -> Network 选项卡 -> 刷新。
3. 复制任意搜索请求标头中的 `cookie` 完整值。
4. 写入脚本中的 `export XHS_COOKIE="..."` 字段。

### 2. 推送通道
支持所有 OpenClaw 已配置的渠道。
```bash
export CHANNEL="wecom"          # 通道名 (wecom/telegram/signal等)
export TARGET_ID="YOUR_ID_HERE" # 目标 ID
```

## 核心特性
- **无倾向性**：不做情感分析，仅还原搜索现场。
- **动态时效**：自动剔除 7 天前的过期数据。
- **多渠道分发**：支持将报告一键分发至多个协同工具。

## 注意
- 定时任务：建议结合 crontab 实现每日定时巡检话题趋势。
- 环境依赖：需安装 `chromium` 和 `puppeteer-core`。
- 本工具为“通用版”，若需针对品牌负面的 AI 深度研判，请使用 `xhs-monitor` 技能。
