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

## ⚙️ 第二步：注入脚本
### 1. 自动执行脚本 (推荐)
打开 `scripts/run_xhs_monitor.sh` 或 `scripts/run_xhs_generic.sh`。
找到以下这一行，将你复制的内容粘贴进去：
```bash
export XHS_COOKIE="此处粘贴你的Cookie"
```

### 2. 设置推送目标 (获取 Telegram ID)
在同一个 `.sh` 文件中，找到 `TARGET_ID`。
将其修改为你的 Telegram ID（如 `telegram:12345678`），这样脚本运行后就会自动把日报发到你的手机上。

**获取方法：**
1. 在 Telegram 中搜索并私聊机器人 `@userinfobot` 或 `@getmyid_bot`。
2. 发送任意消息给它，它会返回你的 `Id`（一串数字，如 `YOUR_ID`）。
3. 在脚本中填写：`TARGET_ID="telegram:你的数字ID"`。

---

## 🚀 运行
完成后，直接在终端执行即可：
```bash
./scripts/run_xhs_monitor.sh "麦当劳"
```
或
```bash
./scripts/run_xhs_generic.sh "你的关键词"
```
