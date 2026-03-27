# 小红书舆情监控

以下是仓库说明，需要安装skills，你只需要跟你的OpenClaw说一句：
> https://clawhub.ai/zhangjh/xhs-sentry
> 你安装一下这个skills，跑一下skills的小红书舆情报告给我，关注的关键词就是“xxxxx”

这是一个面向中文用户的小红书监控技能集合，聚焦三类场景：

- **品牌舆情监控**：监控品牌相关负面内容、风险信号与口碑波动
- **通用关键词巡检**：按主题、竞品、行业词抓取搜索结果并生成摘要
- **现场级舆情取证**：输出结构化结果、页面状态判断与截图证据

当前仓库包含以下技能：

- `xhs-monitor`：定制化的品牌/负面专项监控（主要作者个人在用）
- `xhs-generic-monitor`：通用关键词抓取与推送
- `xhs-sentry`：**小红书舆情哨兵**，适合做通用巡检、竞品观察、口碑监控和热点追踪（已发布 ClawHub）

---

## 仓库结构

```text
xhs-monitor/
xhs-generic-monitor/
xhs-sentry/
COOKIE_GUIDE.md
```

---

## 技能说明

### 1. xhs-monitor
适用于品牌专项巡检。

特点：
- 预设负面风险导向
- 适合品牌方做日常舆情监控
- 可结合消息推送脚本做定时巡检

### 2. xhs-generic-monitor
适用于通用关键词搜索与结果抓取。

特点：
- 不预设正负面倾向
- 适合抓行业词、产品词、竞品词
- 更偏“搜索结果抓取器”

### 3. xhs-sentry（推荐）
适用于中文用户的小红书舆情巡检与口碑监控。

特点：
- 输出结构化笔记信息（标题、作者、点赞、日期、链接、封面）
- 判断页面状态（正常 / 登录墙 / 验证码 / 空结果）
- 复用已有 `XHS_COOKIE` 登录态
- 识别热度、风险、竞品/对比信号
- 输出现场截图，便于核验

如果只安装一个，优先推荐 **`xhs-sentry`**。

---

## 登录态说明

所有技能都建议使用 `XHS_COOKIE` 运行登录态抓取。

`xhs-sentry` 的登录态优先级如下：
1. 环境变量 `XHS_COOKIE`
2. 同仓库其他脚本中的 `export XHS_COOKIE="..."`
3. 若都不存在，则退回匿名模式

Cookie 获取方式请参考：
- `COOKIE_GUIDE.md`

---

## 消息接收渠道配置

如果希望把监控结果自动发送出去，除了 Cookie，还需要配置**消息接收渠道**。

常见示例：

### Telegram
```bash
export CHANNEL="telegram"
export TARGET_ID="telegram:YOUR_TELEGRAM_ID"
```

### 企业微信（WeCom）
```bash
export CHANNEL="wecom"
export TARGET_ID="wecom:YOUR_WECOM_ID"
```

说明：
- Telegram 数字 ID 可通过 `@userinfobot` 获取
- 企业微信接收 ID 需要与你当前 OpenClaw / wecom 通道配置保持一致
- 详细说明见 `COOKIE_GUIDE.md`

---

## 快速验收

在仓库根目录执行：

```bash
NODE_PATH=$(npm root -g) node xhs-sentry/scripts/monitor.js "OpenClaw" 5 /tmp
```

重点检查输出中的：

- `status.auth_mode`
- `status.needsLogin`
- `status.captcha`
- `notes`
- `analysis`

---

## 维护说明

本仓库是**源码仓库**。已发布的 skill 页面：
- https://clawhub.ai/zhangjh/xhs-sentry

---

## 适用人群

这个仓库主要适合：

- 关注品牌口碑的小团队
- 做竞品分析和行业观察的独立开发者
- 需要用小红书做内容、产品或市场研究的中文用户
