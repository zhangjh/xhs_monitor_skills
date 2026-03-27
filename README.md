# xhs_monitor_skills

小红书监控技能仓库，包含三类能力：

- `xhs-monitor`：品牌/负面专项监控
- `xhs-generic-monitor`：通用关键词抓取与推送
- `xhs-sentry`：通用舆情哨兵，支持结构化结果、页面状态判断、cookie 登录态复用、风险/热度/竞品信号分析与现场截图

## 当前结构

```text
xhs-monitor/
xhs-generic-monitor/
xhs-sentry/
COOKIE_GUIDE.md
```

## 使用建议

### 1. 登录态
所有技能都建议通过 `XHS_COOKIE` 使用登录态。

`xhs-sentry` 的登录态优先级：
1. 环境变量 `XHS_COOKIE`
2. 同仓库其他脚本中的 `export XHS_COOKIE="..."`
3. 若都不存在，则退回匿名模式

### 2. 隐私要求
仓库中不得提交：
- 真实 Telegram ID
- 真实 WeCom ID
- 真实 Cookie / Session Token
- 带隐私信息的截图或日志

统一使用占位符，例如：
- `YOUR_XHS_COOKIE_HERE`
- `YOUR_WECOM_ID_HERE`
- `telegram:YOUR_ID`

### 3. 当前推荐发布项
如果对外发布，优先推荐：
- `xhs-sentry`：更适合通用舆情巡检

## 快速验收

```bash
NODE_PATH=$(npm root -g) node xhs-sentry/scripts/monitor.js "OpenClaw" 5 /tmp
```

验收时重点看：
- `status.auth_mode`
- `status.needsLogin`
- `status.captcha`
- `notes`
- `analysis`

## 备注

本仓库是源码仓库；OpenClaw workspace 下的技能目录属于运行副本。修改后应优先回写本仓库，再同步到运行副本，避免版本漂移。
