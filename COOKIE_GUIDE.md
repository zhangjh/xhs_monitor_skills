# 📖 获取与配置指南 (Cookie & Telegram ID)

为了让监控脚本正常抓取并推送小红书内容，你需要获取网页版的 `Cookie` 以及你的 `Telegram ID` 并将其注入。

---

## 🛠️ 第一步：获取 Cookie
1. **电脑登录**：在 Chrome 或 Edge 浏览器中登录 [小红书网页版](https://www.xiaohongshu.com)。
2. **进入开发者模式**：按下键盘上的 `F12` 键（或右键 -> 检查）。
3. **定位网络请求**：
   - 点击顶部的 **Network (网络)** 选项卡。
   - 刷新页面。
   - 在左侧列表中，寻找名称为 `search_result` 或 `home` 的请求。
4. **复制 Cookie**：
   - 在右侧面板中，点击 **Headers (标头)**。
   - 向下滚动找到 **Request Headers (请求标头)**。
   - 找到 `cookie:` 字段，**全选并复制** 冒号后面所有的内容（从 `gid=...` 直到末尾）。

---

## ⚙️ 第二步：获取 Telegram ID
为了将报告直接推送到你的手机：
1. 在 Telegram 中搜索并私聊机器人 `@userinfobot` 或 `@getmyid_bot`。
2. 发送任意消息，它会返回你的数字 `Id`（例如：`YOUR_ID`）。

---

## 🚀 第三步：注入脚本并运行
1. **注入配置**：
   - 打开具体的运行脚本（如 `xhs-monitor/scripts/run_xhs_monitor.sh`）。
   - 修改 `export XHS_COOKIE="YOUR_XHS_COOKIE_HERE"` 为你刚才复制的内容。
   - 修改 `TARGET_ID="telegram:YOUR_CHAT_ID_HERE"` 为你的数字 ID。
2. **执行**：
   - 给脚本赋予权限：`chmod +x xhs-monitor/scripts/*.sh`。
   - 运行：`./xhs-monitor/scripts/run_xhs_monitor.sh "麦当劳"`。

---
⚙️ *Powered by OpenClaw*
