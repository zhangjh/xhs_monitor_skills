# 🏮 小红书舆情监控 (XHS Sentiment Monitor) - 获取与配置指南

为了让监控脚本正常抓取小红书内容，你需要获取网页版的 `Cookie` 并将其注入。

## 🛠️ 第一步：获取 Cookie
1. **电脑登录**：在 Chrome 或 Edge 浏览器中登录 [小红书网页版](https://www.xiaohongshu.com)。
2. **进入开发者模式**：按下键盘上的 `F12` 键（或右键 -> 检查）。
3. **定位网络请求**：
   - 点击顶部的 **Network (网络)** 选项卡。
   - 刷新页面。
   - 在左侧的请求列表中，点击任意一个名称为 `search_result` 或 `home` 的请求。
4. **复制 Cookie**：
   - 在右侧出现的面板中，点击 **Headers (标头)**。
   - 向下滚动找到 **Request Headers (请求标头)** 部分。
   - 找到 `cookie:` 这一行。
   - **全选并复制** 冒号后面所有的文本值（从 `gid=...` 开始直到末尾）。

## ⚙️ 第二步：获取 Telegram ID
在脚本运行后自动发送日报，你需要你的 Telegram 数字 ID。

**获取方法：**
1. 在 Telegram 中搜索并向机器人 `@userinfobot` 发送任意消息。
2. 它会返回一串数字（如 `YOUR_ID`），这就是你的 `Id`。

## ⚙️ 第三步：注入脚本
打开相应的脚本文件（如 `run_xhs_monitor.sh`），将上述获取到的内容填入：
```bash
export XHS_COOKIE="此处粘贴你的Cookie"
TARGET_ID="telegram:你的数字ID"
```

---

## 🚀 运行
完成后，直接在终端执行即可。
